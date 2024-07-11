class_name TableTiles
extends Node2D

signal drew_tile(tile, tile_end_position)

@export var space_between_tiles = 130
@export var max_tile_per_line = 18

var last_drawn_pile

func _ready():
	self.last_drawn_pile = $TopPile
	self.drew_tile.connect(on_draw_tile)


func get_total_tiles():
	return $BottomPile.get_child_count() + $TopPile.get_child_count()


func add_tile_to_players_table(tile):
	var total_tile_in_bottom_line = $BottomPile.get_child_count()
	var total_tile_in_top_line = $TopPile.get_child_count()
	var current_line_total = total_tile_in_bottom_line if total_tile_in_bottom_line < max_tile_per_line else total_tile_in_top_line
	
	if current_line_total >= max_tile_per_line:
		print("Cannot add another tile to player table, reached max number!")
		return
	
	var current_line = $BottomPile if total_tile_in_bottom_line < max_tile_per_line else $TopPile
	tile.position.x = current_line_total * space_between_tiles
	tile.is_face_down = true # All cards here are face down
	current_line.add_child(tile)
	

func on_draw_tile(tile, tile_end_position):
	# Play animation of drawing tile from Table Pile.
	create_tween().tween_property(tile, "position", tile_end_position, 0.2)


func draw_tiles_to_player_hand(initial_position, player_hand, number_of_tiles):
	var drawn_tiles = draw_tiles_starting_from_position(initial_position, number_of_tiles)
	for tile in drawn_tiles:
		self.drew_tile.emit(tile, player_hand.position + player_hand.position_of_next_tile())
		player_hand.add_tile_to_hand(tile, tile.is_face_down)


func draw_tiles_starting_from_position(initial_position, number_of_tiles):
	var drawn_tiles = []
	var tile
	for i in range(0, number_of_tiles):
		# TODO fix this logic
		tile = self.last_drawn_pile.get_child(initial_position)
		drawn_tiles.append(tile)
		self.last_drawn_pile.remove_child(tile)
		self.last_drawn_pile = $TopPile if last_drawn_pile == $BottomPile else $BottomPile
	
	return drawn_tiles
