extends CharacterBody3D


const SPEED = 5.0
const INITIAL_JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping_velocity_increments = 0.0
var isJumping = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		jumping_velocity_increments -= .5
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += INITIAL_JUMP_VELOCITY
		jumping_velocity_increments = 0
		isJumping = true
		
	if Input.is_action_pressed("ui_accept") && isJumping:
		if jumping_velocity_increments < 15.0:
			jumping_velocity_increments += 1
			velocity.y += .2
		else:
			isJumping = false
	if Input.is_action_just_released("ui_accept"):
		isJumping = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var moddedSpeed = SPEED
	if Input.is_physical_key_pressed(KEY_SHIFT):
		moddedSpeed = SPEED * 2
	var input_dir = Input.get_vector("move left", "move right", "move up", "move down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * moddedSpeed
		velocity.z = direction.z * moddedSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, moddedSpeed)
		velocity.z = move_toward(velocity.z, 0, moddedSpeed)

	move_and_slide()
