#ifndef MAINFORMWNDPROC_BI
#define MAINFORMWNDPROC_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"

Declare Function MainFormWndProc( _
	ByVal hWnd As HWND, _
	ByVal wMsg As UINT, _
	ByVal wParam As WPARAM, _
	ByVal lParam As LPARAM _
) As LRESULT

#endif
