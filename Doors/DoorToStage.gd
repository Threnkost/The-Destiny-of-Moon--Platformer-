extends Area2D

export (String) var target_stage = ""

var _player_in := false

func _input(event):
	if event is InputEventKey and event.pressed and Global.current_stage.name == owner.name:
		if Input.is_action_just_pressed("UseDoor") and _player_in and target_stage:
			Global.stage_manager.change_stage(target_stage)
			Global.player.active_camera.shake(0.5, 1024, 16)
			#Global.player.get_node("CameraShakeFX").start(0.5, 1024, 16)

func _on_DoorToStage_body_entered(body):
	if body.is_in_group("Player"):
		_player_in = true

func _on_DoorToStage_body_exited(body):
	if body.is_in_group("Player"):
		_player_in = false
