extends Node2D

var tiles = [
	{
		"type": "number",
		"suit": "circles",
		"number": 4,
		"count": 4,
		"resource": "res://images/tile.png"
	},
	{
		"type": "honor",
		"honor": "east",
		"count": 4,
		"resource": "res://images/tile.png"
	},
	{
		"type": "flower",
		"number": 4,
		"count": 1,
		"resource": "res://images/tile.png"
	},
]

var tile_scene = preload("res://tile.tscn")

func _ready():
	var game_tiles = []
	var tile_object
	for tile in tiles:
		for i in range(tile.count):
			tile_object = tile_scene.instantiate()
			tile_object.init(
				0,
				tile.type, 
				tile.resource, 
				tile.suit if tile.has("suit") else "", 
				tile.honor if tile.has("honor") else "", 
				tile.number if tile.has("number") else -1)
			game_tiles.append(tile_object)
			
	for tile_instance in game_tiles:
		$Tiles/Discard.add_tile_to_discard_pile(tile_instance)
