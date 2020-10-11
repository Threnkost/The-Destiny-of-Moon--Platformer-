extends Node

func add_modifier(stat_name : NodePath, amount := 0.0) -> void:
	var stat_node = get_stat(stat_name)
	if stat_node:
		stat_node.modifiers.append(amount)

func remove_modifier(stat_name : NodePath, amount := 0.0) -> void:
	var stat_node = get_stat(stat_name)
	if stat_node:
		if stat_node.modifiers.has(amount):
			stat_node.modifiers.erase(amount)
		else:
			stat_node.modifiers.append(-amount)

func get_stat(stat_name : NodePath):
	return get_node(stat_name)

func get_stat_amount(stat_name : NodePath) -> float:
	if has_node(stat_name):
		return get_node(stat_name).get_total_amount()
	return 0.0
