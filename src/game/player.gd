class_name Player
extends CharacterBody2D

signal started_run
signal ended_run

const NORMAL_SPEED = 250.0
const RUN_SPEED = 350.0
const JUMP_VELOCITY = -400.0

@export var night: Node2D
@export var flashnight: PointLight2D

var speed = 225.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_run := false


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

func set_night_mode():
	night.show()

func point_flashnight():
	flashnight.look_at(get_global_mouse_position())
