#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
PAYLOAD_DIR="${SCRIPT_DIR}/payload"
VST3_TARGET="${HOME}/Library/Audio/Plug-Ins/VST3/DAS Send.vst3"
AU_TARGET="${HOME}/Library/Audio/Plug-Ins/Components/DAS Send.component"
OBS_TARGET="${HOME}/Library/Application Support/obs-studio/plugins/das-obs-source.plugin"

if [[ "${LANG:-}" == ja_* ]]; then
  print "DawAudioStreamer macOSプレビュー版をインストールします。"
  print "DAWとOBSを終了してから続けてください。"
  print
else
  print "Installing DawAudioStreamer macOS Preview."
  print "Close your DAW and OBS before continuing."
  print
fi

if [[ ! -d "${PAYLOAD_DIR}/DAS Send.vst3" ||
      ! -d "${PAYLOAD_DIR}/DAS Send.component" ||
      ! -d "${PAYLOAD_DIR}/das-obs-source.plugin" ]]; then
  if [[ "${LANG:-}" == ja_* ]]; then
    print -u2 "必要なファイルが見つかりません。ZIPを展開してから実行してください。"
    read -k 1 "?何かキーを押すと閉じます。"
  else
    print -u2 "Required files not found. Extract the ZIP before running this script."
    read -k 1 "?Press any key to close."
  fi
  exit 1
fi

mkdir -p "${VST3_TARGET:h}" "${AU_TARGET:h}" "${OBS_TARGET:h}"
rm -rf "${VST3_TARGET}" "${AU_TARGET}" "${OBS_TARGET}"
/usr/bin/ditto "${PAYLOAD_DIR}/DAS Send.vst3" "${VST3_TARGET}"
/usr/bin/ditto "${PAYLOAD_DIR}/DAS Send.component" "${AU_TARGET}"
/usr/bin/ditto "${PAYLOAD_DIR}/das-obs-source.plugin" "${OBS_TARGET}"

/usr/bin/xattr -dr com.apple.quarantine "${VST3_TARGET}" "${AU_TARGET}" "${OBS_TARGET}" 2>/dev/null || true
/usr/bin/killall -u "${USER}" AudioComponentRegistrar 2>/dev/null || true

print
if [[ "${LANG:-}" == ja_* ]]; then
  print "インストールが完了しました。"
  print "1. DAWのマスターへ「DAS Send」を1個挿します。"
  print "2. OBSのソースへ「DAS Audio（DAW）」を追加します。"
  print "3. DiscordではDAWアプリまたは画面全体を共有します。"
  print
  read -k 1 "?何かキーを押すと閉じます。"
else
  print "Installation complete."
  print "1. Insert one DAS Send instance in your DAW's master."
  print "2. Add DAS Audio (DAW) as a source in OBS."
  print "3. For Discord, share your DAW application or full screen."
  print
  read -k 1 "?Press any key to close."
fi
print
