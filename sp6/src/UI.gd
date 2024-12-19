extends Control

# Signals for the player to listen to
signal jump_pressed
signal move_vector_updated(move_vector)

# References to UI elements
@onready var up_button = $RightScreen/UpButton
@onready var down_button = $RightScreen/DownButton
@onready var left_button = $RightScreen/LeftButton
@onready var right_button = $RightScreen/RightButton
@onready var jump_button = $LeftScreen/JumpButton

# Move vector
var move_vector = Vector2.ZERO

func _ready():
	# Connect button signals
	up_button.pressed.connect(_on_up_pressed)
	down_button.pressed.connect(_on_down_pressed)
	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)
	jump_button.pressed.connect(_on_jump_pressed)

	# Connect release signals to reset move_vector
	up_button.released.connect(_on_button_released)
	down_button.released.connect(_on_button_released)
	left_button.released.connect(_on_button_released)
	right_button.released.connect(_on_button_released)

func _on_up_pressed():
	move_vector = Vector2(0, 1)
	emit_signal("move_vector_updated", move_vector)

func _on_down_pressed():
	move_vector = Vector2(0, -1)
	emit_signal("move_vector_updated", move_vector)

func _on_left_pressed():
	move_vector = Vector2(-1, 0)
	emit_signal("move_vector_updated", move_vector)

func _on_right_pressed():
	move_vector = Vector2(1, 0)
	emit_signal("move_vector_updated", move_vector)

func _on_button_released():
	move_vector = Vector2.ZERO
	emit_signal("move_vector_updated", move_vector)

func _on_jump_pressed():
	emit_signal("jump_pressed")
	print("emit jump")
