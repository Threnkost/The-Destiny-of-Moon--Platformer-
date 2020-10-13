extends Entity

const LOOK_UP_DISTANCE = 150

const SNAP_LENGTH = 8.0
const SNAP_DIRECTION = Vector2.DOWN

export (float) var speed = 1
export (float) var tumbling_speed = 1
export (float) var jumping_force = 1

enum {
	MOVING,
	ATTACKING,
	TUMBLING,
}

#MECHANICS
onready var state_machine_player

var current_state = MOVING setget set_state

var can_jump := true
var can_move := true
var is_jumping := false
var active_camera : Camera2D

var tumbling_cooldown := false setget set_tumbling_cooldown

var attack_cooldown := false setget set_attack_cooldown
var attack_count := 0 setget set_attack_index

var snap_velocity = SNAP_LENGTH * SNAP_DIRECTION

#PROPORTIONS
onready var normal_attack_proportions := [1.0, 1.15, 1.3]
onready var normal_attack_push_proportions := [1.0, 1.0, 2.25]

func _ready():
	state_machine_player = $AnimationTree.get("parameters/playback")

	.connect("health_point_changed", Global.ui, "_on_Player_health_changed")
	.connect("mana_point_changed", Global.ui, "_on_Player_mana_changed")

	.emit_signal("health_point_changed", health_point, max_health_point)
	.emit_signal("mana_point_changed", mana_point, max_mana_point)

func _physics_process(delta):
	$AnimationPlayer.playback_speed = 1.0

	if _is_top_raycasts_colliding():
		velocity.y = abs(velocity.y) / 1.5

	velocity.y += GRAVITY
	if velocity.y >= MAX_GRAVITY:
		velocity.y = MAX_GRAVITY

	if is_on_floor():#_is_bottom_raycasts_colliding():
		velocity.y = 0
		snap_velocity = SNAP_LENGTH * SNAP_DIRECTION

	if Input.is_action_just_pressed("Jump") and can_jump and is_on_floor() and current_state != TUMBLING:
		if bad_state != bad_states.STUNNED:
			snap_velocity = Vector2.ZERO
			velocity.y = -jumping_force		

	_check_direction()
	_handle_inputs()
	_handle_states(delta)
	_handle_sliding()
	_debug()

	#velocity.y = move_and_slide(velocity, Vector2.UP, true).y
	velocity.y = move_and_slide_with_snap(get_total_velocity(), snap_velocity, 
		Vector2.UP, true, 4, deg2rad(45.1)).y

func _check_direction():
	$FirstAttackHitbox.scale.x  = direction
	$SecondAttackHitbox.scale.x = direction
	$ThirdAttackHitbox.scale.x  = direction
	match self.direction:
		1:
			$Sprite.flip_h = false
		-1:
			$Sprite.flip_h = true

func _handle_inputs():
	if Input.is_action_just_pressed("OpenInventory"):
		Global.inventory.visible = !Global.inventory.visible
	
	if Input.is_action_pressed("Attack") and current_state != ATTACKING and not attack_cooldown:
		if bad_state != bad_states.STUNNED:
			current_state = ATTACKING

	if Input.is_action_pressed("Tumble") and velocity.x != 0 and _is_bottom_raycasts_colliding() and not tumbling_cooldown:
		if bad_state != bad_states.STUNNED and current_state != TUMBLING:
			current_state = TUMBLING

	if Input.is_action_just_pressed("DamageMyself"):
		damage(null, 1)

	if active_camera:
		if Input.is_action_pressed("LookUp"):
			active_camera.pos_offset = Vector2(0, -LOOK_UP_DISTANCE)
		else:
			active_camera.pos_offset = Vector2.ZERO

