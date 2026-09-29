//%attributes = {}
C_TEXT:C284($1)
C_LONGINT:C283($0)

C_TEXT:C284($idFor)
C_OBJECT:C1216(objCounters)

$idFor:=$1

If (btnTrace)
	TRACE:C157
End if 


If (objCounters=Null:C1517)  // at the first use objCounter WILL be null
	Use (Storage:C1525)
		If (Storage:C1525.counters=Null:C1517)  // if "counters" has not been created during the "on startup" method
			Storage:C1525.counters:=New shared object:C1526
		End if 
		objCounters:=Storage:C1525.counters
	End use 
End if 

// No need to USE Storage anymore, just USE objCounter directly!
// Advantage: other subobjects of Storage remain free to USE by other processes

Use (objCounters)
	If (objCounters[$idFor]=Null:C1517)
		objCounters[$idFor]:=0
	End if 
	
	objCounters[$idFor]:=objCounters[$idFor]+1
	$0:=objCounters[$idFor]
	
End use 

CopyOfStorage:=OB Copy:C1225(Storage:C1525)






