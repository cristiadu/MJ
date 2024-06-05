class_name Tile
extends StaticBody2D

@export var is_face_down = true

var type = "None"
var honor = ""
var suit = ""
var number = ""
var resource = "res://images/back_tile.png"

func init(type, resource, suit, honor, number):
	self.type = type
	self.honor = honor
	self.suit = suit
	self.number = number
	self.resource = resource

# Called when the node enters the scene tree for the first time.
func _ready():
	$ImageFaceDown.visible = is_face_down
	$ImageFaceUp.visible = not is_face_down
	$ImageFaceUp.texture = load(resource)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
