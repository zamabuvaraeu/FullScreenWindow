#include once "MainFormWndProc.bi"
#include once "win\windowsx.bi"
#include once "DisplayError.bi"
#include once "GdiMatrix.bi"
#include once "Resources.RH"

Const rgbGreen As COLORREF = &h0000FF00
Const rgbBlue As COLORREF = &h00FF0000

Const MOVE_DX As Integer = 10
Const MOVE_DY As Integer = 10

Const EllipseHeight As Long = 100
Const EllipseWidth As Long = 100

Enum MoveDirections
	MoveDirectionRight
	MoveDirectionUp
	MoveDirectionLeft
	MoveDirectionDown
End Enum

Dim Shared MemoryDC As HDC
Dim Shared MemoryBM As HBITMAP
Dim Shared OldMemoryBM As HGDIOBJ
Dim Shared GreenPen As HPEN
Dim Shared BlueBrush As HBRUSH
Dim Shared OldPen As HGDIOBJ
Dim Shared OldBrush As HGDIOBJ

Dim Shared SceneRectangle As RECT
Dim Shared Matrix As XFORM	

Sub DrawEllipse(ByVal hDC As HDC)
	Ellipse( _
		hDC, _
		-1 * EllipseWidth / 2, _
		-1 * EllipseHeight / 2, _
		EllipseWidth / 2, _
		EllipseHeight / 2 _
	)
End Sub

Sub ClearScene()
	
	FillRect( _
		MemoryDC, _
		@SceneRectangle, _
		Cast(HBRUSH, GetStockObject(BLACK_BRUSH)) _
	)
	
End Sub

Sub RenderScene()
	
	ModifyWorldTransform(MemoryDC, @Matrix, MWT_LEFTMULTIPLY)
	
	DrawEllipse(MemoryDC)
	
	ModifyWorldTransform(MemoryDC, NULL, MWT_IDENTITY)
	
End Sub

Sub ChangeScene(ByVal hWin As HWND, ByVal Direction As MoveDirections)
	
	ClearScene()
	
	Select Case Direction
		
		Case MoveDirections.MoveDirectionRight
			MatrixApplyTranslate(@Matrix, CSng(MOVE_DX), 0.0)
			
		Case MoveDirections.MoveDirectionUp
			MatrixApplyTranslate(@Matrix, 0.0, -1.0 * CSng(MOVE_DY))
			
		Case MoveDirections.MoveDirectionLeft
			MatrixApplyTranslate(@Matrix, -1.0 * CSng(MOVE_DX), 0.0)
			
		Case MoveDirections.MoveDirectionDown
			MatrixApplyTranslate(@Matrix, 0.0, CSng(MOVE_DY))
			
	End Select
	
	RenderScene()
	
	InvalidateRect( _
		hWin, _
		NULL, _
		FALSE _
	)
End Sub

Function MainFormWndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	
	Select Case wMsg
		
		Case WM_CREATE
			GreenPen = CreatePen(PS_SOLID, 3, rgbGreen)
			BlueBrush = CreateSolidBrush(rgbBlue)
			
			Scope
				Dim hDC As HDC = GetDC(hWin)
				MemoryDC = CreateCompatibleDC(hDC)
				SetGraphicsMode(MemoryDC, GM_ADVANCED)
				
				Dim ClientRect As RECT = Any
				GetClientRect(hWin, @ClientRect)
				SceneRectangle = ClientRect
				
				MatrixSetIdentity(@Matrix)
				MatrixApplyTranslate(@Matrix, CSng(ClientRect.right / 2), CSng(ClientRect.bottom / 2))
				
				MemoryBM = CreateCompatibleBitmap(hDC, ClientRect.right, ClientRect.bottom)
				OldMemoryBM = SelectObject(MemoryDC, MemoryBM)
				
				
				ReleaseDC(hWin, hDC)
			End Scope
			
			OldPen = SelectObject(MemoryDC, GreenPen)
			OldBrush = SelectObject(MemoryDC, BlueBrush)
			
			RenderScene()
			
		Case WM_KEYDOWN
			
			Select Case wParam
				
				Case VK_LEFT
					ChangeScene(hWin, MoveDirections.MoveDirectionLeft)
					
				Case VK_UP
					ChangeScene(hWin, MoveDirections.MoveDirectionUp)
					
				Case VK_RIGHT
					ChangeScene(hWin, MoveDirections.MoveDirectionRight)
					
				Case VK_DOWN
					ChangeScene(hWin, MoveDirections.MoveDirectionDown)
					
				Case VK_ESCAPE
					DestroyWindow(hWin)
					
			End Select
			
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
