extends Control

signal pressed()


export (String) var shortcut

var item : ConsumableItem
var amount : int setget set_amount


func _ready():
	connect("pressed", self, "_on_Button_clicked")

	var example_item = load("res://Items/Consumable/HealthPotion.tres")
	initialize(example_item, 15)

func initialize(item : ConsumableItem, amount : int) -> void:
	self.item   = item
	self.amount = amount

	$Slot/Amount.text = str(amount)
	$Slot/ItemIcon.texture = item.texture


func set_amount(new_amount):
	amount = new_amount
	$Slot/Amount.text = str(amount)


func clear() -> void:
	self.item = null
	self.amount = 0

	$Slot/Amount.text = str(amount)
	$Slot/ItemIcon.texture = null


func _on_Button_clicked():
	if item and amount >= 1:
		item.use()
