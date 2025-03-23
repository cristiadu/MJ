extends RigidBody2D

@export var current_roll = 1
signal animation_completed(roll_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func roll():
	self.current_roll = randi() % 6 + 1
	play_roll_animation()
	return self.current_roll


func play_roll_animation():
	# Create a delayed timer to start animation
	var start_timer = get_tree().create_timer(0.1)
	start_timer.timeout.connect(_play_animation_sequence)


func _play_animation_sequence():
	# Simulate dice rolling animation frames
	for i in range(20): # Change the number for longer/shorter animation
		$Sprite2D.frame = randi() % 6 # Temporarily set to a random frame
		await get_tree().create_timer(0.15).timeout # Wait between frame changes
		
	# Set final frame and emit completion signal
	$Sprite2D.frame = self.current_roll - 1
	animation_completed.emit(self.current_roll)
