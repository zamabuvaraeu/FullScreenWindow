#ifndef DISPLAYSETTINGSLIST_BI
#define DISPLAYSETTINGSLIST_BI

#include once "windows.bi"

Type DevmodeNode
	NextNode As DevmodeNode Ptr
	DeviceMode As DEVMODE
End Type

Declare Function GetDisplaySettingsList( _
	ByVal hHeap As HANDLE _
)As DevmodeNode Ptr

#endif
