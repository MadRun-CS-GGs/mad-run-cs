extends Node

signal lives_changed(lives: int)
signal game_over
signal level_completed(index: int)

const MAX_LIVES: int = 3

var lives: int = MAX_LIVES
var current_level: int = 0


func reset_game() -> void:
	lives = MAX_LIVES
	current_level = 0
	lives_changed.emit(lives)


func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over.emit()
