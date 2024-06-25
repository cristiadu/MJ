class_name TableTiles
extends Node2D

signal drew_tile(tile, tile_end_position)

@export var space_between_tiles = 130
@export var max_tile_per_line = 18


func _ready():
	self.drew_tile.connect(on_draw_tile)


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
