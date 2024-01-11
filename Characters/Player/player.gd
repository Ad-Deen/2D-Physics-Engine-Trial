extends CharacterBody2D

			#although these variables are editable but the assigned ones are default
@export var speed : float = 200.0		#speed measured in pixels per second
@export var jump_vel : float = -250.0	#-y is upwards
@export var air_jump_vel : float = -150.0
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D



										#+y is downwards in godot
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_air_jumped : bool = false
var animation_locked :bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_air_jumped = false
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():		#normal jump
			jump()
		elif not has_air_jumped:
			if Input.is_action_pressed("Down"):
				velocity.y -= air_jump_vel
				has_air_jumped = true
			else:
				velocity.y += air_jump_vel
				has_air_jumped = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left","right","Up","Down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing_direction()

func update_animation():
	if direction.x != 0:
		animated_sprite.play("run")
		#animated_sprite.play("jump_start")
	else:
		animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:		#right side so no flip
		animated_sprite.flip_h = false
	elif direction.x < 0 :		#left side which needs flip
		animated_sprite.flip_h = true
	
func jump():
	velocity.y += jump_vel
	animated_sprite.play("jump_start")
	animation_locked = true
