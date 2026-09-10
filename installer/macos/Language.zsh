# Source this file before any installation or removal work.
# Read the preferred UI language, not the user's region or network location.
DAS_LANGUAGE=$(/usr/bin/osascript -l JavaScript -e \
  'ObjC.import("Foundation"); $.NSUserDefaults.standardUserDefaults.objectForKey("AppleLanguages").objectAtIndex(0).js' \
  2>/dev/null) || DAS_LANGUAGE="${LC_ALL:-${LC_MESSAGES:-${LANG:-en}}}"
case "${DAS_LANGUAGE}" in
  ja*) DAS_LANGUAGE=ja ;;
  *) DAS_LANGUAGE=en ;;
esac

# Enter keeps the detected language. No system preference is modified.
if [[ -t 0 ]]; then
  while true; do
    read "DAS_LANGUAGE_CHOICE?Language / 言語 [${DAS_LANGUAGE}] (en/ja): "
    case "${DAS_LANGUAGE_CHOICE}" in
      "") break ;;
      en|ja) DAS_LANGUAGE="${DAS_LANGUAGE_CHOICE}"; break ;;
    esac
  done
fi
