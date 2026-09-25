extends CanvasLayer

@onready var player1_power_label: Label = (
	$Screen/VBoxContainer/Player1Container/Player1PowerLabel
)

@onready var player2_power_label: Label = (
	$Screen/VBoxContainer/Player2Container/Player2PowerLabel
)

@onready var player1_viewport: SubViewport = (
	$Screen/VBoxContainer/Player1Container/Player1Viewport
)

@onready var player2_viewport: SubViewport = (
	$Screen/VBoxContainer/Player2Container/Player2Viewport
)

@onready var player1_camera: Camera2D = (
	$Screen/VBoxContainer/Player1Container/Player1Viewport/Player1Camera
)

@onready var player2_camera: Camera2D = (
	$Screen/VBoxContainer/Player2Container/Player2Viewport/Player2Camera
)

var player1: CharacterBody2D
var player2: CharacterBody2D


func _ready() -> void:
	# Ambos viewports muestran el mismo mundo del nivel.
	player1_viewport.world_2d = get_viewport().world_2d
	player2_viewport.world_2d = get_viewport().world_2d

	player1_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	player2_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS


func setup(
	p1: CharacterBody2D,
	p2: CharacterBody2D,
	top_left: Vector2,
	bottom_right: Vector2
) -> void:
	player1 = p1
	player2 = p2
	
	player1.power_changed.connect(
	_on_player1_power_changed
	)

	player2.power_changed.connect(
	_on_player2_power_changed
	)

	_update_power_labels()

	_apply_camera_limits(player1_camera, top_left, bottom_right)
	_apply_camera_limits(player2_camera, top_left, bottom_right)

	player1_camera.global_position = player1.global_position
	player2_camera.global_position = player2.global_position

	player1_camera.enabled = true
	player2_camera.enabled = true


func _process(_delta: float) -> void:
	if is_instance_valid(player1):
		player1_camera.global_position = player1.global_position

	if is_instance_valid(player2):
		player2_camera.global_position = player2.global_position


func _apply_camera_limits(
	camera: Camera2D,
	top_left: Vector2,
	bottom_right: Vector2
) -> void:
	camera.limit_left = int(top_left.x)
	camera.limit_top = int(top_left.y)
	camera.limit_right = int(bottom_right.x)
	camera.limit_bottom = int(bottom_right.y)

	camera.reset_smoothing()

func _on_player1_power_changed(
	power_name: String
) -> void:
	player1_power_label.text = (
		"P1 | " + power_name
	)


func _on_player2_power_changed(
	power_name: String
) -> void:
	player2_power_label.text = (
		"P2 | " + power_name
	)


func _update_power_labels() -> void:
	if player1 != null:
		player1_power_label.text = (
			"P1 | "
			+ PowerManager.get_power_name(
				player1.held_power
			)
		)

	if player2 != null:
		player2_power_label.text = (
			"P2 | "
			+ PowerManager.get_power_name(
				player2.held_power
			)
		)
