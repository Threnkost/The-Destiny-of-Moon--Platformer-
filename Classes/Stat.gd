extends Node
class_name Stat

export (float) var base_amount = 1.0
export (float) var min_value = -10000
export (float) var max_value = 10000

var amount := 0.0
var modifiers := []

func get_total_amount() -> float:
	var total = amount + base_amount
	for i in modifiers:
		total += i
	return clamp(total, min_value, max_value)

