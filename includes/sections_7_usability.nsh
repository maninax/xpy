SectionGroup "$(SubUsability)" SecUsability

#!ifndef VISPA
 Section "$(SecUsabBalloonTips)" UsabBalloonTips
  SectionIn ${TypeClassic}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableBalloonTips" "0" ${UsabBalloonTips} "Usability" "BalloonTips"
  End:
 SectionEnd
#!endif ;VISPA

 Section "$(SecUsabDiskSpace)" UsabDiskSpace
  SectionIn ${TypeClassic}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoLowDiskSpaceChecks" "1" ${UsabDiskSpace} "Usability" "LowDiskspace"
  End:
 SectionEnd
 
#!ifndef VISPA
 Section "$(SecUsabCmdHere)" UsabCmdHere
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  
  SectionGetFlags ${UsabCmdHere} $0
  StrCmp $0 "${READONLY}" End
  
  ${If} $Output == 1
        WriteINIStr "$SaveFile" "Usability" "CmdHere" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecUsabCmdHere)' $(DPSkip)"
  ${Else}
        WriteRegStr HKCR "Directory\shell\cmd" "" "Open Command Window Here"
  	WriteRegStr HKCR "Directory\shell\cmd\command" "" 'cmd.exe /k "cd %L"'
  	DetailPrint '"HKCR\Directory\shell\cmd" $(DPCreate)'
  	WriteRegStr HKCR "Drive\shell\cmd" "" "Open Command Window Here"
  	WriteRegStr HKCR "Drive\shell\cmd\command" "" 'cmd.exe /k "cd %L"'
  	DetailPrint '"HKCR\Drive\shell\cmd" $(DPCreate)'
  	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "CmdHere" "~DeleteKey"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecUsabCmdCompl)" UsabCmdCompl
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Command Processor" "CompletionChar" "9" ${UsabCmdCompl} "Usability" "CmdCompl"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Command Processor" "PathCompletionChar" "9" ${UsabCmdCompl} "Usability" "PathCompl"
  End:
 SectionEnd
#!endif ;VISPA

 Section "$(SecUsabEditNotepad)" UsabEditNotepad
  SectionIn ${TypeNo3rdParty}
  
  SectionGetFlags ${UsabEditNotepad} $0
  StrCmp $0 "${READONLY}" End

  ${If} $Output == 1
  	WriteINIStr "$SaveFile" "Usability" "EditNotepad" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecUsabEditNotepad)' $(DPSkip)"
  ${Else}
  	WriteRegStr HKCR "*\shell\edit" "" "$(LabelEdit)"
  	WriteRegStr HKCR "*\shell\edit\command" "" 'notepad.exe "%1"'
  	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "EditNotepad" "~DeleteKey"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecUsabAutoRun)" UsabAutoRun
  SectionIn ${TypeNo3rdParty}
  #!ifndef VISPA
    StrCmp $WinVer "Vista" End
  #!endif ;VISPA
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" "67108863" ${UsabAutoRun} "Usability" "AutoRun"
  End:
 SectionEnd

#!ifndef VISPA
 Section "$(SecUsabSearchAsst)" UsabSearchAsst
  SectionIn ${TypeClassic}
  StrCmp $WinVer "Vista" End
  ${Registry} "Str" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "Use Search Asst" "no" ${UsabSearchAsst} "Usability" "SearchAsst"
  End:
 SectionEnd
#!endif ;VISPA

 Section "$(SecUsabCleanupWiz)" UsabCleanupWiz
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz" "NoRun" "1" ${UsabCleanupWiz} "Usability" "CleanupWiz"
  End:
 SectionEnd

 Section "$(SecUsabTaskGroup)" UsabTaskGroup
  SectionIn ${TypeClassic}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomming" "0" ${UsabTaskGroup} "Usability" "TaskGroup"
  End:
 SectionEnd

 Section "$(SecUsabClassicStartMenu)" UsabClassicStartMenu
  SectionIn ${TypeClassic}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoSimpleStartMenu" "1" ${UsabClassicStartMenu} "Usability" "ClassicStartMenu"
  ${If} $Output == ""
	xpyhelper::SwitchTaskbarXPStyle 0
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecUsabClassicLogon)" UsabClassicLogon
  SectionIn ${TypeClassic}
  ${Registry} "Dword" "HKLM" "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "ClassicLogon" "0" ${UsabClassicLogon} "Usability" "ClassicLogon"
  End:
 SectionEnd
 
 Section "$(SecUsabShutdownReason)" UsabShutdownReason
  SectionIn ${TypeWin2003}
  ${Registry} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\Windows NT\Reliability" "ShutdownReasonOn" "0" ${UsabShutdownReason} "Usability" "ShutdownReasonOn"
  ${Registry} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\Windows NT\Reliability" "ShutdownReasonUI" "0" ${UsabShutdownReason} "Usability" "ShutdownReasonUI"
  End:
 SectionEnd

