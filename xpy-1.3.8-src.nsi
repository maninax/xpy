; xpy by Jan T. Sott
;   http://xpy.googlecode.com

; Unicode Warning (delete lines to compile for ASCII)
!ifdef NSIS_UNICODE
	!error "Cannot compile using NSIS Unicode!"
!endif

;  Compiler Configuration (config.nsh)
# public sourcecode does not require official branding
 !define PUBSRC
# compiles micro-version (of xpy)
#!define MINIXPY ; uncomment for a stripped down version of xpy
# configures header compression, possible options UPACK, UPX, PETITE (place executables in source root)
# !define COMPRESSION "UPX"
# configures default search engine for Internet Explorer, possible options:
# A9, ASK, BAIDU, BING, DUCKDUCKGO, GOOGLE, IXQUICK (default), METACRAWLER, YAHOO
# configure included language (place language-file to /includes), comment line for multilingual builds
 !define LANGUAGE "english" ; uncomment for monolingual builds, use english language NAME of includes\lang_NAME.nsh

; don't touch this line or file, it can be configured with the commands above
  !include "includes\config.nsh"
  
;Installer Sections
Section -pre
  IntCmp $Output "1" End 0 End  #val1 val2 jump_if_equal [jump_if_val1_less] [jump_if_val1_more]
  
  #StrCmp $Passive "1" 0 +2
  SetDetailsView show

!ifndef MINIXPY
  ${GetTime} "" "L" $R0 $R1 $R2 $R3 $R4 $R5 $R6
	; $0="01"      day
	; $1="04"      month
	; $2="2005"    year
	; $3="Friday"  day of week name
	; $4="11"      hour
	; $5="05"      minute
	; $6="50"      seconds
  
  ReadINIStr $0 "$APPDATA\${SHORTNAME}.ini" "${SHORTNAME}" "FirstRun"
  ${If} $0 == ""
	  WriteINIStr "$APPDATA\${SHORTNAME}.ini" "${SHORTNAME}" "FirstRun" "$R2-$R1-$R0@$R4:$R5.$R6"
  ${EndIf}
  
  WriteINIStr "$APPDATA\${SHORTNAME}.ini" "${SHORTNAME}" "LastRun" "$R2-$R1-$R0@$R4:$R5.$R6"
  WriteINIStr "$APPDATA\${SHORTNAME}.ini" "${SHORTNAME}" "Language" "$LANGUAGE"
  
  ${If} $Passive == "1" ##review
	  ${IfNot} $Input == ""
	    ReadINIStr $CheckBox "$Input" "${SHORTNAME}" "RestorePoint"
	  ${EndIf}
  ${EndIf}
  
  StrCmp $CheckBox "1" 0 End
/*
  ReadRegDword $1 HKLM "SYSTEM\CurrentControlSet\Services\srservice" "Start"
  ${If} $1 == "4"
  ${OrIf} $1 == "3"
    MessageBox MB_YESNO "$(MBEnableRestore)" IDNO +4
    nsExec::Exec 'net.exe START "srservice"'
    DetailPrint "$(DPServStart)"
    StrCpy $RestoreTemp "1"
  ${EndIf}
*/
  DetailPrint "$(DPResPointCreate): ${NAME} [$R2-$R1-$R0, $R4:$R5:$R6]"
  SysRestore::StartRestorePoint /NOUNLOAD "${NAME} [$R2-$R1-$R0, $R4:$R5:$R6]"
  Pop $0
  ${IfNot} $0 == "0"
    IfSilent +4
    ${IfNot} $Passive == "1"
		MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "$(MBResPointStartError)" IDYES +2
		Quit
	${EndIf}
    DetailPrint "$(DPResPointStartError): $0"
  ${EndIf}
!endif ;MINIXPY


!ifdef MINIXPY
  ${IfNot} $SearchEngineIni == ""
    StrCpy $SearchPage "http://ixquick.com"
	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://ixquick.com/do/metasearch.pl?query={searchTerms}"
	StrCpy $SearchName "Ixquick"
    StrCpy $IEShortcut "$(LabelDelShortcut)"
    StrCpy $OutlookShortcut "$(LabelDelShortcut)"
  ${EndIf}
!endif ;MINIXPY
 End:
SectionEnd

!ifdef COMPONENTSPAGE
	!include "includes\sections_1_general.nsh"
	!include "includes\sections_2_services.nsh"
	!include "includes\sections_3_iexplorer.nsh"
	!include "includes\sections_4_wmplayer.nsh"
	!include "includes\sections_5_wmessenger.nsh"
	!include "includes\sections_6_winsearch.nsh"
	!include "includes\sections_7_usability.nsh"
	!include "includes\sections_8_delfiles.nsh"
!endif

Section -post
  !ifndef MINIXPY

    ${If} $Output < "1"
      ${If} $CheckBox == "1"
        SysRestore::FinishRestorePoint
        Pop $0
        StrCmp $0 0 +2
        DetailPrint "$(DPResPointEndError): $0"
/*
        ${If} $RestoreTemp == "1"
          nsExec::Exec 'net.exe STOP "srservice"'
          DetailPrint "$(DPServStop)"
        ${EndIf}
*/
      ${EndIf}
    ${ElseIf} $Output == "1"
		WriteINIStr "$SaveFile" "${SHORTNAME}" "RestorePoint" "$CheckBox"
	  	DetailPrint '"RestorePoint=1" $(DPWritten)'
	  	SectionGetFlags ${IESearchPage} $0
		SectionGetFlags ${IESearchScope} $1

		${If} $0 == "1"
		${OrIf} $1 == "1"
			  WriteINIStr "$SaveFile" "${SHORTNAME}" "Search" "$SearchEngine"
			  DetailPrint '"SearchEngine=$SearchEngine" $(DPWritten)'
		${EndIf}
        
    ${EndIf}

    StrCmp $Restore "1" 0 +2
    Call IsINIEmpty
  !endif ;MINIXPY
  IfFileExists "$APPDATA\${LOWERCASE}.ini" 0 +2
  SetFileAttributes "$APPDATA\${LOWERCASE}.ini" HIDDEN

  StrCmp $IconRefresh "1" 0 +2
  Call IconRefresh
  StrCmp $Passive "1" 0 +4
  DetailPrint "$(DPPasvExit)"
  Sleep 3000
  Quit

  ${If} $Output == "1"
    MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "$(MBSilentBatch)" IDYES +3
    WriteINIStr "$SaveFile" "${SHORTNAME}" "Review" "1"
    Goto +2
    DetailPrint "$(DPSilent)"
  ${ElseIf} $Output == "2"
	unicode::FileAnsi2Unicode "$RegFile" "$RegFile" UTF-16LE
  ${EndIf}
  
  ${If} $Output < "1"
    IfRebootFlag 0 +3
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(MBReboot)" IDNO +2
    Reboot
  ${EndIf}
  
SectionEnd

 ;Installer Functions
 Function .onInit
!ifndef MINIXPY
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${SHORTNAME}") i .r1 ?e'
  Pop $R0
  StrCmp $R0 0 +3
  MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONQUESTION "$(MBInstance)" /SD IDYES IDYES +2
  Abort
!endif ;MINIXPY

  ${If} ${RunningX64}
	SetRegView 64
	#${EnableX64FSRedirection}
  ${Else}
	SetRegView 32
  ${EndIf}
 
  ClearErrors

!ifndef MINIXPY
  InitPluginsDir
  SetOutPath $PLUGINSDIR
!endif ;MINIXPY

	${If} ${AtLeastWinVista}
		StrCpy $SecServFirewall "$(SecServFirewall)"
		StrCpy $SecUnServFirewall "$(SecUnServFirewall)"
		StrCpy $SecDelMailClient "$(SecDelWinMail)"
		StrCpy $SecUnDelMailClient "$(SecUnDelWinMail)"
	${Else}
		StrCpy $SecServFirewall "$(SecServIcfIcs)"
		StrCpy $SecUnServFirewall "$(SecUnServIcfIcs)"
		StrCpy $SecDelMailClient "$(SecDelOutExLnk)"
		StrCpy $SecUnDelMailClient "$(SecUnDelOutExLnk)"
	${EndIf}

  ${GetParameters} $Parameter
 
  !ifndef LANGUAGE
	  ${If} $Parameter == ""
		Call LangSelect
	  ${EndIf}
  !endif
  
  ${If} $Parameter == "/?"
  ${OrIf} $Parameter == "-?"
  ${OrIf} $Parameter == "/help"
  ${OrIf} $Parameter == "/h"
  ${OrIf} $Parameter == "-h"
  ${OrIf} $Parameter == "--help"
  ${OrIf} $Parameter == "--h"
  ${OrIf} $Parameter == "--?"
  ${OrIf} $Parameter == "help"
	StrCpy $Switches "$Switches$\r$\n/help$\t$\t$(LabelShowHelp)"
	StrCpy $Switches "$Switches$\r$\n/file$\t$\t$(LabelSaveSettings)"
	StrCpy $Switches "$Switches$\r$\n/reg$\t$\t$(LabelRegSettings)"
	!ifndef MINIXPY
		StrCpy $Switches "$Switches$\r$\n/force$\t$\t$(LabelForce)"
		!ifndef LANGUAGE
			StrCpy $Switches "$Switches$\r$\n/lang$\t$\t$(LabelLangMenu)"
		!endif
		!ifdef LICENSEPAGE
			StrCpy $Switches "$Switches$\r$\n/license$\t$\t$(LabelShowLicense)"
		!endif ;LICENSEPAGE
	!endif
	StrCpy $Switches "$Switches$\r$\n/all$\t$\t$(LabelApplyAll)"
	!ifndef MINIXPY
		StrCpy $Switches "$Switches$\r$\n/reset$\t$\t$(LabelDeleteIni)"
		StrCpy $Switches "$Switches$\r$\n/restore$\t$\t$(LabelRestore)"
		StrCpy $Switches "$Switches$\r$\n/restore-all$\t$(LabelRestoreAll)"
		${If} ${AtLeastWinVista}
			StrCpy $0 "$\t$\t"
		${Else}
			StrCpy $0 "$\t"
		${EndIf}
		StrCpy $Switches "$Switches$\r$\n/noreboot$0$(LabelNoReboot)" ;shifted on XP
		StrCpy $Switches "$Switches$\r$\n/shortcuts$0$(LabelCreateShortcut)" ;shifted on XP
		StrCpy $Switches "$Switches$\r$\n/install$\t$\t$(LabelInstall)"
		StrCpy $Switches "$Switches$\r$\n/assoc$\t$\t$(LabelAssociate)"
		StrCpy $Switches "$Switches$\r$\n/unassoc$\t$\t$(LabelUnAssociate)"
		StrCpy $Switches "$Switches$\r$\n/win$\t$\t$(LabelWinVersion)"
	!endif
	StrCpy $Switches "$Switches$\r$\n$\r$\nbuilt with NSIS ${NSIS_VERSION}/${NSIS_MAX_STRLEN} [${__DATE__}]"
	
      MessageBox MB_USERICON|MB_DEFBUTTON1 "${NAME} $(LabelSwitches):$\r$\n$Switches"
	  Quit
  ${EndIf}
  
    !ifndef MINIXPY
	  !ifndef LANGUAGE
	    ${GetOptions} $Parameter "/lang=" $0
		${If} $0 == 1
		${OrIf} $Parameter == "/lang"
			StrCpy $ShowLang 1
			Call LangSelect
		${EndIf}
	  !endif ;LANGUAGE
	!endif ;MINIXPY
  
	${IfNot} $Parameter == "/debug"
	${AndIfNot} $Parameter == "/win"
		${If} ${AtLeastWin8} #newest first!
			StrCpy $WinVer "8"
		${ElseIf} ${AtLeastWin7}
			StrCpy $WinVer "7"
		${ElseIf} ${AtLeastWinVista}
			StrCpy $WinVer "Vista"
		${EndIf}
	${EndIf}
	
	${If} $User == ""
		${If} ${AtLeastWinVista}
			ReadRegStr $User HKCU "Volatile Environment" "USERNAME"
		${Else}
			ReadRegStr $User HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer" "Logon User Name"
		${EndIf}
	${EndIf}
	ReadRegStr $ComputerName HKLM "SYSTEM\ControlSet001\Control\ComputerName\ComputerName" "ComputerName"
  
    StrCmp $Parameter "" End
    #StrCmp $Parameter "/lang" End

    !ifndef MINIXPY
	  !ifndef LANGUAGE
    	StrCmp $ShowLang 1 End
	  !endif ;LANGUAGE
	!endif ;MINIXPY
	
	ReadRegStr $WinVersion HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
  
  ${If} $Parameter == "/win"
	  ReadRegStr $WinProduct HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "ProductName"
	  ${If} ${RunningX64}
		StrCpy $WinBit "64-bit"
	  ${Else}
		StrCpy $WinBit "32-bit"
	  ${EndIf}
	  ReadRegStr $WinBuild HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentBuildNumber"
	  ${If} ${AtLeastWinVista}
		ReadRegStr $User HKCU "Volatile Environment" "USERNAME"
	  ${Else}
		ReadRegStr $User HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer" "Logon User Name"
	  ${EndIf}
	  MessageBox MB_OK|MB_ICONINFORMATION "$WinProduct $WinBit [Version $WinVersion.$WinBuild]$\n$\n$(MBLoggedAs) $ComputerName\$User"
	  Quit
  ${ElseIf} $Parameter == "/debug"
	  StrCpy $Caption "[/debug]"
	  Goto NoRestore
  ${ElseIf} $Parameter == "/force"
	  StrCpy $Force "1"
	  Goto End
   ${ElseIf} $Parameter == "/file" 
	  StrCpy $Output "1"
	  StrCpy $SaveFile "$DESKTOP\$User.$ComputerName.${LOWERCASE}"
	  FileInput:
	  IfFileExists "$SaveFile" 0 NoRestore
	  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBOverwrite)" IDNo NoRestore
	  Delete "$SaveFile"
	  Goto NoRestore
   ${ElseIf} $Parameter == "/reg" 
	  StrCpy $Output "2"
	  StrCpy $RegFile "$DESKTOP\$User.$ComputerName.reg"
	  RegInput:
	  IfFileExists "$RegFile" 0 NoRestore
	  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBOverwrite)" IDNo NoRestore
	  Delete "$RegFile"
	  Goto NoRestore
  !ifndef MINIXPY
  !ifdef LICENSEPAGE
  ${ElseIf} $Parameter == "/license"
      StrCpy $Caption "[/license]"
	  StrCpy $ShowLicense 1
	  Goto NoRestore
  !endif ; LICENSEPAGE
  ${ElseIf} $Parameter == "/noreboot"
	  StrCpy $NoReboot 1
	  Goto NoRestore
  ${ElseIf} $Parameter == "/install"
  ${OrIf} $Parameter == "/inst"
	  StrCpy $Caption "[/install]"
	  Var /GLOBAL InstallParameter
	  StrCpy $InstallParameter 1
	  Goto End
  ${ElseIf} $Parameter == "/assoc"
  ${OrIf} $Parameter == "/associate"
		WriteRegStr HKCR ".${LOWERCASE}" "" "${LOWERCASE}.Settings"
		WriteRegStr HKCR "${LOWERCASE}.Settings" "" "${SHORTNAME} Settings"
		WriteRegStr HKCR "${LOWERCASE}.Settings\DefaultIcon" "" "%SystemRoot%\System32\shell32.dll,-151"
		WriteRegStr HKCR "${LOWERCASE}.Settings\shell" "" "open"
		WriteRegStr HKCR "${LOWERCASE}.Settings\shell\open\command" "" '"$EXEPATH.exe" "%1"'
		Call IconRefresh
  ${ElseIf} $Parameter == "/unassoc"
  ${OrIf} $Parameter == "/unassociate"
	  DeleteRegKey HKCR ".${LOWERCASE}"
	  DeleteRegKey HKCR "${LOWERCASE}.Settings"
	  Call IconRefresh
	  Quit
  ${ElseIf} $Parameter == "/shortcuts"
  ${OrIf} $Parameter == "/cuts"
		IfFileExists "$EXEDIR\$(LabelAdvanced)\*.*" +2
		CreateDirectory "$EXEDIR\$(LabelAdvanced)"
		CreateShortCut "$EXEDIR\$(LabelAdvanced)\$(LabelAssociateSc).lnk" "$EXEDIR\${SHORTNAME}.exe" "/associate"
		CreateShortCut "$EXEDIR\$(LabelAdvanced)\$(LabelCreateProfileSc).lnk" "$EXEDIR\${SHORTNAME}.exe" "/file"
		CreateShortCut "$EXEDIR\$(LabelAdvanced)\$(LabelRestoreSettingsSc).lnk" "$EXEDIR\${SHORTNAME}.exe" "/restore"
		CreateShortCut "$EXEDIR\$(LabelAdvanced)\$(LabelUnassociateSc).lnk" "$EXEDIR\${SHORTNAME}.exe" "/unassociate"
		ExecShell open "$EXEDIR\$(LabelAdvanced)"
		Quit
  ${ElseIf} $Parameter == "/reset"
  ${OrIf} $Parameter == "/flush"
	  IfFileExists "$APPDATA\${LOWERCASE}.ini" 0 +3
	  MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "$(MBDeleteIniWarning)" IDNO +2
	  Delete /REBOOTOK "$APPDATA\${LOWERCASE}.ini"
	  Quit
  !endif ;MINIXPY
  ${ElseIf} $Parameter == "/restore-all"
  ${OrIf} $Parameter == "/res-all"
	  !ifndef MINIXPY
	    Call UnSelectUnSections
	  !endif ;MINIXPY
	  Call SelectSections
	  SetSilent silent
	  Goto End
	  !ifndef MINIXPY
  ${ElseIf} $Parameter == "/restore"
  ${OrIf} $Parameter == "/res"
	  Call Restore
	  Goto End  
