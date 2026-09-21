extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0

@onready var sprite: AnimatedSprite2D = $Sprite2D

var s_active: bool = false
var s_timeout: bool = true
var jump_active: bool = true
var wjump_active: bool = true
var last_dir: float = 1.00 #En la linea 59 se guarda la última dirección.

func _physics_process(delta: float) -> void:
	#Físicas de gravedad y banderas de salto.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if is_on_wall() and velocity.y < 0:
			jump_active = false
			wjump_active = true
		elif is_on_wall() and velocity.y > 0:
			velocity.y *= 0.85
			jump_active = false
			wjump_active = true
		else:
			wjump_active = false
	else:
		jump_active = true
	
	#Derecha es 1, Izquierda es -1 y ninguno es 0.
	var direction: float = Input.get_axis("move_left", "move_right")
	
	#Salto en suelo y salto en pared.
	if Input.is_action_just_pressed("jump") and jump_active and velocity.y <= 105:
		velocity.y = jump_velocity
		jump_active = false
	elif Input.is_action_just_pressed("jump") and wjump_active:
		velocity.y = -325
		velocity.x = -last_dir * 350
	
	#Todo lo relacionado al movimiento en x.
	if direction != 0.0:
		if is_on_floor():
			velocity.x = move_toward(
				velocity.x,
				direction * speed,
				acceleration * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				direction * speed,
				800 * delta
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
				800 * delta
			)
	
	#Temporizadores del dash (duración y recarga).
	if Input.is_action_just_pressed("s_action") and s_timeout == true:
		print(velocity)
		s_active = true
		s_timeout = false
		await get_tree().create_timer(0.15).timeout
		s_active = false
		await get_tree().create_timer(2).timeout
		s_timeout = true
		print("HABILIDAD CARGADA")
	
	#Acción del dash.
	if s_active == true:
		if is_on_wall():
			s_active = false
		velocity.y = 0
		velocity.x = last_dir * 400

	move_and_slide()

	if direction != 0.0:
		sprite.play("walk")
	else:
		sprite.stop()