#!ifndef VISPA
 Section "$(SecUsabBarricade)" UsabBarricade
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:SystemDriveRootFolder" "0" ${UsabBarricade} "Usability" "BarricadeRootFolder"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:ControlPanelFolder" "0" ${UsabBarricade} "Usability" "BarricadeControlPanel"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:ProgramFiles" "0" ${UsabBarricade} "Usability" "BarricadeProgramFiles"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:Windows" "0" ${UsabBarricade} "Usability" "BarricadeWindows"
  End:
 SectionEnd
#!endif ;VISPA

   #classic folders
   #HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "WebView" "0"

 Section "$(SecUsabHiddenFiles)" UsabHiddenFiles
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" "1" ${UsabHiddenFiles} "Usability" "HiddenFiles"
  End:
 SectionEnd

 Section "$(SecUsabShowFileExt)" UsabShowFileExt
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" "0" ${UsabShowFileExt} "Usability" "ShowFileExt"
  End:
 SectionEnd
 
 Section "$(SecUsabShowLNKExt)" UsabShowLNKExt
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCR" "lnkfile" "AlwaysShowExt" "" ${UsabShowLNKExt} "Usability" "ShowLNKExt"
  ${If} $Output == ""
	  DeleteRegValue "HKCR" "lnkfile" "NeverShowExt"
	  DetailPrint '"HKCR\lnkfile\NeverShowExt" $(DPDelete)'
	  StrCpy $IconRefresh "1"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecUsabShowPIFExt)" UsabShowPIFExt
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCR" "piffile" "AlwaysShowExt" "" ${UsabShowPIFExt} "Usability" "ShowPIFExt"
  ${If} $Output == ""
	  DeleteRegValue "HKCR" "piffile" "NeverShowExt"
	  DetailPrint '"HKCR\piffile\NeverShowExt" $(DPDelete)'
	  StrCpy $IconRefresh "1"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecUsabShowSCFExt)" UsabShowSCFExt
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCR" "SHCmdFile" "AlwaysShowExt" "" ${UsabShowSCFExt} "Usability" "ShowSCFExt"
  ${If} $Output == ""
	  DeleteRegValue "HKCR" "SHCmdFile" "NeverShowExt"
	  DetailPrint '"HKCR\SHCmdFile\NeverShowExt" $(DPDelete)'
	  StrCpy $IconRefresh "1"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecUsabShowURLExt)" UsabShowURLExt
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCR" "InternetShortcut" "AlwaysShowExt" "" ${UsabShowURLExt} "Usability" "ShowURLExt"
  ${If} $Output == ""
	  DeleteRegValue "HKCR" "InternetShortcut" "NeverShowExt"
	  DetailPrint '"HKCR\InternetShortcut\NeverShowExt" $(DPDelete)'
	  StrCpy $IconRefresh "1"
  ${EndIf}
  End:
 SectionEnd
  
 Section "$(SecUsabFullPath)" UsabFullPath
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" "1" ${UsabFullPath} "Usability" "FullPath"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPathAddress" "1" ${UsabFullPath} "Usability" "FullPathAddress"
  End:
 SectionEnd
  
 Section "$(SecUsabDisableThumbnails)" UsabDisableThumbnails
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisableThumbnailCache" "1" ${UsabDisableThumbnails} "Usability" "DisableThumbnails"
  End:
 SectionEnd
 
 Section "$(SecUsabDisableSounds)" UsabDisableSounds
  SectionIn ${TypeNo3rdParty}
  ${RegExpStr} "HKCU" "AppEvents\Schemes\Apps\.Default\SystemStart\.current" "" "" ${UsabDisableSounds} "Usability" "DisableSounds"
  ${RegExpStr} "HKCU" "AppEvents\Schemes\Apps\.Default\SystemExit\.current" "" "" ${UsabDisableSounds} "Usability" "DisableSounds"
  End:
 SectionEnd
