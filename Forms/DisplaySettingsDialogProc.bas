#include once "DisplaySettingsDialogProc.bi"
#include once "DisplaySettingsList.bi"
#include once "Resources.RH"

Function DisplaySettingsDialogProc( _
		ByVal hwndDlg As HWND, _
		ByVal uMsg As UINT, _
		ByVal wParam As WPARAM, _
		ByVal lParam As LPARAM _
	)As INT_PTR
	
	Dim hListBox As HWND = GetDlgItem(hwndDlg, IDC_LST_DISPLAY)
	
	Select Case uMsg
		
		Case WM_INITDIALOG
			Dim pNodeList As DevmodeNode Ptr = Cast(DevmodeNode Ptr, lParam)
			Dim pNode As DevmodeNode Ptr = pNodeList
			
			Do While pNode <> NULL
				Dim buffer(1024) As TCHAR = Any
				wsprintf( _
					@buffer(0), _
					__TEXT("%u x %u, %u BPP, %u HZ"), _
					pNode->DeviceMode.dmPelsWidth, _
					pNode->DeviceMode.dmPelsHeight, _
					pNode->DeviceMode.dmBitsPerPel, _
					pNode->DeviceMode.dmDisplayFrequency _
				)
				SendMessage( _
					hListBox, _
					LB_ADDSTRING, _
					0, _
					Cast(LPARAM, @buffer(0)) _
				)
				
				pNode = pNode->NextNode
			Loop
			
		Case WM_COMMAND
			Select Case LOWORD(wParam)
				
				Case IDC_LST_DISPLAY
					Select Case HIWORD(wParam)
						
						Case LBN_DBLCLK
							Dim uSelectedIndex As Long = Cast(Long, SendMessage(hListBox, LB_GETCURSEL, 0, 0))
							
							If uSelectedIndex <> LB_ERR Then
								EndDialog(hwndDlg, uSelectedIndex + 1)
							End If
							
						Case LBN_SELCHANGE
							Dim uSelectedIndex As Long = Cast(Long, SendMessage(hListBox, LB_GETCURSEL, 0, 0))
							
							If uSelectedIndex = LB_ERR Then
								EnableWindow(GetDlgItem(hwndDlg, IDOK), False)
							Else
								EnableWindow(GetDlgItem(hwndDlg, IDOK), True)
							End If
							
					End Select
					
				Case IDOK
					' Dim buffer(1024) As TCHAR = Any
					
					' // ���������� ����� ���������� ������
					Dim uSelectedIndex As Long = Cast(Long, SendMessage(hListBox, LB_GETCURSEL, 0, 0))
					
					' // ���� � ������ ���� ���������� ������,
					' // ������� �� �� ����� 
					If uSelectedIndex <> LB_ERR Then
						' // �������� ���������� ������
						' SendMessage(hListBox, LB_GETTEXT, uSelectedIndex, Cast(LPARAM, @buffer(0)))
						
						' // ������� �� �� �����  
						' MessageBox(hwndDlg, @Buffer(0), NULL, MB_OK)
						EndDialog(hwndDlg, uSelectedIndex + 1)
					End If
					
				Case IDCANCEL
					EndDialog(hwndDlg, 0)
					
			End Select
			
		Case WM_CLOSE
			EndDialog(hwndDlg, 0)
			
		Case Else
			Return False
			
	End Select
	
	Return True
	
End Function
