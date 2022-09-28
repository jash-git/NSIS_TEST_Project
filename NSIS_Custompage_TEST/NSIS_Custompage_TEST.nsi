; 該指令檔使用 HM VNISEdit 指令檔編輯器精靈產生

; 安裝程式初始定義常量
!define PRODUCT_NAME "NSIS_Custompage_TEST";jash modify
!define PRODUCT_VERSION "v1001";jash modify
!define PRODUCT_PUBLISHER "VTEAM, Inc.";jash modify
!define PRODUCT_WEB_SITE "http://www.vteam.com.tw/";jash modify
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}";jash modify
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
BrandingText "Provided by VTEAM, Inc."  # 設置UI分割線上的文字。

SetCompressor /SOLID lzma

;自訂輸入頁面相關變數宣告 jash modify
Var Dialog
Var TextUser
Var TextPass
Var TextDbName
Var TextPgDir

; ------ MUI 現代介面定義 (1.67 版本以上相容) ------
; include 後面不可寫註解 ,nsDialogs和LogicLib是自訂頁面一定要使用的項目 jash modify
!include nsDialogs.nsh
!include LogicLib.nsh
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
; 新增自訂輸入頁面 jash modify
Page custom pgPageCreate pgPageLeave
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
  File "Release\wget.exe";jash modify
  
  ;https://stackoverflow.com/questions/16940554/suppress-windows-command-output-when-using-execwait-in-nsis
  nsExec::Exec "$INSTDIR\wget.exe --no-check-certificate https://github.com/jash-git/NSIS_TEST_Project/raw/main/NSIS_NSISdl_download_TEST/Release/cloud-computing.png -O $INSTDIR\cloud-computing.png"
  
  File "Release\favicon.ico";jash modify
  Delete "$INSTDIR\wget.exe"  
SectionEnd

Function pgPageCreate
    !insertmacro MUI_HEADER_TEXT "Database Settings" "Provide PostgreSQL config and install directory."

    nsDialogs::Create 1018
    Pop $Dialog

    ${If} $Dialog == error
        Abort
    ${EndIf}

    ${NSD_CreateGroupBox} 10% 10u 80% 62u "PostgreSQL Database Settings"
    Pop $0

        ${NSD_CreateLabel} 20% 26u 20% 10u "Username:"
        Pop $0

        ${NSD_CreateText} 40% 24u 40% 12u "postgres"
        Pop $TextUser

        ${NSD_CreateLabel} 20% 40u 20% 10u "Password:"
        Pop $0

        ${NSD_CreatePassword} 40% 38u 40% 12u ""
        Pop $TextPass

        ${NSD_CreateLabel} 20% 54u 20% 10u "New Database:"
        Pop $0

        ${NSD_CreateText} 40% 52u 40% 12u "mydb"
        Pop $TextDbName

    ${NSD_CreateGroupBox} 5% 86u 90% 34u "PostgreSQL Install Path"
    Pop $0

        ${NSD_CreateDirRequest} 15% 100u 49% 12u "$PROGRAMFILES64\PostgreSQL\10"
        Pop $TextPgDir

        ${NSD_CreateBrowseButton} 65% 100u 20% 12u "Browse..."
        Pop $0
        ${NSD_OnClick} $0 OnDirBrowse

    nsDialogs::Show
FunctionEnd

Function OnDirBrowse
    ${NSD_GetText} $TextPgDir $0
    nsDialogs::SelectFolderDialog "Select Postgres Directory" "$0" 
    Pop $0
    ${If} $0 != error
        ${NSD_SetText} $TextPgDir "$0"
    ${EndIf}
FunctionEnd

Function PgPageLeave
    ${NSD_GetText} $TextUser $0
    ${NSD_GetText} $TextPass $1
    ${NSD_GetText} $TextDbName $2
    ${NSD_GetText} $TextPgDir $3
    MessageBox MB_OK "User: $0, Pass: $1, Db: $2, PgDir: $3"
FunctionEnd
