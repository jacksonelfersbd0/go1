extends Node3D

# Reference to the ball
@onready var ball: RigidBody3D = get_node("../Player/RigidBody3D")
@onready var camera: Camera3D = $Camera

# Camera follow smoothing factor
var follow_speed: float = 5.0

# Mouse sensitivity and pitch limits
var sensitivity: float = 0.5
var min_pitch: float = -80.0
var max_pitch: float = 80.0

# Camera rotation variables
var yaw: float = 0.0
var pitch: float = 0.0

# Desired distance between camera and ball
var camera_distance: float = 5.0  # Adjust this value to set how far the camera is from the ball

func _ready() -> void:
	# Hide the mouse cursor for free movement
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Handle mouse motion for camera rotation
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)

func _process(delta: float) -> void:
	# Calculate the offset position based on yaw, pitch, and desired distance from the ball
	var offset: Vector3 = Vector3(0, 0, -camera_distance)
	offset = offset.rotated(Vector3(1, 0, 0), deg_to_rad(pitch))
	offset = offset.rotated(Vector3(0, 1, 0), deg_to_rad(yaw))
	
	# Target position for the camera
	var target_position: Vector3 = ball.global_transform.origin + offset
	
	# Smoothly interpolate the camera’s position for a smoother follow effect
	global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)
	
	# Apply yaw and pitch to camera rotation for the look direction
	rotation_degrees = Vector3(pitch, yaw, 0)
