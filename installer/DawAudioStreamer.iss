#define MyAppName "DawAudioStreamer"
#define MyAppVersion "0.4.3"
#define MyAppFileVersion "0.4.3.0"
#define MyAppPublisher "yoruhinot"
#define MyAppCopyright "Copyright (c) 2026 yoruhinot"
#define MyAppUrl "https://github.com/yoruhinot/DawAudioStreamer"
#define MyAppSupportUrl "https://github.com/yoruhinot/DawAudioStreamer/issues"
#define MyAppUpdatesUrl "https://github.com/yoruhinot/DawAudioStreamer/releases"
#define BuildRoot "..\build\windows-msvc-release"
#define SourceArchive "..\build\source\DawAudioStreamer-0.4.3-source.zip"

[Setup]
AppId={{A2AB3F48-3BA4-46A2-9AE8-E46A6D107BA3}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppUrl}
AppSupportURL={#MyAppSupportUrl}
AppUpdatesURL={#MyAppUpdatesUrl}
AppComments={cm:AppComments}
VersionInfoVersion={#MyAppFileVersion}
VersionInfoProductVersion={#MyAppFileVersion}
VersionInfoDescription=DawAudioStreamer Setup
VersionInfoCompany={#MyAppPublisher}
VersionInfoCopyright={#MyAppCopyright}
DefaultDirName={autopf}\DawAudioStreamer
DefaultGroupName=DawAudioStreamer
DisableProgramGroupPage=yes
OutputDir=..\build\installer
OutputBaseFilename=DawAudioStreamer-Setup-{#MyAppVersion}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayName=DawAudioStreamer {#MyAppVersion}
UninstallDisplayIcon={uninstallexe}
CloseApplications=yes
RestartApplications=no
SetupLogging=yes
LanguageDetectionMethod=uilanguage
ShowLanguageDialog=yes
UsePreviousLanguage=yes
LicenseFile=..\LICENSES\AGPL-3.0-only.txt

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; InfoAfterFile: "..\docs\QuickStart.en.txt"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"; InfoAfterFile: "..\docs\QuickStart.ja.txt"

[CustomMessages]
english.AppComments=Stream your DAW's ASIO audio to OBS and Discord screen share
english.IconQuickStart=Quick Start
english.IconLicense=License and Source
english.IconUninstall=Uninstall
english.RunQuickStart=Open Quick Start guide
english.RunVbCable=Open VB-CABLE setup guide for Discord
english.VbCableUrl=https://yoruhinot.github.io/DawAudioStreamer/en/?lang=en#vbcable
english.VbCableAvailableDesc=VB-CABLE was found
english.VbCableAvailableMsg=You can use both OBS and Discord.%n%nDawAudioStreamer does not change your default audio device, ASIO settings, or Discord microphone.
english.VbCableNeededDesc=VB-CABLE is required for Discord
english.VbCableCheckFailedMsg=Installation will continue. OBS works without VB-CABLE.%n%nTo use Discord screen share audio, VB-CABLE is required.%nClick Finish to open the setup guide. Uncheck it on the final screen if you don't need it.
english.VbCableNotFoundMsg=VB-CABLE was not found on this PC.%n%n- OBS works as-is.%n- VB-CABLE is required for Discord screen share audio.%n- This installer does not change third-party drivers or default audio settings.%n%nClick Finish to open the setup guide. Uncheck it on the final screen if you don't need it.
english.VbCablePageTitle=Checking audio for Discord

japanese.AppComments=DAWのASIO音声をOBSとDiscordの画面共有へ送ります
japanese.IconQuickStart=クイックスタート
japanese.IconLicense=ライセンスとソース
japanese.IconUninstall=アンインストール
japanese.RunQuickStart=クイックスタートを開く
japanese.RunVbCable=Discord用のVB-CABLE導入手順を開く
japanese.VbCableUrl=https://yoruhinot.github.io/DawAudioStreamer/?lang=ja#vbcable
japanese.VbCableAvailableDesc=VB-CABLEが見つかりました
japanese.VbCableAvailableMsg=OBSとDiscordの両方を使用できます。%n%nDawAudioStreamerは既定の音声デバイス、ASIO設定、Discordのマイク設定を変更しません。
japanese.VbCableNeededDesc=Discordを使う場合はVB-CABLEを追加してください
japanese.VbCableCheckFailedMsg=インストールは続行できます。OBSはそのまま使用できます。%n%nDiscordで音声を共有するにはVB-CABLEが必要です。%n完了を押すと詳しい導入手順を開きます。不要な場合は完了画面でチェックを外せます。
japanese.VbCableNotFoundMsg=このPCではVB-CABLEが見つかりませんでした。%n%n・OBSはこのまま使用できます。%n・Discordの画面共有音声にはVB-CABLEが必要です。%n・本セットアップは第三者ドライバーや既定の音声設定を変更しません。%n%n完了を押すと詳しい導入手順を開きます。不要な場合は完了画面でチェックを外せます。
japanese.VbCablePageTitle=Discord用音声の確認

[Files]
Source: "{#BuildRoot}\plugins\send-vst3\Release\das-virtual-audio-check.exe"; DestDir: "{tmp}"; Flags: dontcopy
Source: "{#BuildRoot}\plugins\send-vst3\DasSend_artefacts\Release\VST3\DAS Send.vst3\*"; DestDir: "{commoncf64}\VST3\DAS Send.vst3"; Flags: ignoreversion recursesubdirs createallsubdirs restartreplace uninsrestartdelete
Source: "{#BuildRoot}\plugins\obs-source\Release\das-obs-source.dll"; DestDir: "{commonappdata}\obs-studio\plugins\das-obs-source\bin\64bit"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "..\plugins\obs-source\data\locale\ja-JP.ini"; DestDir: "{commonappdata}\obs-studio\plugins\das-obs-source\data\locale"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "..\docs\QuickStart.en.txt"; DestDir: "{app}"; DestName: "QuickStart.txt"; Languages: english; Flags: ignoreversion
Source: "..\docs\QuickStart.ja.txt"; DestDir: "{app}"; DestName: "QuickStart.txt"; Languages: japanese; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.ja.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\CHANGELOG.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\PRIVACY.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\PRIVACY.ja.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSES\*"; DestDir: "{app}\licenses"; Flags: ignoreversion
Source: "..\libs\transport\LICENSE"; DestDir: "{app}\licenses"; DestName: "MIT-transport.txt"; Flags: ignoreversion
Source: "..\THIRD_PARTY_NOTICES.md"; DestDir: "{app}\licenses"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\LICENSE.md"; DestDir: "{app}\licenses"; DestName: "JUCE-LICENSE.md"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\modules\juce_audio_processors\format_types\VST3_SDK\LICENSE.txt"; DestDir: "{app}\licenses"; DestName: "VST3-SDK-LICENSE.txt"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\modules\juce_graphics\fonts\harfbuzz\COPYING"; DestDir: "{app}\licenses"; DestName: "HarfBuzz-COPYING.txt"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\modules\juce_graphics\unicode\sheenbidi\LICENSE"; DestDir: "{app}\licenses"; DestName: "SheenBidi-LICENSE.txt"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\modules\juce_graphics\image_formats\pnglib\LICENSE"; DestDir: "{app}\licenses"; DestName: "libpng-LICENSE.txt"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\modules\juce_graphics\image_formats\jpglib\README"; DestDir: "{app}\licenses"; DestName: "IJG-JPEG-README.txt"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\juce-src\modules\juce_core\zip\zlib\LICENSE"; DestDir: "{app}\licenses"; DestName: "zlib-LICENSE.txt"; Flags: ignoreversion
Source: "{#BuildRoot}\_deps\obs_headers-src\COPYING"; DestDir: "{app}\licenses"; DestName: "OBS-COPYING.txt"; Flags: ignoreversion
Source: "{#SourceArchive}"; DestDir: "{app}\source"; Flags: ignoreversion

[Icons]
Name: "{group}\{cm:IconQuickStart}"; Filename: "{app}\QuickStart.txt"
Name: "{group}\{cm:IconLicense}"; Filename: "{app}\LICENSE"
Name: "{group}\{cm:IconUninstall}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\QuickStart.txt"; Description: "{cm:RunQuickStart}"; Flags: postinstall shellexec skipifsilent nowait
Filename: "{cm:VbCableUrl}"; Description: "{cm:RunVbCable}"; Flags: postinstall shellexec skipifsilent; Check: ShouldOfferVbCable

[Code]
var
  VirtualAudioAvailable: Boolean;
  VirtualAudioCheckFailed: Boolean;
  VirtualAudioPage: TOutputMsgWizardPage;

function ShouldOfferVbCable: Boolean;
begin
  Result := not VirtualAudioAvailable;
end;

procedure InitializeWizard;
var
  CheckResult: Integer;
  PageDescription: String;
  PageMessage: String;
begin
  VirtualAudioAvailable := False;
  VirtualAudioCheckFailed := False;
  try
    ExtractTemporaryFile('das-virtual-audio-check.exe');
    if Exec(ExpandConstant('{tmp}\das-virtual-audio-check.exe'), '', '', SW_HIDE,
            ewWaitUntilTerminated, CheckResult) then
    begin
      VirtualAudioAvailable := CheckResult = 0;
      VirtualAudioCheckFailed := CheckResult = 2;
    end
    else
      VirtualAudioCheckFailed := True;
  except
    VirtualAudioCheckFailed := True;
  end;

  if VirtualAudioAvailable then
  begin
    PageDescription := CustomMessage('VbCableAvailableDesc');
    PageMessage := CustomMessage('VbCableAvailableMsg');
  end
  else if VirtualAudioCheckFailed then
  begin
    PageDescription := CustomMessage('VbCableNeededDesc');
    PageMessage := CustomMessage('VbCableCheckFailedMsg');
  end
  else
  begin
    PageDescription := CustomMessage('VbCableNeededDesc');
    PageMessage := CustomMessage('VbCableNotFoundMsg');
  end;

  VirtualAudioPage := CreateOutputMsgPage(wpLicense, CustomMessage('VbCablePageTitle'),
                                           PageDescription, PageMessage);
end;
