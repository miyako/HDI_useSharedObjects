//%attributes = {}

C_OBJECT:C1216($1)
C_OBJECT:C1216($inventory)

$inventory:=$1

If (btnTrace)
	TRACE:C157
End if 

result:=JSON Stringify:C1217($inventory; *)

