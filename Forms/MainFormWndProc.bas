#include once "MainFormWndProc.bi"
#include once "win\windowsx.bi"
#include once "DisplayError.bi"
#include once "Resources.RH"

Const rgbRed As COLORREF = &h000000FF
Const rgbGreen As COLORREF = &h0000FF00
Const rgbBlue As COLORREF = &h00FF0000
Const rgbBlack As COLORREF = &h00000000
Const rgbWhite As COLORREF = &h00FFFFFF

Const MOVE_DX = 10
Const MOVE_DY = 10

Dim Shared MemoryDC As HDC
Dim Shared MemoryBM As HBITMAP
Dim Shared OldMemoryBM As HGDIOBJ
Dim Shared GreenPen As HPEN
Dim Shared BlueBrush As HBRUSH
Dim Shared OldPen As HGDIOBJ
Dim Shared OldBrush As HGDIOBJ

Dim Shared ShapeRectangle As RECT

Sub Render(ByVal hWin As HWND)
	' Прямоугольник обновления
	Dim UpdateRectangle As RECT = Any
	SetRect( _
		@UpdateRectangle, _
		ShapeRectangle.left - MOVE_DX - 1, _
		ShapeRectangle.top - MOVE_DY - 1, _
		ShapeRectangle.right + MOVE_DX + 1, _
		ShapeRectangle.bottom + MOVE_DY + 1 _
	)
	' Стираем старое изображение
	FillRect(MemoryDC, @UpdateRectangle, Cast(HBRUSH, GetStockObject(BLACK_BRUSH)))
	' Рисуем
	Ellipse(MemoryDC, ShapeRectangle.left, ShapeRectangle.top, ShapeRectangle.right, ShapeRectangle.bottom)
	' Выводим в окно
	InvalidateRect(hWin, @UpdateRectangle, FALSE)
End Sub

Function MainFormWndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	
	Select Case wMsg
		
		Case WM_CREATE
			Scope
				Dim hDC As HDC = GetDC(hWin)
				MemoryDC = CreateCompatibleDC(hDC)
				Dim ClientRect As RECT = Any
				GetClientRect(hWin, @ClientRect)
				MemoryBM = CreateCompatibleBitmap(hDC, ClientRect.right, ClientRect.bottom)
				ReleaseDC(hWin, hDC)
			End Scope
			
			GreenPen = CreatePen(PS_SOLID, 3, rgbGreen)
			BlueBrush = CreateSolidBrush(rgbBlue)
			
			OldMemoryBM = SelectObject(MemoryDC, MemoryBM)
			OldPen = SelectObject(MemoryDC, GreenPen)
			OldBrush = SelectObject(MemoryDC, BlueBrush)
			
			Render(hWin)
			
		' Case WM_LBUTTONDOWN
			' MainForm_LeftMouseDown(hWin, wParam, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam))
			
		Case WM_KEYDOWN
			Select Case wParam
				
				Case VK_LEFT
					OffsetRect(@ShapeRectangle, -MOVE_DX, 0)
					Render(hWin)
					
				Case VK_UP
					OffsetRect(@ShapeRectangle, 0, -MOVE_DY)
					Render(hWin)
					
				Case VK_RIGHT
					OffsetRect(@ShapeRectangle, MOVE_DX, 0)
					Render(hWin)
					
				Case VK_DOWN
					OffsetRect(@ShapeRectangle, 0, MOVE_DY)
					Render(hWin)
					
				Case VK_ESCAPE
					DestroyWindow(hWin)
					
			End Select
			
		' Case WM_TIMER
			' Select Case wParam
				
				' Case RightEnemyDealCardTimer
					' RightEnemyDealCardTimer_Tick(hWin)
					
			' End Select
			
		Case WM_ERASEBKGND
			Return TRUE
			
		Case WM_PAINT
			Dim ps As PAINTSTRUCT = Any
			Dim hDC As HDC = BeginPaint(hWin, @ps)
			
			BitBlt( _
				hDC, _
				ps.rcPaint.left, ps.rcPaint.top, ps.rcPaint.right, ps.rcPaint.bottom, _
				MemoryDC, _
				ps.rcPaint.left, ps.rcPaint.top, _
				SRCCOPY _
			)
			
			EndPaint(hWin, @ps)
			
		Case WM_DESTROY
			SelectObject(MemoryDC, OldMemoryBM)
			SelectObject(MemoryDC, OldBrush)
			SelectObject(MemoryDC, OldPen)
			DeleteObject(BlueBrush)
			DeleteObject(GreenPen)
			DeleteObject(MemoryBM)
			DeleteDC(MemoryDC)
			PostQuitMessage(0)
			
		Case Else
			Return DefWindowProc(hWin, wMsg, wParam, lParam)
			
	End Select
	
	Return 0
	
End Function
