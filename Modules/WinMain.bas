#include "WinMain.bi"
#include "win\commctrl.bi"
#include "MainFormWndProc.bi"
#include "Resources.RH"
#include "DisplayError.bi"

Const BackColor As Integer = &h006400
Const MainWindowClassName = "MainWindow"

Const COMMONCONTROLS_ERRORSTRING = "Failed to register Common Controls"
Const LOADACCELERATORS_ERRORSTRING = "Failed to load Accelerators"
Const CREATEBRUSH_ERRORSTRING = "Failed to create BackColorBrush"
Const REGISTERWINDOWCLASS_ERRORSTRING = "Failed to register WNDCLASSEX"
Const CREATEWINDOW_ERRORSTRING = "Failed to create Main Window"
Const GETMESSAGE_ERRORSTRING = "Error in GetMessage"
Const CHANGEDISPLAYSETTINGS_ERRORSTRING = "Failed to ChangeDisplaySettings"

Function WinMain( _
		Byval hInst As HINSTANCE, _
		ByVal hPrevInstance As HINSTANCE, _
		ByVal Args As WString Ptr Ptr, _
		ByVal ArgsCount As Integer, _
		ByVal iCmdShow As Integer _
	) As Integer
	
	Scope
		Dim icc As INITCOMMONCONTROLSEX = Any
		icc.dwSize = SizeOf(INITCOMMONCONTROLSEX)
		icc.dwICC = ICC_ANIMATE_CLASS Or _
			ICC_BAR_CLASSES Or _
			ICC_COOL_CLASSES Or _
			ICC_DATE_CLASSES Or _
			ICC_HOTKEY_CLASS Or _
			ICC_INTERNET_CLASSES Or _
			ICC_LINK_CLASS Or _
			ICC_LISTVIEW_CLASSES Or _
			ICC_NATIVEFNTCTL_CLASS Or _
			ICC_PAGESCROLLER_CLASS Or _
			ICC_PROGRESS_CLASS Or _
			ICC_STANDARD_CLASSES Or _
			ICC_TAB_CLASSES Or _
			ICC_TREEVIEW_CLASSES Or _
			ICC_UPDOWN_CLASS Or _
			ICC_USEREX_CLASSES Or _
		ICC_WIN95_CLASSES
		
		If InitCommonControlsEx(@icc) = False Then
			DisplayError(GetLastError(), @COMMONCONTROLS_ERRORSTRING)
			Return 1
		End If
	End Scope
	
	Scope
		Dim BackColorBrush As HBRUSH = CreateSolidBrush(BackColor)
		If BackColorBrush = NULL Then
			DisplayError(GetLastError(), @CREATEBRUSH_ERRORSTRING)
			Return 1
		End If
		
		Dim wcls As WNDCLASSEX = Any
		With wcls
			.cbSize        = SizeOf(WNDCLASSEX)
			.style         = 0 ' CS_HREDRAW Or CS_VREDRAW
			.lpfnWndProc   = @MainFormWndProc
			.cbClsExtra    = 0
			.cbWndExtra    = 0
			.hInstance     = hInst
			.hIcon         = LoadIcon(hInst, Cast(WString Ptr, IDI_MAIN))
			.hCursor       = LoadCursor(NULL, IDC_ARROW)
			.hbrBackground = BackColorBrush
			.lpszMenuName  = NULL ' Cast(WString Ptr, IDM_MENU)
			.lpszClassName = @MainWindowClassName
			.hIconSm       = NULL
		End With
		
		If RegisterClassEx(@wcls) = FALSE Then
			DisplayError(GetLastError(), @CHANGEDISPLAYSETTINGS_ERRORSTRING)
			Return 1
		End If
	End Scope
	
	Dim WindowWidth As Long = GetSystemMetrics(SM_CXSCREEN)
	Dim WindowHeight As Long = GetSystemMetrics(SM_CYSCREEN)
	
	Scope
		Dim DeviceMode As DEVMODE = Any
		With DeviceMode
			.dmSize = SizeOf(DEVMODE)
			' .dmPelsWidth = 1680
			' .dmPelsHeight = 1050
			.dmPelsWidth = WindowWidth
			.dmPelsHeight = WindowHeight
			.dmBitsPerPel = 32
			.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
		End With
		
		Dim r As Long = ChangeDisplaySettings(@DeviceMode, CDS_FULLSCREEN)
		If r <> DISP_CHANGE_SUCCESSFUL Then
			DisplayError(r, @REGISTERWINDOWCLASS_ERRORSTRING)
			Return 1
		End If
	End Scope

	Dim NineWindowTitle As WString * 256 = Any
	LoadString(hInst, IDS_WINDOWTITLE, @NineWindowTitle, 255)
	
	Dim hAccel As HACCEL = LoadAccelerators(hInst, Cast(WString Ptr, IDA_ACCEL))
	If hAccel = NULL Then
		DisplayError(GetLastError(), @LOADACCELERATORS_ERRORSTRING)
		Return 1
	End If
	
	Const WindowPositionX As Integer = 0
	Const WindowPositionY As Integer = 0
	Const Style As DWORD = WS_POPUP
	Const StyleEx As DWORD = 0
	
	Dim hWndMain As HWND = CreateWindowEx( _
		StyleEx, _
		@MainWindowClassName, _
		@NineWindowTitle, _
		Style, _
		WindowPositionX, _
		WindowPositionY, _
		WindowWidth, _
		WindowHeight, _
		NULL, _
		Cast(HMENU, NULL), _
		hInst, _
		NULL _
	)
	If hWndMain = NULL Then
		DisplayError(GetLastError(), @CREATEWINDOW_ERRORSTRING)
		Return 1
	End If
	
	ShowWindow(hWndMain, iCmdShow)
	UpdateWindow(hWndMain)
	
	Dim wMsg As MSG = Any
	Dim GetMessageResult As Integer = GetMessage(@wMsg, NULL, 0, 0)
	
	Do While GetMessageResult <> 0
		
		If GetMessageResult = -1 Then
			DisplayError(GetLastError(), @GETMESSAGE_ERRORSTRING)
			Return 1
		End If
		
		If TranslateAccelerator(hWndMain, hAccel, @wMsg) = 0 Then
			TranslateMessage(@wMsg)
			DispatchMessage(@wMsg)
		End If
		
		GetMessageResult = GetMessage(@wMsg, NULL, 0, 0)
		
	Loop
	
	ChangeDisplaySettings(NULL, 0)
	
	Return wMsg.WPARAM
	
End Function
