#include "DisplaySettingsDialogProc.bi"
#include "Resources.RH"

Function DisplaySettingsDialogProc( _
		ByVal hwndDlg As HWND, _
		ByVal uMsg As UINT, _
		ByVal wParam As WPARAM, _
		ByVal lParam As LPARAM _
	)As INT_PTR
	
	Select Case uMsg
		
		Case WM_INITDIALOG
			Dim DeviceMode As DEVMODE = Any
			DeviceMode.dmSize = SizeOf(DEVMODE)
			
			Dim dwModeNumber As DWORD = 0
			Dim bres As BOOL = EnumDisplaySettings( _
				NULL, _
				dwModeNumber, _
				@DeviceMode _
			)
			Do While bres
				Dim buffer(1024) As TCHAR = Any
				wsprintf( _
					@buffer(0), _
					__TEXT("%u x %u, %u BPP, %u HZ"), _
					DeviceMode.dmPelsWidth, _
					DeviceMode.dmPelsHeight, _
					DeviceMode.dmBitsPerPel, _
					DeviceMode.dmDisplayFrequency _
				)
				SendMessage( _
					GetDlgItem(hwndDlg, IDC_LST_DISPLAY), _
					LB_ADDSTRING, _
					0, _
					Cast(LPARAM, @buffer(0)) _
				)
				
				dwModeNumber += 1
				bres = EnumDisplaySettings( _
					NULL, _
					dwModeNumber, _
					@DeviceMode _
				)
			Loop
			
		Case WM_COMMAND
			Select Case LOWORD(wParam)
				
				Case IDC_BTN_RESULT
					EndDialog(hwndDlg, 2)
					
				Case IDCANCEL
					EndDialog(hwndDlg, 1)
					
			End Select
			
		Case WM_CLOSE
			EndDialog(hwndDlg, 1)
			
		Case Else
			Return False
			
	End Select
	
	Return True
	
End Function
