extends RigidBody3D

# Reference to the sound emitter
@onready var sound_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Preload sound to reduce delay
@export var sound_effect: AudioStream = preload("res://clap.wav")

func _ready() -> void:
	# Enable contact monitoring
	contact_monitor = true
	max_contacts_reported = 10  # Adjust if needed
	
	# Ensure the sound is set before the game starts
	sound_player.stream = sound_effect

	# Connect the "body_entered" signal
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Ensure the body is tagged as 'player'
	if body.is_in_group("player"):
		print("drum!")
		sound_player.play()  # Play the sound
