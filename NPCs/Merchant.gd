extends KinematicBody2D

#UI
const MERCHANT_UI = preload("res://UI/MerchantMenu.tscn")
onready var _merchant_ui = MERCHANT_UI.instance()

export (String, FILE, "*.json") var json_file
export (String) var id = ""

#GAMEPLAY MECHANICS
var _player_in := false

func _ready() -> void:
	assert(id, "Invalid id!")

	$KeyF.visible = false
	_merchant_ui.visible = false

	var file = File.new()
	file.open(json_file, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()

	_merchant_ui.initialize(data[id])

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
