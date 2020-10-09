extends Panel

signal dialogue_completed

const DIALOGUE_DURATION = 0.35

var names       := []
var texts       := []
var expressions := []
var index       := 0
var completed_current_dialogue := false

func start():
	Global.main_scene.get_node("UI").add_child(self)
	load_dialogue()

func add_answer(name:="", text:="", expression:Texture=null) -> void:
	names.append(name)
	texts.append(text)
	expressions.append(expression)

func load_dialogue():
	$Text.percent_visible = 0
	completed_current_dialogue = true
	if index < texts.size():
		var speaker  = names[index]
		var dialogue = texts[index]
		$Text.bbcode_text = "%s:\n%s" % [speaker, dialogue]
	
		$Tween.interpolate_property($Text, "percent_visible", 0.0, 1.0, DIALOGUE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
	else:
		finish_dialogue()
	index += 1

func finish_dialogue() -> void:
	emit_signal("dialogue_completed")
	queue_free()

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_accept") and completed_current_dialogue:
			load_dialogue()

func _on_Tween_tween_all_completed():
	completed_current_dialogue = true