!endif ;MINIXPY
  ${EndIf}
 
  
  
  #save profile or to reg file
  ${GetOptions} "$Parameter" "/file=" $SaveFile
  ${GetOptions} "$Parameter" "/reg=" $RegFile
  
  ${If} $SaveFile != ""
  ${AndIf} $RegFile == ""
	  ${GetFileExt} $SaveFile $0
	  StrCmp $0 "${LOWERCASE}" +2
	  StrCpy $SaveFile "$SaveFile.${LOWERCASE}"
	  
	  ${GetParent} $SaveFile $0
	  StrCmp $0 "" 0 +2
	  StrCpy $SaveFile "$DESKTOP\$SaveFile"

	  StrCpy $Output "1"
	  Goto FileInput
  ${EndIf}
  
  ${If} $RegFile != ""
  ${AndIf} $SaveFile == ""
	  ${GetFileExt} $RegFile $0
	  StrCmp $0 "reg" +2
	  StrCpy $RegFile "$RegFile.reg"
	  
	  ${GetParent} $RegFile $0
	  StrCmp $0 "" 0 +2
	  StrCpy $RegFile "$DESKTOP\$RegFile"
	  
	  StrCpy $Output "2"
	  Goto RegInput
  ${EndIf}
    
  #/force=1
  ${GetOptions} "$Parameter" "/force=" $0
  StrCmp $0 "1" 0 +2
  StrCpy $Force 1
  
  !ifdef LICENSEPAGE
	  #/license=1
	  ${GetOptions} "$Parameter" "/license=" $0
	  StrCmp $0 "1" 0 +2
	  StrCpy $ShowLicense 1
  !endif ;LICENSEPAGE  
  
  #/noreboot=1
  ${GetOptions} "$Parameter" "/noreboot=" $0
  StrCmp $0 "1" 0 +2
  StrCpy $NoReboot 1

  !ifdef LICENSEPAGE
	StrCmp $ShowLicense 1 NoRestore  
  !endif ;LICENSEPAGE  
  StrCmp $Force 1 NoRestore 
  !ifndef LANGUAGE
	StrCmp $ShowLang 1 NoRestore  
  !endif
  StrCmp $NoReboot 1 NoRestore  
  
  StrCpy $Input $Parameter
  Call ValidateInput
  Goto End
   
 NoRestore:
  InstTypeSetText 6 ""
  InstTypeSetText 7 ""
  InstTypeSetText 8 ""
  InstTypeSetText 9 ""
  InstTypeSetText 10 ""
  InstTypeSetText 11 ""
  InstTypeSetText 12 ""
  !ifndef MINIXPY
    Call UnSelectUnSections
    Call AutoDetect
  !endif ;MINIXPY

  End:
 FunctionEnd

 
!ifndef MINIXPY
Function myGUIInit
	!ifndef PUBSRC
		GetDlgItem $0 $HWNDPARENT 1037 #Caption
		SetCtlColors $0 0xFFFFFF 0x1b1b1b
		GetDlgItem $0 $HWNDPARENT 1038 #Subcaption
		SetCtlColors $0 0xFFFFFF 0x1b1b1b
	!endif
FunctionEnd

 Function unComponentsShow
; -locks WDSUnDisable if Windows Desktop Search was removed
; -locks unsectiongroups with all content locked
 
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KB940157" "UninstallString"
  ${If} $0 == ""
  ${AndIfNot} $Force == "1"
	  IntOp $1 ${SF_SELECTED} | ${SF_RO}
	  SectionSetFlags ${WDSUnDisable} $1
	  SectionSetInstTypes ${WDSUnDisable} ${ALLUNSECTIONS}
  ${EndIf}
       
  ${LockUnSection} ${SecUnGeneral} ${SecServices}
  ${LockUnSection} ${SecUnServices} ${SecIExplore}
  ${LockUnSection} ${SecUnIExplore} ${SecWMP}
  ${LockUnSection} ${SecUnWMP} ${SecWinMessenger}
  ${LockUnSection} ${SecUnWinMessenger} ${SecWinSearch}
  ${LockUnSection} ${SecUnWinSearch} ${SecUsability}
  ${LockUnSection} ${SecUnUsability} ${SecDelete}
  IntOp $0 ${DelUnWinUpdate} + 2
  ${LockUnSection} ${SecUnDelete} $0
FunctionEnd

 Function ComponentsShow
; -changes caption if parameter was used
; -disables back button
; -locks sectiongroups with all content locked
; -checks if all sections are locked and displays warning
  SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${SHORTNAME} $Caption`
  
  GetDlgItem $0 $HWNDPARENT 3
  EnableWindow $0 0
  
  ${LockSection} ${SecGeneral} ${SecUnGeneral}
  ${LockSection} ${SecServices} ${SecUnServices}
  ${LockSection} ${SecIExplore} ${SecUnIExplore}
  ${LockSection} ${SecWMP} ${SecUnWMP}
  ${LockSection} ${SecWinMessenger} ${SecUnWinMessenger}
  ${LockSection} ${SecWinSearch} ${SecUnWinSearch}
  ${LockSection} ${SecUsability} ${SecUnUsability}
  ${LockSection} ${SecDelete} ${SecUnDelete}

  SectionGetFlags ${SecGeneral} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecServices} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecIExplore} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecWMP} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecWinMessenger} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecWinSearch} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecUsability} $0
  StrCmp $0 "${READONLY}" 0 Possible
  SectionGetFlags ${SecDelete} $0
  StrCmp $0 "${READONLY}" 0 Possible
  MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "$(MBImpossible)" IDYES +2
  Quit

  Possible:
  StrCmp $Passive "1" 0 +2
  Abort
 FunctionEnd
!endif ;MINIXPY

!ifndef MINIXPY
 Function ComponentsLeave
;   -checks if any section is selected and displays warning
;   -checks if all sections are selected and displays warning
;   -checks if irretrievable sections are selected and displays warning
   Push $0
   SectionGetFlags ${WDSRemove} $0
   ${If} $0 == ${SF_SELECTED}
     SectionGetFlags "${WDSDisable}" $0
     Push $1
     IntOp $1 ${SF_SELECTED} | ${SF_RO}
     SectionSetFlags "${WDSDisable}" $1
     Pop $1
   ${EndIf}
   Pop $0
   
    StrCpy $MinSelect "0"
    StrCpy $Warning ""
    
   !insertmacro MinSelect ${SecGeneral} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecGeneral} ${SF_SELECTED}
   !insertmacro MinSelect ${SecServices} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecServices} ${SF_SELECTED}
   !insertmacro MinSelect ${SecIExplore} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecIExplore} ${SF_SELECTED}
   !insertmacro MinSelect ${SecWMP} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecWMP} ${SF_SELECTED}
   !insertmacro MinSelect ${SecWinMessenger} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecWinMessenger} ${SF_SELECTED}
   !insertmacro MinSelect ${SecWinSearch} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecWinSearch} ${SF_SELECTED}
   !insertmacro MinSelect ${SecUsability} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecUsability} ${SF_SELECTED}
   !insertmacro MinSelect ${SecDelete} ${SF_PSELECTED}
   !insertmacro MinSelect ${SecDelete} ${SF_SELECTED}
   
   GetCurInstType $0
   StrCmp $0 "0" 0 +4
   MessageBox MB_OK|MB_ICONQUESTION "$(MBNoSettings)"
   Abort
   
   GetCurInstType $0
   ${If} $0 == "${AllSettings}"
   ${OrIf} $0 == "${No3rdPartySettings}"
     MessageBox MB_YESNO|MB_ICONQUESTION "$(MBAllSettings)" IDYES +2
     Abort
   ${EndIf}
   
   StrCmp $MinSelect "0" NoSetting
   /*
   StrCmp $Output "1" 0 +3
   WriteINIStr "$SaveFile" "${LOWERCASE}" "Version" "${VERSION}"
   Goto +2
   WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${LOWERCASE}" "Version" "${VERSION}"
   */
   /*
   ${If} $Output == "1"
		WriteINIStr "$SaveFile" "${LOWERCASE}" "Version" "${VERSION}"
   ${ElseIf} $Output == "2"
		FileOpen $0 "$RegFile" w
		FileWrite $0 "Windows Registry Editor Version 5.00"
		FileClose $0
   ${Else}
		WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${LOWERCASE}" "Version" "${VERSION}"
   ${EndIf}
   */

  NoSetting:
  ${DelWarn} ${GenWGA} "$(SecGenWGA)"
  ${DelWarn} ${IEAlexa} "$(SecIEAlexa)"
  ${DelWarn} ${IERemove} "$(SecIERemove)"
  ${DelWarn} ${WMUninstall} "$(SecWMUninstall)"
  ${IfNot} ${FileExists} "$PROGRAMFILES\Movie Maker\moviemk.exe"
     ${DelWarn} ${DelMovieMkLnk} "$(SecDelMovieMkLnk)"
  ${EndIf}

   ${IfNot} ${FileExists} "$PROGRAMFILES\Windows Photo Gallery\WindowsPhotoGallery.exe"
     ${DelWarn} ${DelWinPhotoGal} "$(SecDelWinPhotoGal)"
   ${EndIf}

   ${IfNot} ${FileExists} "$PROGRAMFILES\Windows Defender\MsAsCui.exe"
     ${DelWarn} ${DelWinDefender} "$(SecDelWinDefender)"
   ${EndIf}

   ${DelWarn} ${DelWinLiveDl} "$(SecDelWinLiveDl)"

   ${IfNot} ${FileExists} "$SYSDIR\WFS.exe"
     ${DelWarn} ${DelWinFaxScan} "$(SecDelWinFaxScan)"
   ${EndIf}

   ${IfNot} ${FileExists} "$PROGRAMFILES\Windows Calendar\wincal.exe"
      ${DelWarn} ${DelWinCalendar} "$(SecDelWinCalendar)"
   ${EndIf}

   ${IfNot} ${FileExists} "$PROGRAMFILES\Windows Mail\wab.exe"
     ${DelWarn} ${DelWinContacts} "$(SecDelWinContacts)"
   ${EndIf}

   ${IfNot} ${FileExists} "$PROGRAMFILES\MSN\MSNCoreFiles\Install\msnsusii.exe"
     ${DelWarn} ${DelMSNLnk} "$(SecDelMSNLnk)"
   ${EndIf}

   ${IfNot} ${FileExists} "$PROGRAMFILES\Messenger\msmsgs.exe"
     ${DelWarn} ${DelMessengerLnk} "$(SecDelMessengerLnk)"
   ${EndIf}

   ${IfNot} ${FileExists} "$SYSDIR\wupdmgr.exe"
     ${DelWarn} ${DelWinUpdate} "$(SecDelWinUpdate)"
   ${EndIf}
     ${DelWarn} ${DelWelcomeCenter} "$(SecDelWelcomeCenter)"

     ${IfNot} ${FileExists} "$WINDIR\ehome\ehshell.exe"
       ${DelWarn} ${DelWinMediaCenter} "$(SecDelWinMediaCenter)"
     ${EndIf}

     ${DelWarn} ${DelWinUltExtras} "$(SecDelWinUltExtras)"
     
     ${IfNot} ${FileExists} "$PROGRAMFILES\Windows Collaboration\WinCollab.exe"
       ${DelWarn} ${DelWinMeetSpace} "$(SecDelWinMeetSpace)"
     ${EndIf}
	 
     ${DelWarn} ${DelWinCatalog} "$(SecDelWinCatalog)"
     ${DelWarn} ${DelProgAccess} "$(SecDelProgAccess)"
	 
   ${DelWarn} ${DelMsBookmarks} "$(SecDelMsBookmarks)"
   ${DelWarn} ${DelSamplePictures} "$(SecDelSamplePictures)"
   ${DelWarn} ${DelSampleMusic} "$(SecDelSampleMusic)"
   
   ${DelWarn} ${DelSampleVideos} "$(SecDelSampleVideos)"
	 
   ${DelWarn} ${DelSamplePlaylists} "$(SecDelSamplePlaylists)"
   ${DelWarn} ${DelBitmaps} "$(SecDelBitmaps)"
   ${DelWarn} ${DelVistaSP1} "$(SecDelVistaSP1)"
   ${DelWarn} ${DelVistaSP2} "$(SecDelVistaSP2)"
   ${DelWarn} ${DelWin7SP} "$(SecDelWin7SP)"
   ${DelWarn} ${DelPrefetch} "$(SecDelPrefetch)"
   ${DelWarn} ${DelUpdCache} "$(SecDelUpdCache)"
	
   StrCmp $Warning "" End

   MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONEXCLAMATION "$(MBNoRestorePre)$\n$Warning$\n$\n$(MBNoRestorePost)" IDYES End
   StrCpy $Warning ""
   Abort

   End:
 FunctionEnd
!endif ;MINIXPY

!ifndef MINIXPY
	!ifdef DIRECTORYPAGE
		 Function DirectoryShow
			${If} $InstallParameter != 1
				Abort
			${EndIf}
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${SHORTNAME} $Caption`
		 FunctionEnd
		 
		 Function DirectoryLeave
			${If} $InstallParameter == 1
				SetOutPath $INSTDIR
				CopyFiles $EXEPATH "$INSTDIR\${SHORTNAME}.exe"
				WriteRegStr HKCR ".${LOWERCASE}" "" "${LOWERCASE}.Settings"
				WriteRegStr HKCR "${LOWERCASE}.Settings" "" "${SHORTNAME} Settings"
				WriteRegStr HKCR "${LOWERCASE}.Settings\DefaultIcon" "" "%SystemRoot%\System32\shell32.dll,-151"
				WriteRegStr HKCR "${LOWERCASE}.Settings\shell" "" "open"
				WriteRegStr HKCR "${LOWERCASE}.Settings\shell\open\command" "" '"$INSTDIR\${LOWERCASE}.exe" "%1"'
				Call IconRefresh
				${If} ${FileExists} "$INSTDIR\${SHORTNAME}.exe"
					MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "$(MBCreateShortcuts)" IDNO killSelf
					!ifndef PUBSRC
						SetOutPath "$SMPROGRAMS\whyEye.org\${SHORTNAME}"
					!else
						SetOutPath "$SMPROGRAMS\${SHORTNAME}"
					!endif
					CreateShortCut "$OUTDIR\${SHORTNAME}.lnk" "$INSTDIR\${SHORTNAME}.exe"
				${EndIf}
				killSelf:
				Quit
			${Else}
				Abort
			${EndIf}
		 FunctionEnd
	!endif
!endif
	
