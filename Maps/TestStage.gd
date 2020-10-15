extends Stage

func start_stage():
	.start_stage()
	
	$Camera.enable(Global.player)
	
func end_stage():
	$Camera.disable()
	
	.end_stage()

func _on_Deadzone_body_entered(body):
	body.global_position = $StartPosition.global_position
	body.velocity = Vector2.ZERO
