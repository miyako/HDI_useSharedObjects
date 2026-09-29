C_TEXT:C284(Tutorial)

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		ARRAY TEXT:C222(TabControl; 0)
		ALL RECORDS:C47([SAMPLES:4])
		ORDER BY:C49([SAMPLES:4]; [SAMPLES:4]Page:4; >)
		SELECTION TO ARRAY:C260([SAMPLES:4]Title:2; TabControl)
		
		QUERY:C277([SAMPLES:4]; [SAMPLES:4]Page:4=1)
		
		items:="Books, Cds, DVDs, Cars, TVs, Boats, Computers, Phones"
		result:=""
		
		btnTrace:=False:C215
		
		ID1:=0
		ID2:=0
		ID3:=0
		ID4:=0
		ID5:=0
		
		whom:="Smile"
		
		CopyOfStorage:=OB Copy:C1225(Storage:C1525)
		
		
	: (Form event code:C388=On Page Change:K2:54)
		
		QUERY:C277([SAMPLES:4]; [SAMPLES:4]Page:4=FORM Get current page:C276)
		result:=""
		
End case 
