extends Area2D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

@export var bounce_velocity: float = -700.0

func _on_body_entered(body: Node2D) -> void:
	if not (body.is_in_group("player") or body is CharacterBody2D):
		return

	if body.has_method("bounce"):
		body.call("bounce", bounce_velocity)
	elif body is CharacterBody2D:
		var character := body as CharacterBody2D
		character.velocity.y = bounce_velocity
