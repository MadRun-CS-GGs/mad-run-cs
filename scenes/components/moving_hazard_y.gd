extends AnimatableBody2D

@export var offset: Vector2 = Vector2(0, 200)
@export var travel_time: float = 2.0

var start_position: Vector2

func _ready() -> void:
	start_position = global_position
	move_loop()

func move_loop() -> void:
	while true:
		var tween = create_tween()
		tween.tween_property(self, "global_position", start_position + offset, travel_time)
		await tween.finished

		tween = create_tween()
		tween.tween_property(self, "global_position", start_position, travel_time)
		await tween.finished

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("respawn"):
		body.respawn()