!ifndef MINIXPY
	!ifdef LICENSEPAGE
		 Function LicenseShow
		;  checks if license was displayed before, skips license if true
		   SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${SHORTNAME} $Caption`
		   IfSilent End
		   StrCmp $Passive "1" 0 +2
		   Abort
		   StrCmp $ShowLicense 1 End
		   IfFileExists "$APPDATA\${LOWERCASE}.ini" 0 End
		   ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "${LOWERCASE}" "LicenseAgreed"
		   StrCmp $0 "1" 0 +2
		   Abort
		  End:
		 FunctionEnd

		 Function LicenseLeave
		;  writes license agreement to .ini file
		   StrCmp $Output "1" +2
		   WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${LOWERCASE}" "LicenseAgreed" "1"
		 FunctionEnd
	!endif ;LICENSPAGE
!endif ;MINIXPY

!ifndef MINIXPY
  Function ioPage
	!insertmacro MUI_HEADER_TEXT "$(LabelSettings)" "$(LabelDescription)"
	
	LockWindow on
	
	${If} $Output == "1"
	    ${GetFileName} "$SaveFile" "$0"
	    StrCpy $Caption "[»$0]"
		Abort
	${ElseIf} $Output == "2"
	    ${GetFileName} "$RegFile" "$0"
	    StrCpy $Caption "[»$0]"
		Abort
	${ElseIf} $Parameter == "/restore"
		StrCpy $Caption "[/restore]"
		Abort
	${ElseIf} $Force == 1
		StrCpy $Caption "[/force]"
	${ElseIfNot} $Input == ""
		${GetFileName} "$Input" "$0"
	    StrCpy $Caption "[«$0]"
	    Abort
	${EndIf}
	
	SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${SHORTNAME} $Caption`
	
	nsDialogs::Create /NOUNLOAD 1018
	Pop $preDialog	
	
	${If} $preDialog == error
		Abort
	${EndIf}
	
	GetDlgItem $Next $HWNDPARENT 1 

	${NSD_CreateLabel} 0 0 100% 18u "$(LabelModeDesc1)"  
	Pop $LabelTop
	
	${NSD_CreateRadioButton} 6u 20u 100% 12u "$(LabelModeChange)"
	Pop $ButtonMake
	GetFunctionAddress $0 SelectButton
	nsDialogs::OnClick /NOUNLOAD $ButtonMake $0
	
	${NSD_CreateRadioButton} 6u 30u 100% 12u "$(LabelModeRestore)"
	Pop $ButtonRestore
	
	${If} ${FileExists} "$APPDATA\${SHORTNAME}.ini"
	${OrIf} $Force == 1
		EnableWindow $ButtonRestore 1
	${Else}
		EnableWindow $ButtonRestore 0
	${EndIf}
	
	${If} ${FileExists} "$APPDATA\${SHORTNAME}.ini"
		ReadINIStr $0 "$APPDATA\${SHORTNAME}.ini" "${SHORTNAME}" "FirstRun"
	${ElseIf} ${FileExists} "$APPDATA\${SHORTNAME}.ini" ;backwards-compatibility
		ReadINIStr $0 "$APPDATA\vispa.ini" "vispa" "FirstRun"
	${EndIf}

    	StrCmp $0 "" 0 +2
	EnableWindow $ButtonRestore 0
	GetFunctionAddress $0 SelectButton
	nsDialogs::OnClick /NOUNLOAD $ButtonRestore $0
	
	${NSD_CreateLabel} 0 48u 100% 18u "$(LabelModeDesc2)" 
	Pop $LabelBotton

	${NSD_CreateGroupbox} 0 72u 100% 48u "$(LabelProfiles)"
	Pop $GroupBox
	
	${NSD_CreateFileRequest}  5u 82u 274u 12u ""
	Pop $FileRequest
	EnableWindow $FileRequest 0
	GetFunctionAddress $0 onChangeFile
	nsDialogs::OnChange /NOUNLOAD $FileRequest $0
	
	${NSD_CreateBrowseButton} 282u 82u 14u 12u "..."
	Pop $ButtonBrowse
	GetFunctionAddress $0 ClickBrowse
	nsDialogs::OnClick /NOUNLOAD $ButtonBrowse $0
	EnableWindow $ButtonBrowse 0
	
	${NSD_CreateRadioButton} 8u 100u 64u 16u "$(LabelLoadProfile)"
	Pop $ButtonLoad
	GetFunctionAddress $0 SelectLoad
	nsDialogs::OnClick /NOUNLOAD $ButtonLoad $0
	
	${NSD_CreateRadioButton} 72u 100u 64u 16u "$(LabelSaveProfile)"
	Pop $ButtonSave
	GetFunctionAddress $0 SelectSave
	nsDialogs::OnClick /NOUNLOAD $ButtonSave $0
	
	${NSD_CreateRadioButton} 136u 100u 96u 16u "$(LabelRegProfile)"
	Pop $ButtonReg
	GetFunctionAddress $0 SelectReg
	nsDialogs::OnClick /NOUNLOAD $ButtonReg $0
	
	/*
	#internet connection?
	System::Call 'wininet.dll::InternetGetConnectedState(*i .r0, i 0) i.r1'
	
	${If} $1 != 0
		inetc::get /CONNECTTIMEOUT 1000 /SILENT "http://pimpbot.whyeye.org/.latest-unicode" "$PLUGINSDIR\update.ini" /END
		
		ReadINIStr $0 "$PLUGINSDIR\update.ini" "Update" "Version"
		!if ${SEARCH} == "IXQUICK"
			ReadINIStr $1 "$PLUGINSDIR\update.ini" "Update" "URLi"
		!else
			ReadINIStr $1 "$PLUGINSDIR\update.ini" "Update" "URL"
		!endif
		
		${VersionCompare} "$0" "${XPY_VERSION}" $2 #$var=0  Versions are equal, $var=1  Version1 is newer
		
		MessageBox MB_OK "$$0==$0   $$1=$1   $$2=$2"
		
		${If} $2 == 1
		${AndIf} $1 != ""
			${NSD_CreateLink} 365 210 120 24 "&Update available" ;no translation
		Pop $Update
		${EndIf}
	${EndIf}
	*/
	
	Call onChangeFile
	
	GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 0
	
	#disable next button
	GetDlgItem $0 $HWNDPARENT 1
    EnableWindow $0 0

	${If} $Passive != "1"
          nsDialogs::Show
	${EndIf}
	
  FunctionEnd
  
  Function SelectButton  
    Pop $0 # HWND
	
	${If} $0 == error
		Abort
	${EndIf}
	
	EnableWindow $FileRequest 0
	SetCtlColors $FileRequest "" ""
	EnableWindow $ButtonBrowse 0
	
	#enable next button
	GetDlgItem $0 $HWNDPARENT 1 
	EnableWindow $0 1
  FunctionEnd
  
  Function SelectLoad  
    Pop $0 # HWND
	
	${If} $0 == error
		Abort
	${EndIf}
	
	${IfNot} $LoadFile == ""
		SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:$LoadFile"
	${Else}
		SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:"
	${EndIf}
	
	EnableWindow $FileRequest 1	
	#SetCtlColors $FileRequest "" ${REQUIRED}
	EnableWindow $ButtonBrowse 1
	
	Call onChangeFile
  FunctionEnd
  
  Function SelectSave
    Pop $0 # HWND
	
	${If} $0 == error
		Abort
	${EndIf}
	
	${NSD_GetText} $FileRequest $1
	
	${If} $SaveFile != ""
		#${GetFileExt} $SaveFile $0
		#StrCmp $0 "${LOWERCASE}" +2
		#StrCpy $SaveFile "$SaveFile.${LOWERCASE}"
		SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:$SaveFile"
	${Else}
		SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:$DESKTOP\$User.$ComputerName.${LOWERCASE}"
	${EndIf}
	Call SelectButton
	EnableWindow $FileRequest 1
	EnableWindow $ButtonBrowse 1
	
	Call onChangeFile
  FunctionEnd
  
  Function SelectReg
    Pop $0 # HWND
	
	${If} $0 == error
		Abort
	${EndIf}
	
	${NSD_GetText} $FileRequest $1
	
	${IfNot} $RegFile == ""
		#${GetFileExt} $SaveFile $0
		#StrCmp $0 "reg" +2
		#StrCpy $SaveFile "$SaveFile.reg"
		SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:$RegFile"
	${Else}
		SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:$DESKTOP\$User.$ComputerName.reg"
	${EndIf}
	Call SelectButton
	EnableWindow $FileRequest 1
	EnableWindow $ButtonBrowse 1
	
	Call onChangeFile
  FunctionEnd
  
  Function ClickBrowse
    Pop $0 # HWND
	
	${If} $0 == error
		Abort
	${EndIf}
	
	${NSD_GetState} $ButtonLoad $1
	${NSD_GetState} $ButtonSave $2
	${NSD_GetState} $ButtonReg $3
	${NSD_GetText} $FileRequest $4
	
    ${If} $1 == "1" #LOAD
		nsDialogs::SelectFileDialog LOAD "" "${SHORTNAME} Batch File|*.${LOWERCASE};*.vispa|All Files|*.*"
		Pop $0
	${ElseIf} $2 == "1" #SAVE
		nsDialogs::SelectFileDialog SAVE "$4" "${SHORTNAME} Batch File|*.${LOWERCASE}|All Files|*.*"
		Pop $0
		${GetFileExt} "$0" $4
		StrCmp $4 "${LOWERCASE}" +2
		StrCpy $0 "$0.${LOWERCASE}"
	${ElseIf} $3 == "1" #SAVE
		nsDialogs::SelectFileDialog SAVE "$4" "${SHORTNAME} Registration File|*.reg|All Files|*.*"
		Pop $0
		${GetFileExt} "$0" $4
		StrCmp $4 "reg" +2
		StrCpy $0 "$0.reg"
	${EndIf}
	
	SendMessage $FileRequest ${WM_SETTEXT} 0 "STR:$0"
	
	Call onChangeFile
  FunctionEnd
  
  Function onChangeFile
	Pop $0 # HWND
	${NSD_GetText} $FileRequest $1
	${NSD_GetState} $ButtonLoad $2
	${NSD_GetState} $ButtonSave $3
	${NSD_GetState} $ButtonReg $4
	StrLen $5 $1
	
	${If} $2 == "1" ### ButtonLoad ###
		${If} $1 != ""
			${If} ${FileExists} "$1"
			${AndIf} $5 >= 4
				SetCtlColors $FileRequest "" "${VALID}"
				EnableWindow $Next 1
				StrCpy $LoadFile $1
			${Else}
				SetCtlColors $FileRequest "" ${INVALID}
				EnableWindow $Next 0
			${EndIf}
		${Else}
			SetCtlColors $FileRequest "" ${REQUIRED}
			EnableWindow $Next 0
		${EndIf}
		LockWindow off
	${ElseIf} $3 == "1" ### ButtonSave ###
		${If} $1 != ""
			${GetParent} $1 $0
			${If} ${FileExists} "$0\*.*"
			${AndIf} $0 != ""
			${AndIf} $5 >= 4
				SetCtlColors $FileRequest "" "${VALID}"
				EnableWindow $Next 1
				StrCpy $SaveFile $1
			${Else}
				SetCtlColors $FileRequest "" ${INVALID} 
				EnableWindow $Next 0
			${EndIf}
		${Else}
			SetCtlColors $FileRequest "" ${REQUIRED}
			EnableWindow $Next 0
		${EndIf}
		LockWindow off
	${ElseIf} $4 == "1" ### ButtonReg ###
		${If} $1 != ""
			${GetParent} $1 $0
			${If} ${FileExists} "$0\*.*"
			${AndIf} $0 != ""
			${AndIf} $5 >= 4
				SetCtlColors $FileRequest "" "${VALID}"
				EnableWindow $Next 1
				StrCpy $RegFile $1
			${Else}
				SetCtlColors $FileRequest "" ${INVALID} 
				EnableWindow $Next 0
			${EndIf}
		${Else}
			SetCtlColors $FileRequest "" ${REQUIRED}
			EnableWindow $Next 0
		${EndIf}
		LockWindow off
	${EndIf}
	
FunctionEnd
  
  Function ioPageLeave #temp
    ${NSD_GetState} $ButtonMake $0
	${NSD_GetState} $ButtonRestore $1
	${NSD_GetState} $ButtonLoad $2
	${NSD_GetState} $ButtonSave $3
	${NSD_GetState} $ButtonReg $4
	${NSD_GetText} $FileRequest $5
	
	${If} $0 == "1"
	    InstTypeSetText 6 ""
	    InstTypeSetText 7 ""
	    InstTypeSetText 8 ""
	    InstTypeSetText 9 ""
	    InstTypeSetText 10 ""
	    InstTypeSetText 11 ""
	    InstTypeSetText 12 ""
	  !ifndef MINIXPY
	    Call UnSelectUnSections
	    Call AutoDetect
	  !endif ;MINIXPY
    ${ElseIf} $1 == "1"
		${If} $Force == 1
			StrCpy $Caption "[/force /restore]"
		${Else}
			StrCpy $Caption "[/restore]"
		${EndIf}
		Call Restore		
	${ElseIf} $2 == "1"
	    StrCpy $Input "$5"
		Call ValidateInput
		${GetFileName} "$Input" "$0"
	    StrCpy $Caption "[«$0]"
	${ElseIf} $3 == "1"
	${OrIf} $4 == "1"
		${If} ${FileExists} "$5"
			MessageBox MB_YESNO|MB_ICONQUESTION "$(MBOverwrite)" IDYES +2
			Abort
			Delete "$5"			
		${EndIf}
		
/*		${GetParent} $4 $6
		${IsWritable} $6 $7
		${If} $7 == "1"
			MessageBox MB_OK|MB_ICONEXCLAMATION "Path doesn't exist or is read-only"
			Abort
		${EndIf}
*/

		${GetFileName} $5 $OutfileName
		
		${If} $3 == 1
			StrCpy $Output "1"
		${Else}
			StrCpy $Output "2"
		${EndIf}
		InstTypeSetText 6 ""
	    InstTypeSetText 7 ""
	    InstTypeSetText 8 ""
	    InstTypeSetText 9 ""
	    InstTypeSetText 10 ""
	    InstTypeSetText 11 ""
	    InstTypeSetText 12 ""
	  !ifndef MINIXPY
	    Call UnSelectUnSections
	    Call AutoDetect
	  !endif ;MINIXPY
	  StrCpy $Caption "[»$OutfileName]" ;/file
	${EndIf}
  FunctionEnd

 Function io2Page
;       -displays custom page after the components page, allows further input
;       -checks if pre-defined search-engine is valid
;       -checks if firefox/thunderbird is installed and adds more features to ie/mail dropdown
 	StrCmp $Restore "1" 0 +2
 	Abort

   	nsDialogs::Create /NOUNLOAD 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}
	
	SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${SHORTNAME} $Caption`
		
	${NSD_CreateCheckBox} 8u 0 100% 12u "$(LabelRestorePoint)"
	Pop $CheckBox
	
	${If} $Input != ""
          ReadINIStr $0 "$Input" "${SHORTNAME}" "RestorePoint"
          ${If} $0 == "1"
            SendMessage $CheckBox ${BM_SETCHECK} ${BST_CHECKED} 0
          ${Else}
            SendMessage $CheckBox ${BM_SETCHECK} ${BST_UNCHECKED} 0
          ${EndIf}
	${ElseIf} $Output == "2"
		SendMessage $CheckBox ${BM_SETCHECK} ${BST_UNCHECKED} 0
		EnableWindow $CheckBox 0
    ${Else}
		IfSilent +2
		SendMessage $CheckBox ${BM_SETCHECK} ${BST_CHECKED} 0
	${EndIf}
	
	
    ${NSD_CreateGroupBox} 0 24u 100% 116u "$(LabelSettings)"
	Pop $GroupBox
	
	${NSD_CreateLabel} 12u 36u 200 12u "$(LabelDefaultSearch):"
	Pop $SearchLabel

	${NSD_CreateDropList} 12u 50u 132u 12u 0
	Pop $SearchEngine
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:A9 (a9.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Altavista (altavista.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Ask (ask.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Baidu (baidu.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Bing (bing.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:DuckDuckGo (duckduckgo.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Google (google.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Ixquick (ixquick.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Metacrawler (metacrawler.com)"
	SendMessage $SearchEngine ${CB_ADDSTRING} 0 "STR:Yahoo! (yahoo.com)"

	${If} $SearchEngineIni == ""
          ${If} "${SEARCHENGINE}" == "A9 (a9.com)" ; validate defined search engine
          ${OrIf} "${SEARCHENGINE}" == "Altavista (altavista.com)"
          ${OrIf} "${SEARCHENGINE}" == "Ask (ask.com)"
          ${OrIf} "${SEARCHENGINE}" == "Baidu (baidu.com)"
		  ${OrIf} "${SEARCHENGINE}" == "Bing (bing.com)"
		  ${OrIf} "${SEARCHENGINE}" == "DuckDuckGo (duckduckgo.com)"
          ${OrIf} "${SEARCHENGINE}" == "Google (google.com)"
          ${OrIf} "${SEARCHENGINE}" == "Ixquick (ixquick.com)"
          ${OrIf} "${SEARCHENGINE}" == "Metacrawler (metacrawler.com)"
          ${OrIf} "${SEARCHENGINE}" == "Yahoo! (yahoo.com)"
          SendMessage $SearchEngine ${CB_FINDSTRINGEXACT} -1 "STR:${SEARCHENGINE}" $0
        ${Else}
          SendMessage $SearchEngine ${CB_FINDSTRINGEXACT} -1 "STR:Ixquick (ixquick.com)" $0 ;default
	${EndIf}
      ${Else}
        SendMessage $SearchEngine ${CB_FINDSTRINGEXACT} -1 "STR:$SearchEngineIni" $0
      ${EndIf}
	
	SendMessage $SearchEngine ${CB_SETCURSEL} $0 ""
	
	SectionGetFlags ${IESearchPage} $0
	SectionGetFlags ${IESearchScope} $1

	${If} $0 == "1"
	${OrIf} $1 == "1"
		EnableWindow $SearchEngine 1
	${Else}
	       EnableWindow $SearchEngine 0
	${EndIf}

#------- Maximum Connections	
	${NSD_CreateLabel} 152u 36u 132u 12u "$(LabelMaxConn):"
	Pop $MaxConnectionsLabel

	${NSD_CreateDropList} 152u 50u 24u 12u ""
	Pop $MaxConnections
	
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:8"
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:12"
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:16"
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:24"
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:32"
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:48"
	SendMessage $MaxConnections ${CB_ADDSTRING} 0 "STR:64"
	
	ReadRegStr $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "MaxConnectionsPerServer"
	${If} $1 > "4" ;4=Windows XP default
	${AndIf} $1 != ""
		IfSilent +2
		SendMessage $MaxConnections ${CB_FINDSTRINGEXACT} -1 "STR:$1" $0
	${Else}
		SendMessage $MaxConnections ${CB_FINDSTRINGEXACT} -1 "STR:32" $0
	${EndIf}
	
	SendMessage $MaxConnections ${CB_SETCURSEL} $0 ""
	
	SectionGetFlags ${IEMaxConn} $0

	${If} $0 == "1"
		EnableWindow $MaxConnections 1
	${Else}
	    EnableWindow $MaxConnections 0
	${EndIf}
	
#-------
	SetShellVarContext all
#-------InternetExplorer
	${NSD_CreateLabel} 12u 72u 132u 12u "$(LabelIeShortcut):"
	Pop $IELabel

	${NSD_CreateDropList} 12u 86u 132u 12u 0
	Pop $IEShortcut
	SendMessage $IEShortcut ${CB_ADDSTRING} 0 "STR:$(LabelDelShortcut)"
	
	### Firefox
	${If} ${AtLeastWinVista}
		ReadRegStr $0 HKCU "Software\Mozilla\Mozilla Firefox" "CurrentVersion"
	${Else}
		ReadRegStr $0 HKLM "Software\Mozilla\Mozilla Firefox" "CurrentVersion"
	${EndIf}
	${If} $0 != ""
	#${AndIf} ${FileExists} "$DESKTOP\*Firefox*.lnk"
		SendMessage $IEShortcut ${CB_ADDSTRING} 0 "STR:$(LabelFxTarget)"
	${EndIf}
	
	### Chrome
	${If} ${AtLeastWinVista}
		ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "InstallLocation"
	${Else}
		ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "InstallLocation"
	${EndIf}
	${If} $0 != ""
	#${AndIf} ${FileExists}  "$DESKTOP\*Chrome*.lnk"
		SendMessage $IEShortcut ${CB_ADDSTRING} 0 "STR:$(LabelGcTarget)"
	${EndIf}
	
	### Opera
	ReadRegStr $0 HKCU "Software\Opera Software" "Last Install Path"
	${If} $0 != ""
	#${AndIf} ${FileExists}  "$DESKTOP\*Opera*.lnk"
		SendMessage $IEShortcut ${CB_ADDSTRING} 0 "STR:$(LabelOpTarget)"
	${EndIf}

	SendMessage $IEShortcut ${CB_FINDSTRINGEXACT} -1 "STR:$(LabelDelShortcut)" $0
	SendMessage $IEShortcut ${CB_SETCURSEL} $0 ""
	
	SectionGetFlags ${DelIELnk} $0

	${If} $0 == "1"
		EnableWindow $IEShortcut 1
	${Else}
	    EnableWindow $IEShortcut 0
	${EndIf}
#-------Outlook
    ${If} ${AtLeastWinVista}
	  ${NSD_CreateLabel} 152u 72u 132u 12u "$(LabelWinMailShortcut):"
	${Else}
	  ${NSD_CreateLabel} 152u 72u 132u 12u "$(LabelOutlookShortcut):"
	${EndIf}
	Pop $OutlookLabel

	${NSD_CreateDropList} 152u 86u 132u 12u 0
	Pop $OutlookShortcut
	SendMessage $OutlookShortcut ${CB_ADDSTRING} 0 "STR:$(LabelDelShortcut)"
	
	### Thunderbird

	${If} ${AtLeastWinVista}
		ReadRegStr $0 HKCU "Software\Mozilla\Mozilla Thunderbird" "CurrentVersion"
	${Else}
		ReadRegStr $0 HKLM "Software\Mozilla\Mozilla Thunderbird" "CurrentVersion"
	${EndIf}
	${If} $0 != ""
	#${AndIf} ${FileExists}  "$DESKTOP\*Thunderbird*.lnk"
		SendMessage $OutlookShortcut ${CB_ADDSTRING} 0 "STR:$(LabelTbTarget)"
	${EndIf}
	
	### Postbox
	${If} ${AtLeastWinVista}
		ReadRegStr $0 HKCU "Software\Postbox\Postbox" "CurrentVersion"
	${Else}
		ReadRegStr $0 HKLM "Software\Postbox\Postbox" "CurrentVersion"
	${EndIf}
	${If} $0 != ""
	#${AndIf} ${FileExists}  "$DESKTOP\*Thunderbird*.lnk"
		SendMessage $OutlookShortcut ${CB_ADDSTRING} 0 "STR:$(LabelPbTarget)"
	${EndIf}
	
	SendMessage $OutlookShortcut ${CB_FINDSTRINGEXACT} -1 "STR:$(LabelDelShortcut)" $0
	SendMessage $OutlookShortcut ${CB_SETCURSEL} $0 ""

	/*${If} ${AtLeastWinVista}
		SectionGetFlags ${DelWinMail} $0
	${Else}
		SectionGetFlags ${DelOutExLnk} $0
	${EndIf}
	*/
	SectionGetFlags ${DelMailClient} $0

	${If} $0 == "1"
		EnableWindow $OutlookShortcut 1
	${Else}
	       EnableWindow $OutlookShortcut 0
	${EndIf}
	
#------- RDP Port
	${NSD_CreateLabel} 12u 108u 132u 12u "$(LabelRDPPort):"
	Pop $RDPLabel

	${NSD_CreateText} 12u 122u 28u 12u "3389"
	Pop $RDP
	GetFunctionAddress $0 onChangeRDP
	nsDialogs::OnChange /NOUNLOAD $RDP $0
	
	SectionGetFlags ${GenRDPPort} $0

	${If} $0 == "1"
		EnableWindow $RDP 1
	${Else}
	    EnableWindow $RDP 0
	${EndIf}
	
#-------
        SetShellVarContext current
        ${IfNot} $Passive == "1"
          nsDialogs::Show
        ${EndIf}
  FunctionEnd
 
  Function io2PageLeave
;          -writes variables for search-engine setting
;          -writes variable for ie-shortcut setting
;          -writes variable for outlook/mail-shortcut setting
    ${NSD_GetState} $CheckBox $CheckBox
    ${NSD_GetText} $SearchEngine $SearchEngine
    ${NSD_GetState} $MaxConnections $MaxConnections
    Push $SearchEngine
    Call SearchEngines
	   
    ${NSD_GetText} $IEShortcut $IEShortcut
    ${NSD_GetText} $OutlookShortcut $OutlookShortcut
	
	${NSD_GetText} $RDP $RDP
	
	Push "${NUMERIC}"
	Push "$RDP"
	Call StrCSpnReverse
	Pop $0
	
	${If} $RDP > 65535
	${OrIf} $RDP == ""
	${OrIf} $0 != ""
		MessageBox MB_OK|MB_ICONEXCLAMATION "$(MBRDPWarning)" #translate
		Abort
	${EndIf}
	
	${If} $Output == "1"
		WriteINIStr "$SaveFile" "${LOWERCASE}" "Version" "${VERSION}"
	${ElseIf} $Output == "2"
		FileOpen $0 "$RegFile" w
		FileWrite $0 "Windows Registry Editor Version 5.00"
		FileClose $0
	${Else}
		WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${LOWERCASE}" "Version" "${VERSION}"
	${EndIf}
  FunctionEnd
  
  Function onChangeRDP
	Pop $0 # HWND
	
	${NSD_GetText} $RDP $0
	
	Push "${NUMERIC}"
	Push "$0"
	Call StrCSpnReverse
	Pop $1
	
	${If} $0 > 65535
	#${OrIf} $0 == ""
	${OrIf} $1 != ""
	#	MessageBox MB_OK|MB_ICONEXCLAMATION "You need to specify a valid RDP port (0-65535)" #translate
		SetCtlColors $RDP "" ${INVALID}
		LockWindow off
		Abort
	${ElseIf} $0 == ""
		SetCtlColors $RDP "" ${REQUIRED}
		LockWindow off
		Abort
	${Else}
		SetCtlColors $RDP "" ""
		LockWindow off
		Abort
	${EndIf}	
	
  FunctionEnd
!endif ;MINIXPY

!ifndef MINIXPY
  Function InstfilesShow
	w7tbp::Start
    SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${SHORTNAME} $Caption`
  FunctionEnd
