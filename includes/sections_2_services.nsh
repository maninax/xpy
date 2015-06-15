SectionGroup "$(SubServices)" SecServices

 Section "$(SecServErrorRep)" ServErrorRep
  SectionIn ${TypeNo3rdParty}
  ${If} ${AtLeastWinVista}
	${Registry} "Dword" "HKLM" "System\CurrentControlSet\Services\WerSvc" "Start" "4" ${ServErrorRep} "Services" "ErrorRep"
	${If} $Output == ""
		nsExec::Exec 'net.exe STOP "WerSvc"'
	${EndIf}
  ${Else} ;Win2000XP2003
	${Registry} "Dword" "HKLM" "System\CurrentControlSet\Services\ERSvc" "Start" "4" ${ServErrorRep} "Services" "ErrorRep"
    ${If} $Output == ""
		nsExec::Exec 'net.exe STOP "ERSvc"'
	${EndIf}
  ${EndIf}
  DetailPrint "$(DPServStop)"
  End:
 SectionEnd

 Section "$(SecServAutoWinUpd)" ServAutoWinUpd
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\wuauserv" "Start" "4" ${ServAutoWinUpd} "Services" "AutoWinUpd"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "wuauserv"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServSecCenter)" ServSecCenter
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\wscsvc" "Start" "4" ${ServSecCenter} "Services" "SecCenter"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "wscsvc"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServWinDefend)" ServWinDefend
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\WinDefend" "Start" "4" ${ServWinDefend} "Services" "WinDefend"
  ${If} $Output == ""
	  DeleteRegValue "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Windows Defender"
	  DetailPrint '"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Windows Defender" was deleted'
	  nsExec::Exec 'net.exe STOP "WinDefend"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServTimeSync)" ServTimeSync
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\W32Time" "Start" "4" ${ServTimeSync} "Services" "TimeSync"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "W32Time"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServSchedTask)" ServSchedTask
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Schedule" "Start" "4" ${ServSchedTask} "Services" "SchedTask"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "Schedule"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServIndexing)" ServIndexing
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\CiSvc" "Start" "4" ${ServIndexing} "Services" "Indexing"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "CiSvc"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServSuperfetch)" ServSuperfetch
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SysMain" "Start" "4" ${ServIndexing} "Services" "Superfetch"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "SysMain"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServDefrag)" ServDefrag
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\defragsvc" "Start" "4" ${ServDefrag} "Services" "Defrag"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "defragsvc"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServDCOM)" ServDCOM
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Microsoft\Ole" "EnableDCOM" "N" ${ServDCOM} "Services" "DCOM"
  ${If} $Output == ""
	  StrCmp $NoReboot "1" +2
	  SetRebootFlag true
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServTelnet)" ServTelnet
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\TlntSvr" "Start" "4" ${ServTelnet} "Services" "Telnet"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "TlntSvr"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServUPnP)" ServUPnP
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\upnphost" "Start" "4" ${ServUPnP} "Services" "UPnP"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "upnphost"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServUPnPDiscovery)" ServUPnPDiscovery
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SSDPSRV" "Start" "4" ${ServUPnPDiscovery} "Services" "UPnPDiscovery"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "SSDPSRV"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServMessenger)" ServMessenger
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Messenger" "Start" "4" ${ServMessenger} "Services" "Messenger"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "Messenger"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServNetMeetingDesktop)" ServNetMeetingDesktop
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\mnmsrvc" "Start" "4" ${ServNetMeetingDesktop} "Services" "NetMeetingDesktop"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "mnmsrvc"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServRPCLoc)" ServRPCLoc
  SectionIn 2
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\RpcLocator" "Start" "4" ${ServRPCLoc} "Services" "RPCLoc"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "RpcLocator"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecServRemReg)" ServRemReg
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\RemoteRegistry" "Start" "4" ${ServRemReg} "Services" "RemReg"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "RemoteRegistry"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServBranchCache)" ServBranchCache
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" 0 End
  
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\PeerDistSvc" "Start" "4" ${ServBranchCache} "Services" "BranchCache"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe STOP "PeerDistSvc"'
	  DetailPrint "$(DPServStop)"
  ${EndIf}
  End:
 SectionEnd
 

 Section "$SecServFirewall" ServFirewall #ServIcfIcs/ServFirewall
  SectionIn ${TypeNo3rdParty}
  ${If} ${AtLeastWinVista}
	   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\MpsSvc" "Start" "4" ${ServFirewall} "Services" "Firewall"
	   ${If} $Output == ""
			nsExec::Exec 'net.exe STOP "MpsSvc"'
	   ${EndIf}
	   DetailPrint "$(DPServStop)"
  ${Else}
		${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SharedAccess" "Start" "4" ${ServFirewall} "Services" "IcfIcs"
		${If} $Output == ""
			nsExec::Exec "netsh.exe firewall set opmode disable"
			DetailPrint "$(DPFirewStop)"
			nsExec::Exec 'net.exe STOP "SharedAccess"'
		${EndIf}
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServImapi)" ServImapi
  SectionIn ${TypeWin2003}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\ImapiService" "Start" "3" ${ServImapi} "Services" "Imapi"
  ${If} $Output == ""
	nsExec::Exec 'net.exe START "Imapi"'
  DetailPrint "$(DPServStart)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServSensrSvc)" ServSensrSvc
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" 0 End
  
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SensrSvc" "Start" "3" ${ServSensrSvc} "Services" "SensrSvc"
  ${If} $Output == ""
	nsExec::Exec 'net.exe START "SensrSvc"'
  DetailPrint "$(DPServStart)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServAudioSrv)" ServAudioSrv
  SectionIn ${TypeWin2003}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\AudioSrv" "Start" "2" ${ServAudioSrv} "Services" "AudioSrv"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe START "AudioSrv"'
	  DetailPrint "$(DPServStart)"
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecServWIA)" ServWIA
  SectionIn ${TypeWin2003}
  ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\stisvc" "Start" "2" ${ServWIA} "Services" "WIA"
  ${If} $Output == ""
	  nsExec::Exec 'net.exe START "stisvc"'
	  DetailPrint "$(DPServStart)"
  ${EndIf}
  End:
 SectionEnd
 
  Section "$(SecTPAppleMobile)" TPAppleMobile
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Apple Mobile Device" "Start" "4" ${TPAppleMobile} "ThirdParty" "AppleMobile"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "Apple Mobile Device"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd

 Section "$(SecTPIpodService)" TPIpodService
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\iPod Service" "Start" "4" ${TPIpodService} "ThirdParty" "iPodService"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "iPod Service"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd

 Section "$(SecTPBonjourService)" TPBonjourService
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\Bonjour Service" "Start" "4" ${TPBonjourService} "ThirdParty" "BonjourService"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "Bonjour Service"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd
 
 Section "$(SecTPFlashUpdate)" TPFlashUpdate
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\AdobeFlashPlayerUpdateSvc" "Start" "4" ${TPFlashUpdate} "ThirdParty" "FlashUpdate"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "AdobeFlashPlayerUpdateSvc"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd

 Section "$(SecTPGoogleUpdater)" TPGoogleUpdater
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\gusvc" "Start" "4" ${TPGoogleUpdater} "ThirdParty" "GoogleUpdater"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "gusvc"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd

 Section "$(SecTPGoogleSAC)" TPGoogleSAC
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SOFTWARE\Policies\Google\Google Desktop\Enterprise" "disallow_ssd_service" "1" ${TPGoogleSAC} "ThirdParty" "GoogleSAC"
   End:
 SectionEnd
 
 Section "$(SecTPSkypeUpdate)" TPSkypeUpdate
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\SkypeUpdate" "Start" "4" ${TPSkypeUpdate} "ThirdParty" "SkypeUpdate"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "SkypeUpdate"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd
 
 Section "$(SecTPNvidiaUpdate)" TPNvidiaUpdate
   SectionIn ${Type3rdParty}
   ${Registry} "Dword" "HKLM" "SYSTEM\CurrentControlSet\Services\nvUpdatusService" "Start" "4" ${TPNvidiaUpdate} "ThirdParty" "NvidiaUpdate"
   ${If} $Output == ""
	   nsExec::Exec 'net.exe STOP "nvUpdatusService"'
	   DetailPrint "$(DPServStop)"
   ${EndIf}
   End:
 SectionEnd

