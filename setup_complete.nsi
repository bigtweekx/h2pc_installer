# Halo 2 Project Cartographer installer

#Includes code created using:
#NSIS Installation Script created by NSIS Quick Setup Script Generator v1.09.18
#Entirely Edited with NullSoft Scriptable Installation System                
#by Vlasis K. Barkas aka Red Wine red_wine@freemail.gr Sep 2006               

!define APP_NAME "Halo 2 Project Cartographer"
!define COMP_NAME "H2PC"
!define WEB_SITE "www.halo2.online"
!define VERSION "01.01.00.00"
!define COPYRIGHT "H2PC"
!define DESCRIPTION "H2PC Installer"
!define INSTALLER_NAME "C:\Git\h2pc_installer\h2pc_setup.exe"
!define MAIN_APP_EXE "H2Launcher.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_APP_EXE}"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

!define REG_START_MENU "Start Menu Folder"

var SM_Folder
Var DirectXSetupError
Var netSetupError
var vcredistSetupError
######################################################################

VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP_NAME}"
VIAddVersionKey "CompanyName"  "${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor LZMA
Name "${APP_NAME}"
Caption "${APP_NAME}"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDirRegKey "${REG_ROOT}" "${REG_APP_PATH}" ""
InstallDir "C:\Games\Halo 2 Project Cartographer"

######################################################################

!include "MUI.nsh"
!include "DirectSetup.nsh"
!include "x64.nsh"
!include "LogicLib.nsh"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

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

!insertmacro MUI_PAGE_DIRECTORY

!ifdef REG_START_MENU
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Halo 2 Project Cartographer"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
!insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
!endif

!insertmacro MUI_PAGE_INSTFILES

;!define MUI_FINISHPAGE_SHOWREADME "$instdir\readme.txt" ; Can also be a URL
!define MUI_FINISHPAGE_LINK "Official Site for Project Cartographer"
!define MUI_FINISHPAGE_LINK_LOCATION "http://www.h2v.online/"

/* !define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION finishpageaction
 */

!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Start Launcher to login and play"
;!define MUI_FINISHPAGE_RUN_TEXT "Run the launcher to login and play Halo 2? May take a while for window to appear, please be patient"
!define MUI_FINISHPAGE_SHOWREADME_TEXT 
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

ShowInstDetails show

######################################################################

Section -MainProgram

CreateDirectory $INSTDIR\maps  ;Start map extract

;Section 1 - Campaign maps (1/2) and temp installers for .net and directx
InitPluginsDir
; Call plug-in. Push filename to ZIP first, and the dest. folder last.
DetailPrint "Extracting files1.zip, this may take a while (1GB)"
nsisunz::UnzipToLog "$EXEDIR\files1.zip" "$INSTDIR\maps"
; Always check result on stack
Pop $0
StrCmp $0 "success" ok1
  DetailPrint "$0" ;print error message to log
  MessageBox MB_OK|MB_ICONSTOP "Install failed. $0 files1.zip Please make sure the file is unblocked or download the file again."
Abort
ok1:

;Section 2 - Campaign maps (2/2)
InitPluginsDir
; Call plug-in. Push filename to ZIP first, and the dest. folder last.
DetailPrint "Extracting files2.zip, this may take a while (1GB)"
nsisunz::UnzipToLog "$EXEDIR\files2.zip" "$INSTDIR\maps"
; Always check result on stack
Pop $0
StrCmp $0 "success" ok2
  DetailPrint "$0" ;print error message to log
  MessageBox MB_OK|MB_ICONSTOP "Install failed. $0 files2.zip Please make sure the file is unblocked or download the file again."
Abort
ok2:

;Section 3 - MP Maps, shared maps and mainmenu
InitPluginsDir
; Call plug-in. Push filename to ZIP first, and the dest. folder last.
DetailPrint "Extracting files3.zip, this may take a while (1GB)"
nsisunz::UnzipToLog "$EXEDIR\files3.zip" "$INSTDIR\maps"
; Always check result on stack
Pop $0
StrCmp $0 "success" ok3
  DetailPrint "$0" ;print error message to log
  MessageBox MB_OK|MB_ICONSTOP "Install failed. $0 files3.zip Please make sure the file is unblocked or download the file again."
Abort
ok3: ;end map extract

