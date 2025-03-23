extends Node2D

@export var current_draw_wind = "East"
@export var current_table_wind = ""
@export var number_rolled_dice = 10

@onready var first_die = get_parent().get_parent().get_node("Dice/Die1")
@onready var second_die = get_parent().get_parent().get_node("Dice/Die2")
@onready var third_die = get_parent().get_parent().get_node("Dice/Die3")

var dice_rolls = []
var dice_animation_complete_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func start_round():
	self.current_table_wind = get_next_wind(self.current_table_wind)
	roll_dice_and_wait()
	return


# Roll dice and wait for animations to complete
func roll_dice_and_wait():
	# Reset counter
	dice_animation_complete_count = 0
	
	# Connect dice animation completion signals
	first_die.animation_completed.connect(_on_die_animation_completed)
	second_die.animation_completed.connect(_on_die_animation_completed)
	third_die.animation_completed.connect(_on_die_animation_completed)
	
	# Roll the dice
	roll_three_d6()


# Called when a die completes its animation
func _on_die_animation_completed(_roll_value):
	dice_animation_complete_count += 1
	
	# If all three dice are done, proceed with the game
	if dice_animation_complete_count == 3:
		# Disconnect signals to avoid memory leaks
		first_die.animation_completed.disconnect(_on_die_animation_completed)
		second_die.animation_completed.disconnect(_on_die_animation_completed)
		third_die.animation_completed.disconnect(_on_die_animation_completed)
		
		# Calculate sum of dice
		self.number_rolled_dice = dice_rolls.reduce(func(accum, number): return accum + number)
		
		# Continue with the game
		select_draw_wind()
		draw_initial_tiles()


func roll_three_d6():
	dice_rolls = []
	
	# Start all three rolls
	dice_rolls.append(first_die.roll())
	dice_rolls.append(second_die.roll())
	dice_rolls.append(third_die.roll())
	
	return dice_rolls


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
			var current_tiles = players_hand[player_number - 1].get_total_tiles_in_hand()
			var max_tiles = players_hand[player_number - 1].initial_tile_per_hand
			
			if current_tiles == max_tiles:
				print("Player "+str(player_number) + " is ready! (" + str(current_tiles) + "/" + str(max_tiles) + ")")
				players_with_max_tiles += 1
			else:
				var tiles_needed = max_tiles - current_tiles
				var draw_amount = min(4, tiles_needed)  # Draw at most 4 tiles at a time, but don't exceed needed amount
				
				if draw_amount > 0:
					print("Player "+str(player_number) + " is drawing "+str(draw_amount)+" tiles! (" + str(current_tiles) + "/" + str(max_tiles) + ")")
					var success = draw_tiles(player_number, draw_amount)
					
					if not success:
						consecutive_failed_draws += 1
						if consecutive_failed_draws >= 4:  # If all 4 players failed to draw, we're stuck
							print("All players failed to draw, stopping initial draw")
							no_more_tiles_available = true
							break
					else:
						consecutive_failed_draws = 0
						
						# Check if player has drawn any flower tiles and needs extra tiles
						current_tiles = players_hand[player_number - 1].get_total_tiles_in_hand()
						if current_tiles < max_tiles:
							print("Player "+str(player_number) + " likely drew flower tiles, drawing replacements...")
							# Continue drawing until they have the correct number of tiles
							var additional_tiles_needed = max_tiles - current_tiles
							if additional_tiles_needed > 0:
								draw_tiles(player_number, additional_tiles_needed)
						
						# Recheck if player now has max tiles after drawing
						current_tiles = players_hand[player_number - 1].get_total_tiles_in_hand()
						if current_tiles == max_tiles:
							print("Player "+str(player_number) + " is now ready! (" + str(current_tiles) + "/" + str(max_tiles) + ")")
							players_with_max_tiles += 1
		
		# Break the loop if all players have their tiles
		if players_with_max_tiles == 4:
			print("All players have their initial tiles, setup complete")
			break


