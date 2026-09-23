extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	target_position = start_position + offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var offset: Vector2 = Vector2(0, 150)
@export var speed: float = 100.0

var start_position: Vector2
var target_position: Vector2
var going_to_target: bool = true

func _physics_process(delta: float) -> void:
	var destination := target_position if going_to_target else start_position
	
	global_position = global_position.move_toward(
		destination,
		speed * delta
	)
	
	if global_position.distance_to(destination) < 1.0:
		going_to_target = not going_to_target
