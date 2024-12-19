extends StaticBody3D

# The Light node (child of the StaticBody)
@onready var light_node: OmniLight3D = $Light

# Variables to control flashing and timing
var bpm = 255.0  # Beats per minute
var flash_duration = 60.0 / bpm  # Duration of each beat in seconds
var light_flash_intensity = 5.0  # How intense the light flashes
var light_default_intensity = 1.0  # Default intensity of the light

# Timer to handle the beat flashing
var timer: Timer

func _ready() -> void:
	# Initialize the timer to control the flash rate
	timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = flash_duration
	timer.one_shot = false  # Keep the timer running
	timer.connect("timeout", Callable(self, "_on_beat_flash"))
	
	# Start the timer to begin flashing
	timer.start()

	# Set initial light intensity to default
	#light_node.brightness = light_default_intensity

func _on_beat_flash() -> void:
	# Flash the light to the beat
	if light_node.brightness == light_default_intensity:
		light_node.brightness = light_flash_intensity  # Increase light intensity
	else:
		light_node.brightness = light_default_intensity  # Return to default intensity
