class_name Game
extends Node2D

@export_category("Player-Camera")
@export var player: Player
@export var camera: Camera2D
@export_category("Interface")
@export var ui: CanvasLayer
@export var blood: ColorRect
@export_category("Parallax")
@export var background: Node2D
@export var mountains: Parallax2D
@export var wires: Parallax2D
@export var background_snow: Parallax2D
@export_category("Objects")
@export var rake: Rake
@export_category("Preset")
@export var night_mode := false

var camera_locked := true

func _ready() -> void:
	player.started_run.connect(_on_player_started_run)
	player.ended_run.connect(_on_player_ended_run)
	
	rake.chase_started.connect(_on_rake_chase_started)
	
	if night_mode:
		player.set_night_mode()
		ui.set_night_mode()
		set_night_mode()

func _physics_process(delta: float) -> void:
	if camera_locked:
		camera.global_position.x = player.global_position.x

func _on_player_started_run():
	camera.zoom -= Vector2(0.02, 0.02)

func _on_player_ended_run():
	camera.zoom += Vector2(0.02, 0.02)

func _on_rake_chase_started():
	var camera_tween = get_tree().create_tween()
	camera_locked = false
	camera_tween.tween_property(camera, "position", Vector2(rake.position.x, camera.position.y), 0.01)
	
	var chase_tween = get_tree().create_tween()
	chase_tween.tween_property(camera, "zoom", Vector2(1.25, 1.25), 0.05)
	chase_tween.tween_property(camera, "zoom", Vector2(1, 1), 0.05)
	chase_tween.tween_property(blood, "modulate", Color(1, 1, 1, 0.05), 0.02)
	chase_tween.tween_property(camera, "zoom", Vector2(1.25, 1.25), 0.1)
	chase_tween.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
	chase_tween.tween_property(blood, "modulate", Color(1, 1, 1, 0), 0.02)
	chase_tween.tween_property(camera, "zoom", Vector2(1.25, 1.25), 0.2)
	chase_tween.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
	
	await chase_tween.finished
	camera_locked = true
	while true:
		var anxiety_tween = get_tree().create_tween()
		anxiety_tween.tween_property(camera, "zoom", Vector2(1.05, 1.05), 0.1)
		anxiety_tween.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
		anxiety_tween.tween_property(blood, "modulate", Color(1, 1, 1, 0.05), 0.06)
		anxiety_tween.tween_property(blood, "modulate", Color(1, 1, 1, 0), 0.02)
		anxiety_tween.tween_property(camera, "zoom", Vector2(1.05, 1.05), 0.1)
		anxiety_tween.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
		anxiety_tween.tween_property(blood, "modulate", Color(1, 1, 1, 0.05), 0.06)
		anxiety_tween.tween_property(blood, "modulate", Color(1, 1, 1, 0), 0.02)
		await anxiety_tween.finished
		await get_tree().create_timer(0.75).timeout

func set_night_mode():
	background.hide()
	mountains.modulate = Color(1, 1, 1, 0.45)
	wires.modulate = Color(1, 1, 1, 0.1)
	background_snow.modulate = Color(1, 1, 1, 0.6)
	pass
