extends Area2D

export (NodePath) var position_node

onready var target_position : Position2D
var _player_in := false

func _ready():
	target_position = get_node(position_node)

func _input(event):
	if event is InputEventKey and event.pressed and Global.current_stage.name == owner.name:
		if Input.is_action_just_pressed("UseDoor") and _player_in and target_position:
			Global.player.global_position = target_position.global_position

func _on_Door1Position_body_entered(body):
	if body.is_in_group("Player"):
		_player_in = true

func _on_Door1Position_body_exited(body):
	if body.is_in_group("Player"):
		_player_in = false
