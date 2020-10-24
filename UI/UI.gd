extends Control

onready var health_bar
onready var mana_bar


enum hacks {
	A = 1
	B = 2
	C = 4
}
export (int, FLAGS, "A", "B", "C") var a = 0

func _ready():
	health_bar = $Bars/HealthBar
	mana_bar   = $Bars/ManaBar
	
	if a & hacks.A:
		print("A")
	if a & hacks.B:
		print("B")
	if a & hacks.C:
		print("C")

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

