extends Node

# Game state signals
signal game_started
signal round_started
signal tile_drawn(player_number, tile)
signal tile_discarded(player_number, tile)
signal player_turn_changed(player_number)
signal game_over

# Game state variables
var current_player_turn = 1
var game_in_progress = false
var round_in_progress = false
var current_draw_wind = "East"
var current_table_wind = ""

# Player state tracking
var player_has_drawn = [false, false, false, false]  # Indexed 0-3 for players 1-4

# Reference to the notification system
var game_instance = null

# Dictionary of all game tiles
var all_tiles = []

# Get specific player state
func has_player_drawn(player_number):
	return player_has_drawn[player_number - 1]

# Set player draw state
func set_player_drawn(player_number, has_drawn):
	player_has_drawn[player_number - 1] = has_drawn
	
# Change to next player's turn
func next_player_turn():
	current_player_turn = current_player_turn % 4 + 1
	player_turn_changed.emit(current_player_turn)
	
# Get next wind in the sequence
func get_next_wind(wind):
	match wind:
		"East":
			return "South"
		"South":
			return "West"
		"West":
			return "North"
		"North", _:
			return "East"

# Start a new game
func start_game():
	game_in_progress = true
	game_started.emit()

# Start a new round
func start_round():
	round_in_progress = true
	current_table_wind = get_next_wind(current_table_wind)
	round_started.emit()
	
# Record a tile draw
func record_tile_drawn(player_number, tile):
	set_player_drawn(player_number, true)
	tile_drawn.emit(player_number, tile)
	
# Record a tile discard
func record_tile_discarded(player_number, tile):
	set_player_drawn(player_number, false)
	tile_discarded.emit(player_number, tile)
	next_player_turn()
	
# Show a notification
func show_notification(message, duration = 2.0):
	if game_instance and game_instance.has_method("show_notification"):
		game_instance.show_notification(message, duration)
	else:
		print(message)  # Fallback to console if game instance not set 
