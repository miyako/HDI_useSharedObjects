//%attributes = {"invisible":true}
ARRAY TEXT:C222(TabControl; 0)
ARRAY TEXT:C222(TextTabControl; 0)
ALL RECORDS:C47([SAMPLES:4])
ORDER BY:C49([SAMPLES:4]; [SAMPLES:4]Page:4; >)
SELECTION TO ARRAY:C260([SAMPLES:4]Title:2; TabControl)
SELECTION TO ARRAY:C260([SAMPLES:4]Tutorial:3; TextTabControl)
UNLOAD RECORD:C212([SAMPLES:4])

TabControl:=1
Var:=TextTabControl{TabControl}