!endif ;MINIXPY

!ifndef LANGUAGE
  Function LangSelect
	${If} $ShowLang != 1
		ReadINIStr $0 "$APPDATA\${SHORTNAME}.ini" "${SHORTNAME}" "Language"	
		${If} $0 != ""
			StrCpy $LANGUAGE $0
			Goto End
		${EndIf}
	${EndIf}
	
	;   displays a language dialog when launched with /lang switch
	
    Push ""

    !ifdef LANG_ENGLISH
      Push ${LANG_ENGLISH}
      Push English
    !endif

    !ifdef LANG_BULGARIAN
      Push ${LANG_BULGARIAN}
      Push Bulgarian
    !endif
    
    !ifdef LANG_CZECH
      Push ${LANG_CZECH}
      Push Czech
    !endif
    
    !ifdef LANG_FRENCH
      Push ${LANG_FRENCH}
      Push French
    !endif
    
    !ifdef LANG_GERMAN
      Push ${LANG_GERMAN}
      Push German
    !endif
    
    !ifdef LANG_HUNGARIAN
      Push ${LANG_HUNGARIAN}
      Push Hungarian
    !endif
    
    !ifdef LANG_ITALIAN
      Push ${LANG_ITALIAN}
      Push Italian
    !endif
    
    !ifdef LANG_JAPANESE
      Push ${LANG_JAPANESE}
      Push Japanese
    !endif
    
    !ifdef LANG_POLISH
      Push ${LANG_POLISH}
      Push Polish
    !endif
    
    !ifdef LANG_RUSSIAN
      Push ${LANG_RUSSIAN}
      Push Russian
    !endif
    
    !ifdef LANG_SPANISH
      Push ${LANG_SPANISH}
      Push Spanish
    !endif
	
	!ifdef LANG_SWEDISH
      Push ${LANG_SWEDISH}
      Push Swedish
    !endif
    
    !ifdef LANG_TURKISH
      Push ${LANG_TURKISH}
      Push Turkish
    !endif
    
    !ifdef LANG_UKRAINIAN
      Push ${LANG_UKRAINIAN}
      Push Ukrainian
    !endif
    
    Push A ; A means auto count languages
         ;   for the auto count to work the first empty push (Push "") must remain
    LangDLL::LangDialog "Program Language" "Please select a language for ${SHORTNAME}"
    Pop $LANGUAGE
    StrCmp $LANGUAGE "cancel" 0 +2
    Abort
	
	End:
  FunctionEnd
!endif
 
!ifndef MINIXPY
 Function Restore
; some (temporary?) settings for backward compability, don't quite remember!
  
   StrCpy $Restore "1"
   InstTypeSetText 0 ""
   InstTypeSetText 1 ""
   InstTypeSetText 2 ""
   InstTypeSetText 3 ""
   InstTypeSetText 4 ""
   InstTypeSetText 5 ""
   Call UnSelectSections
   
    ${RestoreSection} "General" "CompressedFolders" "${GenUnCompressedFolders}"
	${RestoreSection} "General" "RegWizC" "${GenUnRegWizC}"
    ${RestoreSection} "General" "ErrorRep" "${GenUnErrorRep}"
    ${RestoreSection} "General" "LMHash" "${GenUnLMHash}"
    ${RestoreSection} "General" "WSHEnable" "${GenUnScriptHost}"
    ${RestoreSection} "General" "RemAssist2" "${GenUnRemAssist}"
    ${RestoreSection} "General" "InetOpen" "${GenUnInetOpen}"
    ${RestoreSection} "General" "RestrictAnon" "${GenUnRestrictAnon}"
    ${RestoreSection} "General" "NetCrawl" "${GenUnNetCrawl}"
    ${RestoreSection} "General" "HideComputer" "${GenUnHideComputer}"
	${RestoreSection} "General" "RepInfect" "${GenUnRepInfect}"
    ${RestoreSection} "General" "MediaSense" "${GenUnMediaSense}"
	${RestoreSection} "General" "RegDone" "${GenUnClaimWinReg}"
    ${RestoreSection} "General" "Prefetch" "${GenUnPrefetch}"
    ${RestoreSection} "General" "Superfetch" "${GenUnSuperfetch}"
    ${RestoreSection} "General" "FastShutdn" "${GenUnFastShutdn}"
    ${RestoreSection} "General" "DelPagefile" "${GenUnDelPagefile}"
	${RestoreSection} "General" "DelMRU" "${GenUnDelMRU}"
	${RestoreSection} "General" "RecentShares" "${GenUnRecentShares}"
    ${RestoreSection} "General" "LastUser" "${GenUnLastUser}"
    ${RestoreSection} "General" "PriorityCtrl" "${GenUnPriorityCtrl}"
	${RestoreSection} "General" "SysResponse" "${GenUnSysResponse}"
	${RestoreSection} "General" "DisableUAC" "${GenUnDisableUAC}"
	${RestoreSection} "General" "RDPPort" "${GenUnRDPPort}"
	${RestoreSection} "General" "SpyNet" "${GenUnSpyNet}"
	${RestoreSection} "General" "SyncPolicy" "${GenUnSyncPolicy}"
	${RestoreSection} "General" "EnablePost" "${GenUnEnablePoS}"
	
    ${RestoreSection} "Services" "ErrorRep" "${ServUnErrorRep}"
    ${RestoreSection} "Services" "AutoWinUpd" "${ServUnAutoWinUpd}"
    ${RestoreSection} "Services" "SecCenter" "${ServUnSecCenter}"
    ${RestoreSection} "Services" "AutoWinDefend" "${ServUnWinDefend}"
    ${RestoreSection} "Services" "TimeSync" "${ServUnTimeSync}"
    ${RestoreSection} "Services" "SchedTask" "${ServUnSchedTask}"
	${RestoreSection} "Services" "Indexing" "${ServUnIndexing}"
	${RestoreSection} "Services" "Defrag" "${ServUnDefrag}"
	${RestoreSection} "Services" "Superfetch" "${ServUnSuperfetch}"
	${RestoreSection} "Services" "DCOM" "${ServUnDCOM}"
    ${RestoreSection} "Services" "Telnet" "${ServUnTelnet}"
    ${RestoreSection} "Services" "UPnP" "${ServUnUPnP}"
    ${RestoreSection} "Services" "UPnPDiscovery" "${ServUnUPnPDiscovery}"
	${RestoreSection} "Services" "Messenger" "${ServUnMessenger}"
	${RestoreSection} "Services" "NetMeetingDesktop" "${ServUnNetMeetingDesktop}"
	${RestoreSection} "Services" "RPCLoc" "${ServUnRPCLoc}"
    ${RestoreSection} "Services" "BranchCache" "${ServUnBranchCache}"
    ${RestoreSection} "Services" "RemReg" "${ServUnRemReg}"
	${RestoreSection} "Services" "Firewall" "${ServUnFirewall}"
	
	${RestoreSection} "Services" "Imapi" "${ServUnImapi}"
	${RestoreSection} "Services" "SensrSvc" "${ServUnSensrSvc}"
    ${RestoreSection} "Services" "AudioSrv" "${ServUnAudioSrv}"
    ${RestoreSection} "Services" "WIA" "${ServUnWIA}"
	
    ${RestoreSection} "InternetExplorer" "AutoUpdates" "${IEUnAutoUpdates}"
    ${RestoreSection} "InternetExplorer" "SchedUpd" "${IEUnSchedUpd}"
    ${RestoreSection} "InternetExplorer" "WatsonDisabled" "${IEUnErrorRep}"
    ${RestoreSection} "InternetExplorer" "IntWinAuth" "${IEUnIntWinAuth}"
    ${RestoreSection} "InternetExplorer" "MaxConnPS" "${IEUnMaxConn}"
    ${RestoreSection} "InternetExplorer" "TabSettings" "${IEUnTabSettings}"
    ${RestoreSection} "InternetExplorer" "DelTempFiles" "${IEUnDelTempFiles}"
    ${RestoreSection} "InternetExplorer" "WebformComplete" "${IEUnWebformComplete}"
    ${RestoreSection} "InternetExplorer" "PasswordComplete" "${IEUnPasswordComplete}"
    ${RestoreSection} "InternetExplorer" "SearchPage" "${IEUnSearchPage}"
    ${RestoreSection} "InternetExplorer" "SearchScope" "${IEUnSearchScope}"
    ${RestoreSection} "InternetExplorer" "ActiveX1200" "${IEUnActiveX}"
    ${RestoreSection} "InternetExplorer" "JavaScript1400" "${IEUnJavaScript}"
    ${RestoreSection} "InternetExplorer" "SSL2" "${IEUnSSL2}"
    ${RestoreSection} "InternetExplorer" "PhishFilter" "${IEUnPhishFilter}"
    ${RestoreSection} "InternetExplorer" "SearchAsst" "${IEUnSearchAsst}"
    ${RestoreSection} "InternetExplorer" "404Search" "${IEUn404Search}"
    ${RestoreSection} "InternetExplorer" "BlankPage" "${IEUnBlankPage}"
    ${RestoreSection} "InternetExplorer" "DefaultPrompt" "${IEUnDefaultPrompt}"
    ${RestoreSection} "InternetExplorer" "InfoBar" "${IEUnInfoBar}"
	
    ${RestoreSection} "WindowsMediaPlayer" "AutoLicAcqu" "${WMPUnAutoLicAcqu}"
	${RestoreSection} "WindowsMediaPlayer" "SilentDRM" "${WMPUnSilentDRM}"
	${RestoreSection} "WindowsMediaPlayer" "UpgradeMsg" "${WMPUnUpgradeMsg}"
    ${RestoreSection} "WindowsMediaPlayer" "Library" "${WMPUnLibrary}"
    ${RestoreSection} "WindowsMediaPlayer" "MetadataRet" "${WMPUnMetadataRet}"
    ${RestoreSection} "WindowsMediaPlayer" "UsageTrack" "${WMPUnUsageTrack}"
	${RestoreSection} "WindowsMediaPlayer" "SendUID" "${WMPUnSendUID}"
	${RestoreSection} "WindowsMediaPlayer" "AutoUpdates" "${WMPUnAutoUpdates}"
	${RestoreSection} "WindowsMediaPlayer" "NoMRU" "${WMPUnNoMRU}"
    ${RestoreSection} "WindowsMediaPlayer" "AutoCodecDownl" "${WMPUnAutoCodecDownl}"
    ${RestoreSection} "WindowsMediaPlayer" "CDRecordMP3" "${WMPUnImportMP3}"
    ${RestoreSection} "WindowsMediaPlayer" "NoDRM" "${WMPUnNoDRM}"
	${RestoreSection} "WindowsMediaPlayer" "AllowDeinst" "${WMPUnAllowDeinst}"
	${RestoreSection} "WindowsMessenger" "WMRemOE" "${WMUnRemOE}"
	${RestoreSection} "WindowsSearch" "Disable" "${WDSUnDisable}"
	 
	${RestoreSection} "Usability" "BalloonTips" "${UsabUnBalloonTips}"
	${RestoreSection} "Usability" "LowDiskspace" "${UsabUnDiskSpace}"
	${RestoreSection} "Usability" "CmdHere" "${UsabUnCmdHere}"
	${RestoreSection} "Usability" "CmdCompl" "${UsabUnCmdCompl}"
	${RestoreSection} "Usability" "EditNotepad" "${UsabUnEditNotepad}"
    ${RestoreSection} "Usability" "AutoRun" "${UsabUnAutoRun}"
	${RestoreSection} "Usability" "SearchAsst" "${UsabUnSearchAsst}"
	${RestoreSection} "Usability" "CleanupWiz" "${UsabUnCleanupWiz}"
    ${RestoreSection} "Usability" "TaskGroup" "${UsabUnTaskGroup}"
    ${RestoreSection} "Usability" "ClassicStartMenu" "${UsabUnClassicStartMenu}"
    ${RestoreSection} "Usability" "ClassicLogon" "${UsabUnClassicLogon}"
    ${RestoreSection} "Usability" "ShutdownReasonOn" "${UsabUnShutdownReason}"
	${RestoreSection} "Usability" "BarricadeRootFolder" "${UsabUnBarricade}"
	${RestoreSection} "Usability" "HiddenFiles" "${UsabUnHiddenFiles}"
    ${RestoreSection} "Usability" "ShowFileExt" "${UsabUnShowFileExt}"
    ${RestoreSection} "Usability" "ShowLNKExt" "${UsabUnShowLNKExt}"
    ${RestoreSection} "Usability" "ShowPIFExt" "${UsabUnShowPIFExt}"
    ${RestoreSection} "Usability" "ShowSCFExt" "${UsabUnShowSCFExt}"
    ${RestoreSection} "Usability" "ShowURLExt" "${UsabUnShowURLExt}"
    ${RestoreSection} "Usability" "FullPath" "${UsabUnFullPath}"
    ${RestoreSection} "Usability" "DisableThumbnails" "${UsabUnDisableThumbnails}"
    ${RestoreSection} "Usability" "DisableSounds" "${UsabUnDisableSounds}"
    ${RestoreSection} "Usability" "WinTheme" "${UsabUnWinTheme}"
	   
    ${RestoreSection} "ThirdParty" "AppleMobile" "${TPUnAppleMobile}"
    ${RestoreSection} "ThirdParty" "iPodService" "${TPUnIpodService}"
    ${RestoreSection} "ThirdParty" "BonjourService" "${TPUnBonjourService}"
    ${RestoreSection} "ThirdParty" "FlashUpdate" "${TPUnFlashUpdate}"
    ${RestoreSection} "ThirdParty" "GoogleUpdater" "${TPUnGoogleUpdater}"
    ${RestoreSection} "ThirdParty" "GoogleSAC" "${TPUnGoogleSAC}"
    ${RestoreSection} "ThirdParty" "SkypeUpdate" "${TPUnSkypeUpdate}"
    ${RestoreSection} "ThirdParty" "NvidiaUpdate" "${TPUnNvidiaUpdate}"
    
	${RestoreSection} "Delete" "IELnk" "${DelUnIELnk}"
	${RestoreSection} "Delete" "MailClient" "${DelUnMailClient}"
	${RestoreSection} "Delete" "RecycleBin" "${DelUnRecycleBin}"
    ${RestoreSection} "Delete" "MyDocuments" "${DelUnMyDocuments}"
    ${RestoreSection} "Delete" "MyComputer" "${DelUnMyComputer}"
    ${RestoreSection} "Delete" "MyNetwork" "${DelUnMyNetwork}"
	${RestoreSection} "Delete" "ControlPanel" "${DelUnControlPanel}"
	${RestoreSection} "Delete" "WMPLnk" "${DelUnWMPLnk}"
    ${RestoreSection} "Delete" "MovieMkLnk" "${DelUnMovieMkLnk}"
	${RestoreSection} "Delete" "WinDVDMk" "${DelUnWinDVDMk}"
	${RestoreSection} "Delete" "WinPhotoGal" "${DelUnWinPhotoGal}"
	${RestoreSection} "Delete" "WinDefender" "${DelUnWinDefender}"
	${RestoreSection} "Delete" "WinFaxScan" "${DelUnWinFaxScan}"
	${RestoreSection} "Delete" "WinCalendar" "${DelUnWinCalendar}"
	${RestoreSection} "Delete" "WinContacts" "${DelUnWinContacts}"
	${RestoreSection} "Delete" "MSNLnk" "${DelUnMSNLnk}"
	${RestoreSection} "Delete" "MessengerLnk" "${DelUnMessengerLnk}"
	${RestoreSection} "Delete" "WinUpdate" "${DelUnWinUpdate}"
	${RestoreSection} "Delete" "WinMediaCenter" "${DelUnWinMediaCenter}"
	${RestoreSection} "Delete" "WinMeetSpace" "${DelUnWinMeetSpace}"
	   
   Call unComponentsShow

 FunctionEnd
