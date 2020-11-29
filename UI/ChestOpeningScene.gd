extends Control

signal completed

onready var items : Array

class LootSlot:
	extends TextureRect
	
	onready var amount_label : Label
	
	func _ready():
		self.rect_min_size = Vector2(16,16)
		self.rect_size = self.rect_min_size

		amount_label = Label.new()
		amount_label.rect_position = Vector2(32,0)
		
		add_child(amount_label)

func _ready():
	$Button.modulate = Color(1,1,1,0)

func initialize(item_list) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	items = item_list
	var node = Global.main_scene.get_node("UI")
	node.add_child(self)
	
	Global.current_ui_window = self

	for child in node.get_children():
		raise()
		 
	for i in item_list:
		var item   = i[0]
		var amount = i[1]
		
		var slot = LootSlot.new()
		$Items.add_child(slot)
		slot.amount_label.text = "x" + str(amount)
		slot.texture = item.texture
		slot.modulate = Color(1,1,1,0)
		
		$Tween.interpolate_property(slot, "modulate", Color(1,1,1,0),
			Color(1,1,1,1), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
	$Tween.interpolate_property($Button, "modulate", Color(1,1,1,0),
		Color(1,1,1,1), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func finish() -> void:
	for i in items:
		var item = i[0]
		var amount = i[1]
		Global.inventory.add_item(item, amount)
	Global.current_ui_window = null
	$AnimationPlayer.play("Fading")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
