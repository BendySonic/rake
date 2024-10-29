class_name Player
extends CharacterBody2D

signal started_run
signal ended_run

const NORMAL_SPEED = 250.0
const RUN_SPEED = 500.0
const JUMP_VELOCITY = -400.0

@export var night: Node2D
@export var flashnight: PointLight2D
@export var light_area: Area2D

var speed = 225.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_run := false
var is_flick_started := false
var is_flick := false


func _physics_process(delta: float) -> void:
	move(delta)
	point_flashnight()

func move(delta: float) -> void:
	# Move
	var direction = Input.get_vector("left", "right", "forward", "back")
	velocity = direction * speed
	# Run
	if Input.is_action_just_pressed("run"):
		is_run = true
		speed = RUN_SPEED
		started_run.emit()
	elif Input.is_action_just_released("run"):
		is_run = false
		speed = NORMAL_SPEED
		ended_run.emit()
	
	move_and_slide()

func flick_flashnight():
	while true:
		if light_area.has_overlapping_bodies():
			if not is_flick:
				await get_tree().create_timer(0.2).timeout
			is_flick = true
			var anxiety_tween = get_tree().create_tween()
			anxiety_tween.tween_property(flashnight, "energy", 0.0, 0.05)
			anxiety_tween.tween_property(flashnight, "energy", 0.75, 0.15).set_delay(0.2)
			await anxiety_tween.finished
		else:
			is_flick = false
			await get_tree().create_timer(0.1).timeout

func set_night_mode():
	night.show()

func point_flashnight():
	flashnight.look_at(get_global_mouse_position())

func _on_light_area_2d_body_entered(body: Node2D) -> void:
	if body is Rake:
		body.start_chase(self)
		if not is_flick_started:
			is_flick_started = true
			flick_flashnight()
