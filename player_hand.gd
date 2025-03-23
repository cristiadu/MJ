class_name PlayerHand
extends Node2D

signal should_reorder_tiles

@export var space_between_tiles = 100
@export var tiles_on_hand_draggable = false
@export var initial_tile_per_hand = 13
@export var max_tile_per_hand = 14

@onready var player = get_parent()

func _ready():
	self.should_reorder_tiles.connect(reorder_tiles)
	

func add_tile_to_hand(tile, is_face_down = true):
	var total_tiles_in_hand = self.get_total_tiles_in_hand()
	
	if total_tiles_in_hand >= max_tile_per_hand:
		print("Cannot add another tile to player hand, reached max number!")
		return false
	
	# Set basic properties
	tile.draggable = tiles_on_hand_draggable
	tile.order = total_tiles_in_hand
	tile.change_face_down_or_up(is_face_down)
	
	# Add the tile to the hand
	add_child(tile)
	
	# Reset position and rotation relative to the hand
	tile.position = Vector2(total_tiles_in_hand * space_between_tiles, 0)
	tile.rotation = 0
	
	return true


func get_total_tiles_in_hand():
	return get_child_count()


func position_of_next_tile():
	return Vector2(get_total_tiles_in_hand() * space_between_tiles, 0)


func reorder_tiles():
	for tile in get_children():
		create_tween().tween_property(tile, "position", Vector2(tile.order * space_between_tiles, 0), 0.2)
