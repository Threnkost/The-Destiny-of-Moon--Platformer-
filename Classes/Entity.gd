extends KinematicBody2D
class_name Entity

signal health_point_changed(health_point, max_health_point)
signal mana_point_changed(mana_point, max_mana_point)

const GRAVITY = 30
const MAX_GRAVITY = 1000

export (bool) var debug_mode = false

var gravity_value := 0
var velocity      := Vector2.ZERO
var direction     := 1 #1 is right, -1 is left

export var max_health_point:int = 0 setget set_max_health
export var max_mana_point:int   = 0 setget set_max_mana

var health_point:int     = 0 setget set_health
var mana_point:int       = 0 setget set_mana

var is_alive := true

func _ready():
	health_point = max_health_point
	mana_point   = max_mana_point

func _handle_states(delta) -> void:
	pass

func _apply_gravity(delta) -> void:
	pass

func _debug() -> void:
	pass

func die() -> void:
	is_alive = false
	
func damage(damage) -> void:
	pass

func set_health(new_health):
	health_point = new_health
	emit_signal("health_point_changed", new_health, max_health_point)
	
func set_mana(new_mana):
	mana_point = new_mana
	emit_signal("health_point_changed", new_mana, max_mana_point)

func set_max_health(new_max_health):
	max_health_point = new_max_health
	emit_signal("mana_point_changed", health_point, new_max_health)

func set_max_mana(new_max_mana):
	max_mana_point = new_max_mana
	emit_signal("mana_point_changed", mana_point, new_max_mana)

#func _is_gravity_available() -> bool:
#	return true
