extends Entity

const LOOK_UP_DISTANCE = 150

export (float) var speed = 1
export (float) var jumping_force = 1

enum {
	MOVING,
	ATTACKING
}

onready var state_machine_player

var current_state = MOVING
var can_jump := true
var can_move := true
var active_camera : Camera2D

func _ready():
	state_machine_player = $AnimationTree.get("parameters/playback")

	.connect("health_point_changed", Global.ui, "_on_Player_health_changed")
	.connect("mana_point_changed", Global.ui, "_on_Player_mana_changed")

	.emit_signal("health_point_changed", health_point, max_health_point)
	.emit_signal("mana_point_changed", mana_point, max_mana_point)

func _physics_process(delta):

	if _is_top_raycasts_colliding():
		#velocity.y = GRAVITY * 3
		velocity.y = abs(velocity.y) / 1.5

	velocity.y += GRAVITY
	if velocity.y >= MAX_GRAVITY:
		velocity.y = MAX_GRAVITY

	if velocity.x > 0:
		self.direction = 1
	elif velocity.x < 0:
		self.direction = -1

	if _is_bottom_raycasts_colliding():
		velocity.y = 0

	if Input.is_action_just_pressed("Jump") and can_jump and _is_bottom_raycasts_colliding():
		velocity.y = -jumping_force
	
	_check_direction()
	_handle_inputs()
	_handle_states(delta)

	move_and_slide(velocity, Vector2.UP)

func _check_direction():
	match self.direction:
		1:
			$Sprite.flip_h = false
		-1:
			$Sprite.flip_h = true

func _handle_inputs():
	if Input.is_action_just_pressed("OpenInventory"):
		Global.inventory.visible = !Global.inventory.visible
	
	if active_camera:
		if Input.is_action_pressed("LookUp"):
			active_camera.pos_offset = Vector2(0, -LOOK_UP_DISTANCE)
		else:
			active_camera.pos_offset = Vector2.ZERO

func _handle_states(delta):
	match current_state:
		MOVING:
			_move()
		ATTACKING:
			_attack()

func _attack():
	pass

func _move():
	velocity.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	velocity.x *= speed * int(can_move)

	if velocity.x != 0:
		state_machine_player.travel("Running")
	else:
		state_machine_player.travel("Idle")

func _is_top_raycasts_colliding() -> bool:
	return $HeadRayCast.is_colliding() or $HeadRayCast2.is_colliding() or $HeadRayCast3.is_colliding()

func _is_bottom_raycasts_colliding() -> bool:
	return $GravityRayCast.is_colliding() or $GravityRayCast2.is_colliding() or $GravityRayCast3.is_colliding()

func die() -> void:
	.die()
	is_alive = true
	
	if Global.last_check_point["map_name"] != "invalid":
		if Global.current_stage.name != Global.last_check_point["map_name"]:
			Global.stage_manager.change_stage(Global.last_check_point["map_name"])	
		global_position = Global.last_check_point["position"]
	else:
		global_position = Global.current_stage.get_node("StartPosition").global_position
		#Temporary
