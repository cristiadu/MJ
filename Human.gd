class_name HumanPlayer
extends Node2D

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")

signal draws_tile

@export var player_number = 1

@onready var table = get_parent().get_node("Table")
@onready var player_buttons = get_parent().get_parent().get_node("HUD/Player" + str(player_number) + "/Buttons")

func _ready():
	# Connect signals
	self.draws_tile.connect(on_draw_tile)
	GameState.player_turn_changed.connect(_on_player_turn_changed)
	
	# Connect UI buttons
	var special = player_buttons.get_node("SpecialPlayButton")
	special.connect("pressed", trigger_special_play)
	
	# Connect draw tile button
	var draw_button = player_buttons.get_node("DrawTileButton")
	draw_button.connect("pressed", on_draw_tile)
	
	# Connect discard button
	var discard_button = player_buttons.get_node("DiscardButton")
	discard_button.connect("pressed", discard_tile)
	discard_button.disabled = true  # Disable initially until player draws a tile

# Handle player turn changes
func _on_player_turn_changed(current_player):
	# Enable/disable buttons based on whose turn it is
	var is_my_turn = current_player == player_number
	var draw_button = player_buttons.get_node("DrawTileButton")
	
	if is_my_turn:
		# Only enable draw button if player hasn't drawn yet
		draw_button.disabled = GameState.has_player_drawn(player_number)
	else:
		# Disable all buttons when it's not this player's turn
		draw_button.disabled = true
		var discard_button = player_buttons.get_node("DiscardButton")
		discard_button.disabled = true

# Draw a tile when it's the player's turn
func on_draw_tile():
	# Only allow drawing if it's this player's turn and they haven't drawn yet
	if GameState.current_player_turn == player_number and not GameState.has_player_drawn(player_number):
		# Draw the tile
		var success = table.draw_tiles(player_number, 1)

		if not success:
			print("Failed to draw a tile - no more tiles available")
			# Show a notification to the player that no more tiles are available
			GameState.show_notification("No more tiles available")
		else:
			print("Drew a tile")
			
			# Enable the discard button after drawing
			var discard_button = player_buttons.get_node("DiscardButton")
			if discard_button:
				discard_button.disabled = false
			
			# Disable the draw button after drawing
			var draw_button = player_buttons.get_node("DrawTileButton")
			if draw_button:
				draw_button.disabled = true

# Discard a tile from the player's hand
func discard_tile():
	# Only allow discarding if it's this player's turn and they have drawn
	if GameState.current_player_turn == player_number and GameState.has_player_drawn(player_number):
		# Get all tiles in the hand
		var tiles_in_hand = $Hand.get_children()
		
		if tiles_in_hand.size() <= 0:
			print("No tiles to discard")
			return
		
		# For now, just discard the last tile (highest order)
		# In a more advanced implementation, you would let the player select a tile
		var highest_order = -1
		var tile_to_discard = null
		
		for tile in tiles_in_hand:
			if tile.order > highest_order:
				highest_order = tile.order
				tile_to_discard = tile
		
		if tile_to_discard:
			tile_to_discard.draggable = false

			# Remove from player's hand
			$Hand.remove_child(tile_to_discard)
			
			# Add to discard area
			var discard_area = get_parent().get_node("Discard")
			discard_area.add_tile_to_discard_pile(tile_to_discard)
			
			# Update game state and move to next player's turn
			GameState.record_tile_discarded(player_number, tile_to_discard)
			
			print("Tile discarded: " + tile_to_discard.type + " " + tile_to_discard.subtype)
		else:
			print("No valid tile to discard")

# Check for a possible Pong play
func check_and_play_pong():
	# Implement Pong logic here
	pass

# Check for a possible Seung play
func check_and_play_seung():
	# Implement Seung logic here
	pass

# Check for a possible Gong play
func check_and_play_gong():
	# Implement Gong logic here
	pass

# Handle special play button press
func trigger_special_play():
	# Implement logic for special plays
	pass
