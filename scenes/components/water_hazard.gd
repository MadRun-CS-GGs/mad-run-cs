extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#_on_body_entered()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_body_entered(body: Node2D) -> void:
	print("AGUA DETECTÓ: ", body.name)
	if body.is_in_group("player") and body.has_method("respawn"):
		body.respawn()
