extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D

var active: bool = true
var sprite_start_position: Vector2


func _ready() -> void:
	sprite_start_position = sprite.position


func hit_from_below(player: CharacterBody2D) -> void:
	if not active:
		return

	if not player.is_in_group("player"):
		return

	if not player.has_method("give_power"):
		return

	active = false

	_play_hit_animation()

	var power: int = PowerManager.get_random_power()

	player.give_power(power)

	print(
		player.name,
		" golpeó el Lucky Block y obtuvo: ",
		PowerManager.get_power_name(power)
	)

	await get_tree().create_timer(1.0).timeout

	active = true


func _play_hit_animation() -> void:
	var tween := create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		sprite,
		"position",
		sprite_start_position + Vector2(0, -4),
		0.08
	)

	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		sprite,
		"position",
		sprite_start_position,
		0.10
	)
