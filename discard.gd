extends Node2D

@export var space_between_tiles = 100

var tiles_per_line = 21
var current_line = 1
var max_lines = 5

func add_tile_to_discard_pile(tile):
	var current_line_node = get_node("Line" + current_line)
	var total_tiles_in_line = current_line_node.get_child_count()
	
	# If it's more than it can have per line, then move to next line.
	if total_tiles_in_line >= tiles_per_line:
		current_line += 1
		
		if current_line > max_lines:
			print("Error, max number of lines reached for discard pile!")
			return
		
		current_line_node = get_node("Line" + current_line)
		total_tiles_in_line = current_line_node.get_child_count()
		
	tile.transform.position.x = (total_tiles_in_line - 1) * space_between_tiles
	tile.is_face_down = false # all cards here are face up
	tile.parent = current_line_node
