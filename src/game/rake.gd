class_name Rake
extends CharacterBody2D


enum RakeState {SLEEP, NORMAL, CHASE}

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var see_area: Area2D

# Rake behaivor
var rake_state: RakeState = RakeState.NORMAL:
	set(value):
		rake_state = value
		match value:
			RakeState.CHASE:
				pass
			RakeState.NORMAL:
				direction.x = 0
var direction: Vector2 = Vector2(0, 0)
var target: Player


func _physics_process(delta: float) -> void:
	behavior(delta)

func behavior(delta: float) -> void:
	if rake_state == RakeState.CHASE:
		chase()
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
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func chase() -> void:
	var target_position: float = clamp(target.global_position.x - global_position.x, -1, 1)
	direction.x = target_position

func _on_see_area_body_entered(player: PhysicsBody2D) -> void:
	if player is Player:
		if rake_state == RakeState.NORMAL:
			start_chase(player)

func _on_see_area_body_exited(player: PhysicsBody2D):
	if player is Player:
		if rake_state == RakeState.CHASE:
			end_chase()

func start_chase(player: Player) -> void:
	target = player
	rake_state = RakeState.CHASE

func end_chase() -> void:
	target = null
	rake_state = RakeState.NORMAL
