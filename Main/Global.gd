extends Node

const DIALOGUE = preload("res://Dialogue/Dialogue.tscn")

onready var player
onready var main_scene
onready var inventory
onready var ui
onready var stage_manager : StageManager

var current_stage : Stage
var last_check_point := {
	"map_name":"invalid",
	"position":Vector2.ZERO
}

func _ready():
	main_scene    = get_node("/root/Main")
	stage_manager = main_scene.get_node("StageManager") 
	inventory     = main_scene.get_node("UI/Inventory")
	ui            = main_scene.get_node("UI/UI")

	player = main_scene.get_node("BufferZone/Player")

	main_scene.get_node("BufferZone").remove_child(player)
	main_scene.get_node("BufferZone").queue_free()
