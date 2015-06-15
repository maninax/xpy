SectionGroup "Windows Media Player" SecWMP

 Section "$(SecWMPAutoLicAcqu)" WMPAutoLicAcqu
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SilentAcquisition" "0" ${WMPAutoLicAcqu} "WindowsMediaPlayer" "AutoLicAcqu"
  End:
 SectionEnd

#!ifdef VISPA
 Section "$(SecWMPSilentDRM)" WMPSilentDRM
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" 0 End
  ${Registry} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SilentDRMConfiguration" "0" ${WMPSilentDRM} "WindowsMediaPlayer" "SilentDRM"
  End:
 SectionEnd
#!endif ;VISPA

#!ifndef VISPA
 Section "$(SecWMPUpgradeMsg)" WMPUpgradeMsg
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Str" "HKLM" "SOFTWARE\Microsoft\MediaPlayer\PlayerUpgrade" "AskMeAgain" "no" ${WMPUpgradeMsg} "WindowsMediaPlayer" "UpgradeMsg"
  End:
 SectionEnd
#!endif ;VISPA

 Section "$(SecWMPLibrary)" WMPLibrary
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "AutoAddMusicToLibrary" "0" ${WMPLibrary} "WindowsMediaPlayer" "Library"
  End:
 SectionEnd

 Section "$(SecWMPMetadataRet)" WMPMetadataRet
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "MetadataRetrieval" "0" ${WMPMetadataRet} "WindowsMediaPlayer" "MetadataRet"
  End:
 SectionEnd

 Section "$(SecWMPUsageTrack)" WMPUsageTrack
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "UsageTracking" "0" ${WMPUsageTrack} "WindowsMediaPlayer" "UsageTrack"
  ${Registry} "Dword" "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "ForceUsageTracking" "0" ${WMPUsageTrack} "WindowsMediaPlayer" "ForceUsageTrack"
  End:
 SectionEnd

#!ifdef VISPA
 Section "$(SecWMPSendUID)" WMPSendUID
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" 0 End
  ${Registry} "Dword"  "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SendUserGUID" "00" ${WMPSendUID} "WindowsMediaPlayer" "SendUID"
  End:
 SectionEnd
#!endif ;VISPA

#!ifndef VISPA
 Section "$(SecWMPAutoUpdates)" WMPAutoUpdates
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" "disableAutoUpdate" "1" ${WMPAutoUpdates} "WindowsMediaPlayer" "AutoUpdates"
  End:
 SectionEnd

 Section "$(SecWMPNoMRU)" WMPNoMRU
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Dword" "HKLM" "SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" "disableMRU" "1" ${WMPNoMRU} "WindowsMediaPlayer" "NoMRU"
  End:
 SectionEnd
#!endif ;VISPA

 Section "$(SecWMPAutoCodecDownl)" WMPAutoCodecDownl
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" "HKCU" "Software\Policies\Microsoft\Preferences" "UpgradeCodecPrompt" "0" ${WMPAutoCodecDownl} "WindowsMediaPlayer" "AutoCodecDownl"
  End:
 SectionEnd
 
 Section "$(SecWMPImportMP3)" WMPImportMP3
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Preferences" "CDRecordMP3" "1" ${WMPImportMP3} "WindowsMediaPlayer" "CDRecordMP3"
  ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Preferences" "CDRecordMode" "1" ${WMPImportMP3} "WindowsMediaPlayer" "CDRecordMode"
  ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Preferences" "MP3RecordRate" "128000" ${WMPImportMP3} "WindowsMediaPlayer" "Bitrate"
  #!ifndef VISPA
    StrCmp $WinVer "Vista" End
    ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "HighRate" "320000" ${WMPImportMP3} "WindowsMediaPlayer" "EncHigh"
    ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "LowRate" "56000" ${WMPImportMP3} "WindowsMediaPlayer" "EncLow"
    ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "MediumHighRate" ${WMPImportMP3} "256000" "WindowsMediaPlayer" "EncMedHigh"
    ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "MediumRate" "128000" ${WMPImportMP3} "WindowsMediaPlayer" "EncMedium"
  #!endif ;VISPA
  End:
 SectionEnd
 
 Section "$(SecWMPNoDRM)" WMPNoDRM
  SectionIn ${TypeNo3rdParty}
  ${Registry} "Dword" HKCU "Software\Microsoft\MediaPlayer\Preferences" "CDRecordDRM" "0" ${WMPNoDRM} "WindowsMediaPlayer" "NoDRM"
  End:
 SectionEnd

#!ifndef VISPA
 Section "$(SecWMPAllowDeinst)" WMPAllowDeinst
  SectionIn ${TypeNo3rdParty}
  StrCmp $WinVer "Vista" End
  ${Registry} "Str" "HKLM" "SOFTWARE\Microsoft\MediaPlayer" "BlockUninstall" "no" ${WMPAllowDeinst} "WindowsMediaPlayer" "AllowDeinst"
  End:
 SectionEnd
