  # ${Registry}
  !macro Registry Type RootKey SubKey KeyName KeyValue Section SectionName EntryName
;   default operation for registry modifications
	SectionGetFlags ${Section} $0
    StrCmp $0 "${READONLY}" End
	!ifndef UITEST
		${If} $Output == 1
			WriteINIStr "$SaveFile" "${SectionName}" "${EntryName}" "1"
			DetailPrint '"${EntryName}=1" $(DPWritten)'
		${ElseIf} $Output == 2		
			StrCmp ${RootKey} "HKCR" 0 +2
			StrCpy $R1 "HKEY_CLASSES_ROOT"
			
			StrCmp ${RootKey} "HKCU" 0 +2
			StrCpy $R1 "HKEY_CURRENT_USER"
			
			StrCmp ${RootKey} "HKLM" 0 +2
			StrCpy $R1 "HKEY_LOCAL_MACHINE"				
			
			${If} ${Type} == "Dword"
				Push "${NUMERIC}"
				Push "${KeyValue}"
				Call StrCSpnReverse
				Pop $0
				
				${If} $0 == ""
					StrCpy $R3 "${KeyValue}"
					StrLen $0 $R3
					${While} $0 < 7
						StrLen $0 $R3
						StrCpy $R3 "0$R3"
					${EndWhile}
				${EndIf}
				
				WriteINIStr "$RegFile" "$R1\${SubKey}" "$\"${KeyName}$\"" "dword:$R3"
				DetailPrint "'$R1\${SubKey}\${KeyName}=${KeyValue}' $(DPWritten)"
			${Else}
				WriteINIStr "$RegFile" "$R1\${SubKey}" "$\"${KeyName}$\"" "$\"${KeyValue}$\""
				DetailPrint "'$R1\${SubKey}\${KeyName}=${KeyValue}' $(DPWritten) (${Type}: ${KeyValue})"
			${EndIf}		
		${Else}
			ReadReg${Type} $0 "${RootKey}" "${SubKey}" "${KeyName}"
			#DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPModify) (DWORD: ${KeyValue})'
			${If} $0 == ""
				WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" "~DeleteKey"
			${Else}
				WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" "$0"
			${EndIf}
			WriteReg${Type} "${RootKey}" "${SubKey}" "${KeyName}" "${KeyValue}"
			DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPModify) (${Type}: ${KeyValue})'
		${EndIf}
	!endif
  !macroend
  
  
  
  !macro RegExpStr RootKey SubKey KeyName KeyValue Section SectionName EntryName
;   default operation for registry modifications (regexpand)
    SectionGetFlags ${Section} $0
    StrCmp $0 "${READONLY}" End
	
	!ifndef UITEST
		${If} $Output == 1
			WriteINIStr "$SaveFile" "${SectionName}" "${EntryName}" "1"
			DetailPrint '"${EntryName}=1" $(DPWritten)'
		${ElseIf} $Output == 2		
			DetailPrint "${RootKey}\${SubKey}\${KeyName} $(DPSkip)"
		${Else}
			ReadRegStr $0 "${RootKey}" "${SubKey}" "${KeyName}"
			${If} $0 == ""
				WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" "~DeleteKey"
			${Else}
				WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" "$0"
			${EndIf}
			WriteRegExpandStr  "${RootKey}" "${SubKey}" "${KeyName}" "${KeyValue}"
			DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPModify) (DWORD: ${KeyValue})'
		${EndIf}
	!endif
  !macroend
  
  

     !macro UnRegDWORD RootKey SubKey KeyName SectionName EntryName
       ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}"
       StrCmp $0 "~DeleteKey" +5
       WriteRegDWORD "${RootKey}" "${SubKey}" "${KeyName}" "$0"
       WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" ""
       DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPRestore) (DWORD: $0)'
       Goto +4
       DeleteRegValue "${RootKey}" "${SubKey}" "${KeyName}"
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}"
       DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPDelete)'
     !macroend
     
     

     !macro UnRegStr RootKey SubKey KeyName SectionName EntryName
       ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}"
       StrCmp $0 "~DeleteKey" +5
       WriteRegStr "${RootKey}" "${SubKey}" "${KeyName}" "$0"
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}"
       DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPRestore) (String: $0)'
       Goto +4
       DeleteRegValue "${RootKey}" "${SubKey}" "${KeyName}"
       WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" ""
       DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPDelete)'
     !macroend
     
     
     
     !macro UnRegExpStr RootKey SubKey KeyName SectionName EntryName
       ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}"
       StrCmp $0 "~DeleteKey" +5
       WriteRegExpandStr "${RootKey}" "${SubKey}" "${KeyName}" "$0"
       DeleteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}"
       DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPRestore) (String: $0)'
       Goto +4
       DeleteRegValue "${RootKey}" "${SubKey}" "${KeyName}"
       WriteINIStr "$APPDATA\${LOWERCASE}.ini" "${SectionName}" "${EntryName}" ""
       DetailPrint '"${RootKey}\${SubKey}\${KeyName}" $(DPDelete)'
     !macroend
     
     

  !macro RestoreSection INISection INIEntry Section
;   read sections from .ini and lock setting that were not applied
	!ifndef UITEST
    ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "${INISection}" "${INIEntry}"
		${If} $0 == ""
		${AndIfNot} $Force == "1"
			Push $0
			IntOp $0 ${SF_SELECTED} | ${SF_RO}
			SectionSetFlags ${Section} $0
			Pop $0
			SectionSetInstTypes ${Section} ${ALLUNSECTIONS}
		${Else}
			${SelectSection} "${Section}" "" ""
		${EndIf}
	!endif
  !macroend

  

 !macro Reload Type RootKey SubKey KeyName KeyValue SectionName
