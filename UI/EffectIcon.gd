extends Control


onready var effect_name : String
onready var duration : float


var time := 0.0
var done := false


func add_to_ui(effect_name : String, duration : float) -> void:
	self.effect_name = effect_name
	self.duration = duration
	$Icon.texture = load("res://Assets/Icons/" + effect_name + ".tres")
	Global.ui.get_node("Effects").add_child(self)
	$Timer.start()


func _on_Timer_timeout():
	time += 0.1
	if time >= duration:
		queue_free()
	elif time >= duration / 2.0:
		$AnimationPlayer.play("Clip")


func _on_Tween_tween_all_completed():
	queue_free()
