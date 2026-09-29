//%attributes = {"invisible":true}
#DECLARE($inventory : Object)

If (btnTrace)
	TRACE:C157
End if 

result:=JSON Stringify:C1217($inventory; *)

