extends KinematicBody2D

var _player_in := false

func _ready() -> void:
	$KeyF.visible = false

func _on_PlayerDetection_body_entered(body):
	_player_in = true
	$KeyF.visible = true

func _on_PlayerDetection_body_exited(body):
	_player_in = false
	$KeyF.visible = false
