//%attributes = {}
C_LONGINT:C283($1)
C_LONGINT:C283($ps; $win)
C_OBJECT:C1216($options)
C_TEXT:C284($cr)

Case of 
	: (Count parameters:C259=0)
		
		var $dataClass; $project; $path : Text
		For each ($dataClass; ds:C1482)
			If (ds:C1482[$dataClass].getCount()=0)
				$path:=File:C1566("/RESOURCES/"+$dataClass+".4ie").platformPath
				If (Test path name:C476($path)=Is a document:K24:1)
					$project:=File:C1566("/RESOURCES/"+$dataClass+".4si").getText()
					IMPORT DATA:C665($path; $project)
				End if 
			End if 
		End for each 
		
		$ps:=New process:C317(Current method name:C684; 0; Current method name:C684; 0)
		
	Else 
		
		$cr:=Char:C90(Carriage return:K15:38)
		
		If (Shift down:C543)  //  for debug purpose only
			$win:=Open form window:C675("HDI"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
		Else 
			$win:=Open form window:C675("HDI"; Pop up form window:K39:11; Horizontally centered:K39:1; Vertically centered:K39:4)
		End if 
		
		$options:=New object:C1471
		
		$options.title:="use shared objects and Storage?"
		
		$options.blog:="blog.4d.com"
		$options.info:="Managing objects"  //ex : "4D View Pro feature"
		
		$options.minimumVersion:="1660"  // 1660 means 16R6   1601 means 16.1 (do not use !)
		
		//$options.license:=4D View license  // IF ANY NEEDED
		//$options.license:=4D write license  // IF ANY NEEDED
		
		// THE BACKGROUND PICTURE IS IN THE RESOURCES : Resources/Images/HDIabout.png
		// the picture size is 724 * 364
		// these 3 commented lines should be removed when done !
		
		DIALOG:C40("HDI"; $options)
		CLOSE WINDOW:C154
		
		
		If ($options.quit=True:C214)
			QUIT 4D:C291
		Else 
			
			READ ONLY:C145([SAMPLES:4])
			$win:=Open form window:C675("HDI2"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("HDI2")
			CLOSE WINDOW:C154
			
		End if 
		
End case 

