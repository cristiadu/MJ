class_name TableTiles
extends Node2D

signal drew_tile(tile, tile_end_position)

@export var space_between_tiles = 130
@export var max_tile_per_line = 18

var current_drawn_pile = ""
var top_pile_tiles = []
var bottom_pile_tiles = []
var current_pile_draw_position = 1

# Track available tile positions
var first_available_index = 1
var last_available_index = 0

func _ready():
	self.current_drawn_pile = $TopPile
	self.drew_tile.connect(on_draw_tile)
	top_pile_tiles.resize(max_tile_per_line)
	top_pile_tiles.fill({"tile": null, "was_drawn": false})
	bottom_pile_tiles.resize(max_tile_per_line)
	bottom_pile_tiles.fill({"tile": null, "was_drawn": false})
	
	# Initialize indices
	first_available_index = max_tile_per_line + 1
	last_available_index = 0


func add_tile_to_players_table(tile):
	var total_tile_in_bottom_line = $BottomPile.get_child_count()
	var total_tile_in_top_line = $TopPile.get_child_count()
	var current_line_total = total_tile_in_bottom_line if total_tile_in_bottom_line < max_tile_per_line else total_tile_in_top_line
	
	if current_line_total >= max_tile_per_line:
		print("Cannot add another tile to player table, reached max number!")
		return
	
	var current_line = $BottomPile if total_tile_in_bottom_line < max_tile_per_line else $TopPile
	
	# Add to tiles array so we can draw them later.
	var position = 0
	if current_line == $BottomPile:
		position = total_tile_in_bottom_line + 1  # 1-indexed position
		bottom_pile_tiles[position - 1] = {"tile": tile, "was_drawn": false}
	else:
		position = total_tile_in_top_line + 1  # 1-indexed position
		top_pile_tiles[position - 1] = {"tile": tile, "was_drawn": false}
	
	# Update available indices - positions are 1-indexed
	first_available_index = min(first_available_index, position)
	last_available_index = max(last_available_index, position)

	tile.position.x = current_line_total * space_between_tiles
	tile.is_face_down = true # All tiles here are face down
	current_line.add_child(tile)
	

func on_draw_tile(tile, tile_end_position):
	# Play animation of drawing tile from Table Pile.
	create_tween().tween_property(tile, "position", tile_end_position, 0.2)


func draw_tiles_to_player_hand(player_hand, number_of_tiles):
	var drawn_tiles = draw_tiles_from_current_draw_index(number_of_tiles)
	
	# If no tiles were drawn, return 0 immediately
	if drawn_tiles.size() == 0:
		print("No tiles were drawn from " + self.name)
		return 0
		
	var tiles_added = 0
	for tile in drawn_tiles:
		var next_pos = player_hand.position_of_next_tile()
		self.drew_tile.emit(tile, next_pos)
		var added_tile = player_hand.add_tile_to_hand(tile, player_hand.player.player_number != 1)
		if added_tile:
			tiles_added += 1
		else:
			break
	
	return tiles_added


func get_available_tiles_count(pile_name):
	var count = 0
	var tiles_array = top_pile_tiles if pile_name == "TopPile" else bottom_pile_tiles
	
	for tile_data in tiles_array:
		if tile_data.tile != null and not tile_data.was_drawn:
			count += 1
			
	return count


func get_total_available_tiles():
	return get_available_tiles_count("TopPile") + get_available_tiles_count("BottomPile")


# Check if there's an available tile at a specific position (in either pile)
func has_available_tile_at_position(position):
	if position < 1 or position > max_tile_per_line:
		return false
		
	# Check top pile first, then bottom pile
	if position - 1 < top_pile_tiles.size():
		var top_tile = top_pile_tiles[position - 1]
		if top_tile.tile != null and not top_tile.was_drawn:
			return true
			
	if position - 1 < bottom_pile_tiles.size():
		var bottom_tile = bottom_pile_tiles[position - 1]
		if bottom_tile.tile != null and not bottom_tile.was_drawn:
			return true
			
	return false


