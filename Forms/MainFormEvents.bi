#ifndef MAINFORMEVENTS_BI
#define MAINFORMEVENTS_BI

#include "windows.bi"

' Меню

Declare Sub MenuFileFullScreen_Click(ByVal hWin As HWND)

Declare Sub MenuFileExit_Click(ByVal hWin As HWND)

' События формы

Declare Sub MainForm_Load(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_UnLoad(ByVal hWin As HWND)

Declare Sub MainForm_LeftMouseDown(ByVal hWin As HWND, ByVal KeyModifier As Integer, ByVal X As Integer, ByVal Y As Integer)

Declare Sub MainForm_KeyDown(ByVal hWin As HWND, ByVal KeyCode As Integer)

Declare Sub MainForm_Paint(ByVal hWin As HWND)

Declare Sub MainForm_Resize(ByVal hWin As HWND, ByVal ResizingRequested As Integer, ByVal ClientWidth As Integer, ByVal ClientHeight As Integer)

Declare Sub MainForm_Close(ByVal hWin As HWND)

Declare Sub MainForm_DrawItem(ByVal hWin As HWND, ByVal hwndControl As HWND, ByVal pDrawItemStruct As DRAWITEMSTRUCT Ptr)

#endif
