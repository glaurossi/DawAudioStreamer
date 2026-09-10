"""Exercise only the language helper, never install or remove plugins."""

import os
from pathlib import Path
import pty
import select
import subprocess
import tempfile
import time
import unittest


HELPER = Path(__file__).resolve().parents[1] / "installer/macos/Language.zsh"
COMMAND = 'set -euo pipefail; source "$1"; print "RESULT=$DAS_LANGUAGE"'


def run_helper(helper=HELPER, answer=None, env=None):
    args = ["/bin/zsh", "-f", "-c", COMMAND, "language-test", str(helper)]
    if answer is None:
        return subprocess.check_output(
            args, stdin=subprocess.DEVNULL, env=env, text=True, timeout=15
        )
    master, slave = pty.openpty()
    process = subprocess.Popen(args, stdin=slave, stdout=slave, stderr=slave, env=env)
    os.close(slave)
    output = b""
    sent = False
    deadline = time.monotonic() + 15
    try:
        while time.monotonic() < deadline:
            if select.select([master], [], [], 0.1)[0]:
                try:
                    chunk = os.read(master, 65536)
                except OSError:
                    break
                if not chunk:
                    break
                output += chunk
                if not sent and b"(en/ja): " in output:
                    os.write(master, answer.encode())
                    sent = True
            if process.poll() is not None:
                break
        process.wait(timeout=2)
        if process.returncode != 0 or b"RESULT=" not in output:
            raise AssertionError(output.decode(errors="replace"))
        return output.decode()
    finally:
        if process.poll() is None:
            process.kill()
            process.wait()
        os.close(master)


class LanguageTests(unittest.TestCase):
    def test_system_default(self):
        preferred = subprocess.check_output([
            "/usr/bin/osascript", "-l", "JavaScript", "-e",
            'ObjC.import("Foundation"); $.NSLocale.preferredLanguages.objectAtIndex(0).js',
        ], text=True, timeout=15).strip()
        expected = "ja" if preferred.startswith("ja") else "en"
        self.assertIn("RESULT=" + expected, run_helper())
        self.assertIn("RESULT=" + expected, run_helper(answer="\n"))

    def test_manual_choices(self):
        for language in ("ja", "en"):
            with self.subTest(language=language):
                self.assertIn("RESULT=" + language, run_helper(answer=language + "\n"))

    def test_invalid_choice_retries(self):
        output = run_helper(answer="invalid\nja\n")
        self.assertIn("RESULT=ja", output)
        self.assertEqual(output.count("(en/ja): "), 2)

    def test_locale_fallback(self):
        # Simulate unavailable UI preferences without changing system settings.
        with tempfile.TemporaryDirectory(prefix="das-language-test-") as directory:
            helper = Path(directory) / "Language.zsh"
            helper.write_text(HELPER.read_text().replace("/usr/bin/osascript", "/usr/bin/false"))
            for locale, expected in (("ja_JP.UTF-8", "ja"), ("en_US.UTF-8", "en"), ("fr_FR.UTF-8", "en")):
                with self.subTest(locale=locale):
                    env = dict(os.environ, LC_ALL=locale)
                    self.assertIn("RESULT=" + expected, run_helper(helper, env=env))


if __name__ == "__main__":
    unittest.main()
