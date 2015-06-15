SectionGroup "$(SubDelete)" SecDelete

   Section "$(SecDelIELnk)" DelIELnk
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelIELnk} $0
    StrCmp $0 "${READONLY}" End
    
    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "IELnk" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelIELnk)' $(DPSkip)"
    ${Else}
        Delete "$SMPROGRAMS\Internet Explorer.lnk"
	    ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{871C5380-42A0-1069-A2EA-08002B30309D}"
		${IfNot} $0 == ""
		  WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "IELnk" "$0"
		${Else}
          WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "IELnk" "~DeleteKey"
		${EndIf}
    	WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{871C5380-42A0-1069-A2EA-08002B30309D}" "1"
    	DetailPrint '"HKCU\"Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu\{871C5380-42A0-1069-A2EA-08002B30309D}" $(DPModify) (DWORD: 1)'
        StrCpy $IconRefresh "1"
    	  
    	  ${If} "$IEShortcut" == "$(LabelFxTarget)"
    	        ${If} ${AtLeastWinVista}
					ReadRegStr $0 HKCU "Software\Mozilla\Mozilla Firefox" "CurrentVersion"
					ReadRegStr $0 HKCU "Software\Mozilla\Mozilla Firefox\$0\Main" "PathToExe"
				${Else}
					ReadRegStr $0 HKLM "Software\Mozilla\Mozilla Firefox" "CurrentVersion"
					ReadRegStr $0 HKLM "Software\Mozilla\Mozilla Firefox\$0\Main" "PathToExe"
				${Endif}
    	        SetShellVarContext all
    	        Delete "$DESKTOP\Mozilla Firefox.lnk"
    	        CreateShortCut "$DESKTOP\Internet.lnk" "$0" "" "$PROGRAMFILES\Internet Explorer\iexplore.exe" 0
    	        SetShellVarContext current
				CreateShortCut "$SMPROGRAMS\Internet.lnk" "$0" "" "$PROGRAMFILES\Internet Explorer\iexplore.exe" 0
    	  ${ElseIf} "$IEShortcut" == "$(LabelOpTarget)"
                ReadRegStr $0 HKCU "Software\Opera Software" "Last Install Path"
				SetShellVarContext all
    	        Delete "$DESKTOP\Opera.lnk"
				CreateShortCut "$DESKTOP\Internet.lnk" "$0\opera.exe" "" "$PROGRAMFILES\Internet Explorer\iexplore.exe" 0
				SetShellVarContext current
				CreateShortCut "$SMPROGRAMS\Internet.lnk" "$0\opera.exe" "" "$PROGRAMFILES\Internet Explorer\iexplore.exe" 0
    	  ${ElseIf} "$IEShortcut" == "$(LabelGCTarget)"
				${If} ${AtLeastWinVista}
					ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "InstallLocation"
				${Else}
					ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "InstallLocation"
				${EndIf}
				SetShellVarContext all
    	        Delete "$DESKTOP\Google Chrome.lnk"
				CreateShortCut "$DESKTOP\Internet.lnk" "$0\chrome.exe" "" "$PROGRAMFILES\Internet Explorer\iexplore.exe" 0
    	        SetShellVarContext current
				CreateShortCut "$SMPROGRAMS\Internet.lnk" "$0\chrome.exe" "" "$PROGRAMFILES\Internet Explorer\iexplore.exe" 0
    	  ${EndIf}

    ${EndIf}
    End:
   SectionEnd

   #!ifndef VISPA2
   Section "$SecDelMailClient" DelMailClient #DelWinMail/DelOutExLnk
    SectionIn ${TypeNo3rdParty}
    
	${If} ${AtLeastWinVista}
		${If} $Output == 1
           WriteINIStr "$SaveFile" "Delete" "WinMail" "1"
		${ElseIf} $Output == 2
			DetailPrint "'$SecDelMailClient' $(DPSkip)"
		${Else}
			WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinMail" "1"
			Delete "$SMPROGRAMS\Windows Mail.lnk"
			${If} "$OutlookShortcut" == "$(LabelTbTarget)"
				ReadRegStr $0 HKCU "Software\Mozilla\Mozilla Thunderbird" "CurrentVersion"
				ReadRegStr $0 HKCU "Software\Mozilla\Mozilla Thunderbird\$0\Main" "PathToExe"    	     
				CreateShortCut "$DESKTOP\Mail.lnk" "$0" "" "$PROGRAMFILES\Windows Mail\WinMail.exe" 0    	     
				CreateShortCut "$SMPROGRAMS\Mail.lnk" "$0" "" "$PROGRAMFILES\Windows Mail\WinMail.exe" 0
			${ElseIf} "$OutlookShortcut" == "$(LabelPbTarget)"
				ReadRegStr $0 HKCU "Software\Postbox\Postbox" "CurrentVersion"
				ReadRegStr $0 HKCU "Software\Postbox\Postbox\$0\Main" "PathToExe"    	     
				CreateShortCut "$DESKTOP\Mail.lnk" "$0" "" "$PROGRAMFILES\Windows Mail\WinMail.exe" 0    	     
				CreateShortCut "$SMPROGRAMS\Mail.lnk" "$0" "" "$PROGRAMFILES\Windows Mail\WinMail.exe" 0
			${EndIf}
       ${EndIf}
	${Else}	
		${If} $Output == 1
			WriteINIStr "$SaveFile" "Delete" "OutExLnk" "1"
		${ElseIf} $Output == 2
			DetailPrint "'$SecDelMailClient' $(DPSkip)"
		${Else}
			WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "OutExLnk" "1"
			Delete "$SMPROGRAMS\Outlook Express.lnk"
			
			${If} "$OutlookShortcut" == "$(LabelTbTarget)"
			   ReadRegStr $0 HKLM "Software\Mozilla\Mozilla Thunderbird" "CurrentVersion"
			   ReadRegStr $0 HKLM "Software\Mozilla\Mozilla Thunderbird\$0\Main" "PathToExe"
			   SetShellVarContext all
			   Delete "$DESKTOP\Mozilla Thunderbird.lnk"
			   CreateShortCut "$DESKTOP\Mail.lnk" "$0" "" "$PROGRAMFILES\Outlook Express\msimn.exe" 0
			   SetShellVarContext current
			   CreateShortCut "$SMPROGRAMS\Mail.lnk" "$0" "" "$PROGRAMFILES\Outlook Express\msimn.exe" 0
			${ElseIf} "$OutlookShortcut" == "$(LabelPbTarget)"
			   ReadRegStr $0 HKLM "Software\Postbox\Postbox" "CurrentVersion"
			   ReadRegStr $0 HKLM "Software\Postbox\Postbox\$0\Main" "PathToExe"
			   SetShellVarContext all
			   Delete "$DESKTOP\Postobox.lnk"
			   CreateShortCut "$DESKTOP\Mail.lnk" "$0" "" "$PROGRAMFILES\Outlook Express\msimn.exe" 0
			   SetShellVarContext current
			   CreateShortCut "$SMPROGRAMS\Mail.lnk" "$0" "" "$PROGRAMFILES\Outlook Express\msimn.exe" 0
			${EndIf}

		${EndIf}
	${EndIf}
    #End:
   SectionEnd
   
   Section "$(SecDelRecycleBin)" DelRecycleBinLnk
    SectionIn ${TypeNo3rdParty}
    ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{645FF040-5081-101B-9F08-00AA002F954E}" "1" ${DelRecycleBinLnk} "Delete" "RecycleBin"
	StrCpy $IconRefresh "1"
    End:
   SectionEnd
   
  Section "$(SecDelMyDocuments)" DelMyDocumentsLnk
    SectionIn ${TypeNo3rdParty}
	!ifndef VISPA2
      ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{450D8FBA-AD25-11D0-98A8-0800361B1103}" "1" ${DelMyDocumentsLnk} "Delete" "MyDocuments"
	  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{450D8FBA-AD25-11D0-98A8-0800361B1103}" "1" ${DelMyDocumentsLnk} "Delete" "MyDocumentsNew"
	!else ;VISPA2
	  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" "1" ${DelMyDocumentsLnk} "Delete" "MyDocuments"
	  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" "1" ${DelMyDocumentsLnk} "Delete" "MyDocumentsNew"
	!endif ;VISPA2
	StrCpy $IconRefresh "1"
    End:
   SectionEnd
   
   Section "$(SecDelMyComputer)" DelMyComputerLnk
    SectionIn ${TypeNo3rdParty}
	${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" "1" ${DelMyComputerLnk} "Delete" "MyComputer"
	${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" "1" ${DelMyComputerLnk} "Delete" "MyComputerNew"
	StrCpy $IconRefresh "1"
    End:
   SectionEnd
   
   Section "$(SecDelMyNetwork)" DelMyNetworkLnk
    SectionIn ${TypeNo3rdParty}
	!ifndef VISPA2
      ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{208D2C60-3AEA-1069-A2D7-08002B30309D}" "1" ${DelMyNetworkLnk} "Delete" "MyNetwork"
	  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{208D2C60-3AEA-1069-A2D7-08002B30309D}" "1" ${DelMyNetworkLnk} "Delete" "MyNetworkNew"
	!else ;VISPA2
	  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" "1" ${DelMyNetworkLnk} "Delete" "MyNetwork"
	  ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" "1" ${DelMyNetworkLnk} "Delete" "MyNetworkNew"
	!endif ;VISPA2
	StrCpy $IconRefresh "1"
    End:
   SectionEnd

#!ifdef VISPA   
   Section "$(SecDelControlPanel)" DelControlPanelLnk
    SectionIn ${TypeNo3rdParty}
	StrCmp $WinVer "Vista" 0 End
    ${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" "1" ${DelControlPanelLnk} "Delete" "ControlPanel"
	${Registry} "Dword" "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" "1" ${DelControlPanelLnk} "Delete" "ControlPanelNew"
	StrCpy $IconRefresh "1"
    End:
   SectionEnd
#!endif ;VISPA   
   
   Section "$(SecDelWMPLnk)" DelWMPLnk
    SectionIn ${TypeNo3rdParty}
    SectionGetFlags ${DelWMPLnk} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WMPLnk" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWMPLnk)' $(DPSkip)"
    ${Else}
    	Delete "$SMPROGRAMS\$(TermWinMediaPlayer).lnk"
        #!ifndef VISPA2
    	  Delete "$QUICKLAUNCH\$(TermWinMediaPlayer).lnk"
    	#!endif ;VISPA2
    	IfFileExists "$PROGRAMFILES\Windows Media Player\wmplayer.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WMPLnk" "1"
    ${EndIf}
    End:
   SectionEnd
   
   Section "$(SecDelMovieMkLnk)" DelMovieMkLnk
    SectionIn ${TypeNo3rdParty}
    SectionGetFlags ${DelMovieMkLnk} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
          WriteINIStr "$SaveFile" "Delete" "MovieMkLnk" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelMovieMkLnk)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$SMPROGRAMS\$(TermWinMovieMk).lnk"
    	SetShellVarContext current
    	IfFileExists "$PROGRAMFILES\Movie Maker\moviemk.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "MovieMkLnk" "1"
    ${EndIf}
    End:
   SectionEnd
   
   #!ifdef VISPA 
     Section "$(SecDelWinDVDMk)" DelWinDVDMk
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinDVDMk} $0
      StrCmp $0 "${READONLY}" End
      
      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinDVDMk" "1"
      ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinDVDMk)' $(DPSkip)"
    ${Else}
            SetShellVarContext all
	    Delete "$SMPROGRAMS\$(TermWinDVDMk).lnk"
	    SetShellVarContext current
	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinDVDMk" "1"
      ${EndIf}
    End:
     SectionEnd
     
     Section "$(SecDelWinPhotoGal)" DelWinPhotoGal
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinPhotoGal} $0
      StrCmp $0 "${READONLY}" End

      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinPhotoGal" "1"
      ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinPhotoGal)' $(DPSkip)"
	  ${Else}
            SetShellVarContext all
	    Delete "$SMPROGRAMS\$(TermWinPhotoGal).lnk"
      	    SetShellVarContext current
      	    IfFileExists "$PROGRAMFILES\Windows Photo Gallery\WindowsPhotoGallery.exe" 0 +2
      	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinPhotoGal" "1"
      ${EndIf}
      End:
     SectionEnd
     
     Section "$(SecDelWinDefender)" DelWinDefender
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinDefender} $0
      StrCmp $0 "${READONLY}" End
      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinDefender" "1"
      ${ElseIf} $Output == 2
			DetailPrint "'$(SecDelWinDefender)' $(DPSkip)"
      ${Else}
            SetShellVarContext all
      	    Delete "$SMPROGRAMS\$(TermWinDefender).lnk"
      	    SetShellVarContext current
      	    IfFileExists "$PROGRAMFILES\Windows Defender\MsAsCui.exe" 0 +2
      	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinDefender" "1"
      ${EndIf}
      End:
     SectionEnd

     Section "$(SecDelWinLiveDl)" DelWinLiveDl
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinLiveDl} $0
      StrCmp $0 "${READONLY}" End
      
      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinLiveDl" "1"
      ${ElseIf} $Output == 2
			DetailPrint "'$(SecDelWinLiveDl)' $(DPSkip)"
      ${Else}
            SetShellVarContext all
      	    Delete "$SMPROGRAMS\$(TermWinLiveDl).lnk"
      	    SetShellVarContext current
      	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinLiveDl" "1"
      ${EndIf}
      End:
     SectionEnd

     Section "$(SecDelWinFaxScan)" DelWinFaxScan
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinFaxScan} $0
      StrCmp $0 "${READONLY}" End

      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinFaxScan" "1"
      ${ElseIf} $Output == 2
			DetailPrint "'$(SecDelWinFaxScan)' $(DPSkip)"
      ${Else}
            SetShellVarContext all
      	    Delete "$SMPROGRAMS\$(TermWinFaxScan).lnk"
      	    SetShellVarContext current
      	    IfFileExists "$SYSDIR\WFS.exe" 0 +2
      	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinFaxScan" "1"
      ${EndIf}
      End:
     SectionEnd

     Section "$(SecDelWinCalendar)" DelWinCalendar
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinCalendar} $0
      StrCmp $0 "${READONLY}" End

      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinCalendar" "1"
      ${ElseIf} $Output == 2
			DetailPrint "'$(SecDelWinCalendar)' $(DPSkip)"
      ${Else}
            SetShellVarContext all
      	    Delete "$SMPROGRAMS\$(TermWinCalendar).lnk"
      	    SetShellVarContext current
      	    IfFileExists "$PROGRAMFILES\Windows Calendar\wincal.exe" 0 +2
      	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinCalendar" "1"
      ${EndIf}
      End:
     SectionEnd

     Section "$(SecDelWinContacts)" DelWinContacts
      SectionIn ${TypeNo3rdParty}
	  
	  StrCmp $WinVer "Vista" 0 End
      SectionGetFlags ${DelWinContacts} $0
      StrCmp $0 "${READONLY}" End

      ${If} $Output == 1
      	    WriteINIStr "$SaveFile" "Delete" "WinContacts" "1"
      ${ElseIf} $Output == 2
			DetailPrint "'$(SecDelWinContacts)' $(DPSkip)"
      ${Else}
            SetShellVarContext all
      	    Delete "$SMPROGRAMS\$(TermWinContacts).lnk"
      	    SetShellVarContext current
      	    IfFileExists "$PROGRAMFILES\Windows Mail\wab.exe" 0 +2
      	    WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinContacts" "1"
      ${EndIf}
      End:
     SectionEnd
   #!endif ;VISPA
   
   Section "$(SecDelMSNLnk)" DelMSNLnk #updateme
    SectionIn ${TypeNo3rdParty}
    #!ifndef VISPA
      StrCmp $WinVer "Vista" End
    #!endif ;VISPA
    SectionGetFlags ${DelMSNLnk} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "MSNLnk" "1"
    ${ElseIf} $Output == 2
		DetailPrint "'$(SecDelMSNLnk)' $(DPSkip)"
    ${Else}
    	SetShellVarContext all
    	Delete "$SMPROGRAMS\MSN.lnk"
    	SetShellVarContext current
    	IfFileExists "$PROGRAMFILES\MSN\MSNCoreFiles\Install\msnsusii.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "MSNLnk" "1"
    ${EndIf}
    End:
   SectionEnd

   #!ifndef VISPA   
   Section "$(SecDelMessengerLnk)" DelMessengerLnk
    SectionIn ${TypeNo3rdParty}
    StrCmp $WinVer "Vista" End
	SectionGetFlags ${DelMessengerLnk} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
          WriteINIStr "$SaveFile" "Delete" "MessengerLnk" "1"
    ${ElseIf} $Output == 2
		DetailPrint "'$(SecDelMessengerLnk)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$SMPROGRAMS\Windows Messenger.lnk"
    	SetShellVarContext current
    	IfFileExists "$PROGRAMFILES\Messenger\msmsgs.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "MessengerLnk" "1"
    ${EndIf}
    End:
   SectionEnd
