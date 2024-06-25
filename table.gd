extends Node2D

@export var current_wind_to_draw = "East"
@export var number_rolled_dice = 10

var dice_rolls = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	start_round()


func start_round():
	self.dice_rolls = roll_three_d6()
	self.number_rolled_dice = dice_rolls.reduce(func(accum, number): return accum + number)
	select_draw_wind()


func roll_three_d6():
	var first_roll = roll_a_die(1, 6)
	var second_roll = roll_a_die(1, 6)
	var third_roll = roll_a_die(1, 6)
	return [first_roll, second_roll, third_roll]


func roll_a_die(minimum, maximum):
	return randi() % (maximum-minimum+1) + minimum


# Select which Table Pile will draw from
func select_draw_wind():
	match number_rolled_dice:
		var multiple_of_four when multiple_of_four % 4 == 0:
			self.current_wind_to_draw = "South"
		var multiple_of_three when multiple_of_three % 3 == 0:
			self.current_wind_to_draw = "West"
		var multiple_of_two when multiple_of_two % 2 == 0:
			self.current_wind_to_draw = "North"
		var _multiple_of_one_only:
			self.current_wind_to_draw = "East"


func get_next_wind():
	match current_wind_to_draw:
		"East":
			return "South"
		"South":
			return "West"
		"West":
			return "North"
		"North":
			return "East"


func draw_tile(number_of_tiles = 1):
	var pile_wind = get_node(self.current_wind_to_draw)
	# TODO: Implement this.
