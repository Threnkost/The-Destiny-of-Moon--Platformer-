extends KinematicBody2D

#UI
const MERCHANT_UI = preload("res://UI/MerchantMenu.tscn")
const MERCHANT_UI_BUTTON = preload("res://UI/MerchantUIButton.tscn")
onready var _merchant_ui = MERCHANT_UI.instance()

#GAMEPLAY MECHANICS
var _player_in := false

func _ready() -> void:
	$KeyF.visible = false

func _input(event) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("UseDoor") and _player_in:
			_merchant_ui.open() if !_merchant_ui.visible else _merchant_ui.close()

func _on_PlayerDetection_body_entered(body):
	_player_in = true
	$KeyF.visible = true

func _on_PlayerDetection_body_exited(body):
	_player_in = false
	$KeyF.visible = false
