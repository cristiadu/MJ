extends StaticBody2D

@export var is_face_down = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$ImageFaceDown.visible = is_face_down
	$ImageFaceUp.visible = not is_face_down
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
