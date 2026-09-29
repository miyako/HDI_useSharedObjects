//%attributes = {"invisible":true}
ARRAY TEXT:C222($_items; 0)
GET TEXT KEYWORDS:C1141(items; $_items; *)

var $window; $nbItems; $i; $ps : Integer
var $Inventory : Object

$window:=Current form window:C827  // Caller that will need the answer
$nbItems:=Size of array:C274($_items)

$Inventory:=New shared object:C1526()  // The shared object where the inventory shall be calculated

If (btnTrace)
	TRACE:C157
End if 

Use ($Inventory)  // init the shared object
	$inventory.nbItems:=$nbItems
	$inventory.sendResultTo:=$window
End use 

If (btnTrace)
	TRACE:C157
End if 

// create as many process as items in the array
For ($i; 1; $nbItems)
	// $inventory is sent AS REFERENCE to each process
	$ps:=New process:C317("HowMany"; 0; "HowMany_"+$_items{$i}; $_items{$i}; $inventory)
End for 

