extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0

# Controles configurables.
# Estos valores corresponden por defecto al Player 1.
@export var move_left_action: StringName = &"move_left"
@export var move_right_action: StringName = &"move_right"
@export var jump_action: StringName = &"jump"

# Dash.
@export var special_action: StringName = &"s_action"

# Uso del poder obtenido de un Lucky Block.
@export var use_power_action: StringName = &"use_power"

@onready var sprite: AnimatedSprite2D = $Sprite2D


# Estado de movimiento.
var s_active: bool = true
var jump_active: bool = true
var wjump_active: bool = true

# Checkpoints.
var checkpoint_position: Vector2

# Poder que tiene guardado actualmente el jugador.
var held_power: int = PowerManager.PowerType.NONE

# Modificadores temporales de movimiento.
var speed_power_multiplier: float = 1.0
var acceleration_power_multiplier: float = 1.0

# Sirve para reiniciar correctamente la duración si se usa otra Sopa
# antes de que termine la anterior.
var speed_boost_version: int = 0

func _ready() -> void:
	add_to_group("player")
	checkpoint_position = global_position


func _physics_process(delta: float) -> void:
	# Gravedad y wall slide.
	if not is_on_floor():
		velocity += get_gravity() * delta

		if is_on_wall() and velocity.y > 0:
			velocity.y *= 0.85
			wjump_active = true
		else:
			wjump_active = false

	if is_on_floor():
		jump_active = true

	# Dirección horizontal.
	var direction: float = Input.get_axis(
		move_left_action,
		move_right_action
	)

	# Salto normal.
	if (
		Input.is_action_just_pressed(jump_action)
		and jump_active
		and velocity.y <= 105
	):
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
			direction * speed * speed_power_multiplier,
			acceleration * acceleration_power_multiplier * delta
		)

		sprite.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			friction * delta
		)

	# Dash.
	if Input.is_action_just_pressed(special_action) and s_active:
		velocity.x = direction * 700.0
		velocity.y = 0.0

		s_active = false

		await get_tree().create_timer(1.0).timeout

		s_active = true

	# Activar poder guardado.
	if Input.is_action_just_pressed(use_power_action):
		use_held_power()

	move_and_slide()
	_check_lucky_block_collision()
	
	# Animaciones.
	if direction != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()


# ------------------------------------------------
# POWER SYSTEM
# ------------------------------------------------

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

	# Consumimos el poder.
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

func _check_lucky_block_collision() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)

		# Cuando chocamos con un techo, la normal apunta hacia abajo.
		if collision.get_normal().y <= 0.5:
			continue

		var collider := collision.get_collider()

		if collider != null and collider.has_method("hit_from_below"):
			collider.hit_from_below(self)

# ------------------------------------------------
# PODERES
# --------------A----------------------------------

func _activate_sopa_fiec() -> void:
	speed_boost_version += 1
	var current_version: int = speed_boost_version

	speed_power_multiplier = 1.30
	acceleration_power_multiplier = 1.30

	print(name, " tiene Speed Boost durante 3 segundos")

	await get_tree().create_timer(3.0).timeout

	# Si se usó otra Sopa mientras esperaba, el temporizador anterior
	# ya no debe cancelar el nuevo boost.
	if current_version != speed_boost_version:
		return

	speed_power_multiplier = 1.0
	acceleration_power_multiplier = 1.0

	print(name, " terminó Speed Boost")
