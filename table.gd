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
	draw_initial_tiles()


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
	var pile_wind = get_node(self.current_draw_wind)
	pile_wind.current_pile_draw_position = number_rolled_dice
	
	var no_more_tiles_available = false
	var consecutive_failed_draws = 0
	
	while(players_with_max_tiles < 4 and not no_more_tiles_available):
		players_with_max_tiles = 0  # Reset counter each iteration to recheck
		
		# Check total tiles available across all winds
		var total_available_tiles = 0
		for wind_name in ["East", "South", "West", "North"]:
			var wind_node = get_node(wind_name)
			total_available_tiles += wind_node.get_total_available_tiles()
		
		if total_available_tiles == 0:
			print("No more tiles available in any wind, stopping initial draw")
			no_more_tiles_available = true
			break
			
		for player_number in range(1, 5):
			if players_hand[player_number - 1].get_total_tiles_in_hand() == players_hand[player_number - 1].initial_tile_per_hand:
				print("Player "+str(player_number) + " is ready!")
				players_with_max_tiles += 1
			else:
				var tiles_needed = players_hand[player_number - 1].initial_tile_per_hand - players_hand[player_number - 1].get_total_tiles_in_hand()
				var draw_amount = min(4, tiles_needed)  # Draw at most 4 tiles at a time, but don't exceed needed amount
				if draw_amount > 0:
					print("Player "+str(player_number) + " is drawing "+str(draw_amount)+" tiles!")
					var success = draw_tiles(player_number, draw_amount)
					
					if not success:
						consecutive_failed_draws += 1
						if consecutive_failed_draws >= 4:  # If all 4 players failed to draw, we're stuck
							print("All players failed to draw, stopping initial draw")
							no_more_tiles_available = true
							break
					else:
						consecutive_failed_draws = 0
		
		# Break the loop if all players have their tiles
		if players_with_max_tiles == 4:
			break


func draw_tiles(player_number, number_of_tiles = 1):
	var pile_wind = get_node(self.current_draw_wind)
	var player_hand = get_parent().get_node("Player" + str(player_number) + "/Hand")
	print("Draw"+str(number_of_tiles)+"::Player"+str(player_number))

	var number_of_tiles_to_draw = number_of_tiles
	
	# Get the count of available tiles in the current wind
	var available_tiles_top = pile_wind.get_available_tiles_count("TopPile")
	var available_tiles_bottom = pile_wind.get_available_tiles_count("BottomPile")
	var total_tiles = available_tiles_top + available_tiles_bottom
	
	# If no tiles in current wind, try to find another wind with tiles
	if total_tiles == 0:
		var original_wind = self.current_draw_wind
		var found_tiles = false
		
		# Try each wind until we find one with tiles or we've checked all of them
		while not found_tiles:
			var old_wind = self.current_draw_wind
			self.current_draw_wind = get_next_wind(self.current_draw_wind)
			
			# If we've gone full circle, no tiles are available
			if self.current_draw_wind == original_wind:
				print("No tiles available in any wind")
				return false
				
			# Check if this wind has tiles
			pile_wind = get_node(self.current_draw_wind)
			total_tiles = pile_wind.get_total_available_tiles()
			
			if total_tiles > 0:
				found_tiles = true
				print("Found " + str(total_tiles) + " tiles in " + self.current_draw_wind)
	
	if total_tiles < number_of_tiles:
		number_of_tiles_to_draw = total_tiles
		if total_tiles > 0:
			print("Drawing remaining " + str(number_of_tiles_to_draw) + " tiles from " + self.current_draw_wind)
	
	# Only try to draw tiles if there are tiles to draw
	var added_tiles = false
	if number_of_tiles_to_draw > 0:
		added_tiles = pile_wind.draw_tiles_to_player_hand(player_hand, number_of_tiles_to_draw)
		
		# If no tiles were successfully drawn but we expected some, try the next wind
		if not added_tiles and number_of_tiles_to_draw > 0:
			print("Failed to draw tiles from " + self.current_draw_wind + ", trying next wind")
			self.current_draw_wind = get_next_wind(self.current_draw_wind)
			return draw_tiles(player_number, number_of_tiles)
	else:
		print("No tiles to draw from " + self.current_draw_wind)
		return false

	var remaining_tiles_to_draw = number_of_tiles - number_of_tiles_to_draw
	if remaining_tiles_to_draw > 0 and added_tiles:
		return draw_tiles(player_number, remaining_tiles_to_draw)
		
	return added_tiles


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
