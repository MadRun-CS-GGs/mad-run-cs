extends Node

const LEVELS: Array[String] = [
	"res://scenes/levels/level_01.tscn",
	"res://scenes/levels/level_02.tscn",
	"res://scenes/levels/level_03.tscn",
	"res://scenes/levels/level_04.tscn",
]

const MAIN_MENU: String = "res://scenes/ui/main_menu.tscn"


func load_level(index: int) -> void:
	if index >= 0 and index < LEVELS.size():
		GameManager.current_level = index
		get_tree().change_scene_to_file(LEVELS[index])
	else:
		push_error("SceneLoader: no existe el nivel %d" % index)


func next_level() -> void:
	GameManager.level_completed.emit(GameManager.current_level)
	var siguiente: int = GameManager.current_level + 1
	if siguiente < LEVELS.size():
		load_level(siguiente)
	else:
		get_tree().change_scene_to_file(MAIN_MENU)


func restart_level() -> void:
	load_level(GameManager.current_level)
