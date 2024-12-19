extends Camera

# Movement speed (adjust as needed)
var speed : float = 10.0
# Mouse sensitivity (adjust as needed)
var sensitivity : float = 0.3

# Variables to track mouse movement
var yaw : float = 0.0
var pitch : float = 0.0

# Movement directions
var forward : bool = false
var backward : bool = false
var left : bool = false
var right : bool = false
var up : bool = false
var down : bool = false

func _ready():
	# Hide the mouse cursor and capture it to move the camera smoothly
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement for camera rotation
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, -90, 90)  # Limit pitch to avoid flipping

func _process(delta):
	# Update camera rotation
	rotation_degrees.x = pitch
	rotation_degrees.y = yaw

	# Handle keyboard input using default UI actions
	forward = Input.is_action_pressed("ui_up")
	backward = Input.is_action_pressed("ui_down")
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	up = Input.is_action_pressed("move_up")  # Keep these custom actions
	down = Input.is_action_pressed("move_down")  # Keep these custom actions

	# Apply movement based on input
	var direction = Vector3()

	if forward:
		direction -= transform.basis.z  # Invert the direction to make forward positive
	if backward:
		direction += transform.basis.z  # Invert the direction to make backward negative
	if left:
		direction -= transform.basis.x
	if right:
		direction += transform.basis.x
	if up:
		direction += Vector3(0, 1, 0)
	if down:
		direction -= Vector3(0, 1, 0)

	# Normalize direction and move the camera
	direction = direction.normalized()
	translation += direction * speed * delta
