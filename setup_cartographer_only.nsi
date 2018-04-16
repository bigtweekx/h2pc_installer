RequestExecutionLevel admin

!define APP_NAME "Halo 2 Project Cartographer"
!define COMP_NAME "H2PC"
!define WEB_SITE "https://cartographer.online"
!define VERSION "01.02.00.00"
!define COPYRIGHT "H2PC  © 2018"
!define DESCRIPTION "H2PC Project Cartographer installer for systems with Halo 2 installed"
!define INSTALLER_NAME "C:\Git\h2pc_installer\cartographer_installer.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

!define MUI_FINISHPAGE_RUN "$INSTDIR\halo2.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS "-windowed"  
!define MUI_FINISHPAGE_RUN_TEXT "Run Halo 2 to login and play"

!define MUI_FINISHPAGE_LINK "Please visit our website to learn about Project Cartographer"
!define MUI_FINISHPAGE_LINK_LOCATION "https://halo2.online/forums/current-news.11/"

!include "MUI.nsh"
!include "DirectSetup.nsh"
!include "x64.nsh"
!include "LogicLib.nsh"
!include "psexec.nsh" 
!include "Sections.nsh"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING
!define MUI_ICON "doc_map.ico"

!define MUI_WELCOMEPAGE_TEXT "This installer is for people who have Halo 2 for Windows Vista installed on their computer and would like to install Project Cartographer in order to restore online play.\r\n\r\nIf you do not have Halo 2 installed, please download the h2pc installer from the link below and delete this setup file.\r\n\r\nOtherwise please press 'Next' to continue setup"

;################ Link on welcome page
!define MUI_PAGE_CUSTOMFUNCTION_PRE WelcomePageSetupLinkPre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW WelcomePageSetupLinkShow
!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_COMPONENTS
;!insertmacro MUI_PAGE_INSTFILES
 
Section "secDummy"
  ; ...
SectionEnd
 
 
Function WelcomePageSetupLinkPre
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "Numfields" "4" ; increase counter
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Bottom" "122" ; limit size of the upper label
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Type" "Link"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Text" "Link to h2pc installer"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "State" "http://www.h2pcmt.com/Cartographer/Installer/"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Left" "120"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Right" "315"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Top" "123"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Bottom" "132"
FunctionEnd
 
Function WelcomePageSetupLinkShow
  ; Thanks to pengyou
  ; Fix colors of added link control
  ; See http://forums.winamp.com/showthread.php?s=&threadid=205674
  Push $0
 
  GetDlgItem $0 $MUI_HWND 1203
  SetCtlColors $0 "0000FF" "FFFFFF"
  ; underline font
  CreateFont $1 "$(^Font)" "$(^FontSize)" "400" /UNDERLINE 
  SendMessage $0 ${WM_SETFONT} $1 1 
  Pop $0
 
FunctionEnd



;!define MUI_HEADERIMAGE_BITMAP "logo.png"
;!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_LICENSE "termsofservice.rtf"

!define REG_START_MENU "Start Menu Folder"

!define MUI_PAGE_CUSTOMFUNCTION_SHOW LicenseShow
!insertmacro MUI_PAGE_LICENSE "termsofservice.rtf"
LicenseForceSelection checkbox
Function LicenseShow
 ScrollLicense::Set /NOUNLOAD
FunctionEnd

Function .onGUIEnd
 ScrollLicense::Unload
FunctionEnd

var SM_Folder 
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
  MessageBox MB_YESNOCANCEL "Halo 2 not found. Are you sure it is installed? Press Yes to continue setup and specify Halo 2 install location. Press No to close installer and open download page. Press Cancel to close installer" IDYES yes IDNO no
  Quit
  yes:
  StrCpy $INSTDIR "C:\Program Files (x86)\Microsoft Games\Halo 2\"
  Goto next
  no:
  ExecShell "open" "http://www.h2pcmt.com/Cartographer/Installer/"
  Quit
  next:
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

!ifdef REG_START_MENU
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Halo 2 Project Cartographer"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
!insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
!endif

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"



!define MUI_FINISHPAGE_LINK "Official Site for Project Cartographer"
!define MUI_FINISHPAGE_LINK_LOCATION "https://cartographer.online/"



Function GetFileVersion
	!define GetFileVersion `!insertmacro GetFileVersionCall`
 
	!macro GetFileVersionCall _FILE _RESULT
		Push `${_FILE}`
		Call GetFileVersion
		Pop ${_RESULT}
	!macroend
 
	Exch $0
	Push $1
	Push $2
	Push $3
	Push $4
	Push $5
	Push $6
	ClearErrors
 
	GetDllVersion '$0' $1 $2
	IfErrors error
	IntOp $3 $1 >> 16
	IntOp $3 $3 & 0x0000FFFF
	IntOp $4 $1 & 0x0000FFFF
	IntOp $5 $2 >> 16
	IntOp $5 $5 & 0x0000FFFF
	IntOp $6 $2 & 0x0000FFFF
	StrCpy $0 '$3.$4.$5.$6'
	goto end
 
	error:
	SetErrors
	StrCpy $0 ''
 
	end:
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Exch $0
FunctionEnd