SectionGroupEnd


  !ifndef MINIXPY
    SectionGroup "UnServices" SecUnServices

      Section "$(SecUnServErrorRep)" ServUnErrorRep
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnErrorRep} $0
       StrCmp $0 "${READONLY}" End
       ${If} ${AtLeastWinVista}
		${UnRegDWORD} "HKLM" "System\CurrentControlSet\Services\WerSvc" "Start" "Services" "ErrorRep"
         nsExec::Exec 'net.exe START "WerSvc"'
	   ${Else}
         ${UnRegDWORD} "HKLM" "System\CurrentControlSet\Services\ERSvc" "Start" "Services" "ErrorRep"
         nsExec::Exec 'net.exe START "ERSvc"'
       ${EndIf}
	   DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServAutoWinUpd)" ServUnAutoWinUpd
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnAutoWinUpd} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\wuauserv" "Start" "Services" "AutoWinUpd"
       nsExec::Exec 'net.exe START "wuauserv"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
      
      Section "$(SecServSecCenter)" ServUnSecCenter
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnSecCenter} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\wscsvc" "Start" "Services" "SecCenter"
       nsExec::Exec 'net.exe STOP "wscsvc"'
       DetailPrint "$(DPServStop)"
       End:
      SectionEnd
      
      Section "$(SecUnServWinDefend)" ServUnWinDefend
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnWinDefend} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\WinDefend" "Start" "Services" "WinDefend"
       nsExec::Exec 'net.exe START "WinDefend"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServTimeSync)" ServUnTimeSync
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnTimeSync} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\W32Time" "Start" "Services" "TimeSync"
       nsExec::Exec 'net.exe START "W32Time"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServSchedTask)" ServUnSchedTask
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnSchedTask} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\Current\ControlSet\Services\Schedule" "Start" "Services" "SchedTask"
       nsExec::Exec 'net.exe START "Schedule"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServIndexing)" ServUnIndexing
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnIndexing} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\CiSvc" "Start" "Services" "Indexing"
       nsExec::Exec 'net.exe START "CiSvc"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServSuperfetch)" ServUnSuperfetch
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnSuperfetch} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\SysMain" "Start" "Services" "Superfetch"
       nsExec::Exec 'net.exe START "SysMain"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServDefrag)" ServUnDefrag
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnDefrag} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\defragsvc" "Start" "Services" "Defrag"
       nsExec::Exec 'net.exe START "defragsvc"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServDCOM)" ServUnDCOM
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnDCOM} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Ole" "EnableDCOM" "Services" "DCOM"
       StrCmp $NoReboot "1" +2
       SetRebootFlag true
       End:
      SectionEnd

      Section "$(SecUnServTelnet)" ServUnTelnet
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnTelnet} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\TlntSvr" "Start" "Services" "Telnet"
       nsExec::Exec 'net.exe START "TlntSvr"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServUPnP)" ServUnUPnP
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnUPnP} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\upnphost" "Start" "Services" "UPnP"
       nsExec::Exec 'net.exe START "upnphost"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
      
      Section "$(SecUnServUPnPDiscovery)" ServUnUPnPDiscovery
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnUPnPDiscovery} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\SSDPSRV" "Start" "Services" "UPnPDiscovery"
       nsExec::Exec 'net.exe START "SSDPSRV"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServMessenger)" ServUnMessenger
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnMessenger} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\Messenger" "Start" "Services" "Messenger"
       nsExec::Exec 'net.exe START "Messenger"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
      
      Section "$(SecUnServNetMeetingDesktop)" ServUnNetMeetingDesktop
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnNetMeetingDesktop} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\mnmsrvc" "Start" "Services" "NetMeetingDesktop"
       nsExec::Exec 'net.exe START "mnmsrvc"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServRPCLoc)" ServUnRPCLoc
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnRPCLoc} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\RpcLocator" "Start" "Services" "RPCLoc"
       nsExec::Exec 'net.exe START "RpcLocator"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnServRemReg)" ServUnRemReg
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnRemReg} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\RemoteRegistry" "Start" "Services" "RemReg"
       nsExec::Exec 'net.exe START "RemoteRegistry"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
	  
	  Section "$(SecUnServBranchCache)" ServUnBranchCache
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${ServUnBranchCache} $0
       StrCmp $0 "${READONLY}" End
	   
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\PeerDistSvc" "Start" "Services" "BranchCache"
       nsExec::Exec 'net.exe START "PeerDistSvc"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$SecUnServFirewall" ServUnFirewall #ServUnIcfIcs/ServUnFirewall
        SectionIn ${TypeUnNo3rdParty}
        SectionGetFlags ${ServUnFirewall} $0
        StrCmp $0 "${READONLY}" End

        ${If} ${AtLeastWinVista}
          ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\MpsSvc" "Start" "Services" "Firewall"
          nsExec::Exec 'net.exe START "MpsSvc"'
          DetailPrint "$(DPServStart)"
        ${Else}
		  ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\SharedAccess" "Start" "Services" "IcfIcs"
          nsExec::Exec "netsh.exe firewall set opmode enable"
          nsExec::Exec 'net.exe START "SharedAccess"'
          DetailPrint "$(DPFirewStart)"      
        ${EndIf}
        End:
       SectionEnd
	   
	 Section "$(SecUnServImapi)" ServUnImapi
       SectionIn ${TypeUnWin2003}
       SectionGetFlags ${ServUnImapi} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\ImapiService" "Start" "Services" "Imapi"
       nsExec::Exec 'net.exe STOP "Imapi"'
       DetailPrint "$(DPServStop)"
       End:
     SectionEnd
	 
	 Section "$(SecUnServSensrSvc)" ServUnSensrSvc
       SectionIn ${TypeUnWin2003}
       SectionGetFlags ${ServUnSensrSvc} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\SensrSvc" "Start" "Services" "SensrSvc"
       nsExec::Exec 'net.exe STOP "SensrSvc"'
       DetailPrint "$(DPServStop)"
       End:
     SectionEnd
	 
	 Section "$(SecUnAudioSrv)" ServUnAudioSrv
       SectionIn ${TypeUnWin2003}
       SectionGetFlags ${ServUnAudioSrv} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\AudioSrv" "Start" "Services" "AudioSrv"
       nsExec::Exec 'net.exe STOP "AudioSrv"'
       DetailPrint "$(DPServStop)"
       End:
     SectionEnd
	  
	 Section "$(SecUnServWIA)" ServUnWIA
       SectionIn ${TypeUnWin2003}
       SectionGetFlags ${ServUnWIA} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\stisvc" "Start" "Services" "WIA"
       nsExec::Exec 'net.exe START "stisvc"'
       DetailPrint "$(DPServStart)"
       End:
     SectionEnd
	       
     Section "$(SecUnTPAppleMobile)" TPUnAppleMobile
	   SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnAppleMobile} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\Apple Mobile Device" "Start" "ThirdParty" "AppleMobile"
       nsExec::Exec 'net.exe START "Apple Mobile Device"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnTPIpodService)" TPUnIpodService
       SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnIpodService} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\iPod Service" "Start" "ThirdParty" "iPodService"
       nsExec::Exec 'net.exe START "iPod Service"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
	  
	  Section "$(SecUnTPBonjourService)" TPUnBonjourService
       SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnBonjourService} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\Bonjour Service" "Start" "ThirdParty" "BonjourService"
       nsExec::Exec 'net.exe START "Bonjour Service"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
	  
	  Section "$(SecUnTPFlashUpdate)" TPUnFlashUpdate
       SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnFlashUpdate} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\AdobeFlashPlayerUpdateSvc" "Start" "ThirdParty" "FlashUpdate"
       nsExec::Exec 'net.exe START "AdobeFlashPlayerUpdateSvc"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnTPGoogleUpdater)" TPUnGoogleUpdater
       SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnGoogleUpdater} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\gusvc" "Start" "ThirdParty" "GoogleUpdater"
       nsExec::Exec 'net.exe START "gusvc"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

      Section "$(SecUnTPGoogleSAC)" TPUnGoogleSAC
       SectionIn ${TypeUnNo3rdParty}
       SectionGetFlags ${TPUnGoogleSAC} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Policies\Google\Google Desktop\Enterprise" "disallow_ssd_service" "ThirdParty" "GoogleSAC"
       End:
      SectionEnd
	  
	  Section "$(SecUnTPSkypeUpdate)" TPUnSkypeUpdate
       SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnSkypeUpdate} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\SkypeUpdate" "Start" "ThirdParty" "SkypeUpdate"
       nsExec::Exec 'net.exe START "SkypeUpdate"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd
	  
	  Section "$(SecUnTPNvidiaUpdate)"TPUnNvidiaUpdate
       SectionIn ${TypeUn3rdParty}
       SectionGetFlags ${TPUnNvidiaUpdate} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SYSTEM\CurrentControlSet\Services\nvUpdatusService" "Start" "ThirdParty" "NvidiaUpdate"
       nsExec::Exec 'net.exe START "nvUpdatusService"'
       DetailPrint "$(DPServStart)"
       End:
      SectionEnd

    SectionGroupEnd
  !endif ;MINIXPY