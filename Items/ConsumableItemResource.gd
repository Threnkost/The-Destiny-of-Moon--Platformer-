extends Item
class_name ConsumableItem

export (float) var value := 0.0
export (float) var percent := 0.0

func use() -> bool:
	return false
