//%attributes = {"invisible":true}

C_OBJECT:C1216:=objCounter

If (objCounter=Null:C1517)  // at the first use objCounter WILL be null
	objCounter:=Storage:C1525.counter
End if 

Use (objCounter)
	// no need to "USE" Storage anymore, just USE objCounter directly!
	// other subobjects of Storage shall still be free to USE for other users
	objCounter.contacts:=objCounter.contacts+1
	$0:=objCounter.contacts
End use 






