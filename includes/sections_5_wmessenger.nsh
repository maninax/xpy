SectionGroup "Windows Messenger" SecWinMessenger

 Section "$(SecWMRemOE)" WMRemOE
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Outlook Express" "Hide Messenger" "2" ${WMRemOE} "WindowsMessenger" "WMRemOE"
  End:
 SectionEnd

 Section "$(SecWMUninstall)" WMUninstall
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  
  SectionGetFlags ${WMUninstall} $0
  StrCmp $0 "${READONLY}" End
  ${If} $Output == 1
        WriteINIStr "$SaveFile" "WindowsMessenger" "Uninstall" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecWMUninstall)' $(DPSkip)"
  ${Else}
		IfFileExists "$WINDIR\INF\msmsgs.inf" 0 +3
		nsExec::Exec "RunDLL32.exe advpack.dll,LaunchINFSection $WINDIR\INF\msmsgs.inf,BLC.Remove"
		DetailPrint "Windows Messenger $(DPUninstall)"
  ${EndIf}
  End:
 SectionEnd

SectionGroupEnd

   !ifndef MINIXPY
    SectionGroup "UnWindowsMessenger" SecUnWinMessenger
    
      Section "$(SecUnWMRemOE)" WMUnRemOE
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMUnRemOE} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Outlook Express" "Hide Messenger" "WindowsMessenger" "WMRemOE"
       End:
      SectionEnd
      
    SectionGroupEnd
   !endif ;MINIXPY