extends StaticBody2D


# Called when the node enters the scene tree for the first time.
@export var visible_time: float = 2.0
@export var hidden_time: float = 2.0

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var visual: Polygon2D = $Polygon2D


func _ready() -> void:
	disappear_loop()


func disappear_loop() -> void:
	while true:
		# Plataforma visible
		visual.visible = true
		collision.set_deferred("disabled", false)

		await get_tree().create_timer(visible_time).timeout

		# Plataforma desaparece
		visual.visible = false
		collision.set_deferred("disabled", true)

		await get_tree().create_timer(hidden_time).timeout
