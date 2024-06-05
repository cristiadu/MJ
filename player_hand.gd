class_name PlayerHand
extends Node2D

@export var space_between_tiles = 100
var max_card_per_hand = 14

func add_tile_to_hand(tile, is_face_down = true):
	var total_tiles_in_hand = self.get_child_count()
	
	if total_tiles_in_hand >= max_card_per_hand:
		print("Cannot add another tile to player hand, reached max number!")
		return
	
	tile.position.x = total_tiles_in_hand * space_between_tiles
	tile.is_face_down = is_face_down
	add_child(tile)
