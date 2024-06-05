extends Node2D

var total_tiles = 144

var tiles = [
	{
		"suit": "circles",
		"number": 4,
		"force_face_up": false,
		"count": 4,
		"resource": "res://images/tile_circle_4.png"
	},
	{
		"honor": "east",
		"force_face_up": false,
		"count": 4,
		"resource": "res://images/tile_east.png"
	},
	{
		"suit": "flower",
		"number": 4,
		"force_face_up": true,
		"count": 1,
		"resource": "res://images/tile_flower_4.png"
	},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
