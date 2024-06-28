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


func draw_tiles(number_of_tiles = 1):
	var pile_wind = get_node(self.current_draw_wind)
	# TODO: Implement this.
