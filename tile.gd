class_name Tile
extends Area2D

@export var is_face_down = true
@export var draggable = false
@export var order = 1

@onready var hand = get_parent()
@onready var collision_shape_size = get_collision_shape_size()
@onready var viewport = get_viewport_rect()


var type = "None"
var honor = ""
var suit = ""
var number = ""
var resource = "res://images/tile.png"

var dragging = false  # Whether the tile is being dragged
var drag_offset = Vector2()  # The offset between the mouse and the tile's position when dragging starts

func init(o, t, res, s, h, n):
	self.order = o
	self.type = t
	self.honor = h
	self.suit = s
	self.number = n
	self.resource = res


# Called when the node enters the scene tree for the first time.
func _ready():
	$ImageFaceDown.visible = is_face_down
	$ImageFaceUp.visible = not is_face_down
	$ImageFaceUp.texture = load(resource)
	input_event.connect(_on_Tile_input_event)
	

func _on_Tile_input_event(_viewport, event, _shape_idx):
	if self.draggable:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				# The left mouse button was pressed
				start_dragging(event.global_position)
			elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				stop_dragging()


func start_dragging(mouse_position):
	self.dragging = true
	self.drag_offset = self.global_position - mouse_position
	create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)


func stop_dragging():
	self.dragging = false
	self.drag_offset = Vector2()
	create_tween().tween_property(self, "scale", Vector2(1, 1), 0.2)
	calculate_new_order()


func calculate_new_order():
	var tiles = hand.get_children()  # Assuming 'hand' is a reference to the parent container of the tiles
	var closest_distance = INF
	var closest_tile = null  # This will hold the closest tile
	var old_order = self.order # Store the old order to compare with the new one

	# Iterate through all tiles to find the closest one
	for tile in tiles:
		if tile == self:
			continue
		var distance = self.global_position.distance_to(Vector2(tile.global_position.x, tile.global_position.y))
		if distance < closest_distance:
			closest_distance = distance
			closest_tile = tile

	# If a closest tile is found and it's not the same as the current tile
	if closest_tile and closest_tile.order != old_order:
		var other_tiles_shift_direction = "MOVE_LEFT" if closest_tile.order > old_order else "MOVE_RIGHT"
		var new_order = closest_tile.order

		for tile in tiles:
			if tile == self:
				tile.order = new_order
			elif other_tiles_shift_direction == "MOVE_RIGHT" and tile.order < old_order and tile.order >= new_order:
				tile.order = tile.order + 1
			elif other_tiles_shift_direction == "MOVE_LEFT" and tile.order > old_order and tile.order <= new_order:
				tile.order = tile.order - 1

		# Emit a signal to notify that tiles need to be reordered
		hand.should_reorder_tiles.emit()
	

# Called every physics frame. 'delta' is the elapsed time since the previous physics frame.
func _physics_process(_delta):
	if self.draggable and self.dragging:
		var mouse_position = get_global_mouse_position()
		var new_position = mouse_position + self.drag_offset
		var factor = 0.3
		self.global_position.x = clamp(new_position.x, (collision_shape_size.x * factor), self.viewport.size.x - (collision_shape_size.x  * factor))
		self.global_position.y = clamp(new_position.y, (collision_shape_size.y * factor), self.viewport.size.y - (collision_shape_size.y  * factor))
		if not self.viewport.has_point(mouse_position):
			# Mouse is outside the viewport
			stop_dragging()


func get_collision_shape_size():
	var collision_shape = $CollisionShape2D.shape
	if collision_shape:
		return collision_shape.get_rect().size * 2 # For a RectangleShape2D, size is twice the extents
	return Vector2.ZERO # Default to zero if no shape is found
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# The left mouse button was released outside of the _on_Tile_input_event method
		stop_dragging()
