# Build

[日本語](development.ja.md)

## Requirements

- Windows x64
- Visual Studio 2026 (Desktop development with C++, Windows SDK)
- CMake 3.25 or later
- Inno Setup 6 (only needed to build the installer)

## Steps

```powershell
cmake --preset windows-msvc-release
cmake --build --preset windows-msvc-release
ctest --preset windows-msvc-release
```

To also build the installer:

```powershell
cmake --build build/windows-msvc-release --config Release --target das_installer
```

Key build outputs:

- VST3: `build/windows-msvc-release/plugins/send-vst3/DasSend_artefacts/Release/VST3/DAS Send.vst3`
- OBS plugin: `build/windows-msvc-release/plugins/obs-source/Release/das-obs-source.dll`
- Installer: `build/installer/DawAudioStreamer-Setup-0.4.3.exe`

## macOS (preview)

- Intel or Apple Silicon Mac, macOS 13 or later
- Xcode with command line tools (`xcode-select --install`)
- CMake 3.25 or later
- OBS Studio (matching your Mac's arch) at `/Applications/OBS.app`

Pick the preset for your arch — you can only build the arch of your installed OBS, since OBS ships no universal `libobs`:

```zsh
cmake --preset macos-preview-intel   # or macos-preview-arm
cmake --build --preset macos-preview-intel
ctest --preset macos-preview-intel
```

The distributable ZIP is built by `cmake/CreateMacPreviewPackage.cmake` (see the `macos-preview` CI workflow for the exact invocation); it bundles the plugins with `Install.command` / `Uninstall.command`, ad-hoc signed. CI builds both arches on native runners.

Dependencies and their pinned revisions are listed in [THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md). The release source ZIP includes offline-rebuildable dependency sources.
