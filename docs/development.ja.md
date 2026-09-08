# ビルド

[English](development.md)

## 必要なもの

- Windows x64
- Visual Studio 2026（C++デスクトップ開発、Windows SDK）
- CMake 3.25以降
- Inno Setup 6（インストーラーを作る場合）

## 手順

```powershell
cmake --preset windows-msvc-release
cmake --build --preset windows-msvc-release
ctest --preset windows-msvc-release
```

インストーラーも作る場合：

```powershell
cmake --build build/windows-msvc-release --config Release --target das_installer
```

主な生成物：

- VST3：`build/windows-msvc-release/plugins/send-vst3/DasSend_artefacts/Release/VST3/DAS Send.vst3`
- OBSプラグイン：`build/windows-msvc-release/plugins/obs-source/Release/das-obs-source.dll`
- インストーラー：`build/installer/DawAudioStreamer-Setup-0.4.3.exe`

## macOS（プレビュー版）

- IntelまたはApple Silicon搭載Mac・macOS 13以降
- Xcodeとコマンドラインツール（`xcode-select --install`）
- CMake 3.25以降
- Macのアーキテクチャに合ったOBS Studioを`/Applications/OBS.app`に

アーキテクチャに合わせてpresetを選びます。OBSはユニバーサルな`libobs`を配布していないため、インストール済みOBSと同じアーキテクチャしかビルドできません：

```zsh
cmake --preset macos-preview-intel   # または macos-preview-arm
cmake --build --preset macos-preview-intel
ctest --preset macos-preview-intel
```

配布用ZIPは`cmake/CreateMacPreviewPackage.cmake`で作成します（正確なコマンドは`macos-preview` CIワークフローを参照）。プラグインと`Install.command`／`Uninstall.command`をアドホック署名で同梱します。CIは両アーキテクチャをネイティブランナーでビルドします。

## macOS（プレビュー版）

- IntelまたはApple Silicon搭載Mac・macOS 13以降
- Xcodeとコマンドラインツール（`xcode-select --install`）
- CMake 3.25以降
- Macのアーキテクチャに合ったOBS Studioを`/Applications/OBS.app`に

アーキテクチャに合わせてpresetを選びます。OBSはユニバーサルな`libobs`を配布していないため、インストール済みOBSと同じアーキテクチャしかビルドできません：

```zsh
cmake --preset macos-preview-intel   # または macos-preview-arm
cmake --build --preset macos-preview-intel
ctest --preset macos-preview-intel
```

配布用ZIPは`cmake/CreateMacPreviewPackage.cmake`で作成します（正確なコマンドは`macos-preview` CIワークフローを参照）。プラグインと`Install.command`／`Uninstall.command`をアドホック署名で同梱します。CIは両アーキテクチャをネイティブランナーでビルドします。

使用している依存ライブラリと固定revisionは
[THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md)に記載しています。Releaseの対応ソースZIPには、
オフラインで再ビルドできる依存ソースも含まれます。
