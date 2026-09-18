extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0

# Acciones de entrada configurables.
# Por defecto corresponden al Jugador 1.
@export var move_left_action: StringName = &"move_left"
@export var move_right_action: StringName = &"move_right"
@export var jump_action: StringName = &"jump"
@export var special_action: StringName = &"s_action"

@onready var sprite: AnimatedSprite2D = $Sprite2D

var s_active: bool = true
var jump_active: bool = true
var wjump_active: bool = true


func _physics_process(delta: float) -> void:
	# Gravedad y detección de pared.
	if not is_on_floor():
		velocity += get_gravity() * delta

		if is_on_wall() and velocity.y > 0:
			velocity.y *= 0.85
			wjump_active = true
		else:
			wjump_active = false

	if is_on_floor():
		jump_active = true

	# Movimiento horizontal según las acciones asignadas al jugador.
	var direction: float = Input.get_axis(
		move_left_action,
		move_right_action
	)

	# Salto normal.
	if Input.is_action_just_pressed(jump_action) \
	and jump_active \
	and velocity.y <= 105:
		velocity.y = jump_velocity
		jump_active = false

	# Wall jump.
	elif Input.is_action_just_pressed(jump_action) and wjump_active:
		velocity.y = -325
		velocity.x = -direction * 375
		wjump_active = false

	# Movimiento horizontal.
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

	# Habilidad especial / dash.
	if Input.is_action_just_pressed(special_action) and s_active:
		velocity.x = direction * 700.0
		velocity.y = 0.0

		s_active = false

		await get_tree().create_timer(1.0).timeout

		s_active = true

	move_and_slide()

	# Animaciones.
	if direction != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()
