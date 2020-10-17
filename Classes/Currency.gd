extends Node
class_name Currency

signal value_changed(value)

export (int) var value setget set_value
export (int) var max_value = 1000

func set_value(new_value):
	value = new_value
	value = clamp(self.value, 0, max_value)
	emit_signal("value_changed", value)
