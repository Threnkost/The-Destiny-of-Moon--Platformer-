extends Stage

func start_stage():
	.start_stage()
	
	#$MovingPlatform.run()
	for i in $MovingPlatforms.get_children():
		i.run()
		
	$Camera.enable(Global.player)
	#AudioServer.set_bus_volume_db()
	
func end_stage():
	$Camera.disable()

	.end_stage()

func _on_Deadzone_body_entered(body):
	body.velocity = Vector2.ZERO
	body.falling_time = 0.0
	body.stun(2)
	body.health_point -= 5
	body.global_position = $StartPosition.global_position