#!endif ;VISPA   

   Section "$(SecDelWinUpdate)" DelWinUpdate
    SectionIn ${TypeNo3rdParty}
    SectionGetFlags ${DelWinUpdate} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WinUpdate" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinUpdate)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$STARTMENU\$(TermWinUpdate).lnk"
    	SetShellVarContext current
    	IfFileExists "$SYSDIR\wupdmgr.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinUpdate" "1"
    ${EndIf}
    End:
   SectionEnd
   
#!ifdef VISPA
   Section "$(SecDelWelcomeCenter)" DelWelcomeCenter
    SectionIn ${TypeNo3rdParty}
	
	StrCmp $WinVer "Vista" 0 End
    SectionGetFlags ${DelWelcomeCenter} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WelcomeCenter" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWelcomeCenter)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$STARTMENU\$(TermWelcomeCenter).lnk"
    	SetShellVarContext current
    ${EndIf}
    End:
   SectionEnd

   Section "$(SecDelWinMediaCenter)" DelWinMediaCenter
    SectionIn ${TypeNo3rdParty}
	
	StrCmp $WinVer "Vista" 0 End
    SectionGetFlags ${DelWinMediaCenter} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WinMediaCenter" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinMediaCenter)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$STARTMENU\$(TermWinMediaCenter).lnk"
    	SetShellVarContext current
    	IfFileExists "$WINDIR\ehome\ehshell.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinMediaCenter" "1"
    ${EndIf}
    End:
   SectionEnd

   Section "$(SecDelWinUltExtras)" DelWinUltExtras
    SectionIn ${TypeNo3rdParty}
	
	StrCmp $WinVer "Vista" 0 End
    SectionGetFlags ${DelWinUltExtras} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WinUltExtras" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinUltExtras)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$STARTMENU\$(TermWinUltExtras).lnk"
    	SetShellVarContext current
    ${EndIf}
    End:
   SectionEnd

   Section "$(SecDelWinMeetSpace)" DelWinMeetSpace
    SectionIn ${TypeNo3rdParty}
	
	StrCmp $WinVer "Vista" 0 End
    SectionGetFlags ${DelWinMeetSpace} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WinMeetSpace" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinMeetSpace)' $(DPSkip)"
    ${Else}
    	Delete "$STARTMENU\$(TermWinMeetSpace).lnk"
    	IfFileExists "$PROGRAMFILES\Windows Collaboration\WinCollab.exe" 0 +2
    	WriteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinMeetSpace" "1"
    ${EndIf}
    End:
   SectionEnd
