class_name PlayerHand
extends Node2D

# Signals
signal should_reorder_tiles
signal tile_added(tile)
signal tile_removed(tile)

# Configuration
@export var space_between_tiles = 100
@export var tiles_on_hand_draggable = false
@export var initial_tile_per_hand = 13
@export var max_tile_per_hand = 14

# References
@onready var player = get_parent()
@onready var exposed_tiles = get_parent().get_node("ExposedTiles")
@export var space_between_exposed_tiles = 100

func _ready():
	self.should_reorder_tiles.connect(reorder_tiles)

# Add a tile to the player's hand
func add_tile_to_hand(tile, is_face_down = true):
	var total_tiles_in_hand = self.get_total_tiles_in_hand()
	
	# Check if the tile is a flower
	if tile.type == "flower":
		print("Found flower tile: " + tile.subtype)
		# Add to exposed tiles
		add_tile_to_exposed_area(tile)
		var table = get_node("/root/Game/Tiles/Table")
		table.draw_tiles(player.player_number, 1)
		return true
	
	# Check if we've reached the maximum hand size
	if total_tiles_in_hand >= max_tile_per_hand:
		print("Cannot add another tile to player hand, reached max number!")
		return false
	
	# Set basic properties
	tile.draggable = tiles_on_hand_draggable
	tile.order = total_tiles_in_hand
	tile.change_face_down_or_up(is_face_down)
	
	# Add the tile to the hand
	add_child(tile)
	
	# Reset position and rotation relative to the hand
	tile.position = Vector2(total_tiles_in_hand * space_between_tiles, 0)
	tile.rotation = 0
	
	# Emit signal for any listeners
	tile_added.emit(tile)
	
	return true

# Add a tile to the exposed area (for flowers)
func add_tile_to_exposed_area(tile):
	# Flower tiles should always be face up
	tile.change_face_down_or_up(false)
	
	# Add the tile to the exposed area
	exposed_tiles.add_child(tile)
	
	# Get the logical index of this tile in the exposed_tiles grid
	var index = exposed_tiles.get_child_count() - 1  # 0-based index
	
	# Fixed grid layout with 3 tiles per row
	var tiles_per_row = 3
	var row = int(index / tiles_per_row)  # Ensure integer division
		
	# Get the grid offset based on player number
	var target_position = Vector2(row * space_between_exposed_tiles, 0)
	
	# Use a tween to ensure our positioning happens after any animation from table_tiles
	# This will animate the tile to the correct position in the grid
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	# Force immediate positioning first to avoid overlap during animation
	tile.position = target_position
	tween.tween_property(tile, "position", target_position, 0.3)
	
	tile.rotation = 0
	
	return true

# Get the total number of tiles in the player's hand
func get_total_tiles_in_hand():
	return get_child_count()

# Calculate the position for the next tile to be added
func position_of_next_tile():
	return Vector2(get_total_tiles_in_hand() * space_between_tiles, 0)

# Reorder tiles after a drag operation
func reorder_tiles():
	for tile in get_children():
		create_tween().tween_property(tile, "position", Vector2(tile.order * space_between_tiles, 0), 0.2)

# Remove a tile from the hand
func remove_tile(tile):
	if has_node(tile.get_path()):
		remove_child(tile)
		tile_removed.emit(tile)
		return true
	return false
