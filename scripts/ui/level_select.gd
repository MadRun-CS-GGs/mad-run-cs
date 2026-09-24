extends Control

const CHARACTER_SELECT_SCENE := "res://scenes/ui/character_select.tscn"

const LEVEL_SCENES := [
	"res://scenes/levels/sandbox_malecon.tscn",
	"res://scenes/levels/level_02.tscn",
	"res://scenes/levels/level_03.tscn",
	"res://scenes/levels/level_04.tscn"
]

@onready var level1_button: Button = $CenterContainer/VBoxContainer/Level1Button
@onready var level2_button: Button = $CenterContainer/VBoxContainer/Level2Button
@onready var level3_button: Button = $CenterContainer/VBoxContainer/Level3Button
@onready var level4_button: Button = $CenterContainer/VBoxContainer/Level4Button
@onready var random_button: Button = $CenterContainer/VBoxContainer/RandomButton
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton


func _ready() -> void:
	level1_button.pressed.connect(_on_level1_pressed)
	level2_button.pressed.connect(_on_level2_pressed)
	level3_button.pressed.connect(_on_level3_pressed)
	level4_button.pressed.connect(_on_level4_pressed)
	random_button.pressed.connect(_on_random_pressed)
	back_button.pressed.connect(_on_back_pressed)


func _on_level1_pressed() -> void:
	_select_level(0)


func _on_level2_pressed() -> void:
	_select_level(1)


func _on_level3_pressed() -> void:
	_select_level(2)


func _on_level4_pressed() -> void:
	_select_level(3)


func _on_random_pressed() -> void:
	var random_level := randi_range(0, LEVEL_SCENES.size() - 1)
	_select_level(random_level)


func _select_level(level_index: int) -> void:
	GameManager.selected_level_index = level_index
	get_tree().change_scene_to_file(LEVEL_SCENES[level_index])


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(CHARACTER_SELECT_SCENE)
