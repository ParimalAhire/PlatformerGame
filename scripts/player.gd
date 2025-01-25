extends CharacterBody2D

@export var MAX_SPEED = 200
@export var ACCELERATION = 20
@export var DECELERATION = 4
@export var GRAVITY = 20
@export var JUMP_FORCE = 500
@export var FRICTION = 0.7 * ACCELERATION
@export var JUMP_BUFFER = 60

var state

enum STATES { IDLE, RUNNING, JUMPING, FALLING, LANDING}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	JUMP_BUFFER = min(JUMP_BUFFER+1,60)
	
	if not is_on_floor():
		velocity.y += GRAVITY
		print(velocity.y)
		if(velocity.y < 0):
			state = STATES.JUMPING
		elif velocity.y > 0:
			state = STATES.FALLING
			
	else:
		if Input.is_action_pressed("jump") and JUMP_BUFFER == 60:
			velocity.y -= JUMP_FORCE 
			JUMP_BUFFER = 0
			print("jumping")
			
		if velocity.x == 0 :
			state = STATES.IDLE
		else:
			state = STATES.RUNNING
	
	if velocity.x > -200:
		if Input.is_action_pressed("move_left"):
			velocity.x = min(velocity.x - ACCELERATION + FRICTION, MAX_SPEED)
			animated_sprite.flip_h = true
	if velocity.x < 200:
		if Input.is_action_pressed("move_right"):
			velocity.x = min(velocity.x + ACCELERATION - FRICTION, MAX_SPEED)
			animated_sprite.flip_h = false
	
	# ANIMATION
	match state:
		0:
			animated_sprite.play("idle")
			print("idle")
		1:
			animated_sprite.play("run")
			print("running")
			print(velocity.x)
			if(velocity.x > 0):
				velocity.x = max(velocity.x - DECELERATION, 0)
			elif(velocity.x < 0):
				velocity.x = min(velocity.x + DECELERATION, 0)
		2:
			animated_sprite.play("jump")
			print("jumping")
		3:
			animated_sprite.play("fall")
			print("Falling")
		4:
			animated_sprite.play("land")
			print("landed")
	

	move_and_slide()
