extends UIWindow

onready var cmd_list = $CommandList
onready var output_panel = $Console
onready var input = $Input

func open() -> void:
	if is_openable():
		visible = true
		Global.current_ui_window = self
	
	
func close() -> void:
	visible = false
	Global.current_ui_window = null
	

func output_line(text := "") -> void:
	output_panel.text = output_panel.text + text + "\n"


func _on_Input_text_entered(new_text):
	var command = new_text.split(" ")
	var cmd_title = command.pop_front()
	output_line(new_text)

	input.text = ""


func _on_CloseButton_pressed():
	visible = false


func convert_to_bool(value:String) -> bool:
	if value.to_lower() == "true":
		return true
	return false
