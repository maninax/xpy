SectionGroup "Internet Explorer" SecIExplore

 Section "$(SecIEAutoUpdates)" IEAutoUpdates
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "NoUpdateCheck" "1" ${IEAutoUpdates} "InternetExplorer" "AutoUpdates"
  End:
 SectionEnd

 Section "$(SecIESchedUpd)" IESchedUpd
  SectionIn ${TypeNo3rdParty}
  #!ifndef VISPA
    StrCmp $WinVer "Vista" End
  #!endif ;VISPA
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Webcheck" "NoScheduledUpdates" "1" ${IESchedUpd} "InternetExplorer" "SchedUpd"
  End:
 SectionEnd

 Section "$(SecIEErrorRep)" IEErrorRep
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "IEWatsonDisabled" "1" ${IEErrorRep} "InternetExplorer" "WatsonDisabled"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "IEWatsonEnabled" "0" ${IEErrorRep} "InternetExplorer" "WatsonEnabled"
  End:
 SectionEnd

 Section "$(SecIEIntWinAuth)" IEIntWinAuth
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "EnableNegotiate" "0" ${IEIntWinAuth} "InternetExplorer" "IntWinAuth"
  End:
 SectionEnd

 Section "$(SecIEMaxConn)" IEMaxConn
  SectionIn ${TypeNo3rdParty}
  !ifdef MINIXPY
	StrCpy $MaxConnections "32"
  !endif ;MINIXPY
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "MaxConnectionsPerServer" "$MaxConnections" ${IEMaxConn} "InternetExplorer" "MaxConnPS"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "MaxConnectionsPer1_0Server" "$MaxConnections" ${IEMaxConn} "InternetExplorer" "MaxConnP0S"
  End:
 SectionEnd
 
 Section "$(SecIETabSettings)" IETabSettings
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\TabbedBrowsing" "PopupsUseNewWindow" "2" ${IETabSettings} "InternetExplorer" "TabSettings"
  End:
 SectionEnd

 Section "$(SecIEuplddrvinfo)" IEuplddrvinfo
  SectionIn ${TypeNo3rdParty}
  #!ifndef VISPA
    StrCmp $WinVer "Vista" End
  #!endif ;VISPA
  ${If} $Output == "1"
	  WriteINIStr "$SaveFile" "InternetExplorer" "uplddrvinfo" "1"
  ${ElseIf} $Output == "2"
	  DetailPrint "'$(SecIEuplddrvinfo)' $(DPSkip)"
  ${Else}
	  IfFileExists "$WINDIR\pchealth\helpctr\System\DFS\uplddrvinfo.htm" 0 End
	  Rename "$WINDIR\pchealth\helpctr\System\DFS\uplddrvinfo.htm" "$WINDIR\pchealth\helpctr\System\DFS\uplddrvinfo.htm.bak"
	  DetailPrint "UPLDDRVINFO.HTM $(DPRename)"
  ${EndIf}
  End:
 SectionEnd

 Section "$(SecIEDelTempFiles)" IEDelTempFiles
  SectionIn ${TypeNo3rdParty}
   ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" "Persistent" "0" ${IEDelTempFiles} "InternetExplorer" "DelTempFiles"
   End:
 SectionEnd
 
 Section "$(SecIEWebformComplete)" IEWebformComplete
  SectionIn ${TypeNo3rdParty}
   ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Use FormSuggest" "no" ${IEWebformComplete} "InternetExplorer" "WebformComplete"
   End:
 SectionEnd
 
 Section "$(SecIEPasswordComplete)" IEPasswordComplete
  SectionIn ${TypeNo3rdParty}
   ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\Main" "FormSuggest Passwords" "no" ${IEPasswordComplete} "InternetExplorer" "PasswordComplete"
   End:
 SectionEnd

 Section "$(SecIEAlexa)" IEAlexa
  SectionIn ${TypeNo3rdParty}
  #!ifndef VISPA
    StrCmp $WinVer "Vista" End
  #!endif ;VISPA
  SectionGetFlags ${IEAlexa} $0
  StrCmp $0 "${READONLY}" End
  ${If} $Output == 1
        WriteINIStr "$SaveFile" "InternetExplorer" "Alexa" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecIEAlexa)' $(DPSkip)"
  ${Else}
        DeleteRegKey "HKLM" "SOFTWARE\Microsoft\Internet Explorer\Extensions\{c95fe080-8f5d-11d2-a20b-00aa003c157a}"
		DetailPrint '"HKLM\SOFTWARE\Microsoft\Internet Explorer\Extensions\{c95fe080-8f5d-11d2-a20b-00aa003c157a}" $(DPDelete)'
		IfFileExists "$WINDIR\Web\RELATED.HTM" 0 End
		IfFileExists "$WINDIR\Web\RELATED.HTM.old" +2
		CopyFiles "$WINDIR\Web\RELATED.HTM" "$WINDIR\Web\RELATED.HTM.old"
		${TextReplace::ReplaceInFile} "$WINDIR\Web\RELATED.HTM" "$WINDIR\Web\RELATED.HTM" "http://related.msn.com/related.asp?url=" "http://www.google.com/ie?as_rq=" "/C=1 /AO=1" $0
		${TextReplace::ReplaceInFile} "$WINDIR\Web\RELATED.HTM" "$WINDIR\Web\RELATED.HTM" "escape(userURL)" "encodeURIComponent(userURL)" "/C=1 /AO=1" $0
		DetailPrint '"$WINDIR\Web\related.htm" $(DPPatch)'
		${TextReplace::Unload}
  ${EndIf}
  
  End:
 SectionEnd
 
 Section "$(SecIESearchPage)" IESearchPage
  SectionIn ${TypeNo3rdParty}
     ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Search Page" "$SearchPage" ${IESearchPage} "InternetExplorer" "SearchPage"
     ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Search Bar" "$SearchBar" ${IESearchPage} "InternetExplorer" "SearchBar"
   End:
 SectionEnd
 
 Section "$(SecIESearchScope)" IESearchScope
  SectionIn ${TypeNo3rdParty}
   Call CreateGUID
   Pop $GUID
   ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes\$GUID" "" "$SearchName" ${IESearchScope} "InternetExplorer" "SearchScopeDefault"
   ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes\$GUID" "DisplayName" "Search $SearchName" ${IESearchScope} "InternetExplorer" "SearchScopeName"
   ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes\$GUID" "URL" "$SearchQuery" ${IESearchScope} "InternetExplorer" "SearchScopeURL"
   ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes" "DefaultScope" "$GUID" ${IESearchScope} "InternetExplorer" "DefaultScope"
   End:
 SectionEnd
 
 Section "$(SecIEActiveX)" IEActiveX
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1200" "3" ${IEActiveX} "InternetExplorer" "ActiveX1200"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1201" "3" ${IEActiveX} "InternetExplorer" "ActiveX1201"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1001" "3" ${IEActiveX} "InternetExplorer" "ActiveX1001"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\P3P" "1004" "3" ${IEActiveX} "InternetExplorer" "ActiveX1004"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1405" "3" ${IEActiveX} "InternetExplorer" "ActiveX1405"
  End:
 SectionEnd

 Section "$(SecIEJavaScript)" IEJavaScript
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1400" "3" ${IEJavaScript} "InternetExplorer" "JavaScript1400"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1402" "3" ${IEJavaScript} "InternetExplorer" "JavaScript1402"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1407" "3" ${IEJavaScript} "InternetExplorer" "JavaScript1407"
  End:
 SectionEnd
 
 Section "$(SecIESSL2)" IESSL2
  SectionIn ${TypeNo3rdParty}
  SectionGetFlags ${IESSL2} $0
  StrCmp $0 "${READONLY}" End
  ${If} $Output == 1
        WriteINIStr "$SaveFile" "InternetExplorer" "SSL2" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecIESSL2)' $(DPSkip)"
  ${Else}
		ReadRegDWORD $0 "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols"
		StrCmp $0 "" 0 +2
		StrCpy $0 "40"
		StrCmp $0 "8" +4
		StrCmp $0 "40" +3
		StrCmp $0 "136" +2
		StrCmp $0 "168" 0 End
		WriteINIStr "$APPDATA\${LOWERCASE}.ini" "InternetExplorer" "SSL2" "$0"
		IntOp $0 $0 - 8
		WriteRegDWORD "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols" "$0"
		DetailPrint '"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\SecureProtocols}" $(DPModify) (DWORD: $0)'
  ${EndIf}
  End:
 SectionEnd
 
 Section "$(SecIEPhishFilter)" IEPhishFilter
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\PhishingFilter" "Enabled" "0" ${IEPhishFilter} "InternetExplorer" "PhishFilter"
  End:
 SectionEnd

 Section "$(SecIESearchAsst)" IESearchAsst
  SectionIn ${TypeNo3rdParty}
  #!ifndef VISPA
    StrCmp $WinVer "Vista" End
  #!endif ;VISPA
  ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Use Search Asst" "no" ${IESearchAsst} "InternetExplorer" "SearchAsst"
  End:
 SectionEnd
 
 Section "$(SecIE404Search)" IE404Search
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Do404Search" "01000000" ${IE404Search} "InternetExplorer" "404Search"
  End:
 SectionEnd
 
 Section "$(SecIEBlankPage)" IEBlankPage
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Start Page" "about:blank" ${IEBlankPage} "InternetExplorer" "BlankPage"
  End:
 SectionEnd
 
 Section "$(SecIEDefaultPrompt)" IEDefaultPrompt
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Str" "HKCU" "Software\Microsoft\Internet Explorer\Main" "Check_Associations" "no" ${IEDefaultPrompt} "InternetExplorer" "DefaultPrompt"
  End:
 SectionEnd
 
 Section "$(SecIEInfoBar)" IEInfoBar
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\Internet Explorer\InformationBar" "FirstTime" "0" ${IEInfoBar} "InternetExplorer" "InfoBar"
  End:
 SectionEnd
 
  Section "$(SecIERemove)" IERemove
  SectionIn ${TypeNo3rdParty}
  SectionGetFlags ${IERemove} $0
  StrCmp $0 "${READONLY}" End
  ${If} $Output == 1
        WriteINIStr "$SaveFile" "InternetExplorer" "IERemove" "1"
  ${ElseIf} $Output == 2
        DetailPrint "'$(SecIERemove)' $(DPSkip)"
  ${Else}
	!ifdef MINIXPY
	  ReadRegStr $0 "HKLM" "SOFTWARE\Microsoft\Internet Explorer" "Version"
          StrCpy $IeVersion $0 1
        !endif ;MINIXPY
        ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ie$IeVersion" "UninstallString"
  	nsExec::Exec '$0 /passive /norestart'
  	DetailPrint "Internet Explorer $IeVersion $(DPUninstall)"
  ${EndIf}
  StrCmp $NoReboot "1" +2
  SetRebootFlag true
  End:
 SectionEnd

