extends Stage

func start_stage():
	.start_stage()
	
	$Camera.enable(Global.player)
	
func end_stage():
	$Camera.disable()
	
	.end_stage()
