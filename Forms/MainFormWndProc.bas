#include "MainFormWndProc.bi"
#include "win\windowsx.bi"
#include "MainFormEvents.bi"
#include "Resources.RH"

Function MainFormWndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	
	Select Case wMsg
		
		Case WM_CREATE
			MainForm_Load(hWin, wParam, lParam)
			
		Case WM_COMMAND
			' DebugMessageBoxValue(LoWord(wParam), "Дочернее окно")
			Select Case HiWord(wParam)
				
				Case 0 ' Меню или кнопка
					Select Case LoWord(wParam)
						
						Case IDM_FULLSCREEN
							MenuFileFullScreen_Click(hWin)
						
						Case IDM_FILE_EXIT
							MenuFileExit_Click(hWin)
						
					End Select
					
				Case 1 ' Акселератор
					Select Case LoWord(wParam)
						
						Case IDA_FULLSCREEN
							MenuFileFullScreen_Click(hWin)
							
					End Select
					
				' Case Else ' Элемент управления
					
			End Select
			
		' Case WM_LBUTTONDOWN
			' MainForm_LeftMouseDown(hWin, wParam, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam))
			
		' Case WM_KEYDOWN
			' Select Case wParam
				
				' Case VK_RETURN
					
			' End Select
			
		' Case WM_TIMER
			' Select Case wParam
				
				' Case RightEnemyDealCardTimer
					' RightEnemyDealCardTimer_Tick(hWin)
					
			' End Select
			
		' Case WM_PAINT
			' MainForm_Paint(hWin)
			
		' Case WM_DRAWITEM 
			' MainForm_DrawItem(hWin, Cast(HWND, wParam), CPtr(DRAWITEMSTRUCT Ptr, lParam))
			
		' Case WM_SIZE
			' MainForm_ReSize(hWin, wParam, LoWord(lParam), HiWord(lParam))
			
		' Case WM_CLOSE
			' MainForm_Close(hWin)
			
		Case WM_DESTROY
			MainForm_UnLoad(hWin)
			PostQuitMessage(0)
			
		' Case WM_CTLCOLORSTATIC
			' MainForm_StaticControlTextColor(hWin, Cast(HWND, lParam), Cast(HDC, wParam))
			
		Case Else
			Return DefWindowProc(hWin, wMsg, wParam, lParam)
			
	End Select
	
	Return 0
	
End Function