!endif ;MINIXPY

Function SelectSections
;  show & select all sections
   ${SelectSection} "${SecGeneral}" "" ""
   ${SelectSection} "${GenCompressedFolders}" "General" "CompressedFolders"
   ${SelectSection} "${GenRegWizC}" "General" "RegWizC"
   ${SelectSection} "${GenErrorRep}" "General" "ErrorRep"
   ${SelectSection} "${GenLMHash}" "General" "LMHash"
   ${SelectSection} "${GenWGA}" "General" "WGA"
   ${SelectSection} "${GenScriptHost}" "General" "WSHEnable"
   ${SelectSection} "${GenRemAssist}" "General" "RemAssist1"
   ${SelectSection} "${GenRestrictAnon}" "General" "RestrictAnon"
   ${SelectSection} "${GenInetOpen}" "General" "InetOpen"
   ${SelectSection} "${GenHideComputer}" "General" "HideComputer"
   ${SelectSection} "${GenRepInfect}" "General" "RepInfect"
   ${SelectSection} "${GenMediaSense}" "General" "MediaSense"
   ${SelectSection} "${GenClaimWinReg}" "General" "RegDone"
   ${SelectSection} "${GenPrefetch}" "General" "Prefetch"
   ${SelectSection} "${GenSuperfetch}" "General" "Superfetch"
   ${SelectSection} "${GenFastShutdn}" "General" "FastShutdn"
   ${SelectSection} "${GenDelPagefile}" "General" "DelPagefile"
   ${SelectSection} "${GenDelMRU}" "General" "DelMRU"
   ${SelectSection} "${GenRecentShares}" "General" "RecentShares"
   ${SelectSection} "${GenLastUser}" "General" "LastUser"
   ${SelectSection} "${GenPriorityCtrl}" "General" "PriorityCtrl"
   ${SelectSection} "${GenSysResponse}" "General" "SysResponse"
   ${SelectSection} "${GenDisableUAC}" "General" "DisableUAC"
   ${SelectSection} "${GenRDPPort}" "General" "RDPPort"
   ${SelectSection} "${GenSpyNet}" "General" "SpyNet"
   ${SelectSection} "${GenSyncPolicy}" "General" "SyncPolicy"
   ${SelectSection} "${GenEnablePOS}" "General" "EnablePOS"

   ${SelectSection} "${SecServices}" "" ""
   ${SelectSection} "${ServErrorRep}" "Services" "ErrorRep"
   ${SelectSection} "${ServAutoWinUpd}" "Services" "AutoWinUpd"
   ${SelectSection} "${ServSecCenter}" "Services" "SecCenter"
   ${SelectSection} "${ServWinDefend}" "Services" "WinDefend"
   ${SelectSection} "${ServTimeSync}" "Services" "TimeSync"
   ${SelectSection} "${ServSchedTask}" "Services" "SchedTask"
   ${SelectSection} "${ServIndexing}" "Services" "Indexing"
   ${SelectSection} "${ServDefrag}" "Services" "Defrag"
   ${SelectSection} "${ServSuperfetch}" "Services" "Superfetch"
   ${SelectSection} "${ServDCOM}" "Services" "DCOM"
   ${SelectSection} "${ServTelnet}" "Services" "Telnet"
   ${SelectSection} "${ServUPnP}" "Services" "UPnP"
   ${SelectSection} "${ServUPnPDiscovery}" "Services" "UPnPDiscovery"
   ${SelectSection} "${ServNetMeetingDesktop}" "Services" "NetMeetingDesktop"
   ${SelectSection} "${ServRPCLoc}" "Services" "RPCLoc"
   ${SelectSection} "${ServRemReg}" "Services" "RemReg"   
   ${SelectSection} "${ServBranchCache}" "Services" "BranchCache"   
   ${SelectSection} "${ServFirewall}" "Services" "Firewall"   
   ${SelectSection} "${ServImapi}" "Services" "Imapi"
   ${SelectSection} "${ServSensrSvc}" "Services" "SensrSvc"
   ${SelectSection} "${ServAudioSrv}" "Services" "AudioSrv"
   ${SelectSection} "${ServWIA}" "Services" "WIA"
   ${SelectSection} "${TPAppleMobile}" "ThirdParty" "AppleMobile"
   ${SelectSection} "${TPIpodService}" "ThirdParty" "iPodService"
   ${SelectSection} "${TPBonjourService}" "ThirdParty" "BonjourService"
   ${SelectSection} "${TPFlashUpdate}" "ThirdParty" "FlashUpdate"
   ${SelectSection} "${TPGoogleUpdater}" "ThirdParty" "GoogleUpdater"
   ${SelectSection} "${TPGoogleSAC}" "ThirdParty" "GoogleSAC"
   ${SelectSection} "${TPSkypeUpdate}" "ThirdParty" "SkypeUpdate"
   ${SelectSection} "${TPNvidiaUpdate}" "ThirdParty" "NvidiaUpdate"
   
   ${SelectSection} "${SecIExplore}" "InternetExplorer" ""
   ${SelectSection} "${IEAutoUpdates}" "InternetExplorer" "AutoUpdates"
   ${SelectSection} "${IESchedUpd}" "InternetExplorer" "SchedUpd"
   ${SelectSection} "${IEErrorRep}" "InternetExplorer" "WatsonDisabled"
   ${SelectSection} "${IEIntWinAuth}" "InternetExplorer" "IntWinAuth"
   ${SelectSection} "${IEMaxConn}" "InternetExplorer" "MaxConnPS"
   ${SelectSection} "${IETabSettings}" "InternetExplorer" "TabSettings"
   ${SelectSection} "${IEuplddrvinfo}" "InternetExplorer" "uplddrvinfo"
   ${SelectSection} "${IEDelTempFiles}" "InternetExplorer" "DelTempFiles"
   ${SelectSection} "${IEWebformComplete}" "InternetExplorer" "WebformComplete"
   ${SelectSection} "${IEPasswordComplete}" "InternetExplorer" "PasswordComplete"
   ${SelectSection} "${IEAlexa}" "InternetExplorer" "Alexa"
   ${SelectSection} "${IESearchPage}" "InternetExplorer" "SearchPage"
   ${SelectSection} "${IESearchScope}" "InternetExplorer" "SearchScopeDefault"
   ${SelectSection} "${IEActiveX}" "InternetExplorer" "ActiveX1200"
   ${SelectSection} "${IEJavaScript}" "InternetExplorer" "JavaScript1400"
   ${SelectSection} "${IESSL2}" "InternetExplorer" "SSL2"
   ${SelectSection} "${IEPhishFilter}" "InternetExplorer" "PhishFilter"
   ${SelectSection} "${IESearchAsst}" "InternetExplorer" "SearchAsst"
   ${SelectSection} "${IE404Search}" "InternetExplorer" "404Search"
   ${SelectSection} "${IEBlankPage}" "InternetExplorer" "BlankPage"
   ${SelectSection} "${IEDefaultPrompt}" "InternetExplorer" "DefaultPrompt"
   ${SelectSection} "${IEInfoBar}" "InternetExplorer" "InfoBar"
   ${SelectSection} "${IERemove}" "InternetExplorer" "IERemove"

   ${SelectSection} "${SecWMP}" "" ""
   ${SelectSection} "${WMPAutoLicAcqu}" "WindowsMediaPlayer" "AutoLicAcqu"
   ${SelectSection} "${WMPSilentDRM}" "WindowsMediaPlayer" "SilentDRM"
   ${SelectSection} "${WMPUpgradeMsg}" "WindowsMediaPlayer" "UpgradeMsg"
   ${SelectSection} "${WMPLibrary}" "WindowsMediaPlayer" "Library"
   ${SelectSection} "${WMPMetadataRet}" "WindowsMediaPlayer" "MetadataRet"
   ${SelectSection} "${WMPUsageTrack}" "WindowsMediaPlayer" "UsageTrack"
   ${SelectSection} "${WMPSendUID}" "WindowsMediaPlayer" "SendUID"
   ${SelectSection} "${WMPAutoUpdates}" "WindowsMediaPlayer" "AutoUpdates"
   ${SelectSection} "${WMPNoMRU}" "WindowsMediaPlayer" "NoMRU"
   ${SelectSection} "${WMPAutoCodecDownl}" "WindowsMediaPlayer" "AutoCodecDownl"
   ${SelectSection} "${WMPImportMP3}" "WindowsMediaPlayer" "CDRecordMP3"
   ${SelectSection} "${WMPNoDRM}" "WindowsMediaPlayer" "NoDRM"
   ${SelectSection} "${WMPAllowDeinst}" "WindowsMediaPlayer" "AllowDeinst"
   
   ${SelectSection} "${SecWinMessenger}" "" ""
   ${SelectSection} "${WMRemOE}" "WindowsMessenger" "WMRemOE"
   ${SelectSection} "${WMUninstall}" "WindowsMessenger" "Uninstall"
 
   ${SelectSection} "${SecWinSearch}" "" ""
   ${SelectSection} "${WDSDisable}" "WindowsSearch" "Disable"
   ${SelectSection} "${WDSRemove}" "WindowsSearch" "Uninstall"
   ${SelectSection} "${SecUsability}" "" ""
   ${SelectSection} "${UsabBalloonTips}" "Usability" "BalloonTips"
   ${SelectSection} "${UsabDiskSpace}" "Usability" "LowDiskspace"
   ${SelectSection} "${UsabCmdHere}" "Usability" "CmdHere"
   ${SelectSection} "${UsabCmdCompl}" "Usability" "CmdCompl"
   ${SelectSection} "${UsabEditNotepad}" "Usability" "EditNotepad"
   ${SelectSection} "${UsabAutoRun}" "Usability" "AutoRun"
   ${SelectSection} "${UsabSearchAsst}" "Usability" "SearchAsst"
   ${SelectSection} "${UsabCleanupWiz}" "Usability" "CleanupWiz"
   ${SelectSection} "${UsabTaskGroup}" "Usability" "TaskGroup"
   ${SelectSection} "${UsabClassicStartMenu}" "Usability" "ClassicStartMenu"
   ${SelectSection} "${UsabClassicLogon}" "Usability" "ClassicLogon"
   ${SelectSection} "${UsabShutdownReason}" "Usability" "ShutdownReasonOn"
   ${SelectSection} "${UsabBarricade}" "Usability" "BarricadeRootFolder"
   ${SelectSection} "${UsabHiddenFiles}" "Usability" "HiddenFiles"
   ${SelectSection} "${UsabShowFileExt}" "Usability" "ShowFileExt"
   ${SelectSection} "${UsabShowLNKExt}" "Usability" "ShowLNKExt"
   ${SelectSection} "${UsabShowPIFExt}" "Usability" "ShowPIFExt"
   ${SelectSection} "${UsabShowSCFExt}" "Usability" "ShowSCFExt"
   ${SelectSection} "${UsabShowURLExt}" "Usability" "ShowURLExt"
   ${SelectSection} "${UsabFullPath}" "Usability" "FullPath"
   ${SelectSection} "${UsabDisableThumbnails}" "Usability" "DisableThumbnails"
   ${SelectSection} "${UsabDisableSounds}" "Usability" "DisableSounds"
   ${SelectSection} "${UsabWinTheme}" "Usability" "WinTheme"
   
   ${SelectSection} "${SecDelete}" "" ""
   ${SelectSection} "${DelIELnk}" "Delete" "IELnk"
   ${SelectSection} "${DelMailClient}" "Delete" "MailClient"
   ${SelectSection} "${DelRecycleBinLnk}" "Delete" "RecycleBin"
   ${SelectSection} "${DelMyDocumentsLnk}" "Delete" "MyDocuments"
   ${SelectSection} "${DelMyComputerLnk}" "Delete" "MyComputer"
   ${SelectSection} "${DelMyNetworkLnk}" "Delete" "MyNetwork"
   ${SelectSection} "${DelControlPanelLnk}" "Delete" "MyNetwork"
   ${SelectSection} "${DelWMPLnk}" "Delete" "WMPLnk"
   ${SelectSection} "${DelMovieMkLnk}" "Delete" "MovieMkLnk"
   ${SelectSection} "${DelWinDVDMk}" "Delete" "WinDVDMk"
   ${SelectSection} "${DelWinPhotoGal}" "Delete" "WinPhotoGal"
   ${SelectSection} "${DelWinDefender}" "Delete" "WinDefender"
   ${SelectSection} "${DelWinLiveDl}" "Delete" "WinLiveDl"
   ${SelectSection} "${DelWinFaxScan}" "Delete" "WinFaxScan"
   ${SelectSection} "${DelWinCalendar}" "Delete" "WinCalendar"
   ${SelectSection} "${DelWinContacts}" "Delete" "WinContacts"
   ${SelectSection} "${DelMSNLnk}" "Delete" "MSNLnk"
   ${SelectSection} "${DelMessengerLnk}" "Delete" "MessengerLnk"
   ${SelectSection} "${DelWinUpdate}" "Delete" "WinUpdate"
   ${SelectSection} "${DelWelcomeCenter}" "Delete" "WelcomeCenter"
   ${SelectSection} "${DelWinMediaCenter}" "Delete" "WinMediaCenter"
   ${SelectSection} "${DelWinUltExtras}" "Delete" "WinUltExtras"
   ${SelectSection} "${DelWinMeetSpace}" "Delete" "WinMeetSpace"
   ${SelectSection} "${DelWinCatalog}" "Delete" "WinCatalog"
   ${SelectSection} "${DelProgAccess}" "Delete" "ProgAccess"
   ${SelectSection} "${DelMsBookmarks}" "Delete" "MsBookmarks"
   ${SelectSection} "${DelSamplePictures}" "Delete" "SamplePictures"
   ${SelectSection} "${DelSampleMusic}" "Delete" "SampleMusic"
   ${SelectSection} "${DelSampleVideos}" "Delete" "SampleVideos"
   ${SelectSection} "${DelSamplePlaylists}" "Delete" "SamplePlaylists"
   ${SelectSection} "${DelBitmaps}" "Delete" "Bitmaps"
   ${SelectSection} "${DelVistaSP1}" "Delete" "VistaSP1"
   ${SelectSection} "${DelVistaSP2}" "Delete" "VistaSP2"
   ${SelectSection} "${DelWin7SP}" "Delete" "Win7SP"
   ${SelectSection} "${DelPrefetch}" "Delete" "Prefetch"
   ${SelectSection} "${DelUpdCache}" "Delete" "UpdCache"
FunctionEnd

