extends Node2D

@export var space_between_tiles = 100

var tiles_per_line = 15
var current_line = 1
var max_lines = 5

func add_tile_to_discard_pile(tile):
	if current_line > max_lines:
		print("Error, max number of lines reached for discard pile!")
		return
		
	var current_line_node = get_node("Line" + str(current_line))
	var total_tiles_in_line = current_line_node.get_child_count()
	
	# If it's more than it can have per line, then move to next line.
	if total_tiles_in_line >= tiles_per_line:
		current_line += 1
		
		if current_line > max_lines:
			print("Error, max number of lines reached for discard pile!")
			return
		
		current_line_node = get_node("Line" + str(current_line))
		total_tiles_in_line = current_line_node.get_child_count()
		
	tile.position.x = total_tiles_in_line * space_between_tiles
	tile.change_face_down_or_up(false) # all cards here are face up
	current_line_node.add_child(tile)
