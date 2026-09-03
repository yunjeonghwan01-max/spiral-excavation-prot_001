extends CharacterBody2D

const SPEED := 100.0
const JUMP_VELOCITY := -170.0
const GRAVITY := 600.0

const MAX_HP := 100
const ENEMY_CONTACT_DAMAGE := 10
const HIT_COOLDOWN := 1.0

const Terrain := preload("res://_scripts/terrain.tscn.gd")

@export var terrain_path: NodePath
var terrain: Terrain
var facing_dir := Vector2i.RIGHT

var current_hp := MAX_HP
var _hit_cooldown := 0.0

var _is_digging := false
var _dig_target: Vector2i
var _dig_progress := 0.0


func _ready() -> void:
	terrain = get_node(terrain_path)
	add_to_group("player")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	if is_on_floor() and Input.is_action_just_pressed("player_jump"):
		velocity.y = JUMP_VELOCITY

	var move_input := Input.get_axis("player_move_left", "player_move_right")
	velocity.x = move_input * SPEED

	if move_input < 0.0:
		facing_dir = Vector2i.LEFT
	elif move_input > 0.0:
		facing_dir = Vector2i.RIGHT

	move_and_slide()

	_update_dig(delta)
	_update_enemy_contact(delta)


func _update_enemy_contact(delta: float) -> void:
	_hit_cooldown = max(_hit_cooldown - delta, 0.0)

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider is Node and collider.is_in_group("enemy"):
			_take_damage(ENEMY_CONTACT_DAMAGE)
			break


func _take_damage(amount: int) -> void:
	if _hit_cooldown > 0.0:
		return
	current_hp = max(current_hp - amount, 0)
	_hit_cooldown = HIT_COOLDOWN


func _get_dig_direction() -> Vector2i:
	if Input.is_action_pressed("player_move_left"):
		return Vector2i.LEFT
	elif Input.is_action_pressed("player_move_right"):
		return Vector2i.RIGHT
	elif Input.is_action_pressed("player_move_up"):
		return Vector2i.UP
	elif Input.is_action_pressed("player_move-down"):
		return Vector2i.DOWN
	return facing_dir


func _update_dig(delta: float) -> void:
	if terrain == null:
		return

	if Input.is_action_just_pressed("player_dig"):
		var dig_dir := _get_dig_direction()
		var target := terrain.world_to_grid(global_position) + dig_dir
		if terrain.has_block(target):
			_is_digging = true
			_dig_target = target
			_dig_progress = 0.0

	if not _is_digging:
		return

	if not Input.is_action_pressed("player_dig") or not terrain.has_block(_dig_target):
		_is_digging = false
		_dig_progress = 0.0
		return

	_dig_progress += delta
	if _dig_progress >= terrain.get_dig_time(_dig_target):
		terrain.remove_block(_dig_target)
		_is_digging = false
		_dig_progress = 0.0
