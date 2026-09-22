extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0
@export var air_acceleration: float = 800.0

# ------------------------------------------------
# INPUTS
# ------------------------------------------------

# Por defecto corresponden al Player 1.
@export var move_left_action: StringName = &"move_left"
@export var move_right_action: StringName = &"move_right"
@export var jump_action: StringName = &"jump"

# Dash:
# P1 -> Shift izquierdo
# P2 -> Ctrl derecho
@export var special_action: StringName = &"s_action"

# Uso del poder:
# P1 -> S
# P2 -> Flecha abajo
@export var use_power_action: StringName = &"use_power"


@onready var sprite: AnimatedSprite2D = $Sprite2D


# ------------------------------------------------
# ESTADO DE MOVIMIENTO
# ------------------------------------------------

# Dash.
var s_active: bool = false
var s_timeout: bool = true

# Saltos.
var jump_active: bool = true
var wjump_active: bool = true

# Última dirección en la que miró el jugador.
# 1 = derecha, -1 = izquierda.
var last_dir: float = 1.0


# ------------------------------------------------
# CHECKPOINTS
# ------------------------------------------------

var checkpoint_position: Vector2


# ------------------------------------------------
# POWER SYSTEM
# ------------------------------------------------

var held_power: int = PowerManager.PowerType.NONE

var speed_power_multiplier: float = 1.0
var acceleration_power_multiplier: float = 1.0

var speed_boost_version: int = 0


func _ready() -> void:
	add_to_group("player")
	checkpoint_position = global_position


func _physics_process(delta: float) -> void:
	_handle_gravity_and_jump_flags(delta)

	var direction: float = Input.get_axis(
		move_left_action,
		move_right_action
	)

	_handle_jump(direction)
	_handle_horizontal_movement(direction, delta)
	_handle_dash()
	_handle_power_input()

	move_and_slide()

	_update_animation(direction)


# ------------------------------------------------
# MOVIMIENTO
# ------------------------------------------------

func _handle_gravity_and_jump_flags(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

		# Está tocando pared mientras todavía sube.
		if is_on_wall() and velocity.y < 0.0:
			jump_active = false
			wjump_active = true

		# Wall slide mientras cae.
		elif is_on_wall() and velocity.y > 0.0:
			velocity.y *= 0.85
			jump_active = false
			wjump_active = true

		else:
			wjump_active = false

	else:
		jump_active = true


func _handle_jump(_direction: float) -> void:
	# Salto normal.
	if (
		Input.is_action_just_pressed(jump_action)
		and jump_active
		and velocity.y <= 105.0
	):
		velocity.y = jump_velocity
		jump_active = false

	# Wall jump.
	elif Input.is_action_just_pressed(jump_action) and wjump_active:
		velocity.y = -325.0
		velocity.x = -last_dir * 350.0
		wjump_active = false


func _handle_horizontal_movement(
	direction: float,
	delta: float
) -> void:
	var current_max_speed: float = speed * speed_power_multiplier
	var current_acceleration: float = (
		acceleration * acceleration_power_multiplier
	)

	if direction != 0.0:
		if is_on_floor():
			velocity.x = move_toward(
				velocity.x,
				direction * current_max_speed,
				current_acceleration * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				direction * current_max_speed,
				air_acceleration * acceleration_power_multiplier * delta
			)

		sprite.flip_h = direction < 0.0
		last_dir = direction

	else:
		if is_on_floor():
			velocity.x = move_toward(
				velocity.x,
				0.0,
				friction * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				0.0,
				air_acceleration * delta
			)


# ------------------------------------------------
# DASH
# ------------------------------------------------

func _handle_dash() -> void:
	# Inicia dash y cooldown.
	if (
		Input.is_action_just_pressed(special_action)
		and s_timeout
	):
		_start_dash()

	# Mientras el dash esté activo.
	if s_active:
		if is_on_wall():
			s_active = false
			return

		velocity.y = 0.0
		velocity.x = last_dir * 400.0


func _start_dash() -> void:
	s_active = true
	s_timeout = false

	await get_tree().create_timer(0.15).timeout

	s_active = false

	await get_tree().create_timer(2.0).timeout

	s_timeout = true

	print(name, ": DASH CARGADO")


# ------------------------------------------------
# ANIMACIONES
# ------------------------------------------------

func _update_animation(direction: float) -> void:
	if direction != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()


# ------------------------------------------------
# POWER SYSTEM
# ------------------------------------------------

func _handle_power_input() -> void:
	if Input.is_action_just_pressed(use_power_action):
		use_held_power()


func give_power(power: int) -> void:
	held_power = power

	print(
		name,
		" recibió: ",
		PowerManager.get_power_name(held_power)
	)


func use_held_power() -> void:
	if held_power == PowerManager.PowerType.NONE:
		return

	var power_to_use: int = held_power

	print(
		name,
		" usó: ",
		PowerManager.get_power_name(power_to_use)
	)

	held_power = PowerManager.PowerType.NONE

	match power_to_use:
		PowerManager.PowerType.SOPA_FIEC:
			_activate_sopa_fiec()

		PowerManager.PowerType.BACHE_VIA_COSTA:
			print("Bache todavía no implementado")

		PowerManager.PowerType.GRANIZO_GUAYACO:
			print("Granizo todavía no implementado")

		PowerManager.PowerType.GUARDIA_ESPOL:
			print("Escudo todavía no implementado")

		PowerManager.PowerType.CANGREJO_ALBORADA:
			print("Cangrejo todavía no implementado")


func has_power() -> bool:
	return held_power != PowerManager.PowerType.NONE


# ------------------------------------------------
# PODERES
# ------------------------------------------------

func _activate_sopa_fiec() -> void:
	speed_boost_version += 1

	var current_version: int = speed_boost_version

	speed_power_multiplier = 1.30
	acceleration_power_multiplier = 1.30

	print(name, " tiene Speed Boost durante 3 segundos")

	await get_tree().create_timer(3.0).timeout

	# Si se activó otra Sopa mientras este temporizador esperaba,
	# este temporizador antiguo no debe cancelar el boost nuevo.
	if current_version != speed_boost_version:
		return

	speed_power_multiplier = 1.0
	acceleration_power_multiplier = 1.0

	print(name, " terminó Speed Boost")


# ------------------------------------------------
# CHECKPOINTS / RESPAWN
# ------------------------------------------------

func set_checkpoint(new_position: Vector2) -> void:
	checkpoint_position = new_position


func respawn() -> void:
	global_position = checkpoint_position
	velocity = Vector2.ZERO


# ------------------------------------------------
# COMPONENTES
# ------------------------------------------------

func bounce(force: float) -> void:
	velocity.y = force