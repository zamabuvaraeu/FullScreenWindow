#include once "GdiMatrix.bi"

Sub MatrixSetTranslate( _
		ByVal m As XFORM Ptr, _
		ByVal dx As Single, _
		ByVal dy As Single _
	)
	
	m->eM11 = 1.0 : m->eM21 = 0.0 : m->eDx = dx
	m->eM12 = 0.0 : m->eM22 = 1.0 : m->eDy = dy
	' 0           : 0             : 1
	
End Sub

Sub MatrixSetIdentity( _
		ByVal m As XFORM Ptr _
	)
	
	m->eM11 = 1.0 : m->eM21 = 0.0 : m->eDx = 0.0
	m->eM12 = 0.0 : m->eM22 = 1.0 : m->eDy = 0.0
	' 0           : 0             : 1
	
End Sub

Sub MatrixApplyTranslate( _
		ByVal m As XFORM Ptr, _
		ByVal dx As Single, _
		ByVal dy As Single _
	)
	
	Dim TranslationMatrix As XFORM = Any
	MatrixSetTranslate(@TranslationMatrix, dx, dy)
	CombineTransform(m, m, @TranslationMatrix)
	
End Sub
