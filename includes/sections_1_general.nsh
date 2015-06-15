SectionGroup "$(SubGeneral)" SecGeneral

 Section "$(SecGenCompressedFolders)" GenCompressedFolders
  SectionIn ${TypeClassic}

  SectionGetFlags ${GenCompressedFolders} $0
  StrCmp $0 "${READONLY}" End
  
  !ifndef UITEST
	  ${If} $Output == 1
			WriteINIStr "$SaveFile" "General" "CompressedFolders" "1"
	  ${ElseIf} $Output == 2
			DetailPrint "'$(SecGenCompressedFolders)' $(DPSkip)"
	  ${Else}
		nsExec::Exec 'regsvr32.exe /u /s "$SYSDIR\zipfldr.dll"'
		WriteINIStr "$APPDATA\${LOWERCASE}.ini" "General" "CompressedFolders" "~DeleteKey"
		DetailPrint "ZIPFLDR.DLL $(DPUnloadDLL)"
	  ${EndIf}
  !endif
  End:
 SectionEnd

 Section "$(SecGenRegWizC)" GenRegWizC
  SectionIn ${TypeNo3rdParty}
  
  SectionGetFlags ${GenRegWizC} $0
  StrCmp $0 "${READONLY}" End
  
  !ifndef UITEST
	  ${If} $Output == 1
		WriteINIStr "$SaveFile" "General" "RegWizC" "1"
	  ${ElseIf} $Output == 2
			DetailPrint "'$(SecGenRegWizC)' $(DPSkip)"
	  ${Else}
		nsExec::Exec 'regsvr32.exe /u /s "$SYSDIR\regwizc.dll"'
		DetailPrint "REGWIZC.DLL $(DPUnloadDLL)"
		nsExec::Exec 'regsvr32.exe /u /s "$SYSDIR\licdll.dll"'
		WriteINIStr "$APPDATA\${LOWERCASE}.ini" "General" "RegWizC" "~DeleteKey"
		DetailPrint "LICDLL.DLL $(DPUnloadDLL)"
	  ${EndIf}
  !endif
  
  End:
 SectionEnd

 Section "$(SecGenErrorRep)" GenErrorRep
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\PCHealth\ErrorReporting" "DoReport" "0" ${GenErrorRep} "General" "ErrorRep" #no hkcu
  End:
 SectionEnd

 Section "$(SecGenLMHash)" GenLMHash
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "nolmhash" "1" ${GenLMHash} "General" "LMHash"
  End:
 SectionEnd
 
 Section "$(SecGenWGA)" GenWGA
  SectionIn ${TypeNo3rdParty}

  StrCmp $WinVer "Vista" End
  SectionGetFlags ${GenWGA} $0
  StrCmp $0 "${READONLY}" End
  
  ${If} $Output == 1
	  WriteINIStr "$SaveFile" "General" "WGA" "1"
  ${ElseIf} $Output == 2
		DetailPrint "'$(SecGenWGA)' $(DPSkip)"
  ${Else}
	  DeleteRegKey "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\WGALogon"
	  WriteINIStr "$APPDATA\${LOWERCASE}.ini" "General" "WGA" "~DeleteKey"
	  DetailPrint '"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\WGALogon" $(DPDelete)'
	  
	  DeleteRegKey "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\WGANotify"
	  WriteINIStr "$APPDATA\${LOWERCASE}.ini" "General" "WGANotify" "~DeleteKey"
	  DetailPrint '"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\WGANotify" $(DPDelete)'
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecGenScriptHost)" GenScriptHost
  SectionIn ${TypeNo3rdParty}
   ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows Script Host\Settings" "Enabled" "0" ${GenScriptHost} "General" "WSHEnable"
   ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows Script Host\Settings" "Remote" "0" ${GenScriptHost} "General" "WSHRemote"
   End:
 SectionEnd

 Section "$(SecGenRemAssist)" GenRemAssist
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM"  "SYSTEM\CurrentControlSet\Control\Terminal Server" "AllowTSConnections" "0" ${GenRemAssist} "General" "RemAssist1"
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" "1" ${GenRemAssist} "General" "RemAssist2"
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server" "fAllowToGetHelp" "0" ${GenRemAssist} "General" "RemAssist3"
  End:
 SectionEnd
 
 Section "$(SecGenRestrictAnon)" GenRestrictAnon
  SectionIn ${TypeNo3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "restrictanonymous" "1" ${GenRestrictAnon} "General" "RestrictAnon"
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "restrictanonymoussam" "1" ${GenRestrictAnon} "General" "RestrictAnonSAM"
   End:
 SectionEnd
 
  Section "$(SecGenInetOpen)" GenInetOpen
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "InternetOpenWith" "0" ${GenInetOpen} "General" "InetOpen"
  End:
 SectionEnd
 
 Section "$(SecGenNetCrawl)" GenNetCrawl
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "NoNetCrawling" "1" ${GenNetCrawl} "General" "NetCrawl"
  End:
 SectionEnd
 
 Section "$(SecGenHideComputer)" GenHideComputer
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\ControlSet001\Services\lanmanserver\parameters" "hidden" "1" ${GenHideComputer} "General" "HideComputer"
  End:
 SectionEnd

 Section "$(SecGenRepInfect)" GenRepInfect
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\MRT" "DontReportInfectionInformation" "1" ${GenRepInfect} "General" "RepInfect"
  End:
 SectionEnd

 Section "$(SecGenMediaSense)" GenMediaSense
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "DisableDHCPMediaSense" "1" ${GenMediaSense} "General" "MediaSense"
  StrCmp $NoReboot "1" +2
  SetRebootFlag true
  End:
 SectionEnd

 Section "$(SecGenClaimWinReg)" GenClaimWinReg
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Str" "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "RegDone" "1" ${GenClaimWinReg} "General" "RegDone"
  End:
 SectionEnd

 Section "$(SecGenPrefetch)" GenPrefetch
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" "2" ${GenPrefetch} "General" "Prefetch"
  End:
 SectionEnd

 Section "$(SecGenSuperfetch)" GenSuperfetch
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" "2" ${GenSuperfetch} "General" "Superfetch"
  End:
 SectionEnd

 Section "$(SecGenFastShutdn)" GenFastShutdn
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCU" "Control Panel\Desktop" "AutoEndTasks" "1" ${GenFastShutdn} "General" "FastShutdn"
  End:
 SectionEnd

 Section "$(SecGenDelPagefile)" GenDelPagefile
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" "1" ${GenDelPagefile} "General" "DelPagefile"
  End:
 SectionEnd

 Section "$(SecGenDelMRU)" GenDelMRU
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ClearRecentDocsOnExit" "1" ${GenDelMRU} "General" "DelMRU"
  End:
 SectionEnd

 Section "$(SecGenRecentShares)" GenRecentShares
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoRecentDocsNetHood" "1" ${GenRecentShares} "General" "RecentShares"
  End:
 SectionEnd

 Section "$(SecGenLastUser)" GenLastUser
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DontDisplayLastUserName" "1" ${GenLastUser} "General" "LastUser"
  End:
 SectionEnd
 
 Section "$(SecGenPriorityCtrl)" GenPriorityCtrl
  SectionIn ${TypeWin2003}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "26" ${GenPriorityCtrl} "General" "PriorityCtrl"
  End:
 SectionEnd

 Section "$(SecGenSysResponse)" GenSysResponse
  SectionIn ${TypeWin2003}
  StrCmp $WinVer "Vista" 0 End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "20" ${GenSysResponse} "General" "SysResponse"
  End:
 SectionEnd
 
 Section "$(SecGenDisableUAC)" GenDisableUAC
  StrCmp $WinVer "Vista" 0 End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "EnableLUA" "0" ${GenDisableUAC} "General" "DisableUAC"
  End:
 SectionEnd

 Section "$(SecGenRDPPort)" GenRDPPort
  SectionIn ${TypeNo3rdParty}
  !ifdef MINIXPY
	StrCpy $RDP "3389"
  !endif ;MINIXPY
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "PortNumber" "$RDP" ${GenLastUser} "General" "RDPPort"
  End:
 SectionEnd
 
Section "$(SecGenSpyNet)" GenSpyNet
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Microsoft Antimalware\SpyNet" "SpyNetReporting" "0" ${GenLastUser} "General" "LastUser"
  End:
 SectionEnd
 
 Section "$(SecGenSyncPolicy)" GenSyncPolicy
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "8" 0 End
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\SettingSync" "SyncPolicy" "5" ${GenSyncPolicy} "General" "SyncPolicy"
  End:
 SectionEnd
 
 Section "$(SecGenEnablePOS)" GenEnablePOS
  SectionIn ${TypeNo3rdParty}
  ${If} ${IsWinXP}
  ${OrIf} ${IsWin2003}
    ${Registry} "Dword" "HKLM" "SYSTEM\WPA\PosReady" "Installed" "1" ${GenEnablePOS} "General" "EnablePOS"
  ${EndIf}
  End:
 SectionEnd

SectionGroupEnd

   !ifndef MINIXPY
    SectionGroup "UnGeneral" SecUnGeneral

      Section "$(SecUnGenCompressedFolders)" GenUnCompressedFolders
       SectionIn ${TypeUnClassic}
       SectionGetFlags ${GenUnCompressedFolders} $0
       StrCmp $0 "${READONLY}" End
       nsExec::Exec 'regsvr32.exe /s "$SYSDIR\zipfldr.dll"'
       DeleteINIStr  "$APPDATA\${LOWERCASE}.ini" "General" "CompressedFolders"
       DetailPrint "ZIPFLDR.DLL $(DPloadDLL)"
       End:
      SectionEnd

      Section "$(SecUnGenRegWizC)" GenUnRegWizC
	   SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${GenUnRegWizC} $0
       StrCmp $0 "${READONLY}" End
       nsExec::Exec 'regsvr32.exe /s "$SYSDIR\regwizc.dll"'
       DetailPrint "REGWIZC.DLL $(DPloadDLL)"
       nsExec::Exec 'regsvr32.exe /s "$SYSDIR\licdll.dll"'
       DetailPrint "LICDLL.DLL $(DPloadDLL)"
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "General" "RegWizC"
       End:
      SectionEnd
      
      Section "$(SecUnGenErrorRep)" GenUnErrorRep
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnErrorRep} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\PCHealth\ErrorReporting" "DoReport" "General" "ErrorRep"
       End:
      SectionEnd

	  Section "$(SecUnGenLMHash)" GenUnLMHash
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnLMHash} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "nolmhash" "General" "LMHash"
       End:
      SectionEnd

       Section "$(SecUnGenScriptHost)" GenUnScriptHost
        SectionIn ${TypeUnNo3rdParty}
		SectionGetFlags ${GenUnScriptHost} $0
        StrCmp $0 "${READONLY}" End
        ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Windows Script Host\Settings" "Enabled" "General" "WSHEnable"
        ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Windows Script Host\Settings" "Remote" "General" "WSHRemote"
        End:
       SectionEnd

      Section "$(SecUnGenRemAssist)" GenUnRemAssist
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnRemAssist} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server" "AllowTSConnections" "General" "RemAssist1"
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" "General" "RemAssist2"
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server" "fAllowToGetHelp" "General" "RemAssist3"
       End:
      SectionEnd
      
      Section "$(SecUnGenInetOpen)" GenUnInetOpen
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnInetOpen} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "InternetOpenWith" "General" "InetOpen"
       End:
      SectionEnd
      
      Section "$(SecUnGenRestrictAnon)" GenUnRestrictAnon
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnRestrictAnon} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "restrictanonymous" "General" "RestrictAnon"
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Lsa" "restrictanonymoussam" "General" "RestrictAnonSAM"
       End:
      SectionEnd
      
      Section "$(SecUnGenNetCrawl)" GenUnNetCrawl
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnNetCrawl} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "NoNetCrawling" "General" "NetCrawl"
       End:
      SectionEnd
      	  
      Section "$(SecUnGenHideComputer)" GenUnHideComputer
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnHideComputer} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\ControlSet001\Services\lanmanserver\parameters" "hidden" "General" "HideComputer"
       End:
      SectionEnd

      Section "$(SecUnGenRepInfect)" GenUnRepInfect
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnRepInfect} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Policies\Microsoft\MRT" "DontReportInfectionInformation" "General" "RepInfect"
       End:
      SectionEnd

      Section "$(SecUnGenMediaSense)" GenUnMediaSense
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnMediaSense} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "DisableDHCPMediaSense" "General" "MediaSense"
       StrCmp $NoReboot "1" +2
       SetRebootFlag true
       End:
      SectionEnd

      Section "$(SecUnGenClaimWinReg)" GenUnClaimWinReg
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnClaimWinReg} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "RegDone" "General" "RegDone"
       End:
      SectionEnd
      
      Section "$(SecUnGenPrefetch)" GenUnPrefetch
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnPrefetch} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" "General" "Prefetch"
       End:
      SectionEnd
      
      Section "$(SecUnGenSuperfetch)" GenUnSuperfetch
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnSuperfetch} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" "General" "Superfetch"
       End:
      SectionEnd

      Section "$(SecUnGenFastShutdn)" GenUnFastShutdn
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnFastShutdn} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "Control Panel\Desktop" "AutoEndTasks" "General" "FastShutdn"
       End:
      SectionEnd

      Section "$(SecUnGenDelPagefile)" GenUnDelPagefile
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnDelPagefile} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" "General" "DelPagefile"
       End:
      SectionEnd

      Section "$(SecUnGenDelMRU)" GenUnDelMRU
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnDelMRU} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ClearRecentDocsOnExit" "General" "DelMRU"
       End:
      SectionEnd
      
      Section "$(SecUnGenRecentShares)" GenUnRecentShares
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnRecentShares} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoRecentDocsNetHood" "General" "RecentShares"
       End:
      SectionEnd

      Section "$(SecUnGenLastUser)" GenUnLastUser
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnLastUser} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DontDisplayLastUserName" "General" "LastUser"
       End:
      SectionEnd
	  
	  Section "$(SecUnGenPriorityCtrl)" GenUnPriorityCtrl
       SectionIn ${TypeUnWin2003}
	   SectionGetFlags ${GenUnPriorityCtrl} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "General" "PriorityCtrl"
       End:
      SectionEnd

	  Section "$(SecUnGenSysResponse)" GenUnSysResponse
       SectionIn ${TypeUnWin2003}
	   SectionGetFlags ${GenUnSysResponse} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "General" "SysResponse"
       End:
      SectionEnd
	  
	  Section "$(SecUnGenDisableUAC)" GenUnDisableUAC
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnDisableUAC} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "EnableLUA" "General" "DisableUAC"
       End:
      SectionEnd

	  Section "$(SecUnGenRDPPort)" GenUnRDPPort
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnRDPPort} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" "PortNumber" "General" "RDPPort"
       End:
      SectionEnd

	  Section "$(SecUnGenSpyNet)" GenUnSpyNet
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnSpyNet} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Microsoft Antimalware\SpyNet" "SpyNetReporting" "General" "SpyNet"
       End:
      SectionEnd

    Section "$(SecUnGenSyncPolicy)" GenUnSyncPolicy
       SectionIn ${TypeUnNo3rdParty}
     SectionGetFlags ${GenUnSyncPolicy} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\SettingSync" "SyncPolicy" "General" "SyncPolicy"
       End:
      SectionEnd

	  Section "$(SecUnGenEnablePOS)" GenUnEnablePOS
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${GenUnEnablePOS} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\WPA\PosReady" "EnablePOS" "General" "EnablePOS"
       End:
      SectionEnd

    SectionGroupEnd
  !endif ;MINIXPY