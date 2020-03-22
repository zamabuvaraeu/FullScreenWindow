#include "EntryPoint.bi"
#include "WinMain.bi"
#include "win\shellapi.bi"

Function MainEntryPoint()As Integer
	Dim ArgsCount As DWORD = Any
	Dim ppArgs As WString Ptr Ptr = CommandLineToArgvW(GetCommandLine(), @ArgsCount)
	
	Dim si As STARTUPINFO = Any
	GetStartupInfo(@si)
	
	Dim WinMainResult As Integer = WinMain( _
		GetModuleHandle(0), _
		NULL, _
		ppArgs, _
		CInt(ArgsCount), _
		si.wShowWindow _
	)
	
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