!ifndef MINIXPY
Function UnSelectSections
;  unselect & hide all sections
   SectionSetText ${SecUnGeneral} "$(SubGeneral)"
   ${Hide} "${SecGeneral}"
   ${Hide} "${GenCompressedFolders}"
   ${Hide} "${GenRegWizC}"
   ${Hide} "${GenErrorRep}"
   ${Hide} "${GenLMHash}"
   ${Hide} "${GenWGA}"
   ${Hide} "${GenScriptHost}"
   ${Hide} "${GenRemAssist}"
   ${Hide} "${GenRestrictAnon}"
   ${Hide} "${GenInetOpen}"
   ${Hide} "${GenNetCrawl}"
   ${Hide} "${GenHideComputer}"
   ${Hide} "${GenRepInfect}"
   ${Hide} "${GenMediaSense}"
   ${Hide} "${GenClaimWinReg}"
   ${Hide} "${GenPrefetch}"
   ${Hide} "${GenSuperfetch}"
   ${Hide} "${GenFastShutdn}"
   ${Hide} "${GenDelPagefile}"
   ${Hide} "${GenDelMRU}"
   ${Hide} "${GenRecentShares}"
   ${Hide} "${GenLastUser}"
   ${Hide} "${GenPriorityCtrl}"
   ${Hide} "${GenSysResponse}"
   ${Hide} "${GenDisableUAC}"
   ${Hide} "${GenRDPPort}"
   ${Hide} "${GenSpyNet}"
   ${Hide} "${GenSyncPolicy}"
   ${Hide} "${GenEnablePOS}"
   
   SectionSetText ${SecUnServices} "$(SubServices)"
   ${Hide} "${SecServices}"
   ${Hide} "${ServErrorRep}"
   ${Hide} "${ServAutoWinUpd}"
   ${Hide} "${ServSecCenter}"
   ${Hide} "${ServWinDefend}"
   ${Hide} "${ServTimeSync}"
   ${Hide} "${ServSchedTask}"
   ${Hide} "${ServIndexing}"
   ${Hide} "${ServDefrag}"
   ${Hide} "${ServSuperfetch}"
   ${Hide} "${ServDCOM}"
   ${Hide} "${ServTelnet}"
   ${Hide} "${ServUPnP}"
   ${Hide} "${ServUPnPDiscovery}"
   ${Hide} "${ServMessenger}"
   ${Hide} "${ServNetMeetingDesktop}"
   ${Hide} "${ServRPCLoc}"
   ${Hide} "${ServRemReg}"
   ${Hide} "${ServBranchCache}"
   ${Hide} "${ServFirewall}"
   ${Hide} "${ServImapi}"
   ${Hide} "${ServSensrSvc}"
   ${Hide} "${ServAudioSrv}"
   ${Hide} "${ServWIA}"
   ${Hide} "${TPAppleMobile}"
   ${Hide} "${TPIpodService}"
   ${Hide} "${TPBonjourService}"
   ${Hide} "${TPFlashUpdate}"
   ${Hide} "${TPGoogleUpdater}"
   ${Hide} "${TPGoogleSAC}"
   ${Hide} "${TPSkypeUpdate}"
   ${Hide} "${TPNvidiaUpdate}"
   
   SectionSetText ${SecUnIExplore} "Internet Explorer"
   ${Hide} "${SecIExplore}"
   ${Hide} "${IEAutoUpdates}"
   ${Hide} "${IESchedUpd}"
   ${Hide} "${IEErrorRep}"
   ${Hide} "${IEIntWinAuth}"
   ${Hide} "${IEMaxConn}"
   ${Hide} "${IETabSettings}"
   ${Hide} "${IEuplddrvinfo}"
   ${Hide} "${IEDelTempFiles}"
   ${Hide} "${IEWebformComplete}"
   ${Hide} "${IEPasswordComplete}"
   ${Hide} "${IEAlexa}"
   ${Hide} "${IESearchPage}"
   ${Hide} "${IESearchScope}"
   ${Hide} "${IEActiveX}"
   ${Hide} "${IEJavaScript}"
   ${Hide} "${IESSL2}"
   ${Hide} "${IEPhishFilter}"
   ${Hide} "${IESearchAsst}"
   ${Hide} "${IE404Search}"
   ${Hide} "${IEBlankPage}"
   ${Hide} "${IEDefaultPrompt}"
   ${Hide} "${IEInfoBar}"
   ${Hide} "${IERemove}"
   
   SectionSetText ${SecUnWMP} "Windows Media Player"
   ${Hide} "${SecWMP}"
   ${Hide} "${WMPAutoLicAcqu}"
   ${Hide} "${WMPSilentDRM}"
   ${Hide} "${WMPUpgradeMsg}"
   ${Hide} "${WMPLibrary}"
   ${Hide} "${WMPMetadataRet}"
   ${Hide} "${WMPUsageTrack}"
   ${Hide} "${WMPSendUID}"
   ${Hide} "${WMPAutoUpdates}"
   ${Hide} "${WMPNoMRU}"
   ${Hide} "${WMPAutoCodecDownl}"
   ${Hide} "${WMPImportMP3}"
   ${Hide} "${WMPImportMP3}"
   ${Hide} "${WMPNoDRM}"
   ${Hide} "${WMPAllowDeinst}"
   
   SectionSetText ${SecUnWinMessenger} "Windows Messenger"
   ${Hide} "${SecWinMessenger}"
   ${Hide} "${WMRemOE}"
   ${Hide} "${WMUninstall}"
   
   SectionSetText ${SecUnWinSearch} "$(TermWDS)"
   ${Hide} "${SecWinSearch}"
   ${Hide} "${WDSDisable}"
   ${Hide} "${WDSRemove}"
   
   SectionSetText ${SecUnUsability} "$(SubUsability)"
   ${Hide} "${SecUsability}"
   ${Hide} "${UsabBalloonTips}"
   ${Hide} "${UsabDiskSpace}"
   ${Hide} "${UsabCmdHere}"
   ${Hide} "${UsabCmdCompl}"
   ${Hide} "${UsabEditNotepad}"
   ${Hide} "${UsabAutoRun}"
   ${Hide} "${UsabSearchAsst}"
   ${Hide} "${UsabCleanupWiz}"
   ${Hide} "${UsabTaskGroup}"
   ${Hide} "${UsabClassicStartMenu}"
   ${Hide} "${UsabClassicLogon}"
   ${Hide} "${UsabShutdownReason}"
   ${Hide} "${UsabBarricade}"
   ${Hide} "${UsabHiddenFiles}"
   ${Hide} "${UsabShowFileExt}"
   ${Hide} "${UsabShowLNKExt}"
   ${Hide} "${UsabShowPIFExt}"
   ${Hide} "${UsabShowSCFExt}"
   ${Hide} "${UsabShowURLExt}"
   ${Hide} "${UsabFullPath}"
   ${Hide} "${UsabDisableThumbnails}"
   ${Hide} "${UsabDisableSounds}"
   ${Hide} "${UsabWinTheme}"
 
   SectionSetText ${SecUnDelete} "$(SubDelete)"
   ${Hide} "${SecDelete}"
   ${Hide} "${DelIELnk}"
   
   SectionSetText ${DelMailClient} ""
   ${Hide} "${DelMailClient}"
   
   ${Hide} "${DelRecycleBinLnk}"
   ${Hide} "${DelMyDocumentsLnk}"
   ${Hide} "${DelMyComputerLnk}"
   ${Hide} "${DelMyNetworkLnk}"
   ${Hide} "${DelControlPanelLnk}"
   ${Hide} "${DelWMPLnk}"
   ${Hide} "${DelMovieMkLnk}"
   ${Hide} "${DelWinDVDMk}"
   ${Hide} "${DelWinPhotoGal}"
   ${Hide} "${DelWinDefender}"
   ${Hide} "${DelWinLiveDl}"
   ${Hide} "${DelWinFaxScan}"
   ${Hide} "${DelWinCalendar}"
   ${Hide} "${DelWinContacts}"
   ${Hide} "${DelMSNLnk}"
   ${Hide} "${DelMessengerLnk}"
   ${Hide} "${DelWinUpdate}"
   ${Hide} "${DelWelcomeCenter}"
   ${Hide} "${DelWinMediaCenter}"
   ${Hide} "${DelWinUltExtras}"
   ${Hide} "${DelWinMeetSpace}"
   ${Hide} "${DelWinCatalog}"
   ${Hide} "${DelProgAccess}"
   ${Hide} "${DelMsBookmarks}"
   ${Hide} "${DelSamplePictures}"
   ${Hide} "${DelSampleMusic}"
   ${Hide} "${DelSampleVideos}"
   ${Hide} "${DelSamplePlaylists}"
   ${Hide} "${DelBitmaps}"
   ${Hide} "${DelVistaSP1}"
   ${Hide} "${DelVistaSP2}"
   ${Hide} "${DelWin7SP}"
   ${Hide} "${DelPrefetch}"
   ${Hide} "${DelUpdCache}"
 FunctionEnd
!endif ;MINIXPY

!ifndef MINIXPY
Function UnSelectUnSections
;  deselect & hide all unsections
   ${Hide} "${SecUnGeneral}"
   ${Hide} "${GenUnCompressedFolders}"
   ${Hide} "${GenUnRegWizC}"
   ${Hide} "${GenUnErrorRep}"
   ${Hide} "${GenUnLMHash}"
   ${Hide} "${GenUnScriptHost}"
   ${Hide} "${GenUnRemAssist}"
   ${Hide} "${GenUnInetOpen}"
   ${Hide} "${GenUnRestrictAnon}"
   ${Hide} "${GenUnNetCrawl}"
   ${Hide} "${GenUnHideComputer}"
   ${Hide} "${GenUnRepInfect}"
   ${Hide} "${GenUnMediaSense}"
   ${Hide} "${GenUnClaimWinReg}"
   ${Hide} "${GenUnPrefetch}"
   ${Hide} "${GenUnSuperfetch}"
   ${Hide} "${GenUnFastShutdn}"
   ${Hide} "${GenUnDelPagefile}"
   ${Hide} "${GenUnDelMRU}"
   ${Hide} "${GenUnRecentShares}"
   ${Hide} "${GenUnLastUser}"
   ${Hide} "${GenUnPriorityCtrl}"
   ${Hide} "${GenUnSysResponse}"
   ${Hide} "${GenUnDisableUAC}"
   ${Hide} "${GenUnRDPPort}"
   ${Hide} "${GenUnSpyNet}"
   ${Hide} "${GenUnSyncPolicy}"
   ${Hide} "${GenUnEnablePOS}"
   
   ${Hide} "${SecUnServices}"
   ${Hide} "${ServUnErrorRep}"
   ${Hide} "${ServUnAutoWinUpd}"
   ${Hide} "${ServUnSecCenter}"
   ${Hide} "${ServUnWinDefend}"
   ${Hide} "${ServUnTimeSync}"
   ${Hide} "${ServUnSchedTask}"
   ${Hide} "${ServUnIndexing}"
   ${Hide} "${ServUnDefrag}"
   ${Hide} "${ServUnSuperfetch}"
   ${Hide} "${ServUnDCOM}"
   ${Hide} "${ServUnTelnet}"
   ${Hide} "${ServUnUPnP}"
   ${Hide} "${ServUnUPnPDiscovery}"
   ${Hide} "${ServUnMessenger}"
   ${Hide} "${ServUnNetMeetingDesktop}"
   ${Hide} "${ServUnRPCLoc}"
   ${Hide} "${ServUnRemReg}"
   ${Hide} "${ServUnBranchCache}"
   ${Hide} "${ServUnFirewall}"
   ${Hide} "${ServUnImapi}"
   ${Hide} "${ServUnSensrSvc}"
   ${Hide} "${ServUnAudioSrv}"
   ${Hide} "${ServUnWIA}"
   
   ${Hide} "${SecUnIExplore}"
   ${Hide} "${IEUnAutoUpdates}"
   ${Hide} "${IEUnSchedUpd}"
   ${Hide} "${IEUnErrorRep}"
   ${Hide} "${IEUnIntWinAuth}"
   ${Hide} "${IEUnMaxConn}"
   ${Hide} "${IEUnTabSettings}"
   ${Hide} "${IEUnDelTempFiles}"
   ${Hide} "${IEUnWebformComplete}"
   ${Hide} "${IEUnPasswordComplete}"
   ${Hide} "${IEUnSearchPage}"
   ${Hide} "${IEUnSearchScope}"
   ${Hide} "${IEUnActiveX}"
   ${Hide} "${IEUnJavaScript}"
   ${Hide} "${IEUnSSL2}"
   ${Hide} "${IEUnPhishFilter}"
   ${Hide} "${IEUnSearchAsst}"
   ${Hide} "${IEUn404Search}"
   ${Hide} "${IEUnBlankPage}"
   ${Hide} "${IEUnDefaultPrompt}"
   ${Hide} "${IEUnInfoBar}"
   
   ${Hide} "${SecUnWMP}"
   ${Hide} "${WMPUnAutoLicAcqu}"
   ${Hide} "${WMPUnSilentDRM}"
   ${Hide} "${WMPUnUpgradeMsg}"
   ${Hide} "${WMPUnLibrary}"
   ${Hide} "${WMPUnMetadataRet}"
   ${Hide} "${WMPUnUsageTrack}"
   ${Hide} "${WMPUnSendUID}"
   ${Hide} "${WMPUnAutoUpdates}"
   ${Hide} "${WMPUnNoMRU}"
   ${Hide} "${WMPUnAutoCodecDownl}"
   ${Hide} "${WMPUnImportMP3}"
   ${Hide} "${WMPUnNoDRM}"
   ${Hide} "${WMPUnAllowDeinst}"
   ${Hide} "${SecUnWinMessenger}"
   ${Hide} "${WMUnRemOE}"
   
   ${Hide} "${SecUnWinSearch}"
   ${Hide} "${WDSUnDisable}"
   
   ${Hide} "${SecUnUsability}"
   ${Hide} "${UsabUnBalloonTips}"
   ${Hide} "${UsabUnDiskSpace}"
   ${Hide} "${UsabUnCmdHere}"
   ${Hide} "${UsabUnCmdCompl}"
   ${Hide} "${UsabUnEditNotepad}"
   ${Hide} "${UsabUnAutoRun}"
   ${Hide} "${UsabUnSearchAsst}"
   ${Hide} "${UsabUnCleanupWiz}"
   ${Hide} "${UsabUnTaskGroup}"
   ${Hide} "${UsabUnClassicStartMenu}"
   ${Hide} "${UsabUnClassicLogon}"
   ${Hide} "${UsabUnShutdownReason}"
   ${Hide} "${UsabUnBarricade}"
   ${Hide} "${UsabUnHiddenFiles}"
   ${Hide} "${UsabUnShowFileExt}"
   ${Hide} "${UsabUnShowLNKExt}"
   ${Hide} "${UsabUnShowPIFExt}"
   ${Hide} "${UsabUnShowSCFExt}"
   ${Hide} "${UsabUnShowURLExt}"
   ${Hide} "${UsabUnFullPath}"
   ${Hide} "${UsabUnDisableThumbnails}"
   ${Hide} "${UsabUnDisableSounds}"
   ${Hide} "${UsabUnWinTheme}"
   
   ${Hide} "${TPUnAppleMobile}"
   ${Hide} "${TPUnIpodService}"
   ${Hide} "${TPUnBonjourService}"
   ${Hide} "${TPUnFlashUpdate}"
   ${Hide} "${TPUnGoogleUpdater}"
   ${Hide} "${TPUnGoogleSAC}"
   ${Hide} "${TPUnSkypeUpdate}"
   ${Hide} "${TPUnNvidiaUpdate}"
   
   ${Hide} "${SecUnDelete}"
   ${Hide} "${DelUnIELnk}"
   ${Hide} "${DelUnMailClient}"
   ${Hide} "${DelUnRecycleBin}"
   ${Hide} "${DelUnMyDocuments}"
   ${Hide} "${DelUnMyComputer}"
   ${Hide} "${DelUnMyNetwork}"
   ${Hide} "${DelUnControlPanel}"
   ${Hide} "${DelUnWMPLnk}"
   ${Hide} "${DelUnMovieMkLnk}"
   ${Hide} "${DelUnWinDVDMk}"
   ${Hide} "${DelUnWinPhotoGal}"
   ${Hide} "${DelUnWinDefender}"
   ${Hide} "${DelUnWinFaxScan}"
   ${Hide} "${DelUnWinCalendar}"
   ${Hide} "${DelUnWinContacts}"
   ${Hide} "${DelUnMSNLnk}"
   ${Hide} "${DelUnMessengerLnk}"
   ${Hide} "${DelUnWinUpdate}"
   ${Hide} "${DelUnWinMediaCenter}"
   ${Hide} "${DelUnWinMeetSpace}"
FunctionEnd
!endif ;MINIXPY

!ifndef MINIXPY
 Function AutoDetect
