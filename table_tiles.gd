class_name TableTiles
extends Node2D

signal drew_tile(tile, tile_end_position)

@export var space_between_tiles = 130
@export var max_tile_per_line = 18

var current_drawn_pile = ""
var top_pile_tiles = []
var bottom_pile_tiles = []
var current_pile_draw_position = 1

func _ready():
	self.current_drawn_pile = $TopPile
	self.drew_tile.connect(on_draw_tile)
	top_pile_tiles.resize(max_tile_per_line)
	top_pile_tiles.fill({"tile": null, "was_drawn": false})
	bottom_pile_tiles.resize(max_tile_per_line)
	bottom_pile_tiles.fill({"tile": null, "was_drawn": false})


func add_tile_to_players_table(tile):
	var total_tile_in_bottom_line = $BottomPile.get_child_count()
	var total_tile_in_top_line = $TopPile.get_child_count()
	var current_line_total = total_tile_in_bottom_line if total_tile_in_bottom_line < max_tile_per_line else total_tile_in_top_line
	
	if current_line_total >= max_tile_per_line:
		print("Cannot add another tile to player table, reached max number!")
		return
	
	var current_line = $BottomPile if total_tile_in_bottom_line < max_tile_per_line else $TopPile
	
	# Add to tiles array so we can draw them later.
	if current_line == $BottomPile:
		bottom_pile_tiles.insert(total_tile_in_bottom_line, {"tile": tile, "was_drawn": false})
	else:
		top_pile_tiles.insert(total_tile_in_top_line, {"tile": tile, "was_drawn": false})

	tile.position.x = current_line_total * space_between_tiles
	tile.is_face_down = true # All tiles here are face down
	current_line.add_child(tile)
	

func on_draw_tile(tile, tile_end_position):
	# Play animation of drawing tile from Table Pile.
	create_tween().tween_property(tile, "position", tile_end_position, 0.2)


func draw_tiles_to_player_hand(player_hand, number_of_tiles):
	var drawn_tiles = draw_tiles_from_current_draw_index(number_of_tiles)
	
	# If no tiles were drawn, return false immediately
	if drawn_tiles.size() == 0:
		print("No tiles were drawn from " + self.name)
		return false
		
	for tile in drawn_tiles:
		self.drew_tile.emit(tile, player_hand.position + player_hand.position_of_next_tile())
		var added_tile = player_hand.add_tile_to_hand(tile, tile.is_face_down)
		if not added_tile:
			return false
	return true


func get_available_tiles_count(pile_name):
	var count = 0
	var tiles_array = top_pile_tiles if pile_name == "TopPile" else bottom_pile_tiles
	
	for tile_data in tiles_array:
		if tile_data.tile != null and not tile_data.was_drawn:
			count += 1
			
	return count


func get_total_available_tiles():
	return get_available_tiles_count("TopPile") + get_available_tiles_count("BottomPile")


func draw_tiles_from_current_draw_index(number_of_tiles):
	var drawn_tiles = []
	var tile_metadata = null
	var number_of_tiles_to_draw = number_of_tiles
	
	while number_of_tiles_to_draw > 0:
		# Check if the current pile has any tiles left
		var top_has_tiles = get_available_tiles_count("TopPile") > 0
		var bottom_has_tiles = get_available_tiles_count("BottomPile") > 0
		
		# If current pile is empty but the other one has tiles, switch to it
		if (self.current_drawn_pile == $TopPile and not top_has_tiles and bottom_has_tiles):
			self.current_drawn_pile = $BottomPile
		elif (self.current_drawn_pile == $BottomPile and not bottom_has_tiles and top_has_tiles):
			self.current_drawn_pile = $TopPile
		
		# Try to get a valid tile from the current position
		var found_valid_tile = false
		var start_position = self.current_pile_draw_position
		var max_position = max_tile_per_line
		
		for pos in range(start_position, max_position + 1):
			self.current_pile_draw_position = pos
			
			if self.current_drawn_pile == $TopPile:
				tile_metadata = top_pile_tiles[self.current_pile_draw_position - 1]
			elif self.current_drawn_pile == $BottomPile:
				tile_metadata = bottom_pile_tiles[self.current_pile_draw_position - 1]
				
			if tile_metadata != null and tile_metadata.tile != null and not tile_metadata.was_drawn:
				found_valid_tile = true
				break
				
		# If we didn't find a valid tile in this pile, we're done
		if not found_valid_tile:
			print("No more valid tiles found in " + self.name + " " + self.current_drawn_pile.name)
			return drawn_tiles
			
		drawn_tiles.append(tile_metadata.tile)
		print("Got tile from position: " + str(self.current_pile_draw_position) + ", Pile="+self.current_drawn_pile.name + ", Wind=" + self.name)
		tile_metadata.was_drawn = true
		number_of_tiles_to_draw -= 1
		self.current_drawn_pile.remove_child(tile_metadata.tile)
		
		# Switch piles after drawing a tile
		self.current_drawn_pile = $TopPile if current_drawn_pile == $BottomPile else $BottomPile
		
		# Increment position when switching back to top pile
		if self.current_drawn_pile == $TopPile:
			self.current_pile_draw_position += 1
			print("Increasing position to: " + str(self.current_pile_draw_position))
			
			# If we've reached the end of both piles, we're done
			if self.current_pile_draw_position > max_tile_per_line:
				return drawn_tiles
	
	return drawn_tiles
