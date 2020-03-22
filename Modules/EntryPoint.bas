#include "EntryPoint.bi"
#include "WinMain.bi"
#include "win\shellapi.bi"

Function MainEntryPoint()As Integer
	Dim ArgsCount As DWORD = Any
	Dim ppArgs As WString Ptr Ptr = CommandLineToArgvW(GetCommandLine(), @ArgsCount)
	
	Dim WinMainResult As Integer = WinMain(GetModuleHandle(0), NULL, ppArgs, CInt(ArgsCount), SW_SHOW)
	
	LocalFree(ppArgs)
	
	Return WinMainResult
	
End Function

#ifdef WITHOUT_RUNTIME

Sub EntryPoint Alias "EntryPoint"()
	
	ExitProcess(MainEntryPoint)
	
End Sub

#else

End(MainEntryPoint)

#endif
