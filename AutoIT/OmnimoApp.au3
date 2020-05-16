#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icons\OmnimoApp.ico
#AutoIt3Wrapper_Outfile=..\WP7\@Resources\Common\OmnimoApp.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Made for Omnimo UI
#AutoIt3Wrapper_Res_Description=Made for Omnimo UI
#AutoIt3Wrapper_Res_Fileversion=6.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Xyrfo 2013
#AutoIt3Wrapper_AU3Check_Parameters=-q -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include "Includes\Common.au3"

Switch $CmdLine[1]

; Open Start Menu
Case 'StartMenu'
	Send("{LWIN}")


; �Torrent
; Command line arguments:
; [2]: username
; [3]: password
; [4]: action
; [5]: hash
Case 'uTorrent'
	If $CmdLine[0] < 5 Then OmnimoError("Error", "Too few command line arguments specified.")
    InetRead('http://' & $CmdLine[2] & ':' & $CmdLine[3] & '@127.0.0.1:8080/gui/?action=' & $CmdLine[4] & '&hash=' & $CmdLine[5], 1 + 16)


; Power Plan
; Command line arguments:
; [2] Power mode
Case 'PowerPlan'
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")
	If $CmdLine[2] == 'HighPerformance' Then
        RunWait('powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c', "", @SW_HIDE)
    ElseIf $CmdLine[2] == 'Balanced' Then
        RunWait('powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e', "", @SW_HIDE)
    ElseIf $CmdLine[2] == 'PowerSaver' Then
        RunWait('powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a ', "", @SW_HIDE)
    EndIf
	SendBang("!Refresh WP7\Panels\PowerPlan")


; Set display brightness
; http://www.autoitscript.com/forum/topic/127668-tinybrightnesscontroler-v-1002/
; Command line arguments:
; [2] Brightness level
Case 'SetBrightness'
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")
    $tagDISPLAY_BRIGHTNESS = "ubyte ucDisplayPolicy;ubyte ucACBrightness;ubyte ucDCBrightness"
    Global Const $IOCTL_VIDEO_QUERY_DISPLAY_BRIGHTNESS = Int(0x00230498)
    Global Const $IOCTL_VIDEO_SET_DISPLAY_BRIGHTNESS = Int(0x0023049C)
    Global Const $IOCTL_VIDEO_QUERY_SUPPORTED_BRIGHTNESS = Int(0x00230494)
    Global Const $hLCD = _WinAPI_CreateFile("\\.\LCD", 3, 2, 7)

	If StringLeft($CmdLine[2], 1) = '+' Then
		$brightness = _GetDisplayBrightness() + Int(StringTrimLeft($CmdLine[2], 1))
	ElseIf StringLeft($CmdLine[2], 1) = '-' Then
		$brightness = _GetDisplayBrightness() - Int(StringTrimLeft($CmdLine[2], 1))
	Else
		$brightness = Int($CmdLine[2])
	EndIf

	_SetDisplayBrightness($brightness, $brightness)


