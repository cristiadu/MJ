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


func play():
	# play the round here.
	pass


func on_draw_tile():
	pass


func discard():
	pass


func check_and_play_pong():
	pass


func check_and_play_seung():
	pass


func check_and_play_gong():
	pass


func trigger_start():
	table.draw_initial_tiles()
