#include once "WinMain.bi"
#include once "win\commctrl.bi"
#include once "DisplaySettingsDialogProc.bi"
#include once "DisplaySettingsList.bi"
#include once "MainFormWndProc.bi"
#include once "Resources.RH"
#include once "DisplayError.bi"

Const MainWindowClassName = __TEXT("FullScreenWindow")

Const COMMONCONTROLS_ERRORSTRING = __TEXT("Failed to register Common Controls")
Const REGISTERWINDOWCLASS_ERRORSTRING = __TEXT("Failed to register WNDCLASSEX")
Const CREATEWINDOW_ERRORSTRING = __TEXT("Failed to create Main Window")
Const GETMESSAGE_ERRORSTRING = __TEXT("Error in GetMessage")
Const CHANGEDISPLAYSETTINGS_ERRORSTRING = __TEXT("Failed to ChangeDisplaySettings")
Const DIALOGBOXPARAM_ERRORSTRING = __TEXT("Failed to DialogBoxParam")

Function MessageLoop()As Integer
	
	Dim wMsg As MSG = Any
	Dim GetMessageResult As Integer = GetMessage(@wMsg, NULL, 0, 0)
	
	Do While GetMessageResult <> 0
		
		If GetMessageResult = -1 Then
			DisplayError(GetLastError(), GETMESSAGE_ERRORSTRING)
			Return 1
		End If
		
		TranslateMessage(@wMsg)
		DispatchMessage(@wMsg)
		
		GetMessageResult = GetMessage(@wMsg, NULL, 0, 0)
		
	Loop
	
	Return wMsg.WPARAM
	
End Function

Function RegisterWindowClass( _
		Byval hInst As HINSTANCE _
	)As Integer
	
	Dim wcls As WNDCLASSEX = Any
	With wcls
		.cbSize        = SizeOf(WNDCLASSEX)
		' .style         = 0
		.style         = CS_HREDRAW Or CS_VREDRAW
		.lpfnWndProc   = @MainFormWndProc
		.cbClsExtra    = 0
		.cbWndExtra    = 0
		.hInstance     = hInst
		.hIcon         = LoadIcon(hInst, Cast(TCHAR Ptr, IDI_MAIN))
		.hCursor       = LoadCursor(NULL, IDC_ARROW)
		' .hbrBackground = Cast(HBRUSH, GetStockObject(BLACK_BRUSH))
		.hbrBackground = NULL
		.lpszMenuName  = NULL
		.lpszClassName = StrPtr(MainWindowClassName)
		.hIconSm       = NULL
	End With
	
	Dim regAtom As ATOM = RegisterClassEx(@wcls)
	If regAtom = 0 Then
		DisplayError(GetLastError(), REGISTERWINDOWCLASS_ERRORSTRING)
		Return 1
	End If
	
	Return 0
	
End Function

Function RegisterControls60()As Integer
	
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
	
	Dim resInitControls As BOOL = InitCommonControlsEx(@icc)
	If resInitControls = 0 Then
		DisplayError(GetLastError(), COMMONCONTROLS_ERRORSTRING)
		Return 1
	End If
	
End Function

Function CreateMainWindow( _
		Byval hInst As HINSTANCE, _
		ByVal WindowWidth As Long, _
		ByVal WindowHeight As Long, _
		ByVal iCmdShow As Long _
	)As Long
	
	Const WindowPositionX As Long = 0
	Const WindowPositionY As Long = 0
	Const StyleEx As DWORD = 0
	Const Style As DWORD = WS_POPUP
	
	'Const StyleEx As DWORD = WS_EX_OVERLAPPEDWINDOW ' 0
	'Const Style As DWORD = WS_OVERLAPPEDWINDOW ' WS_POPUP
	
	Dim hWndMain As HWND = CreateWindowEx( _
		StyleEx, _
		StrPtr(MainWindowClassName), _
		StrPtr(MainWindowClassName), _
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
		DisplayError(GetLastError(), CREATEWINDOW_ERRORSTRING)
		Return 1
	End If
	
	ShowWindow(hWndMain, iCmdShow)
	UpdateWindow(hWndMain)
	
End Function

Function GetDisplayResolution( _
		Byval hInst As HINSTANCE, _
		ByVal pResolution As SIZE Ptr _
	)As Integer
	
	Dim pNodeList As DevmodeNode Ptr = GetDisplaySettingsList(GetProcessHeap())
	
	Dim DialogBoxParamResult As INT_PTR = DialogBoxParam( _
		hInst, _
		MAKEINTRESOURCE(IDD_DLG_DISPLAYSETTINGS), _
		NULL, _
		@DisplaySettingsDialogProc, _
		Cast(LPARAM, pNodeList) _
	)
	If DialogBoxParamResult = -1 Then
		DisplayError(GetLastError(), DIALOGBOXPARAM_ERRORSTRING)
		Return 1
	End If
	
	If DialogBoxParamResult = 0 Then
		Return 0
	End If
	
	Dim pNode As DevmodeNode Ptr = pNodeList
	For i As Integer = 1 To DialogBoxParamResult - 1
		pNode = pNode->NextNode
	Next
	
	pNode->DeviceMode.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
	
	Dim r As Long = ChangeDisplaySettings(@pNode->DeviceMode, CDS_FULLSCREEN)
	If r <> DISP_CHANGE_SUCCESSFUL Then
		DisplayError(r, CHANGEDISPLAYSETTINGS_ERRORSTRING)
		Return 1
	End If
	
	pResolution->cx = pNode->DeviceMode.dmPelsWidth
	pResolution->cy = pNode->DeviceMode.dmPelsHeight
	
	Return 0
	
End Function

Function wWinMain Alias "wWinMain"( _
		Byval hInst As HINSTANCE, _
		ByVal hPrevInstance As HINSTANCE, _
		ByVal lpCmdLine As LPWSTR, _
		ByVal iCmdShow As Long _
	)As Long
	
	Dim resControls As Long = RegisterControls60()
	If resControls > 0 Then
		Return resControls
	End If
	
	Dim resRegister As Long = RegisterWindowClass(hInst)
	If resRegister > 0 Then
		Return resRegister
	End If
	
	Dim Resolution As SIZE = Any
	Dim resDisplayResolution As Integer = GetDisplayResolution( _
		hInst, _
		@Resolution _
	)
	If resDisplayResolution > 0 Then
		Return resDisplayResolution
	End If
	
	'Dim WindowWidth As Long = 640
	'Dim WindowHeight As Long = 480
	Dim resCreateWindow As Integer = CreateMainWindow( _
		hInst, _
		Resolution.cx, _
		Resolution.cy, _
		iCmdShow _
	)
	If resCreateWindow > 0 Then
		Return resCreateWindow
	End If
	
	Dim resMessageLoop As Integer = MessageLoop()
	
	ChangeDisplaySettings(NULL, 0)
	
	Return resMessageLoop
	
End Function
