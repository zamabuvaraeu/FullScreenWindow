#include "DisplayError.bi"
#include "IntegerToWString.bi"

Sub DisplayError( _
		ByVal dwErrorCode As DWORD, _
		ByVal Caption As WString Ptr _
	)
	
	Dim Buffer As WString * 100 = Any
	itow(dwErrorCode, @Buffer, 10)
	
	MessageBox(0, @Buffer, Caption, MB_ICONERROR)
	
End Sub
