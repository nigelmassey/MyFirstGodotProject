extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animatedSprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animationLocked : bool = false
var direction : float = 0
var is_jumping : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			animatedSprite.play("fall")			
	elif is_jumping:
		animatedSprite.play("ground")
		is_jumping = false
		
	jump()
		
	if Input.is_action_just_pressed("attack"):
		attack()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()

func update_animation():
	if not animationLocked:
		if velocity.x == 0:
			animatedSprite.play("idle")
		elif velocity.x != 0 && not is_on_wall():
			animatedSprite.play("run")
			if direction == 1:
				animatedSprite.flip_h = false
			elif direction == -1:
				animatedSprite.flip_h = true

func attack():
	animationLocked = true
	animatedSprite.play("attack")
	
func jump():	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animationLocked = true
		is_jumping = true
		animatedSprite.play("jump")
		velocity.y = JUMP_VELOCITY
	
func _on_animated_sprite_2d_animation_finished():
	if not is_jumping:
		animationLocked = false
