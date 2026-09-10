(() => {
  const storageKey = "das-language";
  const current = document.documentElement.lang;
  const url = new URL(window.location.href);
  const requested = url.searchParams.get("lang");
  const explicit = requested === "ja" || requested === "en" ? requested : null;
  let saved;
  try { saved = localStorage.getItem(storageKey); } catch { /* Storage is optional. */ }

  if (explicit) {
    try { localStorage.setItem(storageKey, explicit); } catch { /* Keep the URL choice. */ }
  }

  // Explicit links win. Only the Japanese root is an automatic entry point.
  // Opening /en/ directly must never redirect based on a previous preference.
  const browserLanguage = navigator.languages?.[0] || navigator.language;
  const preferred = saved === "ja" || saved === "en" ? saved
    : (!browserLanguage || /^ja(?:-|$)/i.test(browserLanguage) ? "ja" : "en");
  const target = explicit || (current === "ja" ? preferred : current);
  if (target === current) return;

  const destination = new URL(target === "en" ? "en/" : "../", url);
  destination.search = url.search;
  destination.hash = url.hash;
  window.location.replace(destination.href);
})();
