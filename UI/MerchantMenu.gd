extends Control

onready var path

func open() -> void:
	visible = true
	Global.main_scene.get_node("UI").add_child(self)

func close() -> void:
	visible = false
	Global.main_scene.get_node("UI").remove_child(self)

#AT START
func initialize() -> void:
	pass #Button.initialize(item, amount, price, "Gold")
