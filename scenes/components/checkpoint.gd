extends Area2D
@onready var respawn_point: Marker2D = $Marker2D


func _ready() -> void:
	# Trigger layer, listening exclusively for players on Layer 2.
	collision_layer = 32
	collision_mask = 2
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("set_checkpoint"):
		body.set_checkpoint(respawn_point.global_position)
