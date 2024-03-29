#include once "DisplaySettingsList.bi"

Function CreateDevmodeNode( _
		ByVal hHeap As HANDLE _
	)As DevmodeNode Ptr
	
	Dim pNode As DevmodeNode Ptr = HeapAlloc( _
		hHeap, _
		HEAP_NO_SERIALIZE, _
		SizeOf(DevmodeNode) _
	)
	If pNode <> NULL Then
		pNode->NextNode = NULL
		pNode->DeviceMode.dmSize = SizeOf(DEVMODE)
	End If
	
	Return pNode
	
End Function

Function GetDisplaySettingsList( _
		ByVal hHeap As HANDLE _
	)As DevmodeNode Ptr
	
	Dim pNodeList As DevmodeNode Ptr = CreateDevmodeNode(hHeap)
	If pNodeList = NULL Then
		Return NULL
	End If
	
	Dim dwModeNumber As DWORD = 0 ' ENUM_CURRENT_SETTINGS
	Dim bres As BOOL = EnumDisplaySettings( _
		NULL, _
		dwModeNumber, _
		@pNodeList->DeviceMode _
	)
	
	Dim pNode As DevmodeNode Ptr = pNodeList
	Do While bres
		pNode->NextNode = CreateDevmodeNode(hHeap)
		If pNode->NextNode = NULL Then
			Return NULL
		End If
		
		dwModeNumber += 1
		bres = EnumDisplaySettings( _
			NULL, _
			dwModeNumber, _
			@pNode->NextNode->DeviceMode _
		)
		If bres = False Then
			HeapFree( _
				hHeap, _
				HEAP_NO_SERIALIZE, _
				pNode->NextNode _
			)
			pNode->NextNode = NULL
		Else
			pNode = pNode->NextNode
		End If
	Loop
	
	Return pNodeList
	
End Function
