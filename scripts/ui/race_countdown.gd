extends CanvasLayer


signal countdown_finished


@onready var countdown_label: Label = (
	$CenterContainer/CountdownLabel
)


func start_countdown() -> void:
	countdown_label.text = "3"
	await get_tree().create_timer(1.0).timeout

	countdown_label.text = "2"
	await get_tree().create_timer(1.0).timeout

	countdown_label.text = "1"
	await get_tree().create_timer(1.0).timeout

	countdown_label.text = "¡YA!"
	await get_tree().create_timer(0.7).timeout

	countdown_finished.emit()

	queue_free()
