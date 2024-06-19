class_name Tile
extends Area2D

@export var is_face_down = true

var type = "None"
var honor = ""
var suit = ""
var number = ""
var resource = "res://images/back_tile.png"

var dragging = false  # Whether the tile is being dragged
var drag_offset = Vector2()  # The offset between the mouse and the tile's position when dragging starts


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
	input_event.connect(_on_Tile_input_event)


func _on_Tile_input_event(viewport, event, shape_idx):
	var tween = get_tree().create_tween()
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# The left mouse button was pressed
			self.dragging = true
			self.drag_offset = self.global_position - event.global_position
			tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# The left mouse button was released
			tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			self.dragging = false


# Called every physics frame. 'delta' is the elapsed time since the previous physics frame.
func _physics_process(delta):
	if dragging:
		# The tile is being dragged
		# Move the tile to the mouse's position, adjusted by the drag offset
		self.global_position = get_global_mouse_position() + self.drag_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# The left mouse button was released outside of the _on_Tile_input_event method
		dragging = false
