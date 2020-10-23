extends Node

onready var commands := {
	"god_mode":[TYPE_BOOL]
}


func god_mode(value) -> void:
	get_parent().output_line("OK!")