/*
 Section "$(SecUsabProgFiles)" UsabProgFiles
   SectionIn 2
   ${Registry} "Str" "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion" "ProgramFilesDir" "1" ${UsabProgFiles} "Usability" "ProgFiles"
   End:
 SectionEnd
*/
 Section "$(SecUsabWinTheme)" UsabWinTheme
  SectionIn ${TypeClassic}
  SectionGetFlags ${UsabWinTheme} $0
  StrCmp $0 "${READONLY}" End
       
  ${If} $Output == "1"
        WriteINIStr "$SaveFile" "Usability" "WinTheme" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecUsabWinTheme)' $(DPSkip)"
  ${Else}
	ReadRegStr $0 HKCU "Software\Microsoft\Plus!\Themes\Current" ""
	${If} $0 == ""
    	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "WinTheme" "~DeleteKey"
    	${Else}
    	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "WinTheme" "$0"
    	${EndIf}
        Push "$WINDIR\Resources\Themes\Windows Classic.theme"
  	Call ThemeChange
  ${EndIf}

  End:
 SectionEnd

SectionGroupEnd

   !ifndef MINIXPY
     SectionGroup "UnUsability" SecUnUsability
     #!ifndef VISPA
      Section "$(SecUnUsabBalloonTips)" UsabUnBalloonTips
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnBalloonTips} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableBalloonTips" "Usability" "BalloonTips"
       End:
      SectionEnd
      #!endif ;VISPA

      Section "$(SecUnUsabDiskSpace)" UsabUnDiskSpace
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnDiskSpace} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoLowDiskSpaceChecks" "Usability" "LowDiskspace"
       End:
      SectionEnd

#!ifndef VISPA
      Section "$(SecUnUsabCmdHere)" UsabUnCmdHere
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnCmdHere} $0
       StrCmp $0 "${READONLY}" End
       DeleteRegKey HKCR "Directory\shell\cmd"
       DetailPrint '"HKCR\Directory\shell\cmd" $(DPDelete)'
       DeleteRegKey HKCR "Drive\shell\cmd"
       DetailPrint '"HKCR\Drive\shell\cmd" $(DPDelete)'
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "CmdHere"
       End:
      SectionEnd

      Section "$(SecUnUsabCmdCompl)" UsabUnCmdCompl
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnCmdCompl} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Command Processor" "CompletionChar" "Usability" "CmdCompl"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Command Processor" "PathCompletionChar" "Usability" "PathCompl"
       End:
      SectionEnd
#!endif ;VISPA
      
      Section "$(SecUnUsabEditNotepad)" UsabUnEditNotepad
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnEditNotepad} $0
       StrCmp $0 "${READONLY}" End
       DeleteRegKey HKCR "*\shell\edit"
       DetailPrint '"HKCR\*\shell\edit" $(DPDelete)'
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "EditNotepad"
       End:
      SectionEnd

      Section "$(SecUnUsabAutoRun)" UsabUnAutoRun
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnAutoRun} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" "Usability" "AutoRun"
       End:
      SectionEnd

#!ifndef VISPA
      Section "$(SecUnUsabSearchAsst)" UsabUnSearchAsst
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnSearchAsst} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "Use Search Asst" "Usability" "SearchAsst"
       End:
      SectionEnd
