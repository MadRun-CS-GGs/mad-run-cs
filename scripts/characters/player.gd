extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0

@onready var sprite: AnimatedSprite2D = $Sprite2D



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction: float = Input.get_axis("move_left", "move_right")

	if direction != 0.0:
		velocity.x = move_toward(
			velocity.x,
			direction * speed,
			acceleration * delta
		)
		sprite.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			friction * delta
		)

	move_and_slide()

	if direction != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()
