class_name HumanPlayer
extends Node2D

signal draws_tile

@export var player_number = 1

@onready var table = get_parent().get_node("Table")
@onready var player_buttons = get_parent().get_parent().get_node("HUD/Player" + str(player_number) + "/Buttons")

func _ready():
	self.draws_tile.connect(on_draw_tile)
	var special = player_buttons.get_node("SpecialPlayButton")
	special.connect("pressed", trigger_start)
	
	# Connect draw tile button
	var draw_button = player_buttons.get_node("DrawTileButton")
	draw_button.connect("pressed", on_draw_tile)
	
	# Connect discard button
	var discard_button = player_buttons.get_node("DiscardButton")
	discard_button.connect("pressed", discard)
	discard_button.disabled = true  # Disable initially until player draws a tile


func play():
	# play the round here.
	pass


func on_draw_tile():	
	# Draw the tile
	var success = table.draw_tiles(player_number, 1)
	
	if success:
		# Check if we need to draw again due to a flower tile
		var current_tiles = $Hand.get_total_tiles_in_hand()
		var expected_tiles = $Hand.max_tile_per_hand  # Should be 14 during player's turn
		
		if current_tiles < expected_tiles:
			print("Drew a flower tile, drawing a replacement")
			table.draw_tiles(player_number, expected_tiles - current_tiles)
		
		# Enable the discard button since we now have a tile to discard
		var discard_button = get_parent().get_parent().get_node("HUD/Player" + str(player_number) + "/Buttons/DiscardButton")
		discard_button.disabled = false
	else:
		print("Failed to draw a tile")


func discard():
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
		# Remove from player's hand
		$Hand.remove_child(tile_to_discard)
		
		# Add to discard area
		var discard_area = get_parent().get_node("Discard")
		discard_area.add_tile_to_discard_pile(tile_to_discard)
		
		# Disable the discard button until player draws again
		var discard_button = get_parent().get_parent().get_node("HUD/Player" + str(player_number) + "/Buttons/DiscardButton")
		discard_button.disabled = true
		
		print("Tile discarded: " + tile_to_discard.type + " " + tile_to_discard.subtype)
	else:
		print("No valid tile to discard")


func check_and_play_pong():
	pass


func check_and_play_seung():
	pass


func check_and_play_gong():
	pass


func trigger_start():
	pass
