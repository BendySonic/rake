class_name Rake
extends CharacterBody2D

signal chase_started


enum RakeState {SLEEP, NORMAL, FOLLOW, CHASE}

const NORMAL_SPEED = 200.0
const CHASE_SPEED = 400.0
const JUMP_VELOCITY = -400.0
var gravity = 0

@export var see_area: Area2D
@export var animation: AnimationPlayer
@export var player: Player
@export var default_scale: Vector2

# Rake behaivor
var rake_state: RakeState = RakeState.NORMAL:
	set(value):
		rake_state = value
		match value:
			RakeState.NORMAL:
				speed = NORMAL_SPEED
				direction = Vector2.ZERO
			RakeState.FOLLOW:
				speed = NORMAL_SPEED
			RakeState.CHASE:
				speed = CHASE_SPEED
var direction: Vector2 = Vector2.ZERO
var speed: float = NORMAL_SPEED


func _ready():
	animation.play("stay")
	scale = default_scale

func _physics_process(delta: float) -> void:
	behavior(delta)
	pass

func behavior(delta: float) -> void:
	match rake_state:
		RakeState.FOLLOW, RakeState.CHASE:
			follow()
	animate()
	move(delta)

func move(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Jump
	if direction.y == 1 and is_on_floor():
		direction.y = 0
		velocity.y = JUMP_VELOCITY
	
	# Direction
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func animate():
	var player_position: Vector2 = player.global_position - global_position
	if player_position.x >= 0:
		transform.x = Vector2(-default_scale.x, 0)
	else:
		transform.x = Vector2(default_scale.x, 0)

func follow() -> void:
	var player_position: Vector2 = (player.global_position - global_position).normalized()
	direction = player_position

func _on_see_area_body_entered(player: PhysicsBody2D) -> void:
	if player is Player:
		if rake_state == RakeState.NORMAL:
			start_follow(player)

func _on_see_area_body_exited(player: PhysicsBody2D):
	if player is Player:
		if rake_state == RakeState.FOLLOW:
			end_follow()

func start_follow(player: Player) -> void:
	rake_state = RakeState.FOLLOW
	animation.speed_scale = 0.63
	animation.play("sneak")

func end_follow() -> void:
	rake_state = RakeState.NORMAL

func start_chase(player: Player):
	if not rake_state == RakeState.CHASE:
		end_follow()
		chase_started.emit()
		animation.speed_scale = 0.75
		animation.play("scream")
		await animation.animation_finished
		rake_state = RakeState.CHASE
		animation.speed_scale = 0.8
		animation.play("run")