; detects unnecessary settings and locks them
  ${If} $Output == ""
  ${AndIfNot} $Force == "1"
   ReadRegStr $0 HKCR ".zip" ""
   StrCmp $0 "CompressedFolder" +4 0
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${GenCompressedFolders} $1
   SectionSetInstTypes ${GenCompressedFolders} ${ALLSECTIONS}

   ReadRegStr $0 HKCR "RegWizCtrl.RegWizCtrl" ""
   StrCmp $0 "RegWizCtrl " +4 0
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${GenRegWizC} $1
   SectionSetInstTypes ${GenRegWizC} ${ALLSECTIONS}
   
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\PCHealth\ErrorReporting" "DoReport" "0" "${GenErrorRep}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "nolmhash" "1" "${GenLMHash}"

   StrCpy $0 "0"
   ClearErrors
   EnumRegValue $2 "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\WGALogon" $0
   IfErrors 0 +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${GenWGA} $1
   SectionSetInstTypes ${GenWGA} ${ALLSECTIONS}
   
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows Script Host\Settings" "Enabled" "0" "${GenScriptHost}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" "1" "${GenRemAssist}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "restrictanonymous" "1" "${GenRestrictAnon}"
   ${Reload} "Dword" "HKCU" "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "InternetOpenWith" "0" "${GenInetOpen}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "NoNetCrawling" "1" "${GenNetCrawl}"
   ${Reload} "Dword" "HKLM" "SYSTEM\ControlSet001\Services\lanmanserver\parameters" "hidden" "1" "${GenHideComputer}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\MRT" "DontReportInfectionInformation" "1" "${GenRepInfect}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "DisableDHCPMediaSense" "1" "${GenMediaSense}"
   ${Reload} "Str" "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "RegDone" "1" "${GenClaimWinReg}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" "2" "${GenPrefetch}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" "2" "${GenSuperfetch}"
   ${Reload} "Str" "HKCU" "Control Panel\Desktop" "AutoEndTasks" "1" "${GenFastShutdn}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" "1" "${GenDelPagefile}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ClearRecentDocsOnExit" "1" "${GenDelMRU}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoRecentDocsNetHood" "1" "${GenRecentShares}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DontDisplayLastUserName" "1" "${GenLastUser}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "26" "${GenPriorityCtrl}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "20" "${GenSysResponse}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "EnableLUA" "0" "${GenDisableUAC}"
   
   #${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "PortNumber" "3389" "${GenRDPPort}"
   ReadRegDWORD $0 "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "PortNumber"
   ${If} $0 != "3389"
   ${OrIf} $0 == ""
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${GenRDPPort} $1
	   SectionSetInstTypes ${GenRDPPort} ${ALLSECTIONS}   
   ${EndIf}
   
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\Microsoft Antimalware\SpyNet" "SpyNetReporting" "0" "${GenSpyNet}"
   
   ${If} ${IsWinXP}
   ${OrIf} ${IsWin2003}
	   ${Reload} "Dword" "HKLM" "SYSTEM\WPA\PosReady" "Installed" "1" "${GenEnablePOS}"
	${EndIf}

   ${Reload} "Dword" "HKLM" "System\CurrentControlSet\Services\ERSvc" "Start" "4" "${ServErrorRep}"
   ${Reload} "Dword" "HKLM" "System\CurrentControlSet\Services\WerSvc" "Start" "4" "${ServErrorRep}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\wuauserv" "Start" "4" "${ServAutoWinUpd}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\wscsvc" "Start" "4" "${ServSecCenter}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\WinDefend" "Start" "4" "${ServWinDefend}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\W32Time" "Start" "4" "${ServTimeSync}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Schedule" "Start" "4" "${ServSchedTask}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\CiSvc" "Start" "4" "${ServIndexing}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\defragsvc" "Start" "4" "${ServDefrag}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SysMain" "Start" "4" "${ServSuperfetch}"

	 ReadRegDWORD $0 "HKLM" "SOFTWARE\Microsoft\Ole" "EnableDCOM"
	 ${IfNot} $0 == "0"
	 ${OrIfNot} $0 == "N"
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${ServDCOM} $1
	   SectionSetInstTypes ${ServDCOM} ${ALLSECTIONS}
	 ${EndIf}
   
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\TlntSvr" "Start" "4" "${ServTelnet}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\upnphost" "Start" "4" "${ServUPnP}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SSDPSRV" "Start" "4" "${ServUPnPDiscovery}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Messenger" "Start" "4" "${ServMessenger}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\mnmsrvc" "Start" "4" "${ServNetMeetingDesktop}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\RpcLocator" "Start" "4" "${ServRPCLoc}"
   ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\RemoteRegistry" "Start" "4" "${ServRemReg}"
   #${If} ${AtLeastWin7}
	${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\PeerDistSvc" "Start" "" "4" "${ServBranchCache}"
   #${EndIf}
   
   ${If} ${AtLeastWinVista}
	 ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\MpsSvc" "Start" "4" "${ServFirewall}"
   ${Else}
	 ${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SharedAccess" "Start" "4" "${ServFirewall}"
   ${EndIf}
   
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\ImapiService" "Start" "2" "3" "${ServImapi}"
   #${If} ${AtLeastWin7}
	${Reload} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SensrSvc" "Start" "4" "${ServSensrSvc}"
   #${EndIf}
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\AudioSrv" "Start" "2" "3" "${ServAudioSrv}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\stisvc" "Start" "2" "3" "${ServWIA}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Apple Mobile Device" "Start" "" "4" "${TPAppleMobile}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\iPod Service" "Start" "" "4" "${TPIpodService}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Bonjour Service" "Start" "" "4" "${TPBonjourService}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\AdobeFlashPlayerUpdateSvc" "Start" "" "4" "${TPFlashUpdate}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\gusvc" "Start" "" "4" "${TPGoogleUpdater}"
   ${ReloadOr} "Dword" "HKLM" "SOFTWARE\Policies\Google\Google Desktop\Enterprise" "disallow_ssd_service" "" "1" "${TPGoogleSAC}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SkypeUpdate" "Start" "" "4" "${TPSkypeUpdate}"
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\nvUpdatusService" "Start" "" "4" "${TPNvidiaUpdate}"

   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "NoUpdateCheck" "1" "${IEAutoUpdates}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Webcheck" "NoScheduledUpdates" "1" "${IESchedUpd}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "IEWatsonDisabled" "1" "${IEErrorRep}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "EnableNegotiate" "0" "${IEIntWinAuth}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "MaxConnectionsPerServer" "32" "${IEMaxConn}"

   ReadRegStr $0 "HKLM" "SOFTWARE\Microsoft\Internet Explorer" "Version"
   StrCpy $IeVersion $0 1
   IntCmp $IeVersion "7" 0 NoIE7TabSettings 0
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\TabbedBrowsing" "PopupsUseNewWindow" "2" "${IETabSettings}"
   Goto PostTabSettings
   NoIE7TabSettings:
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IETabSettings} $1
   SectionSetInstTypes ${IETabSettings} ${ALLSECTIONS}
   PostTabSettings:

   IfFileExists "$WINDIR\pchealth\helpctr\System\DFS\uplddrvinfo.htm" +4 0
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IEuplddrvinfo} $1
   SectionSetInstTypes ${IEuplddrvinfo} ${ALLSECTIONS}
   
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" "Persistent" "0" "${IEDelTempFiles}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Use FormSuggest" "no" "${IEWebformComplete}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "FormSuggest Passwords" "no" "${IEPasswordComplete}"

   ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Internet Explorer\Extensions\{c95fe080-8f5d-11d2-a20b-00aa003c157a}" ""
   StrCmp $0 "" 0 +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IEAlexa} $1
   SectionSetInstTypes ${IEAlexa} ${ALLSECTIONS}

   ReadRegStr $0 HKCU "Software\Microsoft\Internet Explorer\Main" "Search Page"
   StrCmp $0 "http://www.microsoft.com/isapi/redir.dll?prd=ie&ar=iesearch" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IESearchPage} $1
   SectionSetInstTypes ${IESearchPage} ${ALLSECTIONS}

   ReadRegStr $0 HKCU "Software\Microsoft\Internet Explorer\SearchScopes" "DefaultScope"
   ReadRegStr $1 HKCU "Software\Microsoft\Internet Explorer\SearchScopes\$0" ""
   StrCmp $1 "Live Search" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IESearchScope} $1
   SectionSetInstTypes ${IESearchScope} ${ALLSECTIONS}

   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1200" "3" "${IEActiveX}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1400" "3" "${IEJavaScript}"

   ReadRegDWORD $0 "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols"
   StrCmp $0 "" 0 +2
   StrCpy $0 "40"
   StrCmp $0 "8" PostSSL2
   StrCmp $0 "40" PostSSL2
   StrCmp $0 "136" PostSSL2
   StrCmp $0 "168" PostSSL2 0
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IESSL2} $1
   SectionSetInstTypes ${IESSL2} ${ALLSECTIONS}
  PostSSL2:

   IntCmp $IeVersion "7" 0 NoIE7PhishFilter 0
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\PhishingFilter" "Enabled" "0" "${IEPhishFilter}"
   Goto PostPhishFilter
   NoIE7PhishFilter:
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IEPhishFilter} $1
   SectionSetInstTypes ${IEPhishFilter} ${ALLSECTIONS}
   PostPhishFilter:

   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Use Search Asst" "no" "${IESearchAsst}"
   ${Reload} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Do404Search" "01000000" "${IE404Search}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Start Page" "about:blank" "${IEBlankPage}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Check_Associations" "no" "${IEDefaultPrompt}"

   IntCmp $IeVersion "7" 0 NoIE7InfoBar 0
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\InformationBar" "FirstTime" "0" "${IEInfoBar}"
   Goto PostInfoBar
   NoIE7InfoBar:
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${IEInfoBar} $1
   SectionSetInstTypes ${IEInfoBar} ${ALLSECTIONS}
   PostInfoBar:
   
   IntCmp $IeVersion "7" 0 NoIERemove 0
   ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ie$IeVersion" "UninstallString"
   ${If} $0 == ""
	 NoIERemove:
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${IERemove} $1
	 SectionSetInstTypes ${IERemove} ${ALLSECTIONS}
   ${EndIf}

   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SilentAcquisition" "0" "${WMPAutoLicAcqu}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SilentDRMConfiguration" "0" "${WMPSilentDRM}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\MediaPlayer\PlayerUpgrade" "AskMeAgain" "no" "${WMPUpgradeMsg}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "AutoAddMusicToLibrary" "0" "${WMPLibrary}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "MetadataRetrieval" "0" "${WMPMetadataRet}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "UsageTracking" "0" "${WMPUsageTrack}"
   ${Reload} "Dword"  "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SendUserGUID" "00" "${WMPSendUID}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" "disableAutoUpdate" "1" "${WMPAutoUpdates}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" "disableMRU" "1" "${WMPNoMRU}"
   ${Reload} "Dword" "HKCU" "Software\Policies\Microsoft\Preferences" "UpgradeCodecPrompt" "0" "${WMPAutoCodecDownl}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "CDRecordMP3" "1" "${WMPImportMP3}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "CDRecordDRM" "0" "${WMPNoDRM}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\MediaPlayer" "BlockUninstall" "no" "${WMPAllowDeinst}"
   ${Reload} "Dword" "HKLM" "SOFTWARE\Microsoft\Outlook Express" "Hide Messenger" "2" "${WMRemOE}" #vispa?
   
   ${IfNot} ${FileExists} "$WINDIR\INF\msmsgs.inf"
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${WMUninstall} $1
	   SectionSetInstTypes ${WMUninstall} ${ALLSECTIONS}
   ${EndIf}
	  
   ${ReloadOr} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\WSearch" "Start" "" "4" ${WDSDisable}
   
   ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KB940157" "UninstallString"
   ${If} $0 == ""
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${WDSRemove} $1
	 SectionSetInstTypes ${WDSRemove} ${ALLSECTIONS}
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${WDSDisable} $1
	 SectionSetInstTypes ${WDSDisable} ${ALLSECTIONS}
   ${EndIf}

   StrCmp $0 "" 0 +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${WDSRemove} $1
   SectionSetInstTypes ${WDSRemove} ${ALLSECTIONS}
   
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableBalloonTips" "0" "${UsabBalloonTips}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoLowDiskSpaceChecks" "1" "${UsabDiskSpace}"

   ReadRegStr $0 HKCR "Drive\shell\cmd" ""
   StrCmp $0 "Open Command Window Here" 0 +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${UsabCmdHere} $1
   SectionSetInstTypes ${UsabCmdHere} ${ALLSECTIONS}
	
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Command Processor" "CompletionChar" "9" "${UsabCmdCompl}"
 
   ReadRegStr $0 HKCR "*\shell\edit" ""
   StrCmp $0 "$(LabelEdit)" 0 +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${UsabEditNotepad} $1
   SectionSetInstTypes ${UsabEditNotepad} ${ALLSECTIONS}

   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" "67108863" "${UsabAutoRun}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "Use Search Asst" "no" "${UsabSearchAsst}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz" "NoRun" "1" "${UsabCleanupWiz}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomming" "0" "${UsabTaskGroup}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoSimpleStartMenu" "1" "${UsabClassicStartMenu}"
   ${Reload} "Dword" "HKLM" "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "ClassicLogon" "0" "${UsabClassicLogon}"
   
   ${If} ${IsWin2003}
		${Reload} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\Windows NT\Reliability" "ShutdownReasonOn" "0" "${UsabShutdownReason}"
   ${Else}
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
		SectionSetFlags ${UsabShutdownReason} $1
		SectionSetInstTypes ${UsabShutdownReason} ${ALLSECTIONS}
	${EndIf}
	${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:SystemDriveRootFolder" "0" "${UsabBarricade}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" "1" "${UsabHiddenFiles}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" "0" "${UsabShowFileExt}"
   
   ${IfNot} $Output >= "1"
		ClearErrors
		ReadRegStr $0 "HKCR" "lnkfile" "NeverShowExt"
		IfErrors 0 +6
		Push $1
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
		SectionSetFlags ${UsabShowLNKExt} $1
		Pop $1
		SectionSetInstTypes ${UsabShowLNKExt} ${ALLSECTIONS}
   ${EndIf}
   
   ${IfNot} $Output >= "1"
		ClearErrors
		ReadRegStr $0 "HKCR" "piffile" "NeverShowExt"
		IfErrors 0 +6
		Push $1
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
		SectionSetFlags ${UsabShowPIFExt} $1
		Pop $1
		SectionSetInstTypes ${UsabShowPIFExt} ${ALLSECTIONS}
   ${EndIf}
   
   ${IfNot} $Output >= "1"
		ClearErrors
		ReadRegStr $0 "HKCR" "SHCmdFile" "NeverShowExt"
		IfErrors 0 +6
		Push $1
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
		SectionSetFlags ${UsabShowSCFExt} $1
		Pop $1
		SectionSetInstTypes ${UsabShowSCFExt} ${ALLSECTIONS}
   ${EndIf}
   
   ${IfNot} $Output >= "1"
		ClearErrors
		ReadRegStr $0 "HKCR" "InternetShortcut" "NeverShowExt"
		IfErrors 0 +6
		Push $1
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
		SectionSetFlags ${UsabShowURLExt} $1
		Pop $1
		SectionSetInstTypes ${UsabShowURLExt} ${ALLSECTIONS}
   ${EndIf}
   
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" "1" "${UsabFullPath}"
   ${Reload} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisableThumbnailCache" "1" "${UsabDisableThumbnails}"

   ReadRegStr $0 HKCU "AppEvents\Schemes\Apps\.Default\SystemStart\.current" ""
   ${If} $0 == ""
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${UsabDisableSounds} $1
	 SectionSetInstTypes ${UsabDisableSounds} ${ALLSECTIONS}
   ${EndIf}

   ${Reload} "Dword" "HKCU" "Software\Microsoft\Plus!\Themes\Current" "" "%SystemRoot%\resources\Themes\Windows Classic.theme" "${UsabWinTheme}"
   
   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{871C5380-42A0-1069-A2EA-08002B30309D}"
   ${If} $0 == "1"
   ${OrIfNot} ${FileExists} "$SMPROGRAMS\Internet Explorer.lnk"
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${DelIELnk} $1
	 SectionSetInstTypes ${DelIELnk} ${ALLSECTIONS}
   ${EndIf}

   ${If} ${AtLeastWinVista}
	   IfFileExists "$SMPROGRAMS\Windows Mail.lnk" +4
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${DelMailClient} $1
	   SectionSetInstTypes ${DelMailClient} ${ALLSECTIONS}
   ${Else}
	   IfFileExists "$SMPROGRAMS\Outlook Express.lnk" +4
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${DelMailClient} $1
	   SectionSetInstTypes ${DelMailClient} ${ALLSECTIONS}
   ${EndIf}

   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{645FF040-5081-101B-9F08-00AA002F954E}"
   ${If} $0 == "1"
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${DelRecycleBinLnk} $1
	 SectionSetInstTypes ${DelRecycleBinLnk} ${ALLSECTIONS}
   ${EndIf}
   
   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{450D8FBA-AD25-11D0-98A8-0800361B1103}"
   ReadRegDWORD $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{450D8FBA-AD25-11D0-98A8-0800361B1103}"
   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
   ReadRegDWORD $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
   
   ${If} $0 == "1"
   ${OrIf} $1 == "1"
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${DelMyDocumentsLnk} $1
	 SectionSetInstTypes ${DelMyDocumentsLnk} ${ALLSECTIONS}
   ${EndIf}
   
   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
   ReadRegDWORD $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
   ${If} $0 == "1"
   ${OrIf} $1 == "1"
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${DelMyComputerLnk} $1
	 SectionSetInstTypes ${DelMyComputerLnk} ${ALLSECTIONS}
   ${EndIf}
   
   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{208D2C60-3AEA-1069-A2D7-08002B30309D}"
   ReadRegDWORD $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{208D2C60-3AEA-1069-A2D7-08002B30309D}"
   ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
	ReadRegDWORD $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
   
   ${If} $0 == "1"
   ${OrIf} $1 == "1"
	 IntOp $1 ${SF_SELECTED} | ${SF_RO}
	 SectionSetFlags ${DelMyNetworkLnk} $1
	 SectionSetInstTypes ${DelMyNetworkLnk} ${ALLSECTIONS}
   ${EndIf}
   
	 ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
	 ReadRegDWORD $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
	 ${If} $0 == "1"
	 ${OrIf} $1 == "1"
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${DelControlPanelLnk} $1
	   SectionSetInstTypes ${DelControlPanelLnk} ${ALLSECTIONS}
	 ${EndIf}

   IfFileExists "$SMPROGRAMS\Windows Media Player.lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWMPLnk} $1
   SectionSetInstTypes ${DelWMPLnk} ${ALLSECTIONS}

   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinMovieMk).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelMovieMkLnk} $1
   SectionSetInstTypes ${DelMovieMkLnk} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinDVDMk).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinDVDMk} $1
   SectionSetInstTypes ${DelWinDVDMk} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinPhotoGal).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinPhotoGal} $1
   SectionSetInstTypes ${DelWinPhotoGal} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinDefender).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinDefender} $1
   SectionSetInstTypes ${DelWinDefender} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinLiveDl).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinLiveDl} $1
   SectionSetInstTypes ${DelWinLiveDl} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinFaxScan).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinFaxScan} $1
   SectionSetInstTypes ${DelWinFaxScan} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinCalendar).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinCalendar} $1
   SectionSetInstTypes ${DelWinCalendar} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\$(TermWinContacts).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinContacts} $1
   SectionSetInstTypes ${DelWinContacts} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\MSN.lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelMSNLnk} $1
   SectionSetInstTypes ${DelMSNLnk} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$SMPROGRAMS\Windows Messenger.lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelMessengerLnk} $1
   SectionSetInstTypes ${DelMessengerLnk} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$STARTMENU\$(TermWinUpdate).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinUpdate} $1
   SectionSetInstTypes ${DelWinUpdate} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$STARTMENU\$(TermWelcomeCenter).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWelcomeCenter} $1
   SectionSetInstTypes ${DelWelcomeCenter} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$STARTMENU\$(TermWinMediaCenter).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinMediaCenter} $1
   SectionSetInstTypes ${DelWinMediaCenter} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$STARTMENU\$(TermWinUltExtras).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinUltExtras} $1
   SectionSetInstTypes ${DelWinUltExtras} ${ALLSECTIONS}
   SetShellVarContext current

   IfFileExists "$STARTMENU\$(TermWinMeetSpace).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinMeetSpace} $1
   SectionSetInstTypes ${DelWinMeetSpace} ${ALLSECTIONS}

   SetShellVarContext all
   IfFileExists "$STARTMENU\$(TermWinCat).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelWinCatalog} $1
   SectionSetInstTypes ${DelWinCatalog} ${ALLSECTIONS}
