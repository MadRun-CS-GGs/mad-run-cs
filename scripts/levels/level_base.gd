class_name LevelBase
extends Node2D

const PLAYER_SCENE := preload("res://scenes/characters/player.tscn")

@onready var spawn: Marker2D = $Gameplay/PlayerSpawn
@onready var exit_area: Area2D = $Gameplay/LevelExit
@onready var entities: Node2D = $Gameplay/Entities

@onready var limit_top_left: Marker2D = $CameraLimits/TopLeft
@onready var limit_bottom_right: Marker2D = $CameraLimits/BottomRight

var player: CharacterBody2D


func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	entities.add_child(player)
	player.global_position = spawn.global_position

	exit_area.body_entered.connect(_on_exit_body_entered)

	_apply_limits()


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