######################################################################

Section -MainProgram
${INSTALL_TYPE}

SetOverwrite ifnewer
Delete "$INSTDIR\H2Launcher.exe"
DetailPrint "Installing Project Cartographer to $INSTDIR"
SetOutPath "$INSTDIR"
;Abort
File "C:\Git\h2pc_installer\cartographer_manual_update\commands.txt"
File "C:\Git\h2pc_installer\cartographer_manual_update\gungame.ini"
File "C:\Git\h2pc_installer\cartographer_manual_update\libcrypto-1_1.dll"
File "C:\Git\h2pc_installer\cartographer_manual_update\libssl-1_1.dll"
File "C:\Git\h2pc_installer\cartographer_manual_update\MF.dll"
File "C:\Git\h2pc_installer\cartographer_manual_update\README.txt"
File "C:\Git\h2pc_installer\cartographer_manual_update\xinput9_1_0.dll"
;File "C:\Git\h2pc_installer\cartographer_manual_update\xlive.dll"
SetOutPath "$INSTDIR\sounds"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\AchievementUnlocked.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\h2pc_logo.png"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\infected.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\infection.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\last_man_standing.wav"
File "C:\Git\h2pc_installer\cartographer_manual_update\sounds\new_zombie.wav"
SetOutPath "$INSTDIR\temp"
File "C:\Git\h2pc_installer\cartographer_manual_update\Update.exe"
File "C:\Git\h2pc_installer\cartographer_manual_update\vcredist_2013_x86.exe"


inetc::get "https://cartographer.online/latest/xlive.dll" "$EXEDIR\xlive.dll" /end            
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
Delete "$EXEDIR\xlive.dll"
SectionEnd

Section "Halo 2 Update" 
 
 SectionIn RO
 ${GetFileVersion} "$INSTDIR\halo2.exe" $R0
 DetailPrint "Halo 2 Version is $R0"
 ${If} $R0 != "1.0.0.11122"
	DetailPrint "Updating Halo 2..."
	ExecWait "$INSTDIR\temp\Update.exe"
 	DetailPrint "Finished updating Halo 2"
 	;Delete "$INSTDIR\temp\Update.exe"
	DetailPrint "Halo 2 exe updated"
	
${Else}
	DetailPrint "Halo 2 is the correct version"
${EndIf}
SectionEnd

Section "Visual c++ 2013"
 
 DetailPrint "Running Visual C++ 2013 setup..."
 DetailPrint "Installer may appear stuck, please wait for setup to continue"
 ExecWait '"$INSTDIR\temp\vcredist_2013_x86.exe" /q /norestart' $R1
 DetailPrint "Finished visual C++ 2013 setup ... "
 ${If} $R1 = "0" 
	DetailPrint "$R1"
		
${ElseIf} $R1 = "3010"
	DetailPrint "$R1"
	
${Else}
	DetailPrint "Visual C++ Error $R1"
	MessageBox MB_OK|MB_ICONSTOP "Error with Visual C++ 2013 install. You may encounter issues when running the game.Please download and install manually, then run the game. Press OK to finish setup"
	
${EndIf}
 ;MessageBox MB_OK|MB_ICONSTOP "return code: $R1"
 Delete "$INSTDIR\temp\vcredist_2013_x86.exe"
 RMDir /r "$INSTDIR\temp"

SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall_cartographer.exe"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateDirectory "$SMPROGRAMS\$SM_Folder"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME} (Windowed).lnk" "$INSTDIR\halo2.exe" "-windowed"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME} (No Vsync).lnk" "$INSTDIR\halo2.exe" "-novsync"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME} (No Sound).lnk" "$INSTDIR\halo2.exe" "-nosound"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk" "$INSTDIR\halo2.exe"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\halo2.exe" "-windowed"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall_cartographer.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME} Website.lnk" "$INSTDIR\${APP_NAME} website.url"
!endif
!insertmacro MUI_STARTMENU_WRITE_END
!endif


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
Delete "$INSTDIR\commands.txt"
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

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk"
Delete "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk"
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} (Windowed).lnk"
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} (No Vsync).lnk"
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} (No Sound).lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} Website.lnk"
!endif
Delete "$DESKTOP\${APP_NAME}.lnk"

RmDir "$SMPROGRAMS\$SM_Folder"
!endif

!ifndef REG_START_MENU
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk"
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} (Windowed).lnk"
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} (No Vsync).lnk"
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} (No Sound).lnk"
Delete "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\Halo 2 Project Cartographer\${APP_NAME} Website.lnk"
!endif
Delete "$DESKTOP\${APP_NAME}.lnk"

RmDir "$SMPROGRAMS\$SM_Folder"
!endif

DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"


SectionEnd



######################################################################