func draw_tiles(player_number, number_of_tiles = 1, recursion_depth = 0):
	# Prevent infinite recursion
	if recursion_depth > 8:  # Allow max 8 recursive calls (2 full circuits around winds)
		print("WARNING: Maximum recursion depth reached in draw_tiles. Stopping to prevent stack overflow.")
		return false
		
	# If no tiles needed, return success immediately
	if number_of_tiles <= 0:
		return true
		
	var pile_wind = get_node(self.current_draw_wind)
	var player_hand = get_parent().get_node("Player" + str(player_number) + "/Hand")
	print("Draw"+str(number_of_tiles)+"::Player"+str(player_number)+", depth="+str(recursion_depth))
	
	# Check if we need to change winds due to position
	if pile_wind.current_pile_draw_position > pile_wind.max_tile_per_line:
		print("Current position " + str(pile_wind.current_pile_draw_position) + " exceeds max of " + str(pile_wind.max_tile_per_line) + " in " + self.current_draw_wind)
		self.current_draw_wind = get_next_wind(self.current_draw_wind)
		pile_wind = get_node(self.current_draw_wind)
		pile_wind.current_pile_draw_position = 1
		print("Moved to next wind: " + self.current_draw_wind + " at position 1")
	
	# Check if this wind has any available tiles
	if not pile_wind.has_available_tiles():
		print("No available tiles in " + self.current_draw_wind + ", trying next wind")
		
		# Try all winds in sequence until we find one with tiles
		var original_wind = self.current_draw_wind
		var tried_all_winds = false
		var winds_checked = 0
		
		while not pile_wind.has_available_tiles() and not tried_all_winds and winds_checked < 4:
			self.current_draw_wind = get_next_wind(self.current_draw_wind)
			pile_wind = get_node(self.current_draw_wind)
			winds_checked += 1
			
			# Check if we've gone full circle
			if self.current_draw_wind == original_wind or winds_checked >= 4:
				tried_all_winds = true
				print("Checked all winds, no available tiles found")
				return false
				
			if pile_wind.has_available_tiles():
				print("Found available tiles in " + self.current_draw_wind)
				# Find first valid position
				var next_position = pile_wind.find_next_available_position(1)
				if next_position != -1:
					pile_wind.current_pile_draw_position = next_position
					print("Setting position to " + str(pile_wind.current_pile_draw_position) + " in " + self.current_draw_wind)
	
	# At this point, we have a wind with tiles and a valid position
	print("Drawing from " + self.current_draw_wind + " at position " + str(pile_wind.current_pile_draw_position))
	
	# Draw tiles from the current wind
	var tiles_drawn = pile_wind.draw_tiles_to_player_hand(player_hand, number_of_tiles)
	
	# Check if we successfully drew some tiles
	if tiles_drawn > 0:
		var remaining_tiles_to_draw = number_of_tiles - tiles_drawn
		print("Drew " + str(tiles_drawn) + " tiles, " + str(remaining_tiles_to_draw) + " remaining to draw")
		
		# If we've drawn all the tiles we need, return success
		if remaining_tiles_to_draw <= 0:
			return true
			
		# If we need more tiles, check position
		if pile_wind.current_pile_draw_position > pile_wind.max_tile_per_line:
			print("Reached end of " + self.current_draw_wind + ", but still need " + str(remaining_tiles_to_draw) + " more tiles")
			self.current_draw_wind = get_next_wind(self.current_draw_wind)
			pile_wind = get_node(self.current_draw_wind)
			pile_wind.current_pile_draw_position = 1
			print("Moving to next wind: " + self.current_draw_wind + " at position 1")
		else:
			print("Continuing to draw from " + self.current_draw_wind + " at position " + str(pile_wind.current_pile_draw_position))
		
		# Recursively try to draw the remaining tiles with incremented recursion depth
		return draw_tiles(player_number, remaining_tiles_to_draw, recursion_depth + 1)
	else:
		print("Failed to draw from " + self.current_draw_wind)
		return false


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
