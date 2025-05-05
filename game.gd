extends Node2D

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")
@onready var TileDataMgr = get_node("/root/TileData")
@onready var NotificationHandler = get_node("/root/NotificationHandler")

var game_tiles = []
var tile_scene = preload("res://tile.tscn")

func _ready():
	# Connect signals from game state
	GameState.game_started.connect(_on_game_started)
	GameState.round_started.connect(_on_round_started)
	GameState.player_turn_changed.connect(_on_player_turn_changed)
	
	# Save reference to this instance in GameState
	GameState.game_instance = NotificationHandler
	
	# Initialize game tiles from tile data
	self.game_tiles = TileDataMgr.create_game_tiles(tile_scene)
	
	# Start the game
	start_game()

func _on_game_started():
	# Shuffle tiles when game starts
	game_tiles.shuffle()
	$Tiles/Table.draw_table_tiles(game_tiles)

func _on_round_started():
	# Update UI or perform any round initialization
	pass

func _on_player_turn_changed(player_number):
	# Update UI to indicate current player's turn
	show_notification("Player " + str(player_number) + "'s turn")

func start_game():
	# Let game state handle the start logic
	GameState.start_game()
	$Tiles/Table.start_round()

# Show notification to the player
func show_notification(message, duration = 2.0):
	NotificationHandler.show_notification(message, duration)
