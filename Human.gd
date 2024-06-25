class_name HumanPlayer
extends Node2D

signal draws_tile

@onready var table = get_parent().get_node("Table")

func _ready():
	self.draws_tile.connect(on_draw_tile)


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
