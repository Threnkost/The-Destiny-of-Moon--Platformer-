extends Control

export (NodePath) var item_container_path

onready var item_container

var dragging_item := {
	"item":null,
	"amount":0
}

func _ready():
	item_container = get_node(item_container_path)
	
	#var item1:ConsumableItemInstance = ConsumableItemInstance.new("Health Potion I")
	#var item2:ConsumableItemInstance = ConsumableItemInstance.new("Mana Potion I")

	var item1 = load("res://Items/Resources/HealthPotion.tres")
	var item2 = load("res://Items/Resources/ManaPotion.tres")

	add_item(item1)
	add_item(item2)

func _process(delta):
	if dragging_item["item"] and dragging_item["amount"] >= 1:
		$Background/DraggingItem.visible = true
		$Background/DraggingItem.texture = dragging_item["item"].texture
		$Background/DraggingItem.rect_global_position = get_global_mouse_position()
	else:
		$Background/DraggingItem.visible = false
		$Background/DraggingItem.texture = null

func add_item(it, n := 1) -> bool:
	var empty_slots := []
	for slot in item_container.get_children():
		if slot.is_valid() and slot.is_same(it):
			#it.queue_free() #not sure
			slot.amount += n
			return true
		elif not slot.is_valid():
			empty_slots.append(slot)

	if empty_slots.size() >= 1:
		empty_slots[0].initialize(it, n)
		return true
	return false

func remove_item(it, n := 1 ) -> bool:
	for slot in item_container.get_children():
		if slot.is_valid() and slot.is_same(it):
			slot.amount -= n
			return true
	return false

func update_description(item_name:="", item_description:=""):
	$Background/ItemDescription.text = """%s

%s
""" % [item_name, item_description]
