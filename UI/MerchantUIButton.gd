extends Control

signal clicked()

export (Color) var disabled_color

var enabled := true
var ui = null
var item    = null
var amount := 0
var price  := 0.0
var currency := "Gold"

func _on_Button_pressed():
	emit_signal("clicked")

func initialize(ui, item, amount = 1, price := 1.0, currency := "Gold") -> void:
	self.ui = ui

	self.item     = item
	self.amount   = amount
	self.price    = price
	self.currency = currency

	$Button/ItemIcon.texture = item.texture
	$Button/Amount.text = str(amount)

func _process(delta) -> void:
	if Global.player.wallet.currencies[currency].value < price:
		enabled = false
		modulate = disabled_color
	elif !enabled:
		enabled = true
		modulate = Color("ffffff")

func _on_Button_mouse_entered():
	ui.update_description(item.name, item.description, price)

func _on_Button_mouse_exited():
	ui.clear_description()

func _on_Button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT and enabled:
			if Global.player.wallet.currencies[currency].value >= price:
				$AnimationPlayer.play("Buying")
			else:
				$AnimationPlayer.play("NonAvailable")

func buy() -> void:
	Global.inventory.add_item(item, amount)
	Global.player.wallet.currencies[currency].value -= price
