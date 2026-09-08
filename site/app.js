const downloadButton = document.querySelector("#windows-download");
const downloadTitle = document.querySelector("#download-title");
const versionLabel = document.querySelector("#download-version");
const macDownloadButton = document.querySelector("#mac-download");
const macDownloadTitle = document.querySelector("#mac-download-title");
const macVersionLabel = document.querySelector("#mac-download-version");
const demoVideo = document.querySelector("#demo-video");
const demoPlay = document.querySelector("#demo-play");

if (demoVideo && demoPlay) {
  demoPlay.hidden = false;
  demoPlay.addEventListener("click", () => {
    demoPlay.hidden = true;
    demoVideo.focus({ preventScroll: true });
    demoVideo.play().catch(() => {
      demoPlay.hidden = false;
    });
  });
  demoVideo.addEventListener("play", () => { demoPlay.hidden = true; });
  demoVideo.addEventListener("ended", () => { demoPlay.hidden = false; });
}

fetch("https://api.github.com/repos/yoruhinot/DawAudioStreamer/releases?per_page=10", {
  headers: { Accept: "application/vnd.github+json" }
})
  .then((response) => {
    if (!response.ok) throw new Error("Release information is unavailable");
    return response.json();
  })
  .then((releases) => {
    const release = releases.find((item) =>
      !item.draft && item.assets.some((asset) => asset.name.toLowerCase().endsWith(".exe"))
    );
    const installer = release?.assets.find((asset) => asset.name.toLowerCase().endsWith(".exe"));
    if (release && installer) {
      downloadButton.href = installer.browser_download_url;
      downloadTitle.textContent = release.prerelease
        ? "Windowsベータ版をダウンロード"
        : "Windows版をダウンロード";
      versionLabel.textContent = `${release.tag_name}・Windows 11・x64`;
    }

    const macRelease = releases.find((item) =>
      !item.draft && item.assets.some((asset) => {
        const name = asset.name.toLowerCase();
        return name.endsWith(".zip") && name.includes("macos-applesilicon");
      })
    );
    const macPackage = macRelease?.assets.find((asset) => {
      const name = asset.name.toLowerCase();
      return name.endsWith(".zip") && name.includes("macos-applesilicon");
    });
    if (macRelease && macPackage) {
      macDownloadButton.href = macPackage.browser_download_url;
      macDownloadTitle.textContent = "macOSプレビュー版をダウンロード";
      macVersionLabel.textContent = `${macRelease.tag_name}・macOS 13以降・Apple Silicon`;
    }
  })
  .catch(() => {
    // Both buttons already fall back to the GitHub Releases page.
  });
