extends Node2D

#	if Input.is_action_pressed("Attack") && current_state != ATTACKING && !attack_cooldown:
#		if bad_state != bad_states.STUNNED:
#			#current_state = ATTACKING
#			pass

const DIVISIVE_OF_SECOND_UP_ATTACK_JUMP_FORCE = 1.5
const SLOWING_DOWN_PROPORTION_WHILE_ATTACKING_ON_AIR = 1.5

export (int) var attack_side_leaping_forward = 300
export (int) var attack_up_jump_force = -200
export (int) var attack_down_fall_force = 200

onready var player = get_parent()

var air_attack_index := 0

func get_main_measure(degree): #Esas ölçüyü alır
	if degree >= 360:
		return degree % 360
	elif degree < 0:
		while degree < 0:
			degree += 360
		return degree
	return degree

func get_quadrant(degree) -> int: #Bölgeleri alır
	if (degree >= 0 and degree < 45) or (degree > 315 and degree <= 360):
		return 1
		
	elif degree >= 45 and degree <= 135:
		return 2

	elif degree > 135 and degree < 225:
		return 3

	elif degree >= 225 and degree <= 315:
		return 4
	return 0

func _can_attack() -> bool:
	return (player.current_state != player.ATTACKING_DOWN and
		player.current_state != player.ATTACKING_SIDE and
		player.current_state != player.ATTACKING_UP)

func _physics_process(delta):
	if player.is_on_floor():
		air_attack_index = 0
	
	if Input.is_action_just_pressed("Attack"):
		var player_global_position = player.global_position
		var mouse_global_position  = get_global_mouse_position()
			
		var vector := Vector2(mouse_global_position.x - player_global_position.x,
			-mouse_global_position.y + player_global_position.y)
		var degree = get_main_measure(int(rad2deg(atan2(vector.y, vector.x))))
		var quadrant = get_quadrant(degree)

		match quadrant:
			1:
				_attack_side(1)
			2:
				_attack_up()
			3:
				_attack_side(-1)
			4:
				_attack_down()

func _attack_down():
	if _can_attack():
		player.current_state = player.ATTACKING_DOWN
		player.velocity = Vector2(0, attack_down_fall_force)
	
func _attack_up():
	if _can_attack() and air_attack_index < 2:
		var jump_force = attack_up_jump_force
		if air_attack_index == 1:
			jump_force /= DIVISIVE_OF_SECOND_UP_ATTACK_JUMP_FORCE
		player.current_state = player.ATTACKING_DOWN
		player.snap_velocity = Vector2.ZERO
		player.velocity.y = jump_force
		air_attack_index += 1

func _attack_side(direction:int):
	if _can_attack():
		#if direction == -player.direction and player.velocity.x != 0:
		#	player.velocity.x = 0
		player.direction = direction
		player.current_state = player.ATTACKING_SIDE
		if player.is_on_floor():
			player.velocity.x = 0
			player.slide_directly_horizontal(attack_side_leaping_forward, 0, 0.2)
		else:
			player.velocity.x /= SLOWING_DOWN_PROPORTION_WHILE_ATTACKING_ON_AIR
