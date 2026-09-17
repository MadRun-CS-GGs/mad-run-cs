extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0

@onready var sprite: AnimatedSprite2D = $Sprite2D

var s_active: bool = true
var jump_active: bool = true
var wjump_active: bool = true

var checkpoint_position: Vector2

func _ready() -> void:
	add_to_group("player")
	checkpoint_position = global_position

func set_checkpoint(new_position: Vector2) -> void:
	checkpoint_position = new_position

func respawn() -> void:
	global_position = checkpoint_position
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if is_on_wall() and velocity.y > 0:
			velocity.y *= 0.85
			wjump_active = true
		else:
			wjump_active = false
		
	if is_on_floor():
		jump_active = true
	
	var direction: float = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("jump") and jump_active and velocity.y <= 105:
		velocity.y = jump_velocity
		jump_active = false
		print(velocity)
	elif Input.is_action_just_pressed("jump") and wjump_active:
		velocity.y = -325
		velocity.x = -direction * 375
		wjump_active = false

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
	
	if Input.is_action_just_pressed("s_action") and s_active == true:
		velocity.x = direction * 700.0
		velocity.y = 0
		print(velocity)
		s_active = false
		await get_tree().create_timer(1).timeout
		s_active = true
		
	move_and_slide()

	if direction != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()
		
func bounce(force: float) -> void:
	velocity.y = force
