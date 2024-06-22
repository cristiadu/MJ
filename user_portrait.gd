extends Node2D

@export var player_name = "Player 1"
@export var player_number = "player1"

var player_colors = {
	"player1": {"label": Color(1,0.5,0), "overlay": Color(1,0.5,0,0.6)},
	"player2": {"label": Color(1,0,0), "overlay": Color(1,0,0,0.6)},
	"player3": {"label": Color(0,1,0), "overlay": Color(0,1,0,0.6)},
	"player4": {"label": Color(0,0.7,1), "overlay": Color(0,0.7,1,0.6)},
}



# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerName.text = player_name
	$PlayerName.add_theme_color_override("font_color", player_colors[player_number].label)
	$Sprite2D.set_modulate(player_colors[player_number].overlay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
