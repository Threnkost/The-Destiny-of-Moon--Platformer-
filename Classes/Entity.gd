extends KinematicBody2D
class_name Entity

signal health_point_changed(health_point, max_health_point)
signal mana_point_changed(mana_point, max_mana_point)

const GRAVITY = 15
const MAX_GRAVITY = 625

enum life_states {
	LIVING,
	DEAD
}

enum bad_states {
	NORMAL,
	STUNNED
}

export (bool) var debug_mode        = false

export (NodePath) var poison_tick_timer_path     = ""
export (NodePath) var poison_duration_timer_path = ""
onready var poison_tick_timer:Timer                    = get_node(poison_tick_timer_path)
onready var poison_duration_timer:Timer                = get_node(poison_duration_timer_path)

export (life_states) var life_state = life_states.LIVING setget set_life_state
export (bad_states) var bad_state   = bad_states.NORMAL setget set_bad_state

export (int) var max_health_point   = 0 setget set_max_health
export (int) var max_mana_point     = 0 setget set_max_mana

onready var stats

var gravity_value := 0
var velocity      := Vector2.ZERO
var velocity2 := Vector2.ZERO
var direction     := 1 #1 is right, -1 is left

var health_point:int     = 0 setget set_health
var mana_point:int       = 0 setget set_mana

#SLIDING MECHANICS
var sliding_velocity := Vector2.ZERO
var target_sliding_velocity := Vector2.ZERO

var weight_x := 0.0
var weight_y := 0.0

var direction_x := 1
var direction_y := 1

var is_poisoned              := false
var poison_damage_per_second := 0.0

func _ready():
	stats = $Stats

	health_point = max_health_point
	mana_point   = max_mana_point

	if poison_tick_timer && poison_duration_timer:
		poison_tick_timer.wait_time    = 1
		poison_duration_timer.one_shot = true

		poison_tick_timer.connect("timeout", self, "_on_Poison_tick")
		poison_duration_timer.connect("timeout", self, "_on_Poison_ended")

func _on_Poison_tick() -> void:
	if is_poisoned:
		var poison_damage = poison_damage_per_second * poison_tick_timer.wait_time
		set_health(health_point - poison_damage)

func _on_Poison_ended() -> void:
	if is_poisoned:
		is_poisoned = false
		poison_duration_timer.wait_time = 0
		poison_tick_timer.stop()

func slide_opposite_horizontal(initial_sliding_x : float, final_sliding_x : float, weight : float) -> void:
	slide(Vector2(initial_sliding_x, 0), Vector2(final_sliding_x, 0), Vector2(weight, 0), Vector2(-direction, 0))

func slide_directly_horizontal(initial_sliding_x : float, final_sliding_x : float, weight : float) -> void:
	slide(Vector2(initial_sliding_x, 0), Vector2(final_sliding_x, 0), Vector2(weight, 0), Vector2(direction, 0))

func slide(initial_sliding_velocity : Vector2, final_sliding_velocity : Vector2, weight : Vector2, directions : Vector2):
	sliding_velocity = initial_sliding_velocity
	target_sliding_velocity = final_sliding_velocity
	
	weight_x = weight.x
	weight_y = weight.y
	
	direction_x = directions.x
	direction_y = directions.y

func _handle_sliding():
	if sliding_velocity == target_sliding_velocity:
		return
	sliding_velocity.x = lerp(sliding_velocity.x, target_sliding_velocity.x, weight_x)
	sliding_velocity.y = lerp(sliding_velocity.y, target_sliding_velocity.y, weight_y)

	velocity2 = Vector2(sliding_velocity.x * direction_x, sliding_velocity.y * direction_y)
	#print(sliding_velocity, target_sliding_velocity)
	#move_and_slide(Vector2(sliding_velocity.x * direction_x, sliding_velocity.y * direction_y))

func _handle_states(delta) -> void:
	pass

func _apply_gravity(delta) -> void:
	pass

func _debug() -> void:
	pass

func die() -> void:
	life_state = life_states.DEAD
	
func poison(duration := 0.5, damage_per_second := 1.0) -> void:
	if poison_duration_timer && poison_tick_timer:
		is_poisoned = true
		poison_duration_timer.wait_time = duration
		poison_damage_per_second = damage_per_second
		poison_tick_timer.start()
		poison_duration_timer.start()

func damage(damager, damage, push_scale:=1) -> void:
	pass

func set_health(new_health):
	health_point = new_health
	if health_point < 0:
		health_point = 0
	elif health_point > max_health_point:
		health_point = max_health_point
	emit_signal("health_point_changed", health_point, max_health_point)
	
func set_mana(new_mana):
	mana_point = new_mana
	if mana_point < 0:
		mana_point = 0
	elif mana_point > max_mana_point:
		mana_point = max_mana_point
	emit_signal("health_point_changed", mana_point, max_mana_point)

func set_max_health(new_max_health):
	max_health_point = new_max_health
	emit_signal("mana_point_changed", health_point, new_max_health)

func set_max_mana(new_max_mana):
	max_mana_point = new_max_mana
	emit_signal("mana_point_changed", mana_point, new_max_mana)

func set_life_state(new_state:int):
	life_state = new_state

func set_bad_state(new_state:int):
	bad_state = new_state

func get_total_velocity() -> Vector2:
	return velocity + velocity2