SectionGroupEnd

   !ifndef MINIXPY
     SectionGroup "UnInternetExplorer" SecUnIExplore
     
      Section "$(SecUnIEAutoUpdates)" IEUnAutoUpdates
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnAutoUpdates} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Internet Explorer\Main" "NoUpdateCheck" "InternetExplorer" "AutoUpdates"
       End:
      SectionEnd
	  	  
      Section "$(SecUnIESchedUpd)" IEUnSchedUpd
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnSchedUpd} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Webcheck" "NoScheduledUpdates" "InternetExplorer" "SchedUpd"
       End:
      SectionEnd
	  
      Section "$(SecUnIEErrorRep)" IEUnErrorRep
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnErrorRep} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Internet Explorer\Main" "IEWatsonDisabled" "InternetExplorer" "WatsonDisabled"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Internet Explorer\Main" "IEWatsonEnabled" "InternetExplorer" "WatsonEnabled"
       End:
      SectionEnd

      Section "$(SecUnIEIntWinAuth)" IEUnIntWinAuth
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnIntWinAuth} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "EnableNegotiate" "InternetExplorer" "IntWinAuth"
       End:
      SectionEnd

      Section "$(SecUnIEMaxConn)" IEUnMaxConn
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnMaxConn} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "MaxConnectionsPerServer" "InternetExplorer" "MaxConnPS"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "MaxConnectionsPer1_0Server" "InternetExplorer" "MaxConnP0S"
       End:
      SectionEnd
      
      Section "$(SecUnIETabSettings)" IEUnTabSettings
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnTabSettings} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Internet Explorer\TabbedBrowsing" "PopupsUseNewWindow" "InternetExplorer" "TabSettings"
       End:
      SectionEnd

      Section "$(SecUnIEDelTempFiles)" IEUnDelTempFiles
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnDelTempFiles} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" "Persistent" "InternetExplorer" "DelTempFiles"
       End:
      SectionEnd
	  
	  Section "$(SecUnIEWebformComplete)" IEUnWebformComplete
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnWebformComplete} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Use FormSuggest" "InternetExplorer" "WebformComplete"
       End:
      SectionEnd
	  
      Section "$(SecUnIEPasswordComplete)" IEUnPasswordComplete
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnPasswordComplete} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Internet Explorer\Main" "FormSuggest Passwords" "InternetExplorer" "PasswordComplete"
       End:
      SectionEnd
      
      Section "$(SecUnIESearchPage)" IEUnSearchPage
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnSearchPage} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Search Page" "InternetExplorer" "SearchPage"
       ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Search Bar" "InternetExplorer" "SearchBar"
       End:
      SectionEnd
      
       Section "$(SecUnIESearchScope)" IEUnSearchScope
        SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnSearchScope} $0
        StrCmp $0 "${READONLY}" End
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes\$GUID" "" "InternetExplorer" "SearchScopeDefault"
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes\$GUID" "DisplayName" "InternetExplorer" "SearchScopeName"
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes\$GUID" "URL" "InternetExplorer" "SearchScopeURL"
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\SearchScopes" "DefaultScope" "InternetExplorer" "DefaultScope"
       End:
      SectionEnd

      Section "$(SecUnIEActiveX)" IEUnActiveX
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnActiveX} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1200" "InternetExplorer" "ActiveX1200"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1201" "InternetExplorer" "ActiveX1201"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1001" "InternetExplorer" "ActiveX1001"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\P3P" "1004" "InternetExplorer" "ActiveX1004"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1405" "InternetExplorer" "ActiveX1405"
       End:
      SectionEnd
      
      Section "$(SecUnIEJavaScript)" IEUnJavaScript
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnJavaScript} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1400" "InternetExplorer" "JavaScript1400"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1402" "InternetExplorer" "JavaScript1402"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" "1407" "InternetExplorer" "JavaScript1407"
       End:
      SectionEnd
      
      Section "$(SecUnIESSL2)" IEUnSSL2
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnSSL2} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols" "InternetExplorer" "SSL2"
       End:
      SectionEnd
      
      Section "$(SecUnIEPhishFilter)" IEUnPhishFilter
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnPhishFilter} $0
       StrCmp $0 "${READONLY}" End
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\PhishingFilter" "Enabled" "InternetExplorer" "PhishFilter"
       End:
      SectionEnd

      Section "$(SecUnIESearchAsst)" IEUnSearchAsst
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnSearchAsst} $0
       StrCmp $0 "${READONLY}" End
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Use Search Asst" "InternetExplorer" "SearchAsst"
       End:
      SectionEnd
      
      Section "$(SecUnIE404Search)" IEUn404Search
        SectionIn ${TypeUnNo3rdParty}
	    SectionGetFlags ${IEUn404Search} $0
        StrCmp $0 "${READONLY}" End
        ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Do404Search" "InternetExplorer" "404Search"
       End:
      SectionEnd
      
      Section "$(SecUnIEBlankPage)" IEUnBlankPage
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnBlankPage} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Start Page" "InternetExplorer" "BlankPage"
       End:
      SectionEnd
      
      Section "$(SecUnIEDefaultPrompt)" IEUnDefaultPrompt
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnDefaultPrompt} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "Software\Microsoft\Internet Explorer\Main" "Check_Associations" "InternetExplorer" "DefaultPrompt"
       End:
      SectionEnd

      Section "$(SecUnIEInfoBar)" IEUnInfoBar
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${IEUnInfoBar} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKCU" "oftware\Microsoft\Internet Explorer\InformationBar" "FirstTime" "InternetExplorer" "InfoBar"
       End:
      SectionEnd

     SectionGroupEnd
   !endif ;MINIXPY