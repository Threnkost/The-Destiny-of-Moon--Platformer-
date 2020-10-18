extends Control

const UI_SLOT = preload("res://UI/MerchantUIButton.tscn")

onready var path

#AT START
func initialize(data : Dictionary) -> void:
	for i in data:
		var item  = load("res://Items/Resources/" + i + ".tres")
		var price = data[i]["price"]
		var amount = data[i]["amount"]
		var currency = data[i]["currency"]

		var slot = UI_SLOT.instance()
		slot.initialize(self, item, amount, price, currency)

		$Background/Items.add_child(slot)

func open() -> void:
	visible = true
	Global.main_scene.get_node("UI").add_child(self)
	$Background/ItemDescription.text = ""

func close() -> void:
	visible = false
	Global.main_scene.get_node("UI").remove_child(self)

func _process(delta):
	$Background/Gold.text = str(Global.player.wallet.currencies["Gold"].value)

func update_description(item_name := "", item_description := "", price := 0) -> void:
	$Background/ItemDescription.text = "%s\n\nPrice: %s" % [item_name, price]

func clear_description() -> void:
	$Background/ItemDescription.text = ""

func _on_CloseButton_pressed():
	close()
