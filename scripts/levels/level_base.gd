class_name LevelBase
extends Node2D


@onready var spawn: Marker2D = $Gameplay/PlayerSpawn
@onready var player2_spawn: Marker2D = $Gameplay/Player2Spawn

@onready var exit_area: Area2D = $Gameplay/LevelExit
@onready var entities: Node2D = $Gameplay/Entities

@onready var limit_top_left: Marker2D = $CameraLimits/TopLeft
@onready var limit_bottom_right: Marker2D = $CameraLimits/BottomRight


var player: CharacterBody2D
var player2: CharacterBody2D


func _ready() -> void:
	_create_player1()
	_create_player2()

	exit_area.body_entered.connect(_on_exit_body_entered)

	_apply_limits()


func _create_player1() -> void:
	var player_scene: PackedScene = GameManager.get_character_scene(
		GameManager.player1_character_index
	)

	player = player_scene.instantiate() as CharacterBody2D

	entities.add_child(player)

	player.global_position = spawn.global_position

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

	entities.add_child(player2)

	player2.global_position = player2_spawn.global_position

	# Solamente Player 1 controla la cámara por ahora.
	var player2_camera := player2.get_node_or_null("Camera2D") as Camera2D

	if player2_camera != null:
		player2_camera.enabled = false

	print(
		"Personaje P2 cargado: ",
		GameManager.player2_character_index
	)


func _apply_limits() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	var camera := player.get_node_or_null("Camera2D") as Camera2D

	if camera != null:
		camera.limit_left = int(limit_top_left.global_position.x)
		camera.limit_top = int(limit_top_left.global_position.y)
		camera.limit_right = int(limit_bottom_right.global_position.x)
		camera.limit_bottom = int(limit_bottom_right.global_position.y)

		camera.reset_smoothing()


func _on_exit_body_entered(body: Node2D) -> void:
	if body == player:
		SceneLoader.call_deferred("next_level")