;Section 4 - Custom Maps
CreateDirectory "$DOCUMENTS\My Games\Halo 2\Maps"
InitPluginsDir
; Call plug-in. Push filename to ZIP first, and the dest. folder last.
DetailPrint "Extracting files4.zip, this may take a while (400MB)"
nsisunz::UnzipToLog "$EXEDIR\files4.zip" "$DOCUMENTS\My Games\Halo 2\Maps"
; Always check result on stack
Pop $0
StrCmp $0 "success" ok4
  DetailPrint "$0" ;print error message to log
  MessageBox MB_OK|MB_ICONSTOP "Install failed. $0 files4.zip Please make sure the file is unblocked or download the file again."
Abort
ok4: ;end map extract

${INSTALL_TYPE}
SetOverwrite ifnewer
SetOutPath "$INSTDIR" ;start base game file install
File "C:\Games\Halo 2 Project Cartographer\activate.exe"
File "C:\Games\Halo 2 Project Cartographer\Durazno.exe"
File "C:\Games\Halo 2 Project Cartographer\gungame.ini"
File "C:\Games\Halo 2 Project Cartographer\H2Launcher.exe"
File "C:\Games\Halo 2 Project Cartographer\h2startup1.ini"
File "C:\Games\Halo 2 Project Cartographer\halo2.exe"
File "C:\Games\Halo 2 Project Cartographer\halo2.exe.cat"
File "C:\Games\Halo 2 Project Cartographer\halo2.exe.cfg"
File "C:\Games\Halo 2 Project Cartographer\halo2final.ini"
File "C:\Games\Halo 2 Project Cartographer\ImeUiRes.dll"
File "C:\Games\Halo 2 Project Cartographer\launch.cab"
File "C:\Games\Halo 2 Project Cartographer\loading.bin"
File "C:\Games\Halo 2 Project Cartographer\MF.dll"
File "C:\Games\Halo 2 Project Cartographer\mspac.dll"
File "C:\Games\Halo 2 Project Cartographer\mspacres.dll"
File "C:\Games\Halo 2 Project Cartographer\mss32.dll"
File "C:\Games\Halo 2 Project Cartographer\mssdsp.flt"
File "C:\Games\Halo 2 Project Cartographer\PCCompat.dll"
File "C:\Games\Halo 2 Project Cartographer\Resource.dll"
File "C:\Games\Halo 2 Project Cartographer\sldlext.dll"
File "C:\Games\Halo 2 Project Cartographer\SLDL_DLL.dll"
File "C:\Games\Halo 2 Project Cartographer\startup.exe"
File "C:\Games\Halo 2 Project Cartographer\TnPCacheEngine.exe"
File "C:\Games\Halo 2 Project Cartographer\TnPUI.dll"
File "C:\Games\Halo 2 Project Cartographer\ts3client_win32.dll"
File "C:\Games\Halo 2 Project Cartographer\ts3server_win32.dll"
File "C:\Games\Halo 2 Project Cartographer\xinput9_1_0.dll"
;File "C:\Games\Halo 2 Project Cartographer\xlive.dll" ;not needed b/c launcher should download
;File "C:\Games\Halo 2 Project Cartographer\xlive.ini"
SetOutPath "$INSTDIR\xinput\p02"
File "C:\Games\Halo 2 Project Cartographer\xinput\p02\xinput9_1_0.dll"
SetOutPath "$INSTDIR\sounds"
File "C:\Games\Halo 2 Project Cartographer\sounds\infected.wav"
File "C:\Games\Halo 2 Project Cartographer\sounds\infection.wav"
File "C:\Games\Halo 2 Project Cartographer\sounds\last_man_standing.wav"
File "C:\Games\Halo 2 Project Cartographer\sounds\new_zombie.wav"
SetOutPath "$INSTDIR\soundbackends"
File "C:\Games\Halo 2 Project Cartographer\soundbackends\directsound_win32.dll"
File "C:\Games\Halo 2 Project Cartographer\soundbackends\windowsaudiosession_win32.dll"
SetOutPath "$INSTDIR\privacy"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_da.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_de.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_en.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_es.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_fr.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_it.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_jp.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_ko.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_no.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_sv.htm"
File "C:\Games\Halo 2 Project Cartographer\privacy\Privacy_zh-Hant.htm"
SetOutPath "$INSTDIR\movie"
File "C:\Games\Halo 2 Project Cartographer\movie\credits_60.wmv"
File "C:\Games\Halo 2 Project Cartographer\movie\intro_60.wmv"
File "C:\Games\Halo 2 Project Cartographer\movie\intro_low_60.wmv"
SetOutPath "$INSTDIR\maps"
#File "C:\Games\Halo 2 Project Cartographer\maps\lockout.map"
#File "C:\Games\Halo 2 Project Cartographer\maps\mainmenu.map"
#File "C:\Games\Halo 2 Project Cartographer\maps\mainmenu.zip"
#File "C:\Games\Halo 2 Project Cartographer\maps\shared.map"
SetOutPath "$INSTDIR\maps\fonts"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\arial-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\arial-14"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_conduit-12"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_conduit-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_conduit-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_h_g-11"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_h_g-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_h_g-24"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_dft_r5_mslcd-14"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\cht_jhenghei_conduit-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\conduit-12"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\conduit-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\conduit-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\fixedsys-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\font_table.txt"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\font_table_cht.txt"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\font_table_jpn.txt"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\font_table_kor.txt"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\handel_gothic-11"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\handel_gothic-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\handel_gothic-14"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\handel_gothic-24"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_con-12"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_con-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_con-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_h_g-11"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_h_g-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_h_g-24"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\jpn_dfghsmgoth_anti_mslcd-14"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_malgun_16_conduit-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_conduit-12"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_conduit-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_conduit-9"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_h_g-11"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_h_g-13"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_h_g-24"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\kor_sdgd_m_anti_mslcd-14"
File "C:\Games\Halo 2 Project Cartographer\maps\fonts\mslcd-14"
SetOutPath "$INSTDIR\icons"
File "C:\Games\Halo 2 Project Cartographer\icons\doc_map.ico"
File "C:\Games\Halo 2 Project Cartographer\icons\doc_savegame.ico"

