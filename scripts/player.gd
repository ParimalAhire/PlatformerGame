extends CharacterBody2D

@export var MAX_SPEED = 200
@export var ACCELERATION = 10
@export var DECELERATION = -40
@export var GRAVITY = 20
@export var JUMP_FORCE = 300
@export var FRICTION = 0.8 * ACCELERATION

var state

enum STATES { IDLE, RUNNING, JUMPING, FALLING, LANDING}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY
		state = STATES.JUMPING
	
	if Input.is_action_pressed("jump") and is_on_floor() :
		velocity.y -= JUMP_FORCE 
		print("jumping")
		
	if velocity.x > -200:
		if Input.is_action_pressed("move_left") and is_on_floor():
			velocity.x = min(velocity.x - ACCELERATION + FRICTION, MAX_SPEED)
			state = STATES.RUNNING
	if velocity.x < 200:
		if Input.is_action_pressed("move_right") and is_on_floor():
			velocity.x = min(velocity.x + ACCELERATION - FRICTION, MAX_SPEED)
			state = STATES.RUNNING
		
	if velocity.x == 0:
		state = STATES.IDLE
	else:
		state = STATES.RUNNING
	
	# ANIMATION
	match state:
		0:
			animated_sprite.play("idle")
			print("idle")
		1:
			animated_sprite.play("run")
			print("running")
			print(velocity.x)
		2:
			animated_sprite.play("jump")
			print("jumping")
		4:
			animated_sprite.play("land")
			print("landed")
	

	move_and_slide()