#   SetShellVarContext current

#   SetShellVarContext all
   IfFileExists "$STARTMENU\$(TermProgAccess).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelProgAccess} $1
   SectionSetInstTypes ${DelProgAccess} ${ALLSECTIONS}
#   SetShellVarContext current
   
#   SetShellVarContext all
   IfFileExists "$FAVORITES\$(TermLinks)" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelMsBookmarks} $1
   SectionSetInstTypes ${DelMsBookmarks} ${ALLSECTIONS}
   SetShellVarContext current
   
   IfFileExists "$PICTURES\$(TermSamplePics).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelSamplePictures} $1
   SectionSetInstTypes ${DelSamplePictures} ${ALLSECTIONS}

   IfFileExists "$MUSIC\$(TermSampleMusic).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelSampleMusic} $1
   SectionSetInstTypes ${DelSampleMusic} ${ALLSECTIONS}

   IfFileExists "$Videos\$(TermSampleVideos).lnk" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelSampleVideos} $1
   SectionSetInstTypes ${DelSampleVideos} ${ALLSECTIONS}

   SetShellVarContext all
   IfFileExists "$MUSIC\$(TermSamplePlaylists)\*.*" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelSamplePlaylists} $1
   SectionSetInstTypes ${DelSamplePlaylists} ${ALLSECTIONS}
   SetShellVarContext current

   IfFileExists "$WINDIR\*.bmp" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelBitmaps} $1
   SectionSetInstTypes ${DelBitmaps} ${ALLSECTIONS}
   
   ; #VistaSP1
   IfFileExists "$SYSDIR\vsp1cln.exe" 0 +2
   StrCpy $vsp1cln_Path "$SYSDIR\vsp1cln.exe"
   
   ${If} ${RunningX64} #keeps using 32-bit version, if 64-bit not present
   ${AndIf} ${FileExists} "$WINDIR\SysNative\vsp1cln.exe"
		StrCpy $vsp1cln_Path "$WINDIR\SysNative\vsp1cln.exe"
   ${EndIf}
   
   ${If} ${FileExists} "$vsp1cln_Path"
   ${AndIf} ${FileExists} "$WINDIR\winsxs\msil_eventviewer_31bf3856ad364e35_6.0.6000.16386_none_a38992acac29bf36\EventViewer.dll"
   ${AndIf} ${IsWinVista}
   ${AndIf} ${IsServicePack} 1
	   #yeah, weird way to do this
   ${Else}
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${DelVistaSP1} $1
	   SectionSetInstTypes ${DelVistaSP1} ${ALLSECTIONS}
   ${EndIf}
   
   #VistaSP2
   IfFileExists "$SYSDIR\compcln.exe" 0 +2
   StrCpy $compcln_Path "$SYSDIR\compcln.exe"
   
   ${If} ${RunningX64} #keeps using 32-bit version, if 64-bit not present
   ${AndIf} ${FileExists} "$WINDIR\SysNative\compcln.exe"
		StrCpy $compcln_Path "$WINDIR\SysNative\compcln.exe"
   ${EndIf}
   
   ${If} ${FileExists} "$compcln_Path"
   ${AndIf} ${FileExists} "$WINDIR\winsxs\msil_microsoft.grouppolicy.reporting_31bf3856ad364e35_6.0.6001.18000_none_4a0d0f9cab244c8b\Microsoft.GroupPolicy.Reporting.dll"
   ${AndIf} ${IsWinVista}
   ${AndIf} ${IsServicePack} 2
	   #yeah, weird way to do this
   ${Else}
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${DelVistaSP2} $1
	   SectionSetInstTypes ${DelVistaSP2} ${ALLSECTIONS}
    ${EndIf}
   
   #DelWin7SP
   IfFileExists "$SYSDIR\DISM.exe" 0 +2
   StrCpy $DISM_Path "$SYSDIR\DISM.exe"
   
   ${If} ${RunningX64} #keeps using 32-bit version, if 64-bit not present
   ${AndIf} ${FileExists} "$WINDIR\SysNative\DISM.exe"
		StrCpy $DISM_Path "$WINDIR\SysNative\DISM.exe"
   ${EndIf}
   
   ${If} ${FileExists} "$DISM_Path"
   ${AndIf} ${FileExists} "$WINDIR\winsxs\msil_addinprocess_b77a5c561934e089_6.1.7600.16385_none_f774a5dff3f1e54a"
   ${AndIf} ${IsWin7}
   ${AndIf} ${IsServicePack} 1
	   #yeah, weird way to do this
   ${Else}
	   IntOp $1 ${SF_SELECTED} | ${SF_RO}
	   SectionSetFlags ${DelWin7SP} $1
	   SectionSetInstTypes ${DelWin7SP} ${ALLSECTIONS}
    ${EndIf}

   IfFileExists "$WINDIR\Prefetch\*.pf" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelPrefetch} $1
   SectionSetInstTypes ${DelPrefetch} ${ALLSECTIONS}
   
   FindFirst $0 $1 "$WINDIR\SoftwareDistribution\Download\*.*"
   IfFileExists "$WINDIR\SoftwareDistribution\Download\$1" +4
   IntOp $1 ${SF_SELECTED} | ${SF_RO}
   SectionSetFlags ${DelUpdCache} $1
   SectionSetInstTypes ${DelUpdCache} ${ALLSECTIONS}
   
  ${EndIf}
 FunctionEnd
!endif ;MINIXPY

!ifndef MINIXPY
 Function IsIniEmpty
; checks if the .ini file is empty and deletes if empty
  !ifndef UITEST
	  StrCpy $EmptyINI "0"
	  
	  ${IsINIEmpty} "General" "CompressedFolders"
	  ${IsINIEmpty} "General" "RegWizC"
	  ${IsINIEmpty} "General" "ErrorRep"
	  ${IsINIEmpty} "General" "LMHash"
	  ${IsINIEmpty} "General" "WGA"
	  ${IsINIEmpty} "General" "WSHEnable"
	  ${IsINIEmpty} "General" "RemAssist1"
	  ${IsINIEmpty} "General" "RepInfect"
	  ${IsINIEmpty} "General" "MediaSense"
	  ${IsINIEmpty} "General" "RegDone"
	  ${IsINIEmpty} "General" "FastShutdn"
	  ${IsINIEmpty} "General" "DelPagefile"
	  ${IsINIEmpty} "General" "DelMRU"
	  ${IsINIEmpty} "General" "LastUser"
	  ${IsINIEmpty} "General" "DisableUAC"

	  ${IsINIEmpty} "Services" "ErrorRep"
	  ${IsINIEmpty} "Services" "AutoWinUpd"
	  ${IsINIEmpty} "Services" "WinDefend"
	  ${IsINIEmpty} "Services" "TimeSync"
	  ${IsINIEmpty} "Services" "SchedTask"
	  ${IsINIEmpty} "Services" "Indexing"
	  ${IsINIEmpty} "Services" "DCOM"
	  ${IsINIEmpty} "Services" "UPnP"
	  ${IsINIEmpty} "Services" "UPnPDiscovery"
	  ${IsINIEmpty} "Services" "Messenger"
	  ${IsINIEmpty} "Services" "RPCLoc"
	  ${IsINIEmpty} "Services" "RemReg"
	  
	  ${If} ${AtLeastWinVista}
		${IsINIEmpty} "Services" "Firewall"
	  ${Else}
		${IsINIEmpty} "Services" "IcfIcs"
	  ${EndIF}

	  ${IsINIEmpty} "InternetExplorer" "AutoUpdates"
	  ${IsINIEmpty} "InternetExplorer" "SchedUpd"
	  ${IsINIEmpty} "InternetExplorer" "IntWinAuth"
	  ${IsINIEmpty} "InternetExplorer" "MaxConnPS"
	  ${IsINIEmpty} "InternetExplorer" "uplddrvinfo"
	  ${IsINIEmpty} "InternetExplorer" "DelTempFiles"
	  ${IsINIEmpty} "InternetExplorer" "Alexa"
	  ${IsINIEmpty} "InternetExplorer" "ActiveX1200"
	  ${IsINIEmpty} "InternetExplorer" "JavaScript1400"
	  ${IsINIEmpty} "InternetExplorer" "SearchAsst"

	  ${IsINIEmpty} "WindowsMediaPlayer" "AutoLicAcqu"
	  ${IsINIEmpty} "WindowsMediaPlayer" "UpgradeMsg"
	  ${IsINIEmpty} "WindowsMediaPlayer" "Library"
	  ${IsINIEmpty} "WindowsMediaPlayer" "MetadataRet"
	  ${IsINIEmpty} "WindowsMediaPlayer" "UsageTrack"
	  ${IsINIEmpty} "WindowsMediaPlayer" "AutoUpdates"
	  ${IsINIEmpty} "WindowsMediaPlayer" "NoMRU"
	  ${IsINIEmpty} "WindowsMediaPlayer" "AutoCodecDownl"
	  ${IsINIEmpty} "WindowsMediaPlayer" "AllowDeinst"
	  ${IsINIEmpty} "WindowsMessenger" "WMRemOE"
	  ${IsINIEmpty} "WindowsMessenger" "Uninstall"
	  ${IsINIEmpty} "WindowsSearch" "Disable"
	  ${IsINIEmpty} "Usability" "BalloonTips"
	  ${IsINIEmpty} "Usability" "LowDiskspace"
	  ${IsINIEmpty} "Usability" "CmdHere"
	  ${IsINIEmpty} "Usability" "CmdCompl"
	  ${IsINIEmpty} "Usability" "AutoRun"
	  ${IsINIEmpty} "Usability" "SearchAsst"
	  ${IsINIEmpty} "Usability" "TaskGroup"
	  ${IsINIEmpty} "Usability" "ClassicStartMenu"
	  ${IsINIEmpty} "Usability" "ClassicLogon"
	  ${IsINIEmpty} "Usability" "BarricadeRootFolder"
	  ${IsINIEmpty} "Usability" "HiddenFiles"
	  ${IsINIEmpty} "Usability" "ShowFileExt"
	  ${IsINIEmpty} "Usability" "WinTheme"
	  
	  StrCmp $EmptyINI "0" 0 +2
	  Delete "$APPDATA\${LOWERCASE}.ini"
	!endif
 FunctionEnd
!endif ;MINIXPY

Function StrReplace
; replaces quotes of $Input file location
  !ifndef UITEST
	  Exch $0 ;this will replace wrong characters
	  Exch
	  Exch $1 ;needs to be replaced
	  Exch
	  Exch 2
	  Exch $2 ;the orginal string
	  Push $3 ;counter
	  Push $4 ;temp character
	  Push $5 ;temp string
	  Push $6 ;length of string that need to be replaced
	  Push $7 ;length of string that will replace
	  Push $R0 ;tempstring
	  Push $R1 ;tempstring
	  Push $R2 ;tempstring
	  StrCpy $3 "-1"
	  StrCpy $5 ""
	  StrLen $6 $1
	  StrLen $7 $0
	  Loop:
	  IntOp $3 $3 + 1
	  Loop_noinc:
	  StrCpy $4 $2 $6 $3
	  StrCmp $4 "" ExitLoop
	  StrCmp $4 $1 Replace
	  Goto Loop
	  Replace:
	  StrCpy $R0 $2 $3
	  IntOp $R2 $3 + $6
	  StrCpy $R1 $2 "" $R2
	  StrCpy $2 $R0$0$R1
	  IntOp $3 $3 + $7
	  Goto Loop_noinc
	  ExitLoop:
	  StrCpy $0 $2
	  Pop $R2
	  Pop $R1
	  Pop $R0
	  Pop $7
	  Pop $6
	  Pop $5
	  Pop $4
	  Pop $3
	  Pop $2
	  Pop $1
	  Exch $0
  !endif
FunctionEnd


Function CreateGUID
; creates a GUID for search scope
  !ifndef UITEST
	System::Call 'ole32::CoCreateGuid(g .s)'
  !endif
FunctionEnd


Function ThemeChange
; changes the pushed windows .theme
  !ifndef UITEST
	  Exch $R0

	  IfFileExists "$R0" 0 End
	  ExecShell 'open' '$R0'
	  FindWindow $0 '#32770' '' $HWNDPARENT
	  StrCpy $3 0

	  wait:
	  IntOp $3 $3 + 1
	  StrCmp $3 50 End
	  Sleep 1000
	  System::Call 'user32::GetForegroundWindow()i .r1'
	  StrCmp $0 $1 wait

	  System::Call 'user32::GetWindowModule${If}(i r1, t .r2, i ${NSIS_MAX_STRLEN})'
	  ${GetFileName} '$2' $2
	  StrCmp $2 'comctl32.dll' 0 wait

	  HideWindow
	  GetDlgItem $2 $1 1
	  SendMessage $2 ${BM_CLICK} 0 0
	  End:

	  Pop $R0
  !endif
FunctionEnd

Function IconRefresh
; refreshes explorer to display modified icons
  !ifndef UITEST
	System::Call 'Shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'
  !endif
FunctionEnd

Function SearchEngines
  Exch $0
  ${If} $0 == "A9 (a9.com)"
	StrCpy $SearchPage "http://a9.com"
	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://a9.com/{searchTerms}"
	StrCpy $SearchName "A9"
  ${ElseIf} $0 == "Altavista (altavista.com)"
	StrCpy $SearchPage "http://altavista.com"
  	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://www.altavista.com/web/results?q={searchTerms}"
	StrCpy $SearchName "Altavista"
  ${ElseIf} $0 == "Ask (ask.com)"
	StrCpy $SearchPage "http://ask.com"
	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://www.ask.com/web?q={searchTerms}"
	StrCpy $SearchName "Ask"
  ${ElseIf} $0 == "Baidu (baidu.com)"
	StrCpy $SearchPage "http://baidu.com"
	StrCpy $SearchBar "baidu.com"
	StrCpy $SearchQuery "http://www.baidu.com/s?wd={searchTerms}"
	StrCpy $SearchName "Baidu"
  ${ElseIf} $0 == "Bing (bing.com)"
	StrCpy $SearchPage "http://bing.com"
	StrCpy $SearchBar "bing.com"
	StrCpy $SearchQuery "http://www.bing.com/search?q={searchTerms}"
	StrCpy $SearchName "Bing"
  ${ElseIf} $0 == "DuckDuckGo (duckduckgo.com)"
	StrCpy $SearchPage "http://duckduckgo.com"
	StrCpy $SearchBar "duckduckgo.com"
	StrCpy $SearchQuery "https://duckduckgo.com/?q={searchTerms}"
	StrCpy $SearchName "DuckDuckGo"
  ${ElseIf} $0 == "Google (google.com)"
	StrCpy $SearchPage "http://google.com"
	StrCpy $SearchBar "http://google.com/ie"
	StrCpy $SearchQuery "http://www.google.com/search?q={searchTerms}"
	StrCpy $SearchName "Google"
  ${ElseIf} $0 == "Ixquick (ixquick.com)"
	StrCpy $SearchPage "http://ixquick.com"
	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://ixquick.com/do/metasearch.pl?query={searchTerms}"
	StrCpy $SearchName "Ixquick"
  ${ElseIf} $0 == "Metacrawler (metacrawler.com)"
	StrCpy $SearchPage "http://metacrawler.com"
	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://www.metacrawler.com/search/web?q={searchTerms}"
	StrCpy $SearchName "Metacrawler"
  ${ElseIf} $0 == "Yahoo! (yahoo.com)"
	StrCpy $SearchPage "http://yahoo.com"
	StrCpy $SearchBar $SearchPage
	StrCpy $SearchQuery "http://search.yahoo.com/search?p={searchTerms}"
	StrCpy $SearchName "Yahoo!"
  ${EndIf}
  Pop $0
FunctionEnd

Function ValidateInput
  !ifndef UITEST
	  Push $Input
	  Push '"'
	  Push ""
	  Call StrReplace
	  Pop $Input

	  /*
	  Push $Input
	  Call GetName
	  Pop $R0
	  StrCmp $R0 "${LOWERCASE}" 0 InvalidInput
	  */
	  ${GetFileExt} $Input $R0
		
	  ${If} ${FileExists} "$Input"
	  ${AndIf} $R0 == "${LOWERCASE}"
	  ${OrIf} $R0 == "vispa"
		;  Temporary Setting for backward-compatibility
		 ValidInput:
		  Push $Input
		  !ifndef MINIXPY
			Call UnSelectUnSections
		  !endif ;MINIXPY
		  Call SelectSections
		  ${IfNot} $Input == ""
			   ReadINIStr $SearchEngineIni "$Input" "${LOWERCASE}" "Search"
			   Push $SearchEngineIni
			   Call SearchEngines  	   
		  ${EndIf}
		  ReadINIStr $0 $Input "${LOWERCASE}" "Review"
		  StrCmp $0 "1" +2
		  StrCpy $Passive "1"
	  ${ElseIf} ${FileExists} "$EXEDIR\$Input"
	  ${AndIf} $R0 == "${LOWERCASE}"
	  ${OrIf} $R0 == "vispa"
		  StrCpy $Input "$EXEDIR\$Input"
		  Goto ValidInput
	  ${Else}
		 #InvalidInput:
		  MessageBox MB_OK|MB_ICONINFORMATION "$(MBNotFound)"
		  Quit
	 ${EndIf}
  !endif
FunctionEnd


Function StrCSpnReverse
 Exch $R0 ; string to check
 Exch
 Exch $R1 ; string of chars
 Push $R2 ; current char
 Push $R3 ; current char
 Push $R4 ; char loop
 Push $R5 ; char loop

  StrCpy $R4 -1

  NextCharCheck:
  StrCpy $R2 $R0 1 $R4
  IntOp $R4 $R4 - 1
   StrCmp $R2 "" StrOK

   StrCpy $R5 -1

   NextChar:
   StrCpy $R3 $R1 1 $R5
   IntOp $R5 $R5 - 1
	StrCmp $R3 "" +2
	StrCmp $R3 $R2 NextCharCheck NextChar
	 StrCpy $R0 $R2
	 Goto Done

 StrOK:
 StrCpy $R0 ""

 Done:

 Pop $R5
 Pop $R4
 Pop $R3
 Pop $R2
 Pop $R1
 Exch $R0
FunctionEnd