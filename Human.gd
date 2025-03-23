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

	if not success:
		print("Failed to draw a tile - no more tiles available")
		# Show a notification to the player that no more tiles are available
		var root = get_node("/root/Game")
		if root.has_method("show_notification"):
			root.show_notification("No more tiles available")
	else:
		print("Drew a tile")
		
		# Enable the discard button after drawing
		var discard_button = player_buttons.get_node("DiscardButton")
		if discard_button:
			discard_button.disabled = false



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
		tile_to_discard.draggable = false

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
