class_name CPUPlayer
extends Node2D

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")

@export var player_wind = ""
@export var player_number = 1

@onready var table = get_parent().get_node("Table")

# CPU play timer
var play_timer = Timer.new()
var thinking_time = 1.5  # seconds for AI to "think"

func _ready():
	# Connect to game state signals
	GameState.player_turn_changed.connect(_on_player_turn_changed)
	
	# Setup AI thinking timer
	add_child(play_timer)
	play_timer.one_shot = true
	play_timer.timeout.connect(_on_cpu_thinking_complete)

# Handle player turn changes
func _on_player_turn_changed(current_player):
	if current_player == player_number:
		# Start CPU turn
		start_cpu_turn()

# Begin CPU turn logic with a delay to simulate thinking
func start_cpu_turn():
	play_timer.wait_time = thinking_time
	play_timer.start()

# When CPU thinking is complete, take action
func _on_cpu_thinking_complete():
	if GameState.current_player_turn == player_number:
		if not GameState.has_player_drawn(player_number):
			draw_tile()
		else:
			discard_tile()

# Draw a tile from the table
func draw_tile():
	var success = table.draw_tiles(player_number, 1)
	
	if success:
		print("CPU Player " + str(player_number) + " drew a tile")
		# Schedule the discard after a short delay
		play_timer.wait_time = thinking_time
		play_timer.start()
	else:
		print("CPU Player " + str(player_number) + " could not draw a tile")
		# End turn if can't draw
		GameState.next_player_turn()

# Discard a tile (simple AI just discards highest order tile)
func discard_tile():
	# Get all tiles in the hand
	var tiles_in_hand = $Hand.get_children()
	
	if tiles_in_hand.size() <= 0:
		print("No tiles to discard")
		GameState.next_player_turn()
		return
	
	# Find the highest order tile (last one)
	var highest_order = -1
	var tile_to_discard = null
	
	for tile in tiles_in_hand:
		if tile.order > highest_order:
			highest_order = tile.order
			tile_to_discard = tile
	
	if tile_to_discard:
		# Remove from CPU's hand
		$Hand.remove_child(tile_to_discard)
		
		# Add to discard area
		var discard_area = get_parent().get_node("Discard")
		discard_area.add_tile_to_discard_pile(tile_to_discard)
		
		# Update game state - this will advance to next player
		GameState.record_tile_discarded(player_number, tile_to_discard)
		
		print("CPU Player " + str(player_number) + " discarded: " + tile_to_discard.type + " " + tile_to_discard.subtype)
	else:
		print("CPU Player " + str(player_number) + " has no valid tile to discard")
		GameState.next_player_turn()

# Check for a possible Pong play
func check_and_play_pong():
	# Simple implementation - will be expanded later
	pass

# Check for a possible Seung play
func check_and_play_seung():
	# Simple implementation - will be expanded later
	pass

# Check for a possible Gong play
func check_and_play_gong():
	# Simple implementation - will be expanded later
	pass
