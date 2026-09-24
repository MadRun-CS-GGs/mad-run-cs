class_name SteamHazard
extends Area2D

## Conducto de vapor temporizado para los tramos verticales.
## Durante la advertencia se ve vapor ámbar, pero no hay colisión. Al entrar
## en el estado activo, el chorro blanco daña al jugador en la capa 2.

@export_range(0.1, 10.0, 0.05) var active_duration: float = 1.15
@export_range(0.6, 10.0, 0.05) var inactive_duration: float = 1.65
@export_range(0.2, 2.0, 0.05) var warning_duration: float = 0.5
@export var damage_amount: int = 1

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var conduit_visual: Polygon2D = $ConduitVisual
@onready var warning_visual: Polygon2D = $WarningVisual
@onready var steam_particles: GPUParticles2D = $SteamParticles
@onready var cycle_timer: Timer = $CycleTimer
@onready var warning_timer: Timer = $WarningTimer

var active: bool = false


func _ready() -> void:
	# Layer 5 is hazards; mask 2 listens exclusively for the player layer.
	collision_layer = 16
	collision_mask = 2

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not cycle_timer.timeout.is_connected(_on_cycle_timer_timeout):
		cycle_timer.timeout.connect(_on_cycle_timer_timeout)
	if not warning_timer.timeout.is_connected(_on_warning_timer_timeout):
		warning_timer.timeout.connect(_on_warning_timer_timeout)

	_begin_inactive()


func _begin_inactive() -> void:
	active = false
	monitoring = false
	monitorable = false
	collision_shape.set_deferred("disabled", true)
	conduit_visual.modulate = Color(0.35, 0.45, 0.52, 1.0)
	warning_visual.visible = false
	steam_particles.emitting = false
	cycle_timer.start(maxf(0.1, inactive_duration - warning_duration))


func _begin_warning() -> void:
	# The player gets a fixed 0.5 s visual warning before any hitbox exists.
	warning_visual.visible = true
	warning_visual.modulate = Color(1.0, 0.62, 0.16, 0.75)
	steam_particles.modulate = Color(1.0, 0.7, 0.25, 0.55)
	steam_particles.emitting = true
	warning_timer.start(warning_duration)


func _begin_active() -> void:
	active = true
	monitoring = true
	monitorable = true
	collision_shape.set_deferred("disabled", false)
	conduit_visual.modulate = Color(0.72, 0.9, 1.0, 1.0)
	warning_visual.visible = false
	steam_particles.modulate = Color(0.9, 0.97, 1.0, 0.95)
	steam_particles.emitting = true
	cycle_timer.start(active_duration)


func _on_cycle_timer_timeout() -> void:
	if active:
		_begin_inactive()
	else:
		_begin_warning()


func _on_warning_timer_timeout() -> void:
	_begin_active()


func _on_body_entered(body: Node2D) -> void:
	if not active:
		return
	if not (body.is_in_group("player") or body is CharacterBody2D):
		return

	if body.has_method("die"):
		body.call("die")
	elif body.has_method("take_damage"):
		body.call("take_damage", damage_amount)
	elif body.has_method("respawn"):
		body.call("respawn")
