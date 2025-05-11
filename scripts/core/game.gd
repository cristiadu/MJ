extends Node2D

# Main game controller that manages the overall game flow
# This class handles game initialization, round management, and communication with other systems

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")
@onready var TileDataMgr = get_node("/root/TileData")
@onready var NotificationHandler = get_node("/root/NotificationHandler")

# Game tile instances created from tile data
var game_tiles = []
# Reference to the tile scene for instantiation
var tile_scene = preload("res://scenes/game_objects/tile.tscn")

func _ready():
	# Connect signals from game state to respond to game events
	GameState.game_started.connect(_on_game_started)
	GameState.round_started.connect(_on_round_started)
	GameState.player_turn_changed.connect(_on_player_turn_changed)
	
	# Save reference to notification handler in GameState for global access
	GameState.game_instance = NotificationHandler
	
	# Initialize game tiles from tile data manager
	self.game_tiles = TileDataMgr.create_game_tiles(tile_scene)
	
	# Start the game immediately when scene is ready
	start_game()

func _on_game_started():
	# Callback when the game starts
	# Shuffle tiles to randomize gameplay and distribute them on the table
	game_tiles.shuffle()
	$Tiles/Table.draw_table_tiles(game_tiles)

func _on_round_started():
	# Callback when a new round starts
	# Update UI or perform any round initialization
	# Currently not implemented - will be used for multi-round gameplay
	pass

func _on_player_turn_changed(player_number):
	# Callback when the active player changes
	# Update UI to indicate which player's turn it is
	show_notification("Player " + str(player_number) + "'s turn")

func start_game():
	# Initialize a new game
	# Let game state handle the start logic and notify observers
	GameState.start_game()
	$Tiles/Table.start_round()

# Show notification to the player
func show_notification(message, duration = 2.0):
	# Display a temporary notification message to inform the player
	NotificationHandler.show_notification(message, duration)