# Check if this wind has any available tiles at all
func has_available_tiles():
	return first_available_index <= last_available_index && last_available_index > 0


# Find the next available position to draw from
func find_next_available_position(start_position = 1):
	for pos in range(start_position, max_tile_per_line + 1):
		if has_available_tile_at_position(pos):
			return pos
	return -1  # No available positions


# Update available indices after drawing a tile
func update_available_indices():
	# Update first available index
	var found_first = false
	for pos in range(first_available_index, max_tile_per_line + 1):
		if has_available_tile_at_position(pos):
			first_available_index = pos
			found_first = true
			break
	
	if not found_first:
		first_available_index = max_tile_per_line + 1
		
	# Update last available index
	var found_last = false
	for pos in range(last_available_index, 0, -1):
		if has_available_tile_at_position(pos):
			last_available_index = pos
			found_last = true
			break
	
	if not found_last:
		last_available_index = 0


func draw_tiles_from_current_draw_index(number_of_tiles):
	var drawn_tiles = []
	var tile_metadata = null
	var tiles_to_draw = number_of_tiles
	
	while tiles_to_draw > 0:
		# Check if there are any available tiles
		if not has_available_tiles():
			print("No more available tiles in " + self.name)
			return drawn_tiles
		
		# If current position is invalid, find the next available position
		if current_pile_draw_position > max_tile_per_line or not has_available_tile_at_position(current_pile_draw_position):
			var next_position = find_next_available_position(1)  # Start searching from position 1
			if next_position == -1:
				print("No more valid positions in " + self.name)
				return drawn_tiles
			
			current_pile_draw_position = next_position
			print("Adjusted to next available position: " + str(current_pile_draw_position))
		
		# Try to draw from top pile first
		var drew_tile = false
		
		# Try top pile
		if current_pile_draw_position - 1 < top_pile_tiles.size():
			var top_tile = top_pile_tiles[current_pile_draw_position - 1]
			if top_tile.tile != null and not top_tile.was_drawn:
				drawn_tiles.append(top_tile.tile)
				print("Got tile from position: " + str(current_pile_draw_position) + ", Pile=TopPile, Wind=" + self.name)
				top_tile.was_drawn = true
				$TopPile.remove_child(top_tile.tile)
				tiles_to_draw -= 1
				drew_tile = true
				
				# After drawing from top pile, don't increment position yet
				# We'll try bottom pile at the same position
			
		# If couldn't draw from top pile or already drew from top pile, try bottom pile
		if not drew_tile and current_pile_draw_position - 1 < bottom_pile_tiles.size():
			var bottom_tile = bottom_pile_tiles[current_pile_draw_position - 1]
			if bottom_tile.tile != null and not bottom_tile.was_drawn:
				drawn_tiles.append(bottom_tile.tile)
				print("Got tile from position: " + str(current_pile_draw_position) + ", Pile=BottomPile, Wind=" + self.name)
				bottom_tile.was_drawn = true
				$BottomPile.remove_child(bottom_tile.tile)
				tiles_to_draw -= 1
				drew_tile = true
				
				# After drawing from bottom pile, increment position for next draw
				current_pile_draw_position += 1
				print("Increasing position to: " + str(current_pile_draw_position))
				
				# Check if we've reached the end of positions
				if current_pile_draw_position > max_tile_per_line:
					print("Reached maximum position " + str(max_tile_per_line))
					break
			
		# If we couldn't draw from either pile at this position, move to next position
		if not drew_tile:
			current_pile_draw_position += 1
			print("No tiles at position " + str(current_pile_draw_position - 1) + ", moving to next position")
			
			# Check if we've reached the end of positions
			if current_pile_draw_position > max_tile_per_line:
				print("Reached maximum position " + str(max_tile_per_line))
				break
		
		# Update available indices after each tile drawn
		update_available_indices()
	
	return drawn_tiles