SetOutPath "$INSTDIR\Temp\vcredist"
File "C:\Git\h2pc_installer\vcredist\vcredist_x86.exe"

AddSize 4000000 ;add 4.0 gb to the installer record to account for the zip files
SectionEnd

;Sections for dependencies install
Section "DirectX Install" 
 
 SectionIn RO
 
 DetailPrint "Running DirectX Setup..."
 ExecWait '"$INSTDIR\maps\directx.exe" /q /T:"$INSTDIR\Temp\Directx\"' 
 ExecWait '"$INSTDIR\Temp\Directx\DXSETUP.exe" /silent' $DirectXSetupError
 ;IfErrors error_dx
 DetailPrint "Finished DirectX Setup"
 ;MessageBox MB_OK|MB_ICONSTOP "return code: $DirectXSetupError"
 Delete "$INSTDIR\maps\directx.exe"
 RMDir /r "$INSTDIR\Temp\Directx\"
 ;error_dx:
; Abort
SectionEnd

Section "dotNET 4.5 Install" 

DetailPrint "Running .NET 4.5 setup..."
ExecWait '"$INSTDIR\maps\dotnetfx452.exe" /passive /norestart' $netSetupError
${If} $netSetupError != "0"
	MessageBox MB_OK|MB_ICONSTOP "Issue with .NET 4.5 install, you may encounter problems with the launcher."
	DetailPrint ".NET 4.5 not installed"
${EndIf}
DetailPrint "Finished .NET 4.5 setup. Return code: $netSetupError"
 ;MessageBox MB_OK|MB_ICONSTOP "return code: $netSetupError"
Delete "$INSTDIR\maps\dotnetfx452.exe"
 ;error_dotnet:
 ;Abort
 ;Delete "$INSTDIR\Temp\vcredist\dotnetfx35.exe"
SectionEnd

Section "visual c++ 2005"
 
 DetailPrint "Running visual c++ 2005 setup..."
 ;ExecWait '"$INSTDIR\Temp\vcredist\vcredist.msi /qn' $vcredistSetupError
 ExecWait '"$INSTDIR\Temp\vcredist\vcredist_x86.exe" /Q' $vcredistSetupError
 ;IfErrors error_vcredist
 DetailPrint "Finished visual c++ 2005 setup ... $vcredistSetupError"
 ;MessageBox MB_OK|MB_ICONSTOP "return code: $vcredistSetupError"
 ;ExecWait '"$INSTDIR\Temp\vcredist\vcredist.exe"'
 Delete "$INSTDIR\Temp\vcredist\vcredist_x86.exe"
 RMDir /r "$INSTDIR\Temp\vcredist"
 RMDir /r "$INSTDIR\Temp"
 ;error_vcredist:
 ;Abort
 ;Delete "$INSTDIR\Temp\vcredist\vcredist_x86.exe"
SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateDirectory "$SMPROGRAMS\$SM_Folder"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME} Website.lnk" "$INSTDIR\${APP_NAME} website.url"
!endif
!insertmacro MUI_STARTMENU_WRITE_END
!endif

!ifndef REG_START_MENU
CreateDirectory "$SMPROGRAMS\Halo 2 Project Cartographer"
CreateShortCut "$SMPROGRAMS\Halo 2 Project Cartographer\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$SMPROGRAMS\Halo 2 Project Cartographer\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\Halo 2 Project Cartographer\${APP_NAME} Website.lnk" "$INSTDIR\${APP_NAME} website.url"
!endif
!endif

WriteRegStr ${REG_ROOT} "${REG_APP_PATH}" "" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"

!ifdef WEB_SITE
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
!endif

; Writes Halo 2 registry keys for install directory. Different for x64 or x86 versions of windows
${If} ${RunningX64}
  SetRegView 64
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo 2\1.0" GameInstallDir "$INSTDIR\"
  DetailPrint "x64" 
${Else}
  SetRegView 32
  WriteRegStr HKLM "SOFTWARE\Microsoft\Microsoft Games\Halo 2\1.0\" GameInstallDir "$INSTDIR\"
  DetailPrint "x32" 
${EndIf}

;Delete temp directory inside install folder
RMDir /r "$INSTDIR\Temp"
SectionEnd

;HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo 2

######################################################################

