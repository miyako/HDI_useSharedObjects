//%attributes = {}

C_TEXT:C284($1)
C_TEXT:C284($what)

C_OBJECT:C1216($2)
C_OBJECT:C1216($inventory)


$what:=$1
$inventory:=$2  // copy the reference for code lisibility


MESSAGE:C88("counting "+$what)

// simulate delay of complicated counting
DELAY PROCESS:C323(Current process:C322; 60+(60*(Random:C100%5)))  // wait for 1 to 5 seconds
$count:=Random:C100


//
Use ($inventory)
	$inventory[$what]:=$count  // save the result for this item
	$inventory.nbItems:=$inventory.nbItems-1  // decrease the number of items
	
	If ($inventory.nbItems=0)
		
		$window:=$inventory.sendResultTo
		
		OB REMOVE:C1226($inventory; "nbItems")
		OB REMOVE:C1226($inventory; "sendResultTo")
		
		If (btnTrace)
			TRACE:C157
		End if 
		
		CALL FORM:C1391($window; "DisplayResult"; $inventory)  // the last process sends the answer the caller
		
	End if 
	
End use 








