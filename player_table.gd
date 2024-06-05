class_name PlayerTable
extends Node2D

@export var space_between_tiles = 130
var max_card_per_line = 18
var line_count = 2

func add_tile_to_players_table(tile):
	var total_tile_in_bottom_line = $BottomLine.get_child_count()
	var total_tile_in_top_line = $TopLine.get_child_count()
	var current_line_total = total_tile_in_bottom_line if total_tile_in_bottom_line < max_card_per_line else total_tile_in_top_line
	
	if current_line_total >= max_card_per_line:
		print("Cannot add another tile to player table, reached max number!")
		return
	
	var current_line = $BottomLine if total_tile_in_bottom_line < max_card_per_line else $TopLine
	tile.transform.position.x = (current_line_total - 1) * space_between_tiles
	tile.is_face_down = true # All cards here are face down
	tile.parent = current_line
	
