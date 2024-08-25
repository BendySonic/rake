class_name Game
extends Node2D

@export_category("Player-Camera")
@export var player: Player
@export var camera: Camera2D
@export_category("Interface")
@export var camera_ui: CanvasLayer
@export_category("Parallax")
@export var background: Node2D
@export var mountains: Parallax2D
@export var wires: Parallax2D
@export var background_snow: Parallax2D
@export_category("Preset")
@export var night_mode := false

func _ready() -> void:
	player.started_run.connect(_on_player_started_run)
	player.ended_run.connect(_on_player_ended_run)
	
	if night_mode:
		player.set_night_mode()
		camera_ui.set_night_mode()
		set_night_mode()

func _physics_process(delta: float) -> void:
	$Objects/Camera2D.global_position.x = $Objects/Player.global_position.x

func _on_player_started_run():
	camera.zoom -= Vector2(0.02, 0.02)

func _on_player_ended_run():
	camera.zoom += Vector2(0.02, 0.02)

func set_night_mode():
	background.hide()
	mountains.modulate = Color(1, 1, 1, 0.45)
	wires.modulate = Color(1, 1, 1, 0.1)
	background_snow.modulate = Color(1, 1, 1, 0.6)
	pass
