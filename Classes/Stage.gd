extends Node2D

class_name Stage

export (bool) var player_active = true
export (NodePath) var start_position_node
export (NodePath) var map_ost_node

onready var start_position:Vector2
onready var map_ost

func _ready():
	start_position = get_node(start_position_node).global_position
	map_ost = get_node(map_ost_node)

func start_stage():
	Global.stage_manager.add_child(self)
	
	if player_active:
		add_child(Global.player)
		Global.player.add_to_group("Player")
		Global.player.global_position = start_position
	if map_ost:
		map_ost.playing = true
	
func end_stage():
	Global.stage_manager.remove_child(self)
	if player_active:
		remove_child(Global.player)
		Global.player.remove_from_group("Player")
	if map_ost:
		map_ost.playing = false
				
		
		
		
		
		#func add_player(start_position := Vector2.ZERO) -> void:
			#	add_child(Global.player)
			#	#call_deferred("add_child", Global.player)
			#	Global.player.global_position = start_position
			#	Global.player.add_to_group("Player")
			
				#print("Player added to the scene!")
			
			#func remove_player() -> void:
			#	remove_child(Global.player)
			#	#call_deferred("remove_child", Global.player)
			#	Global.player.remove_from_group("Player")
			#	
				#print("Playerd has been removed from the scene!")
			
