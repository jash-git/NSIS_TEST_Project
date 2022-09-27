; 該指令檔使用 HM VNISEdit 指令檔編輯器精靈產生

; 安裝程式初始定義常量
!define PRODUCT_NAME "VTeamCreditCard";jash modify
!define PRODUCT_VERSION "v1001";jash modify
!define PRODUCT_PUBLISHER "VTEAM, Inc.";jash modify
!define PRODUCT_WEB_SITE "http://www.vteam.com.tw/";jash modify
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}";jash modify
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
BrandingText "Provided by VTEAM, Inc."  # 設置UI分割線上的文字。

SetCompressor /SOLID lzma

; ------ MUI 現代介面定義 (1.67 版本以上相容) ------
!include "MUI.nsh"

; MUI 預定義常量
!define MUI_ABORTWARNING
!define MUI_ICON "net6.0\sys.ico";jash modify
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; 語言選擇視窗常量設定
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; 歡迎頁面
!insertmacro MUI_PAGE_WELCOME
; 授權合約頁面
;!insertmacro MUI_PAGE_LICENSE "..\..\..\path\to\licence\YourSoftwareLicence.txt"
; 安裝資料夾選擇頁面
!insertmacro MUI_PAGE_DIRECTORY
; 安裝過程頁面
!insertmacro MUI_PAGE_INSTFILES
; 安裝完成頁面
;!define MUI_FINISHPAGE_RUN "$INSTDIR\BCard_WCard_Generator.exe"
!insertmacro MUI_PAGE_FINISH

; 安裝卸載過程頁面
!insertmacro MUI_UNPAGE_INSTFILES

; 安裝介麵包含的語言設定
;!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "TradChinese"

; 安裝預釋放檔案
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 現代介面定義結束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_Setup ${PRODUCT_VERSION}.exe";jash modify
InstallDir "C:\${PRODUCT_NAME}";jash modify
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show


Section "MainSection" SEC01
  SetOverwrite on
  SetOutPath "$INSTDIR"
  
  ExecWait "taskkill /f /im VTeamCreditCard.exe";jash modify;/f 強制
  File "net6.0\unzip.exe";jash modify
  
  Push $1
  Push $0
  ReadRegDWORD $0 HKLM "SOFTWARE\WOW6432Node\dotnet\Setup\InstalledVersions\x64\sharedfx\Microsoft.WindowsDesktop.App" "6.0.8";jash modify
  ReadRegDWORD $1 HKLM "SOFTWARE\WOW6432Node\dotnet\Setup\InstalledVersions\x86\sharedfx\Microsoft.WindowsDesktop.App" "6.0.8";jash modify
  ${If} $1 == ""
	MessageBox MB_ICONINFORMATION|MB_OK "無安裝 .NET6 Runtime$\n開始下載並安裝 .NET6 Runtime";jash modify
    File "net6.0\wget.exe";jash modify
	
	;nsExec::Exec "$INSTDIR\wget.exe --no-check-certificate https://storage.googleapis.com/vteam-pub-storage/vteam_modules/DOT_NET_RUNTIME/windowsdesktop-runtime-6.0.8-win-x64.zip -O $INSTDIR\windowsdesktop-runtime-6.0.8-win-x64.exe";jash modify
	DetailPrint "開始下載 .NET6 Runtime,請稍後..."
	nsExec::Exec "$INSTDIR\wget.exe --no-check-certificate https://storage.googleapis.com/vteam-pub-storage/vteam_modules/DOT_NET_RUNTIME/windowsdesktop-runtime-6.0.8-win-x86.zip -O $INSTDIR\windowsdesktop-runtime-6.0.8-win-x86.zip";jash modify
	nsExec::Exec "$INSTDIR\unzip.exe -o $INSTDIR\windowsdesktop-runtime-6.0.8-win-x86.zip";jash modify ~ -o強制覆蓋
	DetailPrint "開始安裝 .NET6 Runtime,請稍後..."	
	nsExec::Exec "$INSTDIR\windowsdesktop-runtime-6.0.8-win-x86.exe -s";jash modify
	DetailPrint "安裝 .NET6 Runtime已完成"
	
	Delete "$INSTDIR\wget.exe";jash modify
	Delete "$INSTDIR\windowsdesktop-runtime-6.0.8-win-x86.exe";jash modify
	Delete "$INSTDIR\windowsdesktop-runtime-6.0.8-win-x86.zip";jash modify
  ${Else}
  	;MessageBox MB_ICONINFORMATION|MB_OK "有安裝 .NET6 Runtime";jash modify
  ${EndIf}
  
  File "net6.0\deb.zip";jash modify
  nsExec::Exec "$INSTDIR\unzip.exe -o $INSTDIR\deb.zip";jash modify ~ -o強制覆蓋
  File "net6.0\VTeamCreditCard.exe";jash modify

  Delete "$INSTDIR\deb.zip";jash modify
  Delete "$INSTDIR\unzip.exe";jash modify
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\VTeamCreditCard.exe";jash modify
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\VTeamCreditCard.exe";jash modify
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

#-- 依 NSIS 指令檔編輯規則，所有 Function 區段必須放置在 Section 區段之後編寫，以避免安裝程式出現未可預知的問題。--#

Function .onInit
  InitPluginsDir
  ;File "/oname=$PLUGINSDIR\Splash_YourSplash.bmp" "c:\path\to\Splash\YourSplash.bmp"
  ;File "/oname=$PLUGINSDIR\Splash_YourSplash.wav" "c:\path\to\Splash\YourSplashSound.wav"
  ; 使用閃屏外掛程式顯示閃屏
  splash::show 1000 "$PLUGINSDIR\Splash_YourSplash"
  Pop $0 ; $0 返回 '1' 表示使用者提前關閉閃屏, 返回 '0' 表示閃屏正常結束, 返回 '-1' 表示閃屏顯示出錯
  ;File "/oname=$PLUGINSDIR\bgm_YourMIDI.mid" "c:\path\to\YourMIDI.mid"
  ; 開啟音樂檔案
  System::Call "winmm.dll::mciSendString(t 'OPEN $PLUGINSDIR\bgm_YourMIDI.mid TYPE SEQUENCER ALIAS BGMUSIC', t .r0, i 130, i 0)"
  ; 開始播放音樂檔案
  System::Call "winmm.dll::mciSendString(t 'PLAY BGMUSIC NOTIFY', t .r0, i 130, i 0)"
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onGUIEnd
  ; 停止播放音樂檔案
  System::Call "winmm.dll::mciSendString(t 'STOP BGMUSIC',t .r0,i 130,i 0)"
  ; 關閉音樂檔案
  System::Call "winmm.dll::mciSendString(t 'CLOSE BGMUSIC',t .r0,i 130,i 0)"
FunctionEnd

/******************************
 *  以下是安裝程式的卸載部分  *
 ******************************/

Section Uninstall 
  RMDir /r "$INSTDIR\*.*"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 依 NSIS 指令檔編輯規則，所有 Function 區段必須放置在 Section 區段之後編寫，以避免安裝程式出現未可預知的問題。--#

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確實要完全移除 $(^Name) ，及其所有的元件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地從你的電腦移除。";MessageBox MB_ICONINFORMATION|MB_OK "PC reboot now"
  ;Reboot
FunctionEnd
