extends Stage


func start_stage():
	.start_stage()
	visible = true
	
	$Camera.enable(Global.player)

	var dialogue = Global.DIALOGUE.instance()
	dialogue.add_answer("A", "Sa")
	dialogue.add_answer("B", "As")
	dialogue.start()

func end_stage():
	visible = false
	
	$Camera.disable()
	.end_stage()

func _on_Deadline_body_entered(body):
	if body.is_in_group("Player"):
		body.velocity = Vector2(0,0)
#		body.position = $StartPosition.position
		body.die()
