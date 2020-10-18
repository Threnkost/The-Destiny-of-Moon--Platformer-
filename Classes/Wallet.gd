extends Node
class_name Wallet

var currencies := {}

func _ready():
	for i in get_children():
		var currency_name = i.name
		currencies[currency_name] = i
