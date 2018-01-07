RequestExecutionLevel admin

!define APP_NAME "Project Cartographer"
!define COMP_NAME "H2PC"
!define WEB_SITE "http://h2v.online"
!define VERSION "01.00.00.00"
!define COPYRIGHT "Author  © 2006"
!define DESCRIPTION "H2PC Project Cartographer installer for systems with Halo 2 installed"
!define INSTALLER_NAME "C:\Git\h2pc_installer\cartographer_installer.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
!define MUI_FINISHPAGE_RUN "$INSTDIR\halo2.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Run Halo 2"


!include "MUI.nsh"
!include "DirectSetup.nsh"
!include "x64.nsh"
!include "LogicLib.nsh"
!include "psexec.nsh" 
!include "Sections.nsh"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!define MUI_WELCOMEPAGE_TEXT "This installer is for people who have Halo 2 for Windows Vista installed on their computer and would like to install Project Cartographer in order to restore online play.\r\n\r\nIf you do not have Halo 2 installed, please download the complete installer from www.h2v.online/install\r\n\r\nOtherwise please press 'Next' to continue setup"

!define MUI_ICON "doc_map.ico"
;!define MUI_HEADERIMAGE_BITMAP "logo.png"
!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_LICENSE "termsofservice.rtf"

!define MUI_PAGE_CUSTOMFUNCTION_SHOW LicenseShow
!insertmacro MUI_PAGE_LICENSE "termsofservice.rtf"
LicenseForceSelection checkbox
Function LicenseShow
 ScrollLicense::Set /NOUNLOAD
FunctionEnd

Function .onGUIEnd
 ScrollLicense::Unload
FunctionEnd

######################################################################

VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP_NAME}"
VIAddVersionKey "CompanyName"  "${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

Name "${APP_NAME}"
Caption "Project Cartographer Mod Installer"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDirRegKey "${REG_ROOT}" "${UNINSTALL_PATH}" "UninstallString"

Function .onInit

${If} ${RunningX64}
  SetRegView 64
  ReadRegStr $INSTDIR HKLM "SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo 2\1.0" "GameInstallDir" 
${Else}
  SetRegView 32
  ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\Microsoft Games\Halo 2\1.0" "GameInstallDir" 
${EndIf}

${If} $INSTDIR == ""
  StrCpy $INSTDIR "C:\Program Files (x86)\Microsoft Games\Halo 2\"
${Else}
  
${EndIf}

FunctionEnd

InstallDir "$INSTDIR"
######################################################################

!include "MUI.nsh"

!ifdef LICENSE_TXT
!insertmacro MUI_PAGE_LICENSE "${LICENSE_TXT}"
!endif

!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

######################################################################

Section -MainProgram
${INSTALL_TYPE}

SetOverwrite ifnewer

DetailPrint "Installing Project Cartographer to $INSTDIR"
SetOutPath "$INSTDIR"
;Abort
File "C:\Git\h2pc_installer\cartographer_manual_update\gungame.ini"
File "C:\Git\h2pc_installer\cartographer_manual_update\libcrypto-1_1.dll"
File "C:\Git\h2pc_installer\cartographer_manual_update\libssl-1_1.dll"
File "C:\Git\h2pc_installer\cartographer_manual_update\MF.dll"
File "C:\Git\h2pc_installer\cartographer_manual_update\README.txt"
File "C:\Git\h2pc_installer\cartographer_manual_update\Update.exe"
File "C:\Git\h2pc_installer\cartographer_manual_update\xinput9_1_0.dll"
;File "C:\Git\h2pc_installer\cartographer_manual_update\xlive.dll"
SetOutPath "$INSTDIR\sounds"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\AchievementUnlocked.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\h2pc_logo.png"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\infected.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\infection.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\last_man_standing.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\new_zombie.wav"

inetc::get "https://cartographer.online/latest/xlive.dll" "$EXEDIR\xlive.dll"             
Pop $0
;StrCmp $0 "OK" dlok
${If} $0 == "OK"
	DetailPrint "Download OK, installing $EXEDIR\xlive.dll to $INSTDIR"
	CopyFiles "$EXEDIR\xlive.dll" $INSTDIR
${Else}

DetailPrint "xlive.dll download error, installing built in dll"
SetOutPath "$INSTDIR"
File "C:\Git\h2pc_installer\cartographer_manual_update\xlive.dll"
  ;Abort
${EndIf}
SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall_cartographer.exe"

WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall_cartographer.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"

!ifdef WEB_SITE
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
!endif
SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}
Delete "$INSTDIR\gungame.ini"
Delete "$INSTDIR\libcrypto-1_1.dll"
Delete "$INSTDIR\libssl-1_1.dll"
Delete "$INSTDIR\MF.dll"
Delete "$INSTDIR\README.txt"
Delete "$INSTDIR\Update.exe"
Delete "$INSTDIR\xinput9_1_0.dll"
Delete "$INSTDIR\xlive.dll"
Delete "$INSTDIR\sounds\AchievementUnlocked.wav"
Delete "$INSTDIR\sounds\h2pc_logo.png"
Delete "$INSTDIR\sounds\infected.wav"
Delete "$INSTDIR\sounds\infection.wav"
Delete "$INSTDIR\sounds\last_man_standing.wav"
Delete "$INSTDIR\sounds\new_zombie.wav"
 
RmDir "$INSTDIR\sounds"
 
Delete "$INSTDIR\uninstall_cartographer.exe"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP_NAME} website.url"
!endif

RmDir "$INSTDIR"

DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
SectionEnd

######################################################################

