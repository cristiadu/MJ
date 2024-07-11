extends Node2D

@export var current_draw_wind = "East"
@export var current_table_wind = ""
@export var number_rolled_dice = 10

@onready var first_die = get_parent().get_parent().get_node("Dice/Die1")
@onready var second_die = get_parent().get_parent().get_node("Dice/Die2")
@onready var third_die = get_parent().get_parent().get_node("Dice/Die3")


var dice_rolls = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func start_round():
	self.current_table_wind = get_next_wind(self.current_table_wind)
	self.dice_rolls = roll_three_d6()
	self.number_rolled_dice = dice_rolls.reduce(func(accum, number): return accum + number)
	select_draw_wind()
	#draw_initial_tiles()


func roll_three_d6():
	var first_roll = first_die.roll()
	var second_roll = second_die.roll()
	var third_roll = third_die.roll()
	return [first_roll, second_roll, third_roll]


# Select which Table Pile will draw from
func select_draw_wind():
	match number_rolled_dice:
		6,10,14,18:
			self.current_draw_wind = "South"
		3,7,11,15:
			self.current_draw_wind = "West"
		4,8,12,16:
			self.current_draw_wind = "North"
		5,9,13,17:
			self.current_draw_wind = "East"


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


func draw_initial_tiles():
	# Draws all the tiles for all 4 players, following the order of the wind and doing 4 by 4 each draw until they all have the max of tiles.
	var players_with_max_tiles = 0
	var players_hand = [get_parent().get_node("Player1/Hand"), get_parent().get_node("Player2/Hand"), get_parent().get_node("Player3/Hand"), get_parent().get_node("Player4/Hand")]
	while(players_with_max_tiles < 4):
		for player_number in range(1, 5):
			draw_tiles(player_number, 4)
			if players_hand[player_number - 1].get_total_tiles_in_hand() == players_hand[player_number - 1].max_tile_per_hand:
				players_with_max_tiles += 1
	

func draw_tiles(player_number, number_of_tiles = 1):
	var pile_wind = get_node(self.current_draw_wind)
	var player_hand = get_parent().get_node("Player" + str(player_number) + "/Hand")

	var number_of_tiles_to_draw = number_of_tiles
	if pile_wind.get_total_tiles() < number_of_tiles:
		self.current_draw_wind = get_next_wind(self.current_draw_wind)
		number_of_tiles_to_draw = pile_wind.get_total_tiles()
		return

	pile_wind.draw_tiles_to_player_hand(number_rolled_dice, player_hand, number_of_tiles_to_draw)

	number_of_tiles_to_draw = number_of_tiles - number_of_tiles_to_draw
	if number_of_tiles_to_draw > 0:
		draw_tiles(number_of_tiles_to_draw, player_number)


func draw_table_tiles(game_tiles):
	# First X cards to each pile on each side of the table.
	var start_index = 0
	var end_index = start_index + $East.max_tile_per_line * 2
	for tile_instance in game_tiles.slice(start_index, end_index):
		$East.add_tile_to_players_table(tile_instance)
	start_index = end_index
	
	end_index = start_index + $West.max_tile_per_line * 2
	for tile_instance in game_tiles.slice(start_index, end_index):
		$West.add_tile_to_players_table(tile_instance)
	start_index = end_index
	
	end_index = start_index + $North.max_tile_per_line * 2
	for tile_instance in game_tiles.slice(start_index, end_index):
		$North.add_tile_to_players_table(tile_instance)
	start_index = end_index
	
	end_index = start_index + $South.max_tile_per_line * 2
	for tile_instance in game_tiles.slice(start_index, end_index):
		$South.add_tile_to_players_table(tile_instance)
