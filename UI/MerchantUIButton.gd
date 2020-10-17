extends Control

signal clicked()

var item    = null
var amount := 0
var price  := 0.0
var currency := "Gold"

func _on_Button_pressed():
	emit_signal("clicked")

func initialize(item, amount = 1, price := 1.0, currency := "Gold") -> void:
	self.item     = item
	self.amount   = amount
	self.price    = price
	self.currency = currency

	$Button/ItemIcon.texture = item.texture
