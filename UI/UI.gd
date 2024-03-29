extends Control

const DIMENSION_OF_THE_WORLD     = preload("res://Assets/DimensionOfTheWorld.tres")
const DIMENSION_OF_THE_SPIRITS   = preload("res://Assets/DimensionOfTheSpirits.tres")


onready var health_bar
onready var mana_bar


func _ready():
	health_bar = $Bars/HealthBar
	mana_bar   = $Bars/ManaBar
	
	var test = load("res://UI/EffectIcon.tscn").instance()
	test.add_to_ui("Poison", 5.0)

func _physics_process(delta):
	$Money/Label.text = str(Global.player.wallet.currencies["Gold"].value)	
	if Settings.settings["show_fps"]:
		$FPS.text = str(Engine.get_frames_per_second())
	else:
		$FPS.text = ""
		

func _on_Player_health_changed(hp, max_hp):
	$Bars/HealthBar.true_max_value = max_hp
	$Bars/HealthBar.true_value     = hp
	$Bars/HealthBar/Label.text = str("%s/%s" % [hp, max_hp])


func _on_Player_mana_changed(mp, max_mp):
	$Bars/ManaBar.max_value = max_mp
	$Bars/ManaBar.value     = mp
	$Bars/ManaBar/Label.text = str("%s/%s" % [mp, max_mp])