func _handle_states(delta):
	if bad_state == bad_states.STUNNED:
		state_machine_player.travel("Stunned")
		return
	match current_state:
		MOVING:
			_move()
		ATTACKING:
			_attack()
		TUMBLING:
			var anim_length = $AnimationPlayer.get_animation("Tumble").length
			var final_position = global_position.x + tumbling_speed * direction
			print(final_position)
			state_machine_player.travel("Tumble")
			slide_directly_horizontal(tumbling_speed, 0, 0.2) 

func _attack():
	velocity.x = 0
	match attack_count:
		0:
			$AnimationPlayer.playback_speed = stats.get_stat_amount("AttackSpeed")
			state_machine_player.travel("Attack1")
			$Timers/AttackCombinationTimer.start()
		1:
			$AnimationPlayer.playback_speed = stats.get_stat_amount("AttackSpeed")
			state_machine_player.travel("Attack2")
			$Timers/AttackCombinationTimer.stop()

func _move():
	velocity.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	velocity.x *= speed * int(can_move)

	if velocity.x > 0:
		self.direction = 1
	elif velocity.x < 0:
		self.direction = -1

	if velocity.x != 0:
		state_machine_player.travel("Running")
	else:
		state_machine_player.travel("Idle")

func _is_top_raycasts_colliding() -> bool:
	return $TopRaycast1.is_colliding()#$HeadRayCast.is_colliding() or $HeadRayCast2.is_colliding() or $HeadRayCast3.is_colliding()

func _is_bottom_raycasts_colliding() -> bool:
	return $BottomRaycast1.is_colliding() or $BottomRaycast2.is_colliding() or $BottomRaycast3.is_colliding()#$GravityRayCast.is_colliding() or $GravityRayCast2.is_colliding() or $GravityRayCast3.is_colliding()

func damage(damager, damage, push_scale:=1):
	set_health(health_point - damage)

func die() -> void:
	.die()
	life_state = life_states.LIVING

	if Global.last_check_point["map_name"] != "invalid":
		if Global.current_stage.name != Global.last_check_point["map_name"]:
			Global.stage_manager.change_stage(Global.last_check_point["map_name"])	
		global_position = Global.last_check_point["position"]
	else:
		global_position = Global.current_stage.get_node("StartPosition").global_position
		#Temporary

func set_state(new_state : int):
	current_state = new_state

func set_attack_index(new_index : int):
	attack_count = new_index

func set_attack_cooldown(is_in_cooldown : bool):
	attack_cooldown = is_in_cooldown

func set_tumbling_cooldown(is_in_cooldown : bool):
	tumbling_cooldown = is_in_cooldown

func _on_CombinationCooldown_timeout():
	attack_cooldown = false

func _on_AttackCombinationTimer_timeout():
	attack_count = 0

func _on_TumblingCooldown_timeout():
	tumbling_cooldown = false

func _attack_if_enemy(body:Node, damage := 0, index := 0):
	if body.is_in_group("Enemy"):
		var total_damage = damage * normal_attack_proportions[index]
		var push_scale   = normal_attack_push_proportions[index]
		var value_to_heal = total_damage * stats.get_stat_amount("LifeSteal")
		body.damage(self, total_damage, push_scale)
		set_health(health_point + value_to_heal)
		print("Attacked : ", body.name, " value : ", total_damage)

func _on_RightHitbox_body_entered(body):
	_attack_if_enemy(body, stats.get_stat_amount("AttackDamage"), 0)

func _on_SecondAttackHitbox_body_entered(body):
	_attack_if_enemy(body, stats.get_stat_amount("AttackDamage"), 1)

func _on_ThirdAttackHitbox_body_entered(body):
	_attack_if_enemy(body, stats.get_stat_amount("AttackDamage"), 2)

func _debug():
	if not debug_mode:
		return
	
	#$Label.text = str($RayCast2D.is_colliding())
	$BottomRaycastDebug.text = str(is_on_floor())#_is_bottom_raycasts_colliding())
	$BottomRaycastDebug.visible = true
	$Stunned.visible = bad_state == bad_states.STUNNED
