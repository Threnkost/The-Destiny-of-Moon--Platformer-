extends TextureButton

onready var inventory
var item = null
var amount := 0 setget set_amount
var mouse_in := false

func _ready():
	inventory = owner
	
	$ItemAmount.text = ""

func initialize(it, n := 1) -> void:
	item   = it
	amount = n
	
	$ItemIcon.texture = item.texture
	$ItemAmount.text  = str(amount)

func clear() -> void:
	item = null
	amount = 0
	$ItemIcon.texture = null
	$ItemAmount.text  = ""

func set_amount(n) -> void:
	if is_valid():
		amount = n
		$ItemAmount.text = str(amount)
		if amount <= 0:
			clear()

func is_valid() -> bool:
	return item != null and amount > 0

func is_same(it) -> bool:
	return item.name == it.name and item.description == it.description

func _on_SlotButton_mouse_entered():
	mouse_in = true
	if item:
		Global.inventory.update_description(item.name, item.description)

func _on_SlotButton_mouse_exited():
	mouse_in = false
	Global.inventory.update_description()

func _on_SlotButton_pressed():
	#if is_valid():
	var slot_item = item
	var slot_amount = amount
	if inventory.dragging_item["item"] and inventory.dragging_item["amount"] > 0:
		initialize(inventory.dragging_item["item"], inventory.dragging_item["amount"])
	else:
		clear()
	inventory.dragging_item["item"]   = slot_item
	inventory.dragging_item["amount"] = slot_amount
