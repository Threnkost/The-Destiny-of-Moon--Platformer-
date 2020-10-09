extends Node2D
class_name StageManager

signal stage_changed()

#Hangi stage ayarlıysa önce ondan başlar.
export (NodePath) var initial_stage_path

#Child olarak atanmış stageleri buraya kaydeder.
onready var stages := {}

func _ready() -> void:
	visible = true
	var initial_stage = get_node(initial_stage_path)
	for child_stage in get_children():
		stages[child_stage.name] = child_stage
		remove_child(child_stage)

	Global.current_stage = initial_stage
	initial_stage.start_stage()

#Stage değiştirir.
func change_stage(stage_name="") -> void:
	if stages.has(stage_name):
		var previous_stage = Global.current_stage
		Global.current_stage = stages[stage_name]

		previous_stage.end_stage()
		Global.current_stage.start_stage()

		emit_signal("stage_changed")








#func next_stage() -> void:
#	var index = Global.current_stage.get_index()
#	var total_stage_count = get_child_count()
#
#	if index+1 < total_stage_count:
#		var previous_stage = Global.current_stage
#		var next_stage     = get_child(index+1)
#
#		previous_stage.end_stage()
#		next_stage.start_stage()
#
#		emit_signal("stage_changed", next_stage, previous_stage)
#	else:
#		print("Couldn't find next stage! Because it was the last stage.")