#!endif ;VISPA

      Section "$(SecUnUsabCleanupWiz)" UsabUnCleanupWiz
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnCleanupWiz} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz" "NoRun" "Usability" "CleanupWiz"
       End:
      SectionEnd
      
      Section "$(SecUnUsabTaskGroup)" UsabUnTaskGroup
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnTaskGroup} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomming" "Usability" "TaskGroup"
       End:
      SectionEnd

      Section "$(SecUnUsabClassicStartMenu)" UsabUnClassicStartMenu
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnClassicStartMenu} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoSimpleStartMenu" "Usability" "ClassicStartMenu"
       xpyhelper::SwitchTaskbarXPStyle 1
       End:
      SectionEnd
      
      Section "$(SecUnUsabClassicLogon)" UsabUnClassicLogon
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnClassicLogon} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "ClassicLogon" "Usability" "ClassicLogon"
       End:
      SectionEnd
	  
	  Section "$(SecUnUsabShutdownReason)" UsabUnShutdownReason
       SectionIn ${TypeUnWin2003}
	   SectionGetFlags ${UsabUnShutdownReason} $0
       StrCmp $0 "${READONLY}" End
	   ${UnRegDWORD} "HKLM" "SOFTWARE\Policies\Microsoft\Windows NT\Reliability" "ShutdownReasonOn" "Usability" "ShutdownReasonOn"
	   ${UnRegDWORD} "HKLM" "SOFTWARE\Policies\Microsoft\Windows NT\Reliability" "ShutdownReasonUI" "Usability" "ShutdownReasonUI"
       End:
      SectionEnd

      #!ifndef VISPA
      Section "$(SecUnUsabBarricade)" UsabUnBarricade
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnBarricade} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:SystemDriveRootFolder" "Usability" "BarricadeRootFolder"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:ControlPanelFolder" "Usability" "BarricadeControlPanel"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:ProgramFiles" "Usability" "BarricadeProgramFiles"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\WebView\BarricadedFolders" "shell:Windows" "Usability" "BarricadeWindows"
       End:
      SectionEnd
      #!endif ;VISPA
      
      Section "$(SecUnUsabHiddenFiles)" UsabUnHiddenFiles
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnHiddenFiles} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" "Usability" "HiddenFiles"
       End:
      SectionEnd

      Section "$(SecUnUsabShowFileExt)" UsabUnShowFileExt
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnShowFileExt} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" "Usability" "ShowFileExt"
       End:
      SectionEnd

      Section "$(SecUnUsabShowLNKExt)" UsabUnShowLNKExt
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnShowLNKExt} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCR" "lnkfile" "AlwaysShowExt" "Usability" "ShowLNKExt"
	   ${If} $Output == ""
		   WriteRegStr  "HKCR" "lnkfile" "NeverShowExt" ""
		   DetailPrint '"HKCR\lnkfile\NeverShowExt" $(DPCreate)'
		   StrCpy $IconRefresh "1"
	   ${EndIf}
       End:
      SectionEnd

      Section "$(SecUnUsabShowPIFExt)" UsabUnShowPIFExt
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnShowPIFExt} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCR" "piffile" "AlwaysShowExt" "Usability" "ShowPIFExt"
	   ${If} $Output == ""
		   WriteRegStr  "HKCR" "piffile" "NeverShowExt" ""
		   DetailPrint '"HKCR\piffile\NeverShowExt" $(DPCreate)'
		   StrCpy $IconRefresh "1"
	   ${EndIf}
       End:
      SectionEnd

      Section "$(SecUnUsabShowSCFExt)" UsabUnShowSCFExt
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnShowSCFExt} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCR" "SHCmdFile" "AlwaysShowExt" "Usability" "ShowSCFExt"
	   ${If} $Output == ""
		   WriteRegStr  "HKCR" "SHCmdFile" "NeverShowExt" ""
		   DetailPrint '"HKCR\SHCmdFile\NeverShowExt" $(DPCreate)'
		   StrCpy $IconRefresh "1"
	   ${EndIf}
       End:
      SectionEnd

      Section "$(SecUnUsabShowURLExt)" UsabUnShowURLExt
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnShowURLExt} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCR" "InternetShortcut" "AlwaysShowExt" "Usability" "ShowURLExt"
	   ${If} $Output == ""
		   WriteRegStr  "HKCR" "InternetShortcut" "NeverShowExt" ""
		   DetailPrint '"HKCR\InternetShortcut\NeverShowExt" $(DPCreate)'
		   StrCpy $IconRefresh "1"
	   ${EndIf}
       End:
      SectionEnd
      
      Section "$(SecUnUsabFullPath)" UsabUnFullPath
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnFullPath} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" "Usability" "FullPath"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPathAddress" "Usability" "FullPathAddress"
       End:
      SectionEnd
      
      Section "$(SecUnUsabDisableThumbnails)" UsabUnDisableThumbnails
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnDisableThumbnails} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisableThumbnailCache" "Usability" "DisableThumbnails"
       End:
      SectionEnd
      
      Section "$(SecUnUsabDisableSounds)" UsabUnDisableSounds
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${UsabUnDisableSounds} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegExpStr} "HKCU" "AppEvents\Schemes\Apps\.Default\SystemStart\.current" "" "Usability" "DisableSounds"
       ${UnRegExpStr} "HKCU" "AppEvents\Schemes\Apps\.Default\SystemExit\.current" "" "Usability" "DisableSounds"
       End:
      SectionEnd

      Section "$(SecUnUsabWinTheme)" UsabUnWinTheme
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${UsabUnWinTheme} $0
       StrCmp $0 "${READONLY}" End

       ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "Usability" "WinTheme"
       ${WordFind} "$0" "\" "+1" $R0
       
       ${If} $R0 == "%USERPROFILE%"
             Push $0
       	     Push "%USERPROFILE%"
       	     Push "$PROFILE"
       ${ElseIf} $R0 == "%SystemRoot%"
       ${OrIf} $R0 == "%WinDir%"
             Push $0
       	     Push "%SystemRoot%"
       	     Push "$WINDIR"
       ${ElseIf} $R0 == "%ResourceDir%"
             Push $0
       	     Push "%ResourceDir%"
       	     Push "$WINDIR\resources"
       ${EndIf}

       Call StrReplace
       Pop $1
       
       Push "$1"
       Call ThemeChange
       WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Usability" "WinTheme" ""
       
       End:
      SectionEnd
      
     SectionGroupEnd
   !endif ;MINIXPY