#!endif ;VISPA
   
#!ifndef VISPA
   Section "$(SecDelWinCatalog)" DelWinCatalog
    SectionIn ${TypeNo3rdParty}
	
	StrCmp $WinVer "Vista" End
    SectionGetFlags ${DelWinCatalog} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "WinCatalog" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWinCatalog)' $(DPSkip)"
    ${Else}
        SetShellVarContext all
    	Delete "$STARTMENU\$(TermWinCat).lnk"
    	SetShellVarContext current
    ${EndIf}
    End:
   SectionEnd
   
   Section "$(SecDelProgAccess)" DelProgAccess
    SectionIn ${TypeNo3rdParty}
	
	StrCmp $WinVer "Vista" End
    SectionGetFlags ${DelProgAccess} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "ProgAccess" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelProgAccess)' $(DPSkip)"
    ${Else}
    	SetShellVarContext all
    	Delete "$STARTMENU\$(TermProgAccess).lnk"
    	SetShellVarContext current
    ${EndIf}
    End:
   SectionEnd
#!endif ;VISPA
   
   
   Section "$(SecDelMsBookmarks)" DelMsBookmarks
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelMsBookmarks} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "MsBookmarks" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelMsBookmarks)' $(DPSkip)"
    ${Else}
    	#SetShellVarContext all
    	RMDir /r "$FAVORITES\$(TermLinks)"
    	RMDir /r "$FAVORITES\$(TermMsWeb)"
	!ifndef VISPA2
    	  StrCmp $WinVer "Vista" End
    	  Delete "$FAVORITES\$(TermMSN).url"
    	  Delete "$FAVORITES\$(TermRadioGuide).url"
    	!else ;VISPA2
          RMDir /r "$FAVORITES\$(TermMsnWeb)"
          RMDir /r "$FAVORITES\$(TermWinLiveWeb)"
    	!endif ;VISPA2
    	#SetShellVarContext current
    ${EndIf}
    End:
   SectionEnd


   Section "$(SecDelSamplePictures)" DelSamplePictures
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelSamplePictures} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "SamplePictures" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelSamplePictures)' $(DPSkip)"
    ${Else}
    	SetShellVarContext all
    	Delete "$PICTURES\$(TermSamplePics)\*.*"
    	SetShellVarContext current
    	Delete "$PICTURES\$(TermSamplePics).lnk"
    ${EndIf}
    End:
   SectionEnd
   

   Section "$(SecDelSampleMusic)" DelSampleMusic
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelSampleMusic} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "SampleMusic" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelSampleMusic)' $(DPSkip)"
    ${Else}
    	SetShellVarContext all
    	Delete "$MUSIC\$(TermSampleMusic)\*.*"
    	SetShellVarContext current
    	Delete "$MUSIC\$(TermSampleMusic).lnk"
    ${EndIf}
    End:
   SectionEnd
   
   #!ifdef VISPA #updateme
   Section "$(SecDelSampleVideos)" DelSampleVideos
    SectionIn ${TypeNo3rdParty}
    
	StrCmp $WinVer "Vista" 0 End
	SectionGetFlags ${DelSampleVideos} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "SampleVideos" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelSampleVideos)' $(DPSkip)"
    ${Else}
    	SetShellVarContext all
    	Delete "$VIDEOS\$(TermSampleVideos)\*.*"
    	SetShellVarContext current
    	Delete "$VIDEOS\$(TermSampleVideos).lnk"
    	${EndIf}
    End:
   SectionEnd
   #!endif ;VISPA
   
   
   Section "$(SecDelSamplePlaylists)" DelSamplePlaylists
    SectionIn ${TypeNo3rdParty}
    SectionGetFlags ${DelSamplePlaylists} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "SamplePlaylists" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelSamplePlaylists)' $(DPSkip)"
    ${Else}
    	SetShellVarContext all
    	RMDir /r "$MUSIC\$(TermSamplePlaylists)"
    	SetShellVarContext current
    ${EndIf}
    End:
   SectionEnd
   

   Section "$(SecDelBitmaps)" DelBitmaps
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelBitmaps} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "Bitmaps" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelBitmaps)' $(DPSkip)"
    ${Else}
    	Delete "$WINDIR\*.bmp"
    ${EndIf}
    End:
   SectionEnd
   
   
   Section "$(SecDelVistaSP1)" DelVistaSP1
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelVistaSP1} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "VistaSP1" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelVistaSP1)' $(DPSkip)"
    ${Else}
    	DetailPrint "$(DPCompCln)"
		nsExec::ExecToLog /OEM '"$vsp1cln_Path" /quiet'
    ${EndIf}
    End:
   SectionEnd
   
   
   Section "$(SecDelVistaSP2)" DelVistaSP2
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelVistaSP2} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "VistaSP2" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelVistaSP2)' $(DPSkip)"
    ${Else}
		DetailPrint "$(DPCompCln)"
    	nsExec::ExecToLog /OEM '"$compcln_Path" /quiet'
    ${EndIf}
    End:
   SectionEnd
   
   
   Section "$(SecDelWin7SP)" DelWin7SP
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelWin7SP} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "Win7SP" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelWin7SP)' $(DPSkip)"
    ${Else}
		DetailPrint "$(DPCompCln)"
    	nsExec::ExecToLog /OEM '"$DISM_Path" /Online /Cleanup-Image /spsuperseded'
    ${EndIf}
    End:
   SectionEnd
   
   
   Section "$(SecDelPrefetch)" DelPrefetch
    SectionIn ${TypeNo3rdParty}
    
    SectionGetFlags ${DelPrefetch} $0
    StrCmp $0 "${READONLY}" End

    ${If} $Output == 1
        WriteINIStr "$SaveFile" "Delete" "Prefetch" "1"
    ${ElseIf} $Output == 2
        DetailPrint "'$(SecDelPrefetch)' $(DPSkip)"
    ${Else}
    	Delete /REBOOTOK "$WINDIR\Prefetch\*.*"
    ${EndIf}
    End:
   SectionEnd
   
   
   #!ifdef VISPA
	   Section "$(SecDelUpdCache)" DelUpdCache
		SectionIn ${TypeNo3rdParty}
		
		StrCmp $WinVer "Vista" 0 End
		SectionGetFlags ${DelUpdCache} $0
		StrCmp $0 "${READONLY}" End

		${If} $Output == 1
			WriteINIStr "$SaveFile" "Delete" "UpdCache" "1"
		${ElseIf} $Output == 2
			DetailPrint "'$(SecDelUpdCache)' $(DPSkip)"
		${Else}
			#Delete /REBOOTOK /r "$WINDIR\SoftwareDistribution\Download\*.*"
			RMDir /REBOOTOK /r "$WINDIR\SoftwareDistribution\Download"
		${EndIf}
		End:
	   SectionEnd
   #!endif ;VISPA

