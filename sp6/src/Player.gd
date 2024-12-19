extends RigidBody3D

# Movement speed
var speed = 60.0
# Jump strength
var jump_strength = 1500.0

# Reference to the camera and its holder
@onready var camera_holder = get_node("../../CameraHolder")
@onready var camera = camera_holder.get_node("Camera")

# References to the RayCast3D nodes
@onready var ray_cast_down = $RayCastDown
@onready var ray_cast_up = $RayCastUp
@onready var ray_cast_front = $RayCastFront
@onready var ray_cast_back = $RayCastBack
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight

# Vector to move the ball
var velocity = Vector3.ZERO

# For rotational movement (angular velocity)
var rotation_factor = 1.0

# Mobile control inputs
var mobile_move_vector = Vector2.ZERO

# Mouse capture state
var mouse_captured = true

func _ready():
	add_to_group("player")  # Ensure the player can be detected by the platform
	# Set up raycast directions
	ray_cast_down.target_position = Vector3(0, -0.5, 0)  # Straight down
	ray_cast_up.target_position = Vector3(0, 0.5, 0)     # Straight up
	ray_cast_front.target_position = Vector3(0, 0, -0.5)  # Forward
	ray_cast_back.target_position = Vector3(0, 0, 0.5)    # Backward
	ray_cast_left.target_position = Vector3(-0.5, 0, 0)   # Left
	ray_cast_right.target_position = Vector3(0.5, 0, 0)   # Right

	# Connect UI signals
	UIManager.move_vector_updated.connect(_on_move_vector_updated)
	UIManager.jump_pressed.connect(_on_jump_pressed)

	# Make sure the mouse is visible and part of the game by default
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("Mouse mode set to captured")

func _on_move_vector_updated(move_vector):
	# Update the move vector based on UI joystick input
	mobile_move_vector = move_vector

func _on_jump_pressed():
	print("jump pressed")
	# Jump action triggered by UI button press
	if ray_cast_down.is_colliding() or ray_cast_front.is_colliding() or ray_cast_back.is_colliding() or ray_cast_left.is_colliding() or ray_cast_right.is_colliding() or ray_cast_up.is_colliding():
		apply_central_force(Vector3(0, jump_strength, 0))

func _process(delta):
	# Get the camera's forward and right direction
	var forward = -camera.global_transform.basis.z.normalized()  # Negative Z is forward
	var right = camera.global_transform.basis.x.normalized()    # X is right

	# Remove any vertical movement from forward direction to only consider horizontal yaw
	forward.y = 0  # Ignore vertical (pitch) component of the forward direction
	forward = forward.normalized()  # Normalize again to ensure it's a unit vector

	# Get input from the player (horizontal movement)
	var move_dir = Vector3.ZERO

	# Keyboard input (PC controls)
	if Input.is_action_pressed("ui_left"):
		move_dir -= right
	if Input.is_action_pressed("ui_right"):
		move_dir += right
	if Input.is_action_pressed("ui_up"):
		move_dir += forward
	if Input.is_action_pressed("ui_down"):
		move_dir -= forward

	# Mobile joystick input (add joystick's move vector)
	if mobile_move_vector != Vector2.ZERO:
		move_dir += forward * mobile_move_vector.y + right * mobile_move_vector.x

	# Apply movement using forces (keep Y as 0 for horizontal-only movement)
	if move_dir != Vector3.ZERO:
		move_dir.y = 0  # Ignore any vertical (Y) movement
		# Apply force for linear movement
		apply_force(move_dir.normalized() * speed, Vector3.ZERO)
		
		# Calculate direction of torque based on input movement
		var torque = move_dir.cross(Vector3(0, 1, 0)) * rotation_factor
		apply_torque(torque)

	# Jump if the player presses the jump key and RayCasts detect the ground
	if Input.is_action_just_pressed("ui_accept") and (ray_cast_down.is_colliding() or 
		ray_cast_front.is_colliding() or ray_cast_back.is_colliding() or 
		ray_cast_left.is_colliding() or ray_cast_right.is_colliding() or 
		ray_cast_up.is_colliding()):
		apply_central_force(Vector3(0, jump_strength, 0))
