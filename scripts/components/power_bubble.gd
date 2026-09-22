extends Area2D

@export var respawn_time: float = 5.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var available: bool = true


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not available:
		return

	if not body.is_in_group("player"):
		return

	if not body.has_method("give_power"):
		return

	_give_power(body)


func _give_power(player: CharacterBody2D) -> void:
	available = false

	var power: int = PowerManager.get_random_power()

	player.give_power(power)

	print(
		player.name,
		" tocó una Power Bubble y recibió: ",
		PowerManager.get_power_name(power)
	)

	_disable_bubble()

	await get_tree().create_timer(respawn_time).timeout

	_enable_bubble()


func _disable_bubble() -> void:
	sprite.visible = false
	collision.set_deferred("disabled", true)


func _enable_bubble() -> void:
	sprite.visible = true
	collision.set_deferred("disabled", false)
	available = true