; Change skin
; Command line arguments:
; [2] Skin
; [3] Skin path
Case 'Skin'
	If $CmdLine[0] < 3 Then OmnimoError("Error", "Too few command line arguments specified.")
    FileCopy($CmdLine[3] & '\WP7\@Resources\Common\Color\' & $CmdLine[2] & '.inc', $CmdLine[3] & '\WP7\@Resources\Common\Color\color.inc', 1)
	SendBang("!Refresh *")


; Change language
; Command line arguments:
; [2] Language name
; [3] Language code
; [4] Restart Rainmeter (0/1)
; [5] Skin path
; [6] Program path
Case 'Lang'
	If $CmdLine[0] < 7 Then OmnimoError("Error", "Too few command line arguments specified.")
    FileCopy($CmdLine[5] & "\WP7\@Resources\Common\Variables\Languages\" & $CmdLine[2] & ".inc", $CmdLine[5] & "\WP7\@Resources\Common\Variables\Languages\lang.inc", 1)
	IniWrite($CmdLine[6] & "Rainmeter.ini", "Rainmeter", "Language", $CmdLine[3])
	If $CmdLine[4] = "1" Then
		SendBang("!Quit")
		ProcessWaitClose("Rainmeter.exe")
		ShellExecute($CmdLine[7] & "Rainmeter.exe")
	EndIf


; Change tray icon
; Command line arguments:
; [2] Tray icon
; [3] Program path
; [4] Settings path
; [5] Skins path
Case 'Tray'
	If $CmdLine[0] < 5 Then OmnimoError("Error", "Too few command line arguments specified.")
	Const $TraySection = IniReadSection($CmdLine[5] & "\WP7\@Resources\Common\Gallery\Tray\" & $CmdLine[2] & ".txt", "TrayMeasure")
	IniWriteSection($CmdLine[4] & "Rainmeter.ini", "TrayMeasure", $TraySection)
	SendBang("!Quit")
    ProcessWaitClose("Rainmeter.exe")
    ShellExecute($CmdLine[3] & "Rainmeter.exe")


; Change theme
; Command line arguments:
; [2] Theme
; [3] Program path
; [4] Settings path
; [5] Skins path
Case 'Themes'
	If $CmdLine[0] < 5 Then OmnimoError("Error", "Too few command line arguments specified.")
    ; Close Rainmeter
	SendBang("!Quit")
    ProcessWaitClose("Rainmeter.exe")

	$RainmeterSection = IniReadSection($CmdLine[4] & "\Rainmeter.ini", "Rainmeter")
	$sData = ""
	For $i = 1 To $RainmeterSection[0][0]
        $sData &= $RainmeterSection[$i][0] & "=" & $RainmeterSection[$i][1] & @LF
    Next

    ; Replace Rainmeter.ini with new theme
    FileCopy($CmdLine[5] & "\WP7\@Resources\Common\Gallery\Themes\" & $CmdLine[2] & ".thm", $CmdLine[4] & "\Rainmeter.ini", 1)
	IniWriteSection($CmdLine[4] & "\Rainmeter.ini", "Rainmeter", $sData)

    ShellExecute($CmdLine[3] & "Rainmeter.exe")


; Eject disc
Case 'Eject'
	$drive = DriveGetDrive("CDROM")
	If @error Then OmnimoError("Error", "Unable to find an optical disc drive.")
	For $i = 1 To $drive[0]
		CDTray($drive[$i], "open")
	Next


; Turn monitor off
Case 'Monitor'
	Monitor("off")


; Toggle desktop icons
; Command line arguments:
; [2] Show / Hide (optional)
Case 'ToggleIcons'
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")
    $hParent = WinGetHandle("Program Manager")
    $hListView = ControlGetHandle($hParent, "", "SysListView321")

    ; State == 7 => desktop icons are shown
    ; State == 5 => desktop icons are hidden
    $state = WinGetState($hListView)

	Switch $CmdLine[2]
		Case 'Show'
			WinSetState($hListView, '', @SW_SHOW)
		Case 'Hide'
			WinSetState($hListView, '', @SW_HIDE)
		Case 'Toggle'
			If $state = '7' Then
				WinSetState($hListView, '', @SW_HIDE)
						SendBang("[!Toggle *][!Show 'WP7\Panels\ShowDesktop']")
			ElseIf $state = '5' Then
				WinSetState($hListView, '', @SW_SHOW)
					SendBang("[!Toggle *][!Show 'WP7\Panels\ShowDesktop']")
			
			EndIf
	EndSwitch

    ; HACK!!! The numbers aren't always 5 and 7 on some systems so this might be buggy


; Set variable in color.inc
; Command line arguments:
; [2] Variable
; [3] Color
; [4] Skins path
Case 'SetColor'
	If $CmdLine[0] < 4 Then OmnimoError("Error", "Too few command line arguments specified.")
    IniWrite($CmdLine[4] & '\WP7\@Resources\Common\Color\Color.inc', 'Variables', $CmdLine[2], HexToRGB($CmdLine[3]))
	SendBang("!Refresh *")


; Set Aero blur color as panel color
; Command line arguments:
; [2] Skins path
Case 'ColorizationColor'
	If Not (@OSVersion = "WIN_8" Or @OSVersion = "WIN_7" Or @OSVersion = "WIN_VISTA") Then Exit
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")

	$ColorizationColor = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM", "ColorizationColor")
	If @error Then OmnimoError("Error", "Unable to read Aero blur color from the registry.")

	$ColorizationHex = "0x" & Hex(Int($ColorizationColor), 8)
	$ColorizationRgb = HexToRGB($ColorizationHex)
	$Alpha = BitAnd(BitShift($ColorizationHex, 24), 0xFF)

	Const $SkinsPath = $CmdLine[2]
	Const $ColorInc = $SkinsPath & "\WP7\@Resources\Common\Color\color.inc"

	IniWrite($ColorInc, "Variables", "Colorskin", $ColorizationRgb)
	IniWrite($ColorInc, "Variables", "Opacity", $Alpha)

	SendBang("!Refresh *")


; VLC radio
; Command line arguments:
; [2] VLC path
; [3] Channel
Case 'Radio'
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")
    ; Restart VLC with the new channel
    ProcessClose("vlc.exe")
	ProcessWaitClose("vlc.exe")
	If $CmdLine[2] <> 'Kill' Then
		ShellExecute($CmdLine[2], '-I=dummy ' & '"' & $CmdLine[3] & '"')
	EndIf


; Power buttons
; Command line arguments:
; [2] Command
; [3] Time to sleep
Case 'Power'
	If $CmdLine[0] < 3 Then OmnimoError("Error", "Too few command line arguments specified.")

	Sleep(Int($CmdLine[3]) * 1000)
	SendBang("!DeactivateConfig WP7\TextItems\Extra\PowerButtons\Dialogue")

	Switch $CmdLine[2]
		Case 'Shutdown'
			Run('shutdown.exe /s /t 00', "", @SW_HIDE)
		Case 'Restart'
			Run('shutdown.exe /r /t 00', "", @SW_HIDE)
		Case 'Logoff'
			Run('shutdown.exe /l', "", @SW_HIDE)
		Case 'Sleep'
			Run('rundll32.exe powrprof.dll,SetSuspendState 0,1,0', "", @SW_HIDE)
		Case 'Hibernate'
			Run('rundll32.exe PowrProf.dll,SetSuspendState', "", @SW_HIDE)
		Case 'Lock'
			Run('rundll32.exe user32.dll,LockWorkStation', "", @SW_HIDE)
	EndSwitch


; Windows Update
Case 'Update'
	; Exit gracefully when not connected
	$oWU_ErrorHandler = ObjEvent("AutoIt.Error", "_WU_ErrorHandler")

	; Check for updates
	$wupdate = ObjCreate("Microsoft.Update.Session")
	If @error Then Exit
	$searcher = $wupdate.CreateUpdateSearcher()
	$result = $searcher.Search("IsInstalled=0 and IsHidden=0")
	If @error Then Exit

    ; Refresh panel
	SendBang("!SetVariable Updates " & $result.Updates.Count & " WP7\InstalledPanels\WindowsUpdate")
	SendBang("!Update WP7\InstalledPanels\WindowsUpdate")


; Take a screenshot
; Command line arguments:
; [2] Skins path
Case 'Screenshot'
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")
    $config = $CmdLine[2] & '\WP7\@Resources\Config\Panels\Camera\UserVariables.inc'

    ; Read variables
    $Delay = IniRead($config, 'Variables', 'Delay', '0')
    $CaptureCursor = IniRead($config, 'Variables', 'CaptureCursor', 'False')
    $FileFormat = IniRead($config, 'Variables', 'FileFormat', 'jpg')
    $OpenImageAfter = IniRead($config, 'Variables', 'OpenImageAfter', 'True')
    $SaveTo = IniRead($config, 'Variables', 'SaveTo', @UserProfileDir & '\Pictures')
    $SaveTo = StringReplace($SaveTo, '%USERPROFILE%', @UserProfileDir)
    Sleep(Int($Delay) * 1000)

	_ScreenCapture_Capture($SaveTo & '\' & @MDAY & '-' & @MON & '-' & @YEAR & '_' & @HOUR & '-' & @MIN & '.' & $FileFormat, Default, Default, @DesktopWidth, @DesktopHeight, $CaptureCursor <> "False")

    If $OpenImageAfter = 'True' Then
        ShellExecute($SaveTo & '\' & @MDAY & '-' & @MON & '-' & @YEAR & '_' & @HOUR & '-' & @MIN & '.' & $FileFormat)
    EndIf


; Create an extra
; Command line arguments:
; [2] Name
; [3] Path to Extra Builder


Case 'Browser'
	$GUI = GUICreate("Omnimo Information Hub", 535, 470, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_CLIPCHILDREN))
	GUISetBkColor(0x7A7A7A)

	_IEErrorHandlerRegister()
	$oIE = _IECreateEmbedded()
	$obj = GUICtrlCreateObj($oIE, 0, 25, 535, 445)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	$back = GUICtrlCreateButton("< Back", 3, 3, 60, 20, 0)

	_IENavigate($oIE, $CmdLine[2])
	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $back
				_IEAction($oIE, "back")
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
	WEnd



Case 'Create'
	If $CmdLine[0] < 3 Then OmnimoError("Error", "Too few command line arguments specified.")

	Const $EscapedName = StringRegExpReplace($CmdLine[2], '[\s\\/\*\?\:<>|\"]', "")
	Const $CreatedDir = $CmdLine[3] & "\Created\" & $EscapedName
	If FileExists($CreatedDir) Then
		$answer = MsgBox(52, "Extra Builder", "An extra with the selected name already exists. Overwrite?")
		If $answer = 7 Then Exit
	EndIf

	DirCopy($CmdLine[3] & "\Template", $CreatedDir, 1)
	FileCopy(IniRead($CmdLine[3] & "\Template\UserVariables.inc", "Variables", "ItemImage", ""), $CreatedDir & "\Item.png", 1)
	SendBang("!RefreshApp")
	SendBang("!ActivateConfig WP7\TextItems\Extra\ExtraBuilder\Created\" & $EscapedName & " Item.ini")


; File / Folder selector
; Command line arguments:
; [2] Image / File / Folder / App
; [3] Variable to write
; [4] Panel path
Case 'Select'
    Switch $CmdLine[2]
		Case 'File'
			If $CmdLine[0] > 5 Then
				$StartingDir = $CmdLine[6]
			Else
				$StartingDir = @UserProfileDir
			EndIf
			$file = FileOpenDialog("Choose a file", $StartingDir, "All files (*.*)", 1)
			If @error Then Exit
			IniWrite($CmdLine[4], "Variables", $CmdLine[3], $file)

		Case 'Image'
			If $CmdLine[0] > 5 Then
				$StartingDir = $CmdLine[6]
			Else
				$StartingDir = @UserProfileDir & "\Pictures"
			EndIf
			$file = FileOpenDialog("Choose an image", $StartingDir, "Images (*.png;*.jpg;*.jpeg;*.bmp)", 1)
			If @error Then Exit
			IniWrite($CmdLine[4], "Variables", $CmdLine[3], $file)
			SendBang("!Refresh " & $CmdLine[5])

		Case 'Folder'
			$folder = FileSelectFolder("Choose a folder", "", 1)
			If @error Then Exit
			$split = StringSplit($folder, "\")
			$FolderName = UBound($split) - 1
			$ConfigPath = StringReplace("WP7\", "WP7\@Resources\Config\", $CmdLine[4]) & "\UserVariables.inc"
			IniWrite($ConfigPath, "Variables", $CmdLine[3], $folder)
			IniWrite($ConfigPath, "Variables", "FolderName", $split[$FolderName])
			SendBang("!Refresh " & $CmdLine[5])

		Case 'App'
			$file = FileOpenDialog("Choose an application", @DesktopDir, "Apps (*.exe;*.lnk)", 1)
			If @error Then Exit
			; Get file extension, amazingly bullet-proof method
			$ext = StringRight($file, 3)
			If $ext = 'exe' Then
				$info = FileGetVersion($file, "ProductName")  ; Get program's name
				$path = $file
			ElseIf $ext = 'lnk' Then
				Global $szDrive, $szDir, $szFName, $szExt
				$TestPath = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
				$Shortcut = FileGetShortcut($file)
				$path = $Shortcut[0]
				$info = $TestPath[3]
			EndIf

			$ConfigPath = StringReplace("WP7\", "WP7\@Resources\Config\", $CmdLine[7]) & "\UserVariables.inc"
			IniWrite($ConfigPath, "Variables", $CmdLine[3], $path)
			IniWrite($ConfigPath, "Variables", $CmdLine[4], $info)

			; Open an icon select dialog
			$icon = FileOpenDialog("Choose an icon", $CmdLine[6] & '\WP7\@Resources\Graphics\Panels\Launcher\Icons', "Images (*.png;*.jpg;*.jpeg;*.bmp)", 1)
			If @error Then Exit

			IniWrite($ConfigPath, "Variables", $CmdLine[5], $icon)
			SendBang("!Refresh " & $CmdLine[8])
    EndSwitch


; Panel Combos config tool
; Command line arguments:
; [2] Skins path
Case 'PanelCombos'
	If $CmdLine[0] < 2 Then OmnimoError("Error", "Too few command line arguments specified.")

    ; Create GUI
    $Form1_1 = GUICreate("", 208, 316, -1, -1, BitOR($WS_VISIBLE, $WS_SYSMENU), $WS_EX_TOOLWINDOW)
    GUISetBkColor(0xE1E1E1)

    ; Options
    $Checkbox1 = GUICtrlCreateCheckbox("Bing", 8, 8, 73, 17)
    $Checkbox2 = GUICtrlCreateCheckbox("Reader", 8, 32, 73, 17)
    $Checkbox3 = GUICtrlCreateCheckbox("Reader2", 8, 56, 81, 17)
    $Checkbox4 = GUICtrlCreateCheckbox("WeirdReader", 8, 80, 89, 17)
    $Checkbox5 = GUICtrlCreateCheckbox("Launcher", 8, 104, 73, 17)
    $Checkbox6 = GUICtrlCreateCheckbox("Notes", 8, 128, 65, 17)
    $Checkbox7 = GUICtrlCreateCheckbox("Todolist", 8, 152, 89, 17)
    $Checkbox8 = GUICtrlCreateCheckbox("Facebook", 8, 176, 89, 17)
    $Checkbox9 = GUICtrlCreateCheckbox("Sys monitor", 8, 200, 97, 17)
    $Checkbox10 = GUICtrlCreateCheckbox("Gmail", 8, 224, 57, 17)
    $Checkbox11 = GUICtrlCreateCheckbox("Deviantart", 105, 8, 89, 17)
    $Checkbox12 = GUICtrlCreateCheckbox("System info", 105, 32, 89, 17)
    $Checkbox13 = GUICtrlCreateCheckbox("�Torrent", 105, 56, 89, 17)
    $Checkbox14 = GUICtrlCreateCheckbox("Weather", 105, 80, 89, 17)
    $Checkbox15 = GUICtrlCreateCheckbox("Movies", 105, 104, 65, 17)
    $Checkbox16 = GUICtrlCreateCheckbox("NowPlaying", 105, 128, 89, 17)
    $Checkbox17 = GUICtrlCreateCheckbox("World Clock", 105, 152, 89, 17)
    $Checkbox18 = GUICtrlCreateCheckbox("Websites", 105, 176, 81, 17)
    $Checkbox19 = GUICtrlCreateCheckbox("Youtube", 105, 200, 81, 17)
    $Checkbox20 = GUICtrlCreateCheckbox("Calendar", 105, 224, 57, 17)
    $Button1 = GUICtrlCreateButton("OK", 8, 250, 186, 33)

    $config = $CmdLine[2] & '\WP7\@Resources\Config\TextItems\UserVariables.inc'
    GUISetState(@SW_SHOW)

    ;I'm an expert on for loops
    For $k = 1 To 7
        Assign("toggle" & $k, IniRead($config, 'Variables', 'Toggle' & $k, ''), 2)
        Check_Enabled(Eval("toggle" & $k))
    Next
    Check_Disable()

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit
            ;Seriously, someone shoot this guy
            Case $Checkbox1
                Check_Disable()
            Case $Checkbox2
                Check_Disable()
            Case $Checkbox3
                Check_Disable()
            Case $Checkbox4
                Check_Disable()
            Case $Checkbox5
                Check_Disable()
            Case $Checkbox6
                Check_Disable()
            Case $Checkbox7
                Check_Disable()
            Case $Checkbox8
                Check_Disable()
            Case $Checkbox9
                Check_Disable()
            Case $Checkbox10
                Check_Disable()
            Case $Checkbox11
                Check_Disable()
            Case $Checkbox12
                Check_Disable()
            Case $Checkbox13
                Check_Disable()
            Case $Checkbox14
                Check_Disable()
            Case $Checkbox15
                Check_Disable()
            Case $Checkbox16
                Check_Disable()
            Case $Checkbox17
                Check_Disable()
            Case $Checkbox18
                Check_Disable()
            Case $Checkbox19
                Check_Disable()
            Case $Checkbox20
                Check_Disable()
            Case $Button1
                $count = 0
                ;Oh god, please make it stop
                If GUICtrlRead($Checkbox1) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Bing")
                EndIf
                If GUICtrlRead($Checkbox2) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Reader")
                EndIf
                If GUICtrlRead($Checkbox3) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Reader2")
                EndIf
                If GUICtrlRead($Checkbox4) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "WeirdReader")
                EndIf
                If GUICtrlRead($Checkbox5) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Launcher")
                EndIf
                If GUICtrlRead($Checkbox6) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Notes")
                EndIf
                If GUICtrlRead($Checkbox7) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Todolist")
                EndIf
                If GUICtrlRead($Checkbox8) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Facebook")
                EndIf
                If GUICtrlRead($Checkbox9) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "System")
                EndIf
                If GUICtrlRead($Checkbox10) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Gmail")
                EndIf
                If GUICtrlRead($Checkbox11) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Deviantart")
                EndIf
                If GUICtrlRead($Checkbox12) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "SystemInfo")
                EndIf
                If GUICtrlRead($Checkbox13) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "uTorrent")
                EndIf
                If GUICtrlRead($Checkbox14) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Weather")
                EndIf
                If GUICtrlRead($Checkbox15) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Movies")
                EndIf
                If GUICtrlRead($Checkbox16) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "NowPlaying")
                EndIf
                If GUICtrlRead($Checkbox17) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "WorldClock")
                EndIf
                If GUICtrlRead($Checkbox18) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Websites")
                EndIf
                If GUICtrlRead($Checkbox19) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Youtube")
                EndIf
                If GUICtrlRead($Checkbox20) = 1 Then
                    $count = $count + 1
                    IniWrite($config, 'Variables', 'Toggle' & $count, "Calendar")
                EndIf
				SendBang("!Refresh WP7\TextItems")
                Exit
        EndSwitch

    WEnd

EndSwitch

Func Check_Enabled($Toggle)
    Switch $Toggle
        Case "Bing"
            GUICtrlSetState($Checkbox1, $GUI_CHECKED)
        Case "Reader"
            GUICtrlSetState($Checkbox2, $GUI_CHECKED)
        Case "Reader2"
            GUICtrlSetState($Checkbox3, $GUI_CHECKED)
        Case "WeirdReader"
            GUICtrlSetState($Checkbox4, $GUI_CHECKED)
        Case "Launcher"
            GUICtrlSetState($Checkbox5, $GUI_CHECKED)
        Case "Notes"
            GUICtrlSetState($Checkbox6, $GUI_CHECKED)
        Case "Todolist"
            GUICtrlSetState($Checkbox7, $GUI_CHECKED)
        Case "Facebook"
            GUICtrlSetState($Checkbox8, $GUI_CHECKED)
        Case "System"
            GUICtrlSetState($Checkbox9, $GUI_CHECKED)
        Case "Gmail"
            GUICtrlSetState($Checkbox10, $GUI_CHECKED)
        Case "Deviantart"
            GUICtrlSetState($Checkbox11, $GUI_CHECKED)
        Case "SystemInfo"
            GUICtrlSetState($Checkbox12, $GUI_CHECKED)
        Case "uTorrent"
            GUICtrlSetState($Checkbox13, $GUI_CHECKED)
        Case "Weather"
            GUICtrlSetState($Checkbox14, $GUI_CHECKED)
        Case "Movies"
            GUICtrlSetState($Checkbox15, $GUI_CHECKED)
        Case "NowPlaying"
            GUICtrlSetState($Checkbox16, $GUI_CHECKED)
        Case "WorldClock"
            GUICtrlSetState($Checkbox17, $GUI_CHECKED)
        Case "Websites"
            GUICtrlSetState($Checkbox18, $GUI_CHECKED)
        Case "Youtube"
            GUICtrlSetState($Checkbox19, $GUI_CHECKED)
        Case "Calendar"
            GUICtrlSetState($Checkbox20, $GUI_CHECKED)
    EndSwitch
EndFunc   ;==>Check_Enabled

Func Check_Disable()
    $count = 0
    ; Such beautiful code
    For $m = 1 To 20
        If GUICtrlRead(Eval("Checkbox" & $m)) = 1 Then
            $count = $count + 1
        EndIf
    Next
    If $count > 6 Then
        ; Yeah, I'm gonna go stab myself in the eye with a fork now
        For $i = 1 To 20
            If GUICtrlRead(Eval("Checkbox" & $i)) <> 1 Then
                GUICtrlSetState(Eval("Checkbox" & $i), $GUI_DISABLE)
            EndIf
        Next
    Else
        ; Don't look at me I'm dead
        For $j = 1 To 20
            GUICtrlSetState(Eval("Checkbox" & $j), $GUI_ENABLE)
        Next
    EndIf

EndFunc   ;==>Check_Disable

Func _GetDisplayBrightness()
    $DISPLAY_BRIGHTNESS = DllStructCreate($tagDISPLAY_BRIGHTNESS)
    DllStructSetData($DISPLAY_BRIGHTNESS, "ucDisplayPolicy", 0x1)
    DllStructSetData($DISPLAY_BRIGHTNESS, "ucACBrightness", 0x20)
    DllStructSetData($DISPLAY_BRIGHTNESS, "ucDCBrightness", 0x20)
    DllCall( _
    "kernel32.dll", "int", _
    "DeviceIoControl", _
    "hwnd", $hLCD, _
    "int", $IOCTL_VIDEO_QUERY_DISPLAY_BRIGHTNESS, _
    "ptr", 0, _
    "int", 0, _
    "ptr", DllStructGetPtr($DISPLAY_BRIGHTNESS), _
    "int", DllStructGetSize($DISPLAY_BRIGHTNESS), _
    "int*", 0, _
    "ptr", 0 )
    Return SetError(@error, DllStructGetData($DISPLAY_BRIGHTNESS, "ucDCBrightness"), DllStructGetData($DISPLAY_BRIGHTNESS, "ucACBrightness"))
EndFunc ;==> _GetDisplayBrightness ( )

Func _SetDisplayBrightness($ac = -1, $dc = -1)
    $DISPLAY_BRIGHTNESS = DllStructCreate($tagDISPLAY_BRIGHTNESS)
    Local $policy = 0
    If $ac > -1 Then
        $policy += 1
        DllStructSetData($DISPLAY_BRIGHTNESS, "ucACBrightness", $ac)
    EndIf
    If $dc > -1 Then
        $policy += 2
        DllStructSetData($DISPLAY_BRIGHTNESS, "ucDCBrightness", $dc)
    EndIf
    DllStructSetData($DISPLAY_BRIGHTNESS, "ucDisplayPolicy", $policy)
    $ret = DllCall( _
            "kernel32.dll", "int", _
            "DeviceIoControl", _
            "hwnd", $hLCD, _
            "int", $IOCTL_VIDEO_SET_DISPLAY_BRIGHTNESS, _
            "ptr", DllStructGetPtr($DISPLAY_BRIGHTNESS), _
            "int", DllStructGetSize($DISPLAY_BRIGHTNESS), _
            "ptr", 0, _
            "int", 0, _
            "int*", 0, _
            "ptr", 0)
    Return SetError(@error, 0, $ret[0])
EndFunc   ;==>_SetDisplayBrightness

Func Monitor($io_control = "on")
    Local $WM_SYSCommand = 274
    Local $SC_MonitorPower = 61808
    Local $HWND = WinGetHandle('[CLASS:Progman]')
    Switch StringUpper($io_control)
        Case "OFF"
            DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND, "int", $WM_SYSCommand, "int", $SC_MonitorPower, "int", 2)
        Case "ON"
            DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND, "int", $WM_SYSCommand, "int", $SC_MonitorPower, "int", -1)
        Case Else
            MsgBox(32, @ScriptName, "Command usage: on/off")
    EndSwitch
EndFunc

Func _WU_ErrorHandler()
	; Do something more clever here?
	Exit
EndFunc ;==>_WU_ErrorHandler