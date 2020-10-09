extends Control

export (NodePath) var item_container_path

onready var item_container

var dragging_item := {
	"item":null,
	"amount":0
}

func _ready():
	item_container = get_node(item_container_path)
	
	var item1:ConsumableItemInstance = ConsumableItemInstance.new("Health Potion I")
	var item2:ConsumableItemInstance = ConsumableItemInstance.new("Mana Potion I")
#
#	dragging_item["item"]   = item1
#	dragging_item["amount"] = 3

	add_item(item1)
	add_item(item2)

func _process(delta):
	if dragging_item["item"] and dragging_item["amount"] >= 1:
		$Panel/DraggingItem.visible = true
		$Panel/DraggingItem.texture = dragging_item["item"].item_texture
		$Panel/DraggingItem.rect_global_position = get_global_mouse_position()
	else:
		$Panel/DraggingItem.visible = false
		$Panel/DraggingItem.texture = null

func add_item(it : ItemInstance, n := 1) -> bool:
	var empty_slots := []
	for slot in item_container.get_children():
		if slot.is_valid() and slot.is_same(it):
			it.queue_free() #not sure
			slot.amount += n
			return true
		elif not slot.is_valid():
			empty_slots.append(slot)

	if empty_slots.size() >= 1:
		empty_slots[0].initialize(it, n)
		return true
	return false

func remove_item(it : ItemInstance, n := 1 ) -> bool:
	for slot in item_container.get_children():
		if slot.is_valid() and slot.is_same(it):
			slot.amount -= n
			return true
	return false

func update_description(item_name:="", item_description:=""):
	$Panel/ItemDescription.text = """%s

%s
""" % [item_name, item_description]
