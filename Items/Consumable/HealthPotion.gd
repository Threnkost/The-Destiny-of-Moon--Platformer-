extends ConsumableItem
class_name HealthPotion

func use() -> bool:
	if Global.player.health_point < Global.player.max_health_point:
		Global.player.health_point += value
		Global.inventory.remove_item(self)
		return true
	return false
