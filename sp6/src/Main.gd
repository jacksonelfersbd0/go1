extends Node3D

# ----------------- SCENE SCRIPT ------------------#
#    Close your game faster by clicking 'Esc'      #
#   Change mouse mode by clicking 'Shift + F1'     #
# -------------------------------------------------#

@export var fast_close: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set mouse mode to captured (commented out here as per the original script)
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Disable fast_close in non-debug builds
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	# Enable input processing only if fast_close is enabled
	set_process_input(fast_close)

func _input(event: InputEvent) -> void:
	# Check for 'ui_cancel' action (default 'Esc' key) to quit the game
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
