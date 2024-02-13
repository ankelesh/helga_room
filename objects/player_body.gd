extends CharacterBody3D


var SPEED = 3.0
const WALK_SPEED = 3.0
const RUN_SPEED = 6.0
const JUMP_VELOCITY = 5.5

var spin = 0.1  # rotation speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	$SpringArm3D.add_excluded_object(self)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("strafe_right", "strafe_left", "move_back", "move_forward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x > 0:
			rotate_y(-lerp(0.0, spin, event.relative.x/10))
		elif event.relative.x < 0:
			rotate_y(-lerp(0.0, spin, event.relative.x/10))
	if Input.is_key_pressed(KEY_SHIFT):
		SPEED = lerp(RUN_SPEED, WALK_SPEED, -0.1)
	else:
		SPEED = lerp(WALK_SPEED, RUN_SPEED, 0.1)
			
