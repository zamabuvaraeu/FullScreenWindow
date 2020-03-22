#include "MainFormEvents.bi"
#include "DisplayError.bi"

Dim Shared FullScreenMode As Boolean
Dim Shared Placement As WINDOWPLACEMENT

Sub MainFormMenuFileFullScreen_Click(ByVal hWin As HWND)
	If FullScreenMode Then
		SetWindowPlacement(hWin, @Placement) ' Загружаем парметры предыдущего оконного режима
		SetWindowLong(hWin, GWL_STYLE, WS_OVERLAPPEDWINDOW) ' Устанавливаем стили окнного режима
		' SetWindowLong(hWnd, GWL_EXSTYLE, 0L)
		ShowWindow(hWin, SW_SHOWDEFAULT) ' Показываем обычное окно
		FullScreenMode = False
	Else
		GetWindowPlacement(hWin, @Placement) ' Сохраняем параметры оконного режима
		SetWindowLong(hWin, GWL_STYLE, WS_POPUP) ' Устанавливаем новые стили
		' SetWindowLong(hWin, GWL_EXSTYLE, WS_EX_TOPMOST) ' Устанавливаем новые стили
		ShowWindow(hWin, SW_SHOWMAXIMIZED) ' Окно во весь экран
		FullScreenMode = True
	End If
End Sub

Sub MainFormMenuFileExit_Click(ByVal hWin As HWND)
	
	DestroyWindow(hWin)
	
End Sub

Sub MainForm_Load(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)
	Placement.length = SizeOf(WINDOWPLACEMENT)
End Sub

Sub MainForm_UnLoad(ByVal hWin As HWND)
	
End Sub

Sub MainForm_Close(ByVal hWin As HWND)
	
	DestroyWindow(hWin)
	
End Sub