;  read the registry and lock settings that are already set or not supported
   ${IfNot} $Output >= "1"
	    ReadReg${Type} $0 "${RootKey}" "${SubKey}" "${KeyName}"
	    StrCmp $0 "${KeyValue}" 0 +6
	    Push $1
	    IntOp $1 ${SF_SELECTED} | ${SF_RO}
	    SectionSetFlags ${SectionName} $1
	    Pop $1
	    SectionSetInstTypes ${SectionName} ${ALLSECTIONS}
   ${EndIf}
 !macroend
 
 
 !macro ReloadOr Type RootKey SubKey KeyName KeyValue1 KeyValue2 SectionName
;  read the registry and locks settings that are already set or not supported
   ${IfNot} $Output >= "1"
     ReadReg${Type} $0 "${RootKey}" "${SubKey}" "${KeyName}"
     ${If} $0 == "${KeyValue1}"
     ${OrIf} $0 == "${KeyValue2}"
		Push $1
		IntOp $1 ${SF_SELECTED} | ${SF_RO}
		SectionSetFlags ${SectionName} $1
		Pop $1
		SectionSetInstTypes ${SectionName} ${ALLSECTIONS}
     ${EndIf}
   ${EndIf}
 !macroend
 
 
 !macro IsINIEmpty INISection INIEntry
;  check if .ini contains used data, empty files will get deleted afterwards
   !ifndef UITEST
	   ReadINIStr $0 "$APPDATA\${LOWERCASE}.ini" "${INISection}" "${INIEntry}"
	   StrCmp $0 "" post${INISection}${INIEntry} 0
	   IntOp $EmptyINI $EmptyINI + 1
	   post${INISection}${INIEntry}:
   !endif
 !macroend
 
 
  
 !macro xpySelectSection SECTION INISection INIEntry
;   modified SelectSection
    StrCmp $Input "" +3
    ReadINIStr $1 "$Input" "${INISection}" "${INIEntry}"
    StrCmp $1 "1" 0 Post${SECTION}
    Push $0
    SectionGetFlags "${SECTION}" $0
    IntOp $0 $0 | ${SF_SELECTED}
    SectionSetFlags "${SECTION}" $0
    Pop $0
    Post${SECTION}:
 !macroend
 
 

 !macro xpyUnselectSection SECTION
;   modified UnselectSection
   Push $0
   SectionGetFlags "${SECTION}" $0
   IntOp $0 $0 & ${SECTION_OFF}
   SectionSetFlags "${SECTION}" $0
   Pop $0
 !macroend
 
 
 
 !macro MinSelect Section Selected
;  check if any settings are selected, a warning might appear afterwards
   !insertmacro SectionFlagIsSet ${Section} ${Selected} Add${Section}${Selected} Post${Section}${Selected}
   Add${Section}${Selected}:
   IntOp $MinSelect $MinSelect + 1
   Post${Section}${Selected}:
 !macroend
 
 
 
 !macro LockSection Section UnSection
;   lock sectiongroups whose children are all locked
    StrCpy $1 "0" ;counter
    IntOp $2 ${UnSection} - 1
    IntOp $3 ${Section} + 1

   Loop${Section}:
    StrCmp $3 $2 Stop${Section}
    SectionGetFlags $3 $0
    ${IfNot} $0 == "${READONLY}"
		IntOp $1 $1 + 1
    ${EndIf}
    IntOp $3 $3 + 1
    Goto Loop${Section}

   Stop${Section}:
    ${If} $1 == "0"
    	Push $1
    	SectionGetFlags "${Section}" $0
	   	IntOp $1 $0 | ${SF_RO}
	   	SectionSetFlags ${Section} $1
	   	Pop $1
	   	SectionSetInstTypes ${Section} ${ALLSECTIONS}
    ${EndIf}
  !macroend
  
  
  
  !macro LockUnSection UnSection Section
;   lock (restore-)sectiongroups whose children are all locked
    StrCpy $1 "0" ;counter
    IntOp $2 ${Section} - 1
    IntOp $3 ${UnSection} + 1

   Loop${UnSection}:
    StrCmp $3 $2 Stop${UnSection}
    SectionGetFlags $3 $0
    ${IfNot} $0 == "${READONLY}"
	#   ${OrIfNot} $0 == "${READONLY}"
	    IntOp $1 $1 + 1
    ${EndIf}
    IntOp $3 $3 + 1
    Goto Loop${UnSection}

   Stop${UnSection}:
    ${If} $1 == "0"
    	Push $1
    	SectionGetFlags "${UnSection}" $0
	   	IntOp $1 $0 | ${SF_RO}
	   	SectionSetFlags ${UnSection} $1
	   	Pop $1
    ${EndIf}
  !macroend
  
  !macro HideSection Section
;   unselect & hide section
	${UnselectSection} "${Section}"
	SectionSetText ${Section} ""
  !macroend
  
  
  !macro DelWarning Section Description
;   checks if a section with destructive element is selected and adds line to the messagebox warning
    !insertmacro SectionFlagIsSet ${Section} ${SF_RO} Post${Section} Next${Section}
    Next${Section}:
    !insertmacro SectionFlagIsSet ${Section} ${SF_SELECTED} Warning${Section} Post${Section}
    Warning${Section}:
    StrCpy $Warning "$Warning$\n- ${Description}"
    Post${Section}:
  !macroend