#include "EntryPoint.bi"
#include "WinMain.bi"

#ifdef WITHOUT_RUNTIME
Sub EntryPoint Alias "EntryPoint"()
#endif
	
	Dim RetCode As Long = wWinMain( _
		GetModuleHandle(0), _
		NULL, _
		GetCommandLineW(), _
		SW_SHOW _
	)
	
	#ifdef WITHOUT_RUNTIME
		ExitProcess(RetCode)
	#else
		End(RetCode)
	#endif
	
#ifdef WITHOUT_RUNTIME
End Sub
#endif
