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
	for tile in drawn_tiles:
		self.drew_tile.emit(tile, player_hand.position + player_hand.position_of_next_tile())
		player_hand.add_tile_to_hand(tile, tile.is_face_down)


func draw_tiles_from_current_draw_index(number_of_tiles):
	var drawn_tiles = []
	var tile_metadata = null
	var number_of_tiles_to_draw = number_of_tiles
	while number_of_tiles_to_draw > 0:
		tile_metadata = null
		if self.current_drawn_pile == $TopPile:
			tile_metadata = top_pile_tiles[self.current_pile_draw_position - 1]
		elif self.current_drawn_pile == $BottomPile:
			tile_metadata = bottom_pile_tiles[self.current_pile_draw_position - 1]
			
		if tile_metadata == null or tile_metadata.tile == null or tile_metadata.was_drawn:
			print("Tried to retrieve a tile on invalid position: " + str(self.current_pile_draw_position) + ", Metadata: " + str(tile_metadata))
			return []
			
		drawn_tiles.append(tile_metadata.tile)
		print("Got tile from position: " + str(self.current_pile_draw_position) + ", Pile="+self.current_drawn_pile.name + ", Wind=" + self.name)
		tile_metadata.was_drawn = true
		number_of_tiles_to_draw -= 1
		self.current_drawn_pile.remove_child(tile_metadata.tile)
		self.current_drawn_pile = $TopPile if current_drawn_pile == $BottomPile else $BottomPile
		if self.current_drawn_pile == $TopPile:
			self.current_pile_draw_position += 1
			print("Increasing number to: " + str(self.current_pile_draw_position))
	
	return drawn_tiles
