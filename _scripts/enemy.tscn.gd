extends CharacterBody2D

const SPEED := 100.0
const GRAVITY := 600.0

var direction := 1


func _ready() -> void:
	add_to_group("enemy")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	velocity.x = direction * SPEED

	move_and_slide()

	if is_on_wall():
		direction *= -1