SectionGroupEnd

   !ifndef MINIXPY
     SectionGroup "UnDelete" SecUnDelete
	 
	   Section "$(SecUnDelIELnk)" DelUnIELnk
		SectionIn ${TypeUnNo3rdParty}
		SectionGetFlags ${DelUnIELnk} $0
		StrCmp $0 "${READONLY}" End
		${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{871C5380-42A0-1069-A2EA-08002B30309D}" "Delete" "IELnk"
		SetShellVarContext all
		Delete "$DESKTOP\Internet.lnk"
		SetShellVarContext current
		CreateShortCut "$SMPROGRAMS\Internet Explorer.lnk" "$PROGRAMFILES\Internet Explorer\iexplore.exe"
		StrCpy $IconRefresh "1"
		End:
      SectionEnd

	  Section "$SecUnDelMailClient" DelUnMailClient
       SectionIn ${TypeUnNo3rdParty}
		SectionGetFlags ${DelUnMailClient} $0
        StrCmp $0 "${READONLY}" End 
		${If} ${AtMostWinVista}
			CreateShortCut "$SMPROGRAMS\Windows Mail.lnk" "$PROGRAMFILES\Windows Mail\WinMail.exe"
			DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinMail"
		${Else}
			CreateShortCut "$SMPROGRAMS\Outlook Express.lnk" "$PROGRAMFILES\Outlook Express\msimn.exe"
			DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "OutExLnk"
		${EndIf}
		SetShellVarContext all
		Delete "$DESKTOP\Mail.lnk"
		SetShellVarContext current
        End:
      SectionEnd      
	  
      Section "$(SecUnDelRecycleBin)" DelUnRecycleBin
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${DelUnRecycleBin} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{645FF040-5081-101B-9F08-00AA002F954E}" "Delete" "RecycleBin"
       StrCpy $IconRefresh "1"
       End:
      SectionEnd
      
      Section "$(SecUnDelMyDocuments)" DelUnMyDocuments
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${DelUnMyDocuments} $0
       StrCmp $0 "${READONLY}" End
       #${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{450D8FBA-AD25-11D0-98A8-0800361B1103}" "Removal Message" "Delete" "MyDocuments"
	   !ifndef VISPA2
	     ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{450D8FBA-AD25-11D0-98A8-0800361B1103}" "Delete" "MyDocuments"
		 ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{450D8FBA-AD25-11D0-98A8-0800361B1103}" "Delete" "MyDocumentsNew"
	   !else ;VISPA2
	     ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" "Delete" "MyDocuments"
		 ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{450D8FBA-AD25-11D0-98A8-0800361B1103}" "Delete" "MyDocumentsNew"
	   !endif ;VISPA
       StrCpy $IconRefresh "1"
       End:
      SectionEnd
	  
	  Section "$(SecUnDelMyComputer)" DelUnMyComputer
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${DelUnMyComputer} $0
       StrCmp $0 "${READONLY}" End
	   ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" "Delete" "MyComputer"
	   ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" "Delete" "MyComputerNew"
       StrCpy $IconRefresh "1"
       End:
      SectionEnd
	  
	  Section "$(SecUnDelMyNetwork)" DelUnMyNetwork
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${DelUnMyNetwork} $0
       StrCmp $0 "${READONLY}" End
	   !ifndef VISPA2
	     ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{208D2C60-3AEA-1069-A2D7-08002B30309D}" "Delete" "MyNetwork"
		 ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{208D2C60-3AEA-1069-A2D7-08002B30309D}" "Delete" "MyNetworkNew"
	   !else ;VISPA2
	     ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" "Delete" "MyNetwork"
		 ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" "Delete" "MyNetworkNew"
	   !endif ;VISPA2
       StrCpy $IconRefresh "1"
       End:
      SectionEnd

#!ifdef VISPA	  
	  Section "$(SecUnDelControlPanel)" DelUnControlPanel
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${DelUnControlPanel} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" "Delete" "ControlPanel"
	   ${UnRegDWORD} "HKCU" "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" "Delete" "ControlPanelNew"
       StrCpy $IconRefresh "1"
       End:
      SectionEnd
#!endif ;VISPA
      
      Section "$(SecUnDelWMPLnk)" DelUnWMPLnk
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${DelUnWMPLnk} $0
       StrCmp $0 "${READONLY}" End

       ReadRegStr $1 HKCU ".DEFAULT\Software\Microsoft\Keyboard\Native Media Players\WMP" "ExePath"
       CreateShortCut "$SMPROGRAMS\$(TermWinMediaPlayer).lnk" $1
       #!ifndef VISPA2
         CreateShortCut "$QUICKLAUNCH\$(TermWinMediaPlayer).lnk" $1
       #!endif ;VISPA2
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WMPLnk"
       End:
      SectionEnd
      
      Section "$(SecUnDelMovieMkLnk)" DelUnMovieMkLnk
        SectionIn ${TypeUnNo3rdParty}
	    SectionGetFlags ${DelUnMovieMkLnk} $0
         StrCmp $0 "${READONLY}" End
         
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinMovieMk).lnk" "$PROGRAMFILES\Movie Maker\moviemk.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "MovieMkLnk"
         End:
       SectionEnd

