!ifndef XPY_VERSION
  !define XPY_VERSION "1.3.7"
!endif

!ifdef MINIXPY
  !ifndef LANGUAGE
    !define LANGUAGE "english"
  !endif
!endif

;Names and Numbers
!define VERSION "${XPY_VERSION}"
!define LONG_VERSION "${XPY_VERSION}.0"
!define NAME "xpy ${VERSION}"
!define SHORTNAME "xpy"
!define LOWERCASE "${SHORTNAME}"
!define WEBSITE "http://whyeye.org/projects/xpy"

;Header Compression
!ifdef COMPRESSION
  !if ${COMPRESSION} == "UPX" ; UPX compression (http://upx.sourceforge.net/)
	!packhdr "$%TEMP%\exehead.tmp" "upx.exe --best $%TEMP%\exehead.tmp"
  !else if ${COMPRESSION} == "PETITE" ; Petite compression (http://www.un4seen.com/petite/)
	!packhdr "$%TEMP%\exehead.tmp" "petite.exe -9 -r* -y $%TEMP%\exehead.tmp" 
  !endif
!endif

;Search Engine
; e.g. !define SEARCH "IXQUICK"
!ifdef SEARCH
  !if ${SEARCH} == "A9"
    !define SEARCHENGINE "A9 (a9.com)"
  !else if ${SEARCH} == "ALTAVISTA"
    !define SEARCHENGINE "Altavista (altavista.com)"
  !else if ${SEARCH} == "ASK"
    !define SEARCHENGINE "Ask (ask.com)"
  !else if ${SEARCH} == "BAIDU"
    !define SEARCHENGINE "Baidu (baidu.com)"
  !else if ${SEARCH} == "BING"
    !define SEARCHENGINE "Bing (bing.com)"
  !else if ${SEARCH} == "DUCKDUCKGO"
    !define SEARCHENGINE "DuckDuckGo (duckduckgo.com)"
  !else if ${SEARCH} == "GOOGLE"
    !define SEARCHENGINE "Google (google.com)"
  !else if ${SEARCH} == "IXQUICK"
    !define SEARCHENGINE "Ixquick (ixquick.com)"
  !else if ${SEARCH} == "METACRAWLER"
    !define SEARCHENGINE "Metacrawler (metacrawler.com)"
  !else if ${SEARCH} == "YAHOO"
    !define SEARCHENGINE "Yahoo! (yahoo.com)"
  !endif
!else
   !define SEARCHENGINE "Ixquick (ixquick.com)" ; default
!endif

;Pages
  !define DIRECTORYPAGE
# !define LICENSEPAGE ;disabled as of 1.2.6
  !define IOPAGE
  !define COMPONENTSPAGE
  !define IO2PAGE
  !define INSTFILESPAGE

; Variables
  Var Next
  Var Output
  Var Input
  Var SaveFile
  Var RegFile
  !ifndef MINIXPY
    Var OutfileName
    Var LoadFile
  !endif
  Var Passive
  Var Switches
  Var SearchEngineIni
  Var WinProduct
  Var WinBit
  Var WinVersion
  Var WinBuild
  Var User
  Var ComputerName
  Var Parameter
  #Var Help
  Var Caption
  #Var Message
  Var IeVersion
  Var IconRefresh
  Var Force
  !ifndef LANGUAGE
	   Var ShowLang
  !endif
  !ifdef LICENSEPAGE
	Var ShowLicense
  !endif
  Var NoReboot
  Var WinVer    
  !ifndef MINIXPY
    Var emptyini
    Var Restore
    Var Warning
    Var MinSelect
	#Var Update
  !endif ;MINIXPY
  Var GUID
  
!ifndef MINIXPY
;  UI Variables
  Var Dialog
  Var CheckBox
  Var GroupBox
  Var SearchLabel
  Var SearchEngine
  Var IELabel
  Var OutlookLabel
  Var preDialog
  Var ButtonMake
  Var ButtonRestore
  Var ButtonLoad
  Var ButtonSave
  Var ButtonReg
  Var LabelTop
  Var LabelBotton
  Var FileRequest
  Var ButtonBrowse
  Var MaxConnectionsLabel
  Var RDPLabel
!endif ;MINIXPY
  Var MaxConnections
  Var RDP
  Var SecDelMailClient
  Var SecUnDelMailClient
  Var SecServFirewall
  Var SecUnServFirewall
  Var IEShortcut
  Var OutlookShortcut
  Var vsp1cln_Path
  Var compcln_Path
  Var DISM_Path
  
;  SearchEngines
  Var SearchPage
  Var SearchBar
  Var SearchQuery
  Var SearchName

;  Inclusions
  !ifndef MINIXPY
    !include "MUI2.nsh"
  !endif ;MINIXPY
  !include "WinMessages.nsh"
  !include "LogicLib.nsh"
  !include "WinVer.nsh"
  !include "x64.nsh"
  !include "nsDialogs.nsh"
  !include "FileFunc.nsh"
			!insertmacro GetParameters
			!insertmacro GetOptions
			!insertmacro GetFileName
			!insertmacro GetFileExt
			!insertmacro GetParent
  !ifndef MINIXPY
    !include "WordFunc.nsh"
             !insertmacro WordFind
  !endif ;MINIXPY
  !include "TextReplace.nsh"
  
;  Definitions
  !define SHCNE_ASSOCCHANGED 0x8000000
  !define SHCNF_IDLIST 0
  !define READONLY "17" ; 0.10: 17
  !define ALLSECTIONS "63" ; 0.10: 31
  !define ALLUNSECTIONS "4032"
  
  !define SelectSection "!insertmacro xpySelectSection"
  !define UnselectSection "!insertmacro xpyUnselectSection"
  !define RestoreSection "!insertmacro RestoreSection"
  !define IsINIEmpty "!insertmacro IsINIEmpty"
  !define LockSection "!insertmacro LockSection"
  !define LockUnSection "!insertmacro LockUnSection"
  !define Hide "!insertmacro HideSection"

  !define Registry "!insertmacro Registry"
  !define RegStr "!insertmacro RegStr"
  !define RegExpStr "!insertmacro RegExpStr"
  !define UnRegDWORD "!insertmacro UnRegDWORD"
  !define UnRegStr "!insertmacro UnRegStr"
  !define UnRegExpStr "!insertmacro UnRegExpStr"
  !define Reload "!insertmacro Reload"
  !define ReloadOr "!insertmacro ReloadOr"
  !define DelWarn "!insertmacro DelWarning"
  
  !define mdTXT "!insertmacro MUI_DESCRIPTION_TEXT"
  
  !define REQUIRED "0xfff799"
  !define INVALID "0xffbfbf"
  !define VALID "0xd8eabd"
  !define NUMERIC "1234567890"
  !define ILLCHARS "/*?$\"<>|" # original: "\/:*?$\"<>|"
  
  Name "${SHORTNAME}"
  Caption "${SHORTNAME}"
  OutFile "${LOWERCASE}.exe"
  SetDatablockOptimize on
  SetCompress force
  SetCompressor /SOLID lzma
  CRCCheck on
  XPStyle on
  RequestExecutionLevel admin ; for Vista or later
  InstallButtonText "$(LabelApply)"

  !ifndef PUBSRC
    InstallDir "$PROGRAMFILES\whyEye.org\xpy"
	BrandingText "whyEye.org"
    !ifndef MINIXPY
	  !define MUI_COMPONENTSPAGE_CHECKBITMAP "ui\yi-${LOWERCASE}.bmp"
      !define MUI_ICON "ui\yi-${LOWERCASE}.ico"
      !define MUI_UI "ui\nodesc.exe"
	  !ifdef LICENSEPAGE
		!define MUI_LICENSEPAGE_BGCOLOR "FFFFFF"
	  !endif ;LICENSEPAGE
      !define MUI_INSTFILESPAGE_COLORS "000000 FFFFFF"
      !define MUI_INSTFILESPAGE_PROGRESSBAR "colored smooth"
	  !define MUI_BGCOLOR "0x1b1b1b"
    !else ;MINIXPY
      CheckBitmap "ui\yi-${LOWERCASE}.bmp"
      Icon "ui\yi-minixpy.ico"
      InstallColors 000000 FFFFFF
      InstProgressFlags colored smooth
    !endif ;MINIXPY
  !else ;PUBSRC
    InstallDir "$PROGRAMFILES\xpy"
	BrandingText "${WEBSITE}"
  !endif ;PUBSRC
  #!define MUI_TEXT_INSTALLING_TITLE "$(LabelInstallHeader)"
  #!define MUI_TEXT_INSTALLING_SUBTITLE "$(LabelInstallSubtext)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "$(LabelFinishHeader)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "$(LabelFinishSubtext)"

;  Installer Pages
  !ifndef MINIXPY
	!define MUI_CUSTOMFUNCTION_GUIINIT myGuiInit
	!ifdef DIRECTORYPAGE
		!define MUI_PAGE_CUSTOMFUNCTION_PRE DirectoryShow
		!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirectoryLeave
		!insertmacro MUI_PAGE_DIRECTORY
	!endif
	!ifdef LICENSEPAGE
		!define MUI_PAGE_CUSTOMFUNCTION_PRE LicenseShow
		!define MUI_PAGE_CUSTOMFUNCTION_LEAVE LicenseLeave
		!define MUI_LICENSEPAGE_TEXT_BOTTOM "$(LabelLicense)"
		!define MUI_LICENSEPAGE_CHECKBOX
		  !insertmacro MUI_PAGE_LICENSE "license.txt"
	!endif ;LICENSEPAGE
	!define MUI_PAGE_HEADER_TEXT  "$(LabelSettings)"
  !define MUI_PAGE_HEADER_SUBTEXT  "$(LabelDescription)"
	!ifdef IOPAGE
		Page custom ioPage ioPageLeave ;new  
  !endif
	!ifdef COMPONENTSPAGE
		!define MUI_PAGE_CUSTOMFUNCTION_PRE ComponentsShow
		!define MUI_PAGE_CUSTOMFUNCTION_LEAVE ComponentsLeave    
		  !insertmacro MUI_PAGE_COMPONENTS
	!endif
	!ifdef IO2PAGE
		Page custom io2Page io2PageLeave ;new
	!endif
	!ifdef INSTFILESPAGE
		!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstfilesShow
    !define MUI_PAGE_HEADER_TEXT  "$(LabelInstallHeader)"
    !define MUI_PAGE_HEADER_SUBTEXT  "$(LabelInstallSubtext)"
		!insertmacro MUI_PAGE_INSTFILES
	!endif
  !else ;MINIXPY
    Page Components
	  Page InstFiles
  !endif ;MINIXPY

  !include "includes\macros.nsh"

;Language Inclusions
  !ifndef LANGUAGE
    !include "includes\lang_english.nsh" # first = default
    !include /NONFATAL "includes\lang_czech.nsh"
    !include /NONFATAL "includes\lang_german.nsh"
    !include /NONFATAL "includes\lang_polish.nsh"
  !else
    !include "includes\lang_${LANGUAGE}.nsh"
  !endif
  
;Version Information
  VIProductVersion "${LONG_VERSION}"
  VIAddVersionKey "ProductName" "${SHORTNAME}"
  VIAddVersionKey "FileVersion" "${LONG_VERSION}"
  VIAddVersionKey "LegalCopyright" "Jan T. Sott"
  VIAddVersionKey "FileDescription" "${SHORTNAME} ${VERSION}"
  VIAddVersionKey "Comments" "${WEBSITE}"


;InstallTypes
  !define Type3rdParty "2 3"
  !define TypeNo3rdParty "2 4"
  !define TypeClassic "2 4 5"
  !define TypeWin2003 "2 4 6"
  
  !ifndef MINIXPY
	  !define TypeUn3rdParty "8 9"
	  !define TypeUnNo3rdParty "8 10"
	  !define TypeUnClassic "8 10 11"
	  !define TypeUnWin2003 "8 10 12"
  !endif ;MINIXPY
  
  InstType "$(ITNone)"            ; 1 No Settings
  InstType "$(ITAll)"             ; 2 All Settings
  InstType "$(IT3rdParty)"        ; 3 3rd Party only
  InstType "$(ITNo3rdParty)"      ; 4 All Settings (no 3rd Party)
  InstType "$(ITClassic)"         ; 5 Windows Classic
  InstType "$(ITWin2k3)"          ; 6 Windows 2003 to Workstation
  !ifndef MINIXPY
	  InstType "$(ITNone)"       ; 7 Undo No Settings
	  InstType "$(ITAll)"        ; 8 Undo All Settings
	  InstType "$(IT3rdParty)"   ; 9 Undo 3rd Party only
	  InstType "$(ITNo3rdParty)" ;10 Undo All Settings (no 3rd Party)
	  InstType "$(ITClassic)"    ;11 Undo Windows Classic
	  InstType "$(ITWin2k3)"     ;12 Undo Windows 2003 to Workstation
  !endif ;MINIXPY
  !define AllSettings "1"
  !define No3rdPartySettings "3"