; 該指令檔使用 HM VNISEdit 指令檔編輯器精靈產生

; 安裝程式初始定義常量
!define PRODUCT_NAME "NSIS_taskkill_TEST";jash modify
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
!define MUI_ICON "Release\favicon.ico";jash modify
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
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "TradChinese"

; 安裝預釋放檔案
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 現代介面定義結束 ------


Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe";jash modify
InstallDir "C:\${PRODUCT_NAME}";jash modify-因應有MySQL，所以已把安裝目錄放在C槽下，原本~ InstallDir "$PROGRAMFILES\SYRIS Workstation"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show

Section "MainSection" SEC01
  SetOverwrite on
  SetOutPath "$INSTDIR"

  
  ExecWait "taskkill /f /im Calculator.exe"
  ExecWait "taskkill /f /im notepad.exe";/f 強制
  
  File "Release\favicon.ico";jash modify  
SectionEnd