#!ifdef VISPA
       Section "$(SecUnDelWinDVDMk)" DelUnWinDVDMk
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinDVDMk} $0
         StrCmp $0 "${READONLY}" End
         ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\dvdmaker.exe" ""
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinDVDMk).lnk" $1
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinDVDMk"
         End:
       SectionEnd
       
       Section "$(SecUnDelWinPhotoGal)" DelUnWinPhotoGal
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinPhotoGal} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinPhotoGal).lnk" "$PROGRAMFILES\Windows Photo Gallery\WindowsPhotoGallery.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinPhotoGal"
         End:
       SectionEnd
       
       Section "$(SecUnDelWinDefender)" DelUnWinDefender
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinDefender} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinDefender).lnk" "$PROGRAMFILES\Windows Defender\MsAsCui.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinDefender"
         End:
       SectionEnd

       Section "$(SecUnDelWinFaxScan)" DelUnWinFaxScan
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinFaxScan} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinFaxScan).lnk" "$SYSDIR\WFS.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinFaxScan"
         End:
       SectionEnd
       
       Section "$(SecUnDelWinCalendar)" DelUnWinCalendar
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinCalendar} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinCalendar).lnk" "$PROGRAMFILES\Windows Calendar\wincal.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinCalendar"
         End:
       SectionEnd
       
       Section "$(SecUnDelWinContacts)" DelUnWinContacts
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinContacts} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\$(TermWinContacts).lnk" "$PROGRAMFILES\Windows Mail\wab.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinContacts"
         End:
       SectionEnd
