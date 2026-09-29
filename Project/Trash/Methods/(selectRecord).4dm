//%attributes = {"invisible":true}
C_LONGINT:C283($1)

CLEAR VARIABLE:C89(varFirstname)
CLEAR VARIABLE:C89(varLastname)
CLEAR VARIABLE:C89(varAvatar)

If ($1>0)
	GOTO SELECTED RECORD:C245([(Children):1]; $1)
	varFirstname:=OB Get:C1224([(Children):1]Obj:2; "firstname")
	varLastname:=OB Get:C1224([(Children):1]Obj:2; "lastname")
	varAvatar:=OB Get:C1224([(Children):1]Obj:2; "avatar"; Is picture:K8:10)
	OBJECT SET ENABLED:C1123(*; "detail_@"; True:C214)
Else 
	UNLOAD RECORD:C212([(Children):1])
	OBJECT SET ENABLED:C1123(*; "detail_@"; False:C215)
End if 
