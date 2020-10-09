extends TextureButton

onready var inventory
var item : ItemInstance = null
var amount := 0 setget set_amount
var mouse_in := false

func _ready():
	inventory = owner
	
	$ItemAmount.text = ""

func initialize(it : ItemInstance, n := 1) -> void:
	item   = it
	amount = n
	
	$ItemIcon.texture = item.item_texture
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

func is_same(it : ItemInstance) -> bool:
	return item.item_name == it.item_name and item.item_description == it.item_description

func _on_SlotButton_mouse_entered():
	mouse_in = true
	if item:
		Global.inventory.update_description(item.item_name, item.item_description)

func _on_SlotButton_mouse_exited():
	mouse_in = false
	Global.inventory.update_description()

func _on_SlotButton_pressed():
	if is_valid():
		print("asdasd")
		inventory.dragging_item["item"]   = item
		inventory.dragging_item["amount"] = amount
