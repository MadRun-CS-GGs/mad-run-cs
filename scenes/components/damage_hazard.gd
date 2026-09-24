extends Area2D

@export var damage_amount: int = 1


func _ready() -> void:
	# Keeping this connection in code makes the component safe if it is
	# duplicated or rebuilt from a scene without its serialized connection.
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# The group is the normal path. The CharacterBody2D fallback keeps hazards
	# functional for a player scene that has not added itself to the group yet.
	if not (body.is_in_group("player") or body is CharacterBody2D):
		return

	if body.has_method("die"):
		body.call("die")
	elif body.has_method("take_damage"):
		body.call("take_damage", damage_amount)
	elif body.has_method("respawn"):
		body.call("respawn")
