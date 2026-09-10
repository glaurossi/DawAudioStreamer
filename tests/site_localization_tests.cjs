const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const site = path.join(__dirname, '..', 'site');
const languageCode = fs.readFileSync(path.join(site, 'language.js'), 'utf8');
const appCode = fs.readFileSync(path.join(site, 'app.js'), 'utf8');
const root = 'https://yoruhinot.github.io/DawAudioStreamer/';

function language({ url = root, lang = 'ja', browser = 'ja-JP', saved, blocked = false, languages } = {}) {
  const writes = [];
  let redirect;
  vm.runInNewContext(languageCode, {
    URL,
    document: { documentElement: { lang } },
    window: { location: { href: url, replace(value) { redirect = value; } } },
    navigator: { language: browser, languages },
    localStorage: {
      getItem() { if (blocked) throw Error('disabled'); return saved; },
      setItem(key, value) { if (blocked) throw Error('disabled'); writes.push([key, value]); }
    }
  });
  return { redirect, writes };
}

test('Japanese browser stays Japanese; other languages use English', () => {
  assert.equal(language().redirect, undefined);
  for (const browser of ['en-US', 'fr-FR', 'ko-KR']) {
    assert.equal(language({ browser }).redirect, root + 'en/');
  }
  assert.equal(language({ browser: 'en', languages: ['ja-JP', 'en'] }).redirect, undefined);
});

test('Missing language information falls back to Japanese', () => {
  assert.equal(language({ browser: '' }).redirect, undefined);
});

test('Saved manual choice wins over the browser', () => {
  assert.equal(language({ saved: 'ja', browser: 'en' }).redirect, undefined);
  assert.equal(language({ saved: 'en' }).redirect, root + 'en/');
  assert.equal(language({ saved: 'invalid', browser: 'ja' }).redirect, undefined);
});

test('Direct English links stay English even with a Japanese preference', () => {
  assert.equal(language({ url: root + 'en/#setup', lang: 'en', saved: 'ja' }).redirect, undefined);
});

test('Explicit Japanese links override browser and saved preferences', () => {
  const result = language({ url: root + '?lang=ja#vbcable', browser: 'en', saved: 'en' });
  assert.equal(result.redirect, undefined);
  assert.deepEqual(result.writes, [['das-language', 'ja']]);
});

test('Explicit English links remember the choice', () => {
  const result = language({ url: root + 'en/?lang=en', lang: 'en', saved: 'ja' });
  assert.equal(result.redirect, undefined);
  assert.deepEqual(result.writes, [['das-language', 'en']]);
});

test('Redirect preserves query and section without a loop', () => {
  const url = root + '?v=test#setup';
  const destination = language({ url, browser: 'en' }).redirect;
  assert.equal(destination, root + 'en/?v=test#setup');
  assert.equal(language({ url: destination, lang: 'en', browser: 'en' }).redirect, undefined);
  assert.equal(language({ url: root + 'en/?lang=ja#obs', lang: 'en' }).redirect, root + '?lang=ja#obs');
});

test('Language selection still works when storage is blocked', () => {
  assert.equal(language({ browser: 'en', blocked: true }).redirect, root + 'en/');
  assert.equal(language({ url: root + '?lang=ja', browser: 'en', blocked: true }).redirect, undefined);
});

function button() {
  return { href: undefined, textContent: '', small: {}, removed: [],
    removeAttribute(name) { this.removed.push(name); },
    querySelector() { return this.small; } };
}

async function downloads(releases, failure = false, intelPublished = false) {
  const nodes = Object.fromEntries(['windows-download', 'download-title', 'download-version',
    'mac-download-arm', 'mac-download-intel'].map(id => [id, button()]));
  nodes['mac-download-arm'].href = 'published-arm-fallback';
  if (intelPublished) nodes['mac-download-intel'].href = 'published-intel-fallback';
  vm.runInNewContext(appCode, {
    document: { documentElement: { lang: 'en' }, querySelector: selector => nodes[selector.slice(1)] || null },
    fetch: async () => { if (failure) throw Error('offline'); return { ok: true, json: async () => releases }; }
  });
  await new Promise(setImmediate);
  return nodes;
}

const asset = arch => ({ name: `DawAudioStreamer-test-macOS-${arch}.zip`, browser_download_url: `https://example.com/${arch}` });

test('Intel remains unavailable before an Intel asset is published', async () => {
  const nodes = await downloads([{ tag_name: 'v1', assets: [asset('AppleSilicon')] }]);
  assert.equal(nodes['mac-download-arm'].href, 'https://example.com/AppleSilicon');
  assert.equal(nodes['mac-download-intel'].href, undefined);
});

test('Resolve Intel and Apple Silicon releases independently', async () => {
  const nodes = await downloads([
    { draft: true, tag_name: 'draft', assets: [asset('AppleSilicon')] },
    { tag_name: 'v2', assets: [asset('Intel')] },
    { tag_name: 'v1', assets: [asset('AppleSilicon')] }
  ]);
  assert.equal(nodes['mac-download-arm'].small.textContent, 'v1 · macOS 13+');
  assert.equal(nodes['mac-download-intel'].small.textContent, 'v2 · macOS 13+');
  assert.deepEqual(nodes['mac-download-intel'].removed, ['aria-disabled', 'tabindex']);
});

test('API failure keeps published fallback and does not enable Intel', async () => {
  const nodes = await downloads([], true);
  assert.equal(nodes['mac-download-arm'].href, 'published-arm-fallback');
  assert.equal(nodes['mac-download-intel'].href, undefined);
});

test('API failure keeps both published Mac downloads available', async () => {
  const nodes = await downloads([], true, true);
  assert.equal(nodes['mac-download-arm'].href, 'published-arm-fallback');
  assert.equal(nodes['mac-download-intel'].href, 'published-intel-fallback');
});

test('Both HTML pages load language selection and link to published Mac packages', () => {
  for (const filename of ['index.html', 'en/index.html']) {
    const html = fs.readFileSync(path.join(site, filename), 'utf8');
    assert.match(html, /<script src="(?:\.\.\/)?language\.js\?[^\"]+"><\/script>/);
    for (const [id, arch] of [['arm', 'AppleSilicon'], ['intel', 'Intel']]) {
      const link = html.match(new RegExp(`<a[^>]+id="mac-download-${id}"[^>]*>`))[0];
      assert.doesNotMatch(link, /aria-disabled|tabindex/);
      assert.ok(link.includes(`releases/download/v0.4.2-macos-preview.1/DawAudioStreamer-0.4.2-macos-preview.1-macOS-${arch}.zip`));
    }
    assert.match(html, /href="(?:\.\.\/|en\/)\?lang=(?:ja|en)"/);
  }
});