#!endif ;VISPA

       Section "$(SecUnDelMSNLnk)" DelUnMSNLnk
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnMSNLnk} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\MSN.lnk" "$PROGRAMFILES\MSN\MSNCoreFiles\Install\msnsusii.exe" "" "$PROGRAMFILES\MSN\MSNCoreFiles\Install\msnms.ico"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "MSNLnk"
         End:
       SectionEnd
#!ifndef VISPA       
       Section "$(SecUnDelMessengerLnk)" DelUnMessengerLnk
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnMessengerLnk} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$SMPROGRAMS\Windows Messenger.lnk" "$PROGRAMFILES\Messenger\msmsgs.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "MessengerLnk"
         End:
       SectionEnd
#!endif ;VISPA
       
       Section "$(SecUnDelWinUpdate)" DelUnWinUpdate
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinUpdate} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$STARTMENU\$(TermWinUpdate).lnk" "$SYSDIR\wupdmgr.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinUpdate"
         End:
       SectionEnd

#!ifdef VISPA
       Section "$(SecUnDelWinMediaCenter)" DelUnWinMediaCenter
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinMediaCenter} $0
         StrCmp $0 "${READONLY}" End
         SetShellVarContext all
         CreateShortCut "$STARTMENU\$(TermWinMediaCenter).lnk" "$WINDIR\ehome\ehshell.exe"
         SetShellVarContext current
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinMediaCenter"
         End:
       SectionEnd
       
       Section "$(SecUnDelWinMeetSpace)" DelUnWinMeetSpace
         SectionIn ${TypeUnNo3rdParty}
	     SectionGetFlags ${DelUnWinMeetSpace} $0
         StrCmp $0 "${READONLY}" End
         CreateShortCut "$STARTMENU\$(TermWinMediaCenter).lnk" "$PROGRAMFILES\Windows Collaboration\WinCollab.exe"
         DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "Delete" "WinMeetSpace"
         End:
       SectionEnd
#!endif ;VISPA

     SectionGroupEnd
   !endif ;MINIXPY