Section Uninstall
${INSTALL_TYPE}
Delete "$INSTDIR\activate.exe"
Delete "$INSTDIR\Durazno.exe"
Delete "$INSTDIR\gungame.ini"
Delete "$INSTDIR\H2Launcher.exe"
Delete "$INSTDIR\h2startup1.ini"
Delete "$INSTDIR\halo2.exe"
Delete "$INSTDIR\halo2.exe.cat"
Delete "$INSTDIR\halo2.exe.cfg"
Delete "$INSTDIR\halo2final.ini"
Delete "$INSTDIR\ImeUiRes.dll"
Delete "$INSTDIR\launch.cab"
Delete "$INSTDIR\loading.bin"
Delete "$INSTDIR\MF.dll"
Delete "$INSTDIR\mspac.dll"
Delete "$INSTDIR\mspacres.dll"
Delete "$INSTDIR\mss32.dll"
Delete "$INSTDIR\mssdsp.flt"
Delete "$INSTDIR\PCCompat.dll"
Delete "$INSTDIR\Resource.dll"
Delete "$INSTDIR\sldlext.dll"
Delete "$INSTDIR\SLDL_DLL.dll"
Delete "$INSTDIR\startup.exe"
Delete "$INSTDIR\TnPCacheEngine.exe"
Delete "$INSTDIR\TnPUI.dll"
Delete "$INSTDIR\ts3client_win32.dll"
Delete "$INSTDIR\ts3server_win32.dll"
Delete "$INSTDIR\xinput9_1_0.dll"
Delete "$INSTDIR\xlive.dll"
Delete "$INSTDIR\xlive.ini"
Delete "$INSTDIR\xinput\p02\xinput9_1_0.dll"
Delete "$INSTDIR\sounds\infected.wav"
Delete "$INSTDIR\sounds\infection.wav"
Delete "$INSTDIR\sounds\last_man_standing.wav"
Delete "$INSTDIR\sounds\new_zombie.wav"
Delete "$INSTDIR\soundbackends\directsound_win32.dll"
Delete "$INSTDIR\soundbackends\windowsaudiosession_win32.dll"
Delete "$INSTDIR\privacy\Privacy.htm"
Delete "$INSTDIR\privacy\Privacy_da.htm"
Delete "$INSTDIR\privacy\Privacy_de.htm"
Delete "$INSTDIR\privacy\Privacy_en.htm"
Delete "$INSTDIR\privacy\Privacy_es.htm"
Delete "$INSTDIR\privacy\Privacy_fr.htm"
Delete "$INSTDIR\privacy\Privacy_it.htm"
Delete "$INSTDIR\privacy\Privacy_jp.htm"
Delete "$INSTDIR\privacy\Privacy_ko.htm"
Delete "$INSTDIR\privacy\Privacy_no.htm"
Delete "$INSTDIR\privacy\Privacy_sv.htm"
Delete "$INSTDIR\privacy\Privacy_zh-Hant.htm"
Delete "$INSTDIR\movie\credits_60.wmv"
Delete "$INSTDIR\movie\intro_60.wmv"
Delete "$INSTDIR\movie\intro_low_60.wmv"
Delete "$INSTDIR\maps\lockout.map"
Delete "$INSTDIR\maps\mainmenu.map"
Delete "$INSTDIR\maps\mainmenu.zip"
Delete "$INSTDIR\maps\shared.map"
Delete "$INSTDIR\maps\fonts\arial-13"
Delete "$INSTDIR\maps\fonts\arial-14"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_conduit-12"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_conduit-13"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_conduit-9"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_h_g-11"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_h_g-13"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_h_g-24"
Delete "$INSTDIR\maps\fonts\cht_dft_r5_mslcd-14"
Delete "$INSTDIR\maps\fonts\cht_jhenghei_conduit-9"
Delete "$INSTDIR\maps\fonts\conduit-12"
Delete "$INSTDIR\maps\fonts\conduit-13"
Delete "$INSTDIR\maps\fonts\conduit-9"
Delete "$INSTDIR\maps\fonts\fixedsys-9"
Delete "$INSTDIR\maps\fonts\font_table.txt"
Delete "$INSTDIR\maps\fonts\font_table_cht.txt"
Delete "$INSTDIR\maps\fonts\font_table_jpn.txt"
Delete "$INSTDIR\maps\fonts\font_table_kor.txt"
Delete "$INSTDIR\maps\fonts\handel_gothic-11"
Delete "$INSTDIR\maps\fonts\handel_gothic-13"
Delete "$INSTDIR\maps\fonts\handel_gothic-14"
Delete "$INSTDIR\maps\fonts\handel_gothic-24"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_con-12"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_con-13"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_con-9"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_h_g-11"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_h_g-13"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_h_g-24"
Delete "$INSTDIR\maps\fonts\jpn_dfghsmgoth_anti_mslcd-14"
Delete "$INSTDIR\maps\fonts\kor_malgun_16_conduit-9"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_conduit-12"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_conduit-13"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_conduit-9"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_h_g-11"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_h_g-13"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_h_g-24"
Delete "$INSTDIR\maps\fonts\kor_sdgd_m_anti_mslcd-14"
Delete "$INSTDIR\maps\fonts\mslcd-14"
Delete "$INSTDIR\icons\doc_map.ico"
Delete "$INSTDIR\icons\doc_savegame.ico"
 
RmDir "$INSTDIR\icons"
RmDir "$INSTDIR\maps\fonts"
RmDir /r "$INSTDIR\maps"
RmDir "$INSTDIR\movie"
RmDir "$INSTDIR\privacy"
RmDir "$INSTDIR\soundbackends"
RmDir "$INSTDIR\sounds"
RmDir "$INSTDIR\xinput\p02"
RmDir "$INSTDIR\xinput"
RmDir "$INSTDIR\Temp"
 
Delete "$INSTDIR\uninstall.exe"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP_NAME} website.url"
!endif

RmDir /r "$INSTDIR"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk"
Delete "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} Website.lnk"
!endif
Delete "$DESKTOP\${APP_NAME}.lnk"

RmDir "$SMPROGRAMS\$SM_Folder"
!endif

!ifndef REG_START_MENU
Delete "$SMPROGRAMS\Halo 2 Project Cartographer\${APP_NAME}.lnk"
Delete "$SMPROGRAMS\Halo 2 Project Cartographer\Uninstall ${APP_NAME}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\Halo 2 Project Cartographer\${APP_NAME} Website.lnk"
!endif
Delete "$DESKTOP\${APP_NAME}.lnk"

RmDir "$SMPROGRAMS\Halo 2 Project Cartographer"
!endif

DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"

${If} ${RunningX64}
  SetRegView 64
  DeleteRegKey HKLM "SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo 2\1.0"
  DetailPrint "x64" 
${Else}
  SetRegView 32
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Microsoft Games\Halo 2\1.0\"
  DetailPrint "x32" 
${EndIf}
SectionEnd

######################################################################