#!endif ;VISPA
SectionGroupEnd

   !ifndef MINIXPY
     SectionGroup "Windows Media Player" SecUnWMP
     
      Section "$(SecUnWMPAutoLicAcqu)" WMPUnAutoLicAcqu
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnAutoLicAcqu} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SilentAcquisition" "WindowsMediaPlayer" "AutoLicAcqu"
       End:
      SectionEnd
      
#!ifdef VISPA
       Section "$(SecUnWMPSilentDRM)" WMPUnSilentDRM
        SectionIn ${TypeUnNo3rdParty}
	    SectionGetFlags ${WMPUnSilentDRM} $0
        StrCmp $0 "${READONLY}" End
        ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SilentDRMConfiguration" "WindowsMediaPlayer" "SilentDRM"
        End:
      SectionEnd
#!endif ;VISPA

#!ifndef VISPA
      Section "$(SecUnWMPUpgradeMsg)" WMPUnUpgradeMsg
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnUpgradeMsg} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegStr} "HKLM" "SOFTWARE\Microsoft\MediaPlayer\PlayerUpgrade" "AskMeAgain" "WindowsMediaPlayer" "UpgradeMsg"
       End:
      SectionEnd
#!endif ;VISPA

      Section "$(SecUnWMPLibrary)" WMPUnLibrary
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnLibrary} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "AutoAddMusicToLibrary" "WindowsMediaPlayer" "Library"
       End:
      SectionEnd

      Section "$(SecUnWMPMetadataRet)" WMPUnMetadataRet
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnMetadataRet} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "MetadataRetrieval" "WindowsMediaPlayer" "MetadataRet"
       End:
      SectionEnd

      Section "$(SecUnWMPUsageTrack)" WMPUnUsageTrack
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnUsageTrack} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "UsageTracking" "WindowsMediaPlayer" "UsageTrack"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "ForceUsageTracking" "WindowsMediaPlayer" "ForceUsageTrack"
       End:
      SectionEnd

#!ifdef VISPA
      Section "$(SecUnWMPSendUID)" WMPUnSendUID
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnSendUID} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "SendUserGUID" "WindowsMediaPlayer" "SendUID"
       End:
      SectionEnd
#!endif ;VISPA

#!ifndef VISPA
      Section "$(SecUnWMPAutoUpdates)" WMPUnAutoUpdates
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnAutoUpdates} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" "disableAutoUpdate" "WindowsMediaPlayer" "AutoUpdates"
       End:
      SectionEnd

      Section "$(SecUnWMPNoMRU)" WMPUnNoMRU
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnNoMRU} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" "disableMRU" "WindowsMediaPlayer" "NoMRU"
       End:
      SectionEnd
#!endif ;VISPA

      Section "$(SecUnWMPAutoCodecDownl)" WMPUnAutoCodecDownl
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnAutoCodecDownl} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Policies\Microsoft\Preferences" "UpgradeCodecPrompt" "WindowsMediaPlayer" "AutoCodecDownl"
       End:
      SectionEnd
      
      Section "$(SecUnWMPImportMP3)" WMPUnImportMP3
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnImportMP3} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "CDRecordMP3" "WindowsMediaPlayer" "CDRecordMP3"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "CDRecordMode" "WindowsMediaPlayer" "CDRecordMode"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "MP3RecordRate" "WindowsMediaPlayer" "Bitrate"
#!ifndef VISPA
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "HighRate" "WindowsMediaPlayer" "EncHigh"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "LowRate" "WindowsMediaPlayer" "EncLow"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "MediumHighRate" "WindowsMediaPlayer" "EncMedHigh"
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Settings\MP3Encoding" "MediumRate" "WindowsMediaPlayer" "EncMedium"
#!endif ;VISPA
       End:
      SectionEnd
      
      Section "$(SecUnWMPNoDRM)" WMPUnNoDRM
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnNoDRM} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKCU" "Software\Microsoft\MediaPlayer\Preferences" "CDRecordDRM" "WindowsMediaPlayer" "NoDRM"
       End:
      SectionEnd

#!ifndef VISPA
      Section "$(SecUnWMPAllowDeinst)" WMPUnAllowDeinst
       SectionIn ${TypeUnNo3rdParty}
	   SectionGetFlags ${WMPUnAllowDeinst} $0
       StrCmp $0 "${READONLY}" End
       ${UnRegDWORD} "HKLM" "SOFTWARE\Microsoft\MediaPlayer" "BlockUninstall" "WindowsMediaPlayer" "AllowDeinst"
       End:
      SectionEnd
#!endif ;VISPA
    SectionGroupEnd
  !endif ;MINIXPY