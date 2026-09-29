//%attributes = {"invisible":true}
C_OBJECT:C1216:=objCounter

If (objCounter=Null:C1517)  // at the first use objCounter WILL be null
	
	If (Storage:C1525.counter#Null:C1517)
		
		// Getthe Storage.counter reference directly
		objCounter:=Storage:C1525.counter
		
	Else 
		
		Use (Storage:C1525)
			// CHECK AGAIN: Storage.counter MAY be NOT be null anymore.
			// It might have been created since two lines above !
			If (Storage:C1525.counter=Null:C1517)  // 
				// as long as we are inside a "USE", the counter can be created safely
				Storage:C1525.counter:=New shared object:C1526("customers"; 0; "contacts"; 0; "cars"; 0; "boats"; 0)
			End if 
			
			// finaly, get the Storage.counter  reference
			objCounter:=Storage:C1525.counter
		End use 
		
	End if 
	
End if 

// whatever happend above objCounter cannot be null anymore

Use (objCounter)
	// no need to "USE" Storage anymore, just USE the needed shared object 
	//other subobjects of Storage shall still be free to USE for other users
	
	objCounter.contacts:=objCounter.contacts+1
	$0:=objCounter.contacts
	
End use 
