extends Control

onready var health_bar
onready var mana_bar

func _ready():
	health_bar = $Bars/HealthBar
	mana_bar   = $Bars/ManaBar

func _on_Player_health_changed(hp, max_hp):
	$Bars/HealthBar.true_max_value = max_hp
	$Bars/HealthBar.true_value     = hp
	$Bars/HealthBar/Label.text = str("%s/%s" % [hp, max_hp])

func _on_Player_mana_changed(mp, max_mp):
	$Bars/ManaBar.max_value = max_mp
	$Bars/ManaBar.value     = mp
	$Bars/ManaBar/Label.text = str("%s/%s" % [mp, max_mp])

