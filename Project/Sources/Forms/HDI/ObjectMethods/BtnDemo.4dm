//%attributes = {"invisible":true}
If (Form:C1466.quit)
	INVOKE ACTION(ak return to design mode)
Else 
	
	READ ONLY:C145([SAMPLES:4])
	
	var $window : Integer
	$window:=Open form window:C675("HDI2"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
	SET WINDOW TITLE(Get window title(Current form window:C827); $window)
	DIALOG:C40("HDI2"; *)
	
End if 