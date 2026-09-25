extends CanvasLayer


@onready var winner_label: Label = (
	$Overlay/CenterContainer/PanelContainer/VBoxContainer/WinnerLabel
)

@onready var restart_button: Button = (
	$Overlay/CenterContainer/PanelContainer/VBoxContainer/RestartButton
)

@onready var menu_button: Button = (
	$Overlay/CenterContainer/PanelContainer/VBoxContainer/MenuButton
)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)


func show_winner(player_number: int) -> void:
	winner_label.text = "¡PLAYER %d GANA!" % player_number


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false

	get_tree().change_scene_to_file(
		"res://scenes/ui/main_menu.tscn"
	)
