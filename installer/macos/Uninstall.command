#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/Language.zsh"

VST3_TARGET="${HOME}/Library/Audio/Plug-Ins/VST3/DAS Send.vst3"
AU_TARGET="${HOME}/Library/Audio/Plug-Ins/Components/DAS Send.component"
OBS_TARGET="${HOME}/Library/Application Support/obs-studio/plugins/das-obs-source.plugin"

if [[ "${DAS_LANGUAGE}" == ja ]]; then
  print "DawAudioStreamer macOSプレビュー版をアンインストールします。"
  print "DAWとOBSを終了してから続けてください。"
else
  print "Uninstalling DawAudioStreamer macOS Preview."
  print "Close your DAW and OBS before continuing."
fi
print

rm -rf "${VST3_TARGET}" "${AU_TARGET}" "${OBS_TARGET}"
/usr/bin/killall -u "${USER}" AudioComponentRegistrar 2>/dev/null || true

if [[ "${DAS_LANGUAGE}" == ja ]]; then
  print "アンインストールが完了しました。DAWプロジェクトとOBSシーンは削除していません。"
  read -k 1 "?何かキーを押すと閉じます。"
else
  print "Uninstall complete. Your DAW projects and OBS scenes were not removed."
  read -k 1 "?Press any key to close."
fi
print
