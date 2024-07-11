extends RigidBody2D

@export var current_roll = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func roll():
	self.current_roll = randi() % 6 + 1
	play_roll_animation()
	return self.current_roll


func play_roll_animation():
	await get_tree().create_timer(0.1).timeout # Wait a bit before starting
	for i in range(20): # Change the number for longer/shorter animation
		$Sprite2D.frame = randi() % 6 # Temporarily set to a random frame to simulate rolling
		await get_tree().create_timer(0.15).timeout # Wait between frame changes
	$Sprite2D.frame = self.current_roll - 1
