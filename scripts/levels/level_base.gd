class_name LevelBase
extends Node2D


const SPLIT_SCREEN_SCENE: PackedScene = preload(
	"res://scenes/ui/split_screen.tscn"
)


@onready var spawn: Marker2D = $Gameplay/PlayerSpawn

@onready var player2_spawn: Marker2D = get_node_or_null(
	"Gameplay/Player2Spawn"
) as Marker2D

@onready var exit_area: Area2D = $Gameplay/LevelExit
@onready var entities: Node2D = $Gameplay/Entities

@onready var limit_top_left: Marker2D = $CameraLimits/TopLeft
@onready var limit_bottom_right: Marker2D = $CameraLimits/BottomRight


var player: CharacterBody2D
var player2: CharacterBody2D

var split_screen: CanvasLayer


func _ready() -> void:
	_create_player1()

	if player2_spawn != null:
		_create_player2()
		_create_split_screen()
	else:
		print("Este nivel todavía no tiene Player2Spawn")

	exit_area.body_entered.connect(_on_exit_body_entered)

	# Si solamente existe P1, usamos la cámara tradicional.
	if player2 == null:
		_apply_limits()


func _create_player1() -> void:
	var player_scene: PackedScene = GameManager.get_character_scene(
		GameManager.player1_character_index
	)

	player = player_scene.instantiate() as CharacterBody2D

	entities.add_child(player)

	player.global_position = spawn.global_position

	if player.has_method("set_checkpoint"):
		player.set_checkpoint(spawn.global_position)

	print(
		"Personaje P1 cargado: ",
		GameManager.player1_character_index
	)


func _create_player2() -> void:
	var player_scene: PackedScene = GameManager.get_character_scene(
		GameManager.player2_character_index
	)

	player2 = player_scene.instantiate() as CharacterBody2D

	# Controles exclusivos de Player 2.
	player2.set("move_left_action", &"p2_move_left")
	player2.set("move_right_action", &"p2_move_right")
	player2.set("jump_action", &"p2_jump")
	player2.set("special_action", &"p2_s_action")
	player2.set("use_power_action", &"p2_use_power")

	entities.add_child(player2)

	# Primero colocamos al jugador en su spawn.
	player2.global_position = player2_spawn.global_position

	# Luego guardamos ese mismo lugar como checkpoint inicial.
	if player2.has_method("set_checkpoint"):
		player2.set_checkpoint(player2_spawn.global_position)

	print(
		"Personaje P2 cargado: ",
		GameManager.player2_character_index
	)


func _create_split_screen() -> void:
	if player == null or player2 == null:
		return

	# Las cámaras incluidas dentro de player.tscn no se utilizarán
	# cuando estemos jugando con pantalla dividida.
	_disable_player_camera(player)
	_disable_player_camera(player2)

	split_screen = SPLIT_SCREEN_SCENE.instantiate() as CanvasLayer

	add_child(split_screen)

	split_screen.call(
		"setup",
		player,
		player2,
		limit_top_left.global_position,
		limit_bottom_right.global_position
	)


func _disable_player_camera(
	target_player: CharacterBody2D
) -> void:
	var camera := target_player.get_node_or_null(
		"Camera2D"
	) as Camera2D

	if camera != null:
		camera.enabled = false


func _apply_limits() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	if player == null:
		return

	var camera := player.get_node_or_null(
		"Camera2D"
	) as Camera2D

	if camera == null:
		return

	camera.limit_left = int(
		limit_top_left.global_position.x
	)

	camera.limit_top = int(
		limit_top_left.global_position.y
	)

	camera.limit_right = int(
		limit_bottom_right.global_position.x
	)

	camera.limit_bottom = int(
		limit_bottom_right.global_position.y
	)

	camera.reset_smoothing()


func _on_exit_body_entered(body: Node2D) -> void:
	if body == player:
		SceneLoader.call_deferred("next_level")
