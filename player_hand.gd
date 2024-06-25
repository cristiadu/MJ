class_name PlayerHand
extends Node2D

signal should_reorder_tiles

@export var space_between_tiles = 100
@export var tiles_on_hand_draggable = false
var max_card_per_hand = 14

func _ready():
	self.should_reorder_tiles.connect(reorder_tiles)
	

func add_tile_to_hand(tile, is_face_down = true):
	var total_tiles_in_hand = self.get_child_count()
	
	if total_tiles_in_hand >= max_card_per_hand:
		print("Cannot add another tile to player hand, reached max number!")
		return
	
	tile.draggable = tiles_on_hand_draggable
	tile.position.x = total_tiles_in_hand * space_between_tiles
	tile.order = total_tiles_in_hand
	tile.is_face_down = is_face_down
	add_child(tile)


func reorder_tiles():
	for tile in get_children():
		create_tween().tween_property(tile, "position", Vector2(tile.order * space_between_tiles, 0), 0.2)
