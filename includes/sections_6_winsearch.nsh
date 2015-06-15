SectionGroup "$(TermWDS)" SecWinSearch

 Section "$(SecWDSDisable)" WDSDisable
  SectionIn ${TypeNo3rdParty}
  StrCmp $0 "${SF_SELECTED}" End
  ${Registry} "Dword" HKLM "SYSTEM\CurrentControlSet\Services\WSearch" "Start" "4" ${WDSDisable} "WindowsSearch" "Disable"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "WSearch"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecWDSRemove)" WDSRemove
  SectionIn ${TypeNo3rdParty}
  SectionGetFlags ${WDSRemove} $0
  StrCmp $0 "${READONLY}" End
  ${If} $Output == 1
        WriteINIStr "$SaveFile" "WindowsSearch" "Uninstall" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecWDSRemove)' $(DPSkip)"
  ${Else}
        ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KB940157" "UninstallString"
  	nsExec::Exec '$0 /passive /norestart'
  	DetailPrint "$(TermWDS) $(DPUninstall)"
  ${EndIf}
  StrCmp $NoReboot "1" +2
  SetRebootFlag true
  End:
 SectionEnd

SectionGroupEnd

  !ifndef MINIXPY
    SectionGroup "UnWinSearch" SecUnWinSearch
    
      Section "$(SecUnWDSDisable)" WDSUnDisable
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WDSUnDisable} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\WSearch" "Start" "WindowsSearch" "Disable"
       nsExec::Exec 'net.exe START "WSearch"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
    
    SectionGroupEnd
  !endif ;MINIXPY