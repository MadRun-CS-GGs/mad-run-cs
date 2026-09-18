extends Control

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu.tscn"
const LEVEL_SELECT_SCENE := "res://scenes/ui/level_select.tscn"

const CHARACTERS := [
	"PERSONAJE 1",
	"PERSONAJE 2",
	"PERSONAJE 3"
]

@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton

@onready var confirm_button: Button = $CenterContainer/VBoxContainer/ConfirmButton

@onready var player1_random_button: Button = $CenterContainer/VBoxContainer/PlayersContainer/Player1Panel/VBoxContainer/RandomButton
@onready var player2_random_button: Button = $CenterContainer/VBoxContainer/PlayersContainer/Player2Panel/VBoxContainer/RandomButton

@onready var player1_character_name: Label = $CenterContainer/VBoxContainer/PlayersContainer/Player1Panel/VBoxContainer/CharacterName
@onready var player1_previous_button: Button = $CenterContainer/VBoxContainer/PlayersContainer/Player1Panel/VBoxContainer/SelectionButtons/PreviousButton
@onready var player1_next_button: Button = $CenterContainer/VBoxContainer/PlayersContainer/Player1Panel/VBoxContainer/SelectionButtons/NextButton

@onready var player2_character_name: Label = $CenterContainer/VBoxContainer/PlayersContainer/Player2Panel/VBoxContainer/CharacterName
@onready var player2_previous_button: Button = $CenterContainer/VBoxContainer/PlayersContainer/Player2Panel/VBoxContainer/SelectionButtons/PreviousButton
@onready var player2_next_button: Button = $CenterContainer/VBoxContainer/PlayersContainer/Player2Panel/VBoxContainer/SelectionButtons/NextButton

var player1_index: int = 0
var player2_index: int = 0


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)
	
	player1_random_button.pressed.connect(_on_player1_random_pressed)
	player2_random_button.pressed.connect(_on_player2_random_pressed)
	
	player1_previous_button.pressed.connect(_on_player1_previous_pressed)
	player1_next_button.pressed.connect(_on_player1_next_pressed)
	
	player2_previous_button.pressed.connect(_on_player2_previous_pressed)
	player2_next_button.pressed.connect(_on_player2_next_pressed)
	
	_update_player1_display()
	_update_player2_display()


func _on_player1_previous_pressed() -> void:
	player1_index = wrapi(player1_index - 1, 0, CHARACTERS.size())
	_update_player1_display()


func _on_player1_next_pressed() -> void:
	player1_index = wrapi(player1_index + 1, 0, CHARACTERS.size())
	_update_player1_display()

func _on_player2_previous_pressed() -> void:
	player2_index = wrapi(player2_index - 1, 0, CHARACTERS.size())
	_update_player2_display()


func _on_player2_next_pressed() -> void:
	player2_index = wrapi(player2_index + 1, 0, CHARACTERS.size())
	_update_player2_display()


func _update_player2_display() -> void:
	player2_character_name.text = CHARACTERS[player2_index]

func _update_player1_display() -> void:
	player1_character_name.text = CHARACTERS[player1_index]


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _on_player1_random_pressed() -> void:
	player1_index = randi_range(0, CHARACTERS.size() - 1)
	_update_player1_display()


func _on_player2_random_pressed() -> void:
	player2_index = randi_range(0, CHARACTERS.size() - 1)
	_update_player2_display()

func _on_confirm_pressed() -> void:
	GameManager.player1_character_index = player1_index
	GameManager.player2_character_index = player2_index

	get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)
