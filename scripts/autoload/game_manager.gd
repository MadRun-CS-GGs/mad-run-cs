extends Node

const CHARACTER_SCENES: Array[PackedScene] = [
	preload("res://scenes/characters/player.tscn"),
	preload("res://scenes/characters/player.tscn"),
	preload("res://scenes/characters/player.tscn")
]

var player1_character_index: int = 0
var player2_character_index: int = 0
var selected_level_index: int = 0


func get_character_scene(character_index: int) -> PackedScene:
	if character_index < 0 or character_index >= CHARACTER_SCENES.size():
		return CHARACTER_SCENES[0]

	return CHARACTER_SCENES[character_index]
