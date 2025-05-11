extends Node

# Centralized tile data definitions
var tiles = [
	{
		"type": "number",
		"suit": "dot",
		"number": 1,
		"count": 4,
		"resource": "res://resources/images/tiles/one-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 2,
		"count": 4,
		"resource": "res://resources/images/tiles/two-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 3,
		"count": 4,
		"resource": "res://resources/images/tiles/three-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 4,
		"count": 4,
		"resource": "res://resources/images/tiles/four-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 5,
		"count": 4,
		"resource": "res://resources/images/tiles/five-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 6,
		"count": 4,
		"resource": "res://resources/images/tiles/six-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 7,
		"count": 4,
		"resource": "res://resources/images/tiles/seven-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 8,
		"count": 4,
		"resource": "res://resources/images/tiles/eight-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "dot",
		"number": 9,
		"count": 4,
		"resource": "res://resources/images/tiles/nine-dot-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 1,
		"count": 4,
		"resource": "res://resources/images/tiles/one-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 2,
		"count": 4,
		"resource": "res://resources/images/tiles/two-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 3,
		"count": 4,
		"resource": "res://resources/images/tiles/three-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 4,
		"count": 4,
		"resource": "res://resources/images/tiles/four-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 5,
		"count": 4,
		"resource": "res://resources/images/tiles/five-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 6,
		"count": 4,
		"resource": "res://resources/images/tiles/six-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 7,
		"count": 4,
		"resource": "res://resources/images/tiles/seven-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 8,
		"count": 4,
		"resource": "res://resources/images/tiles/eight-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "bamboo",
		"number": 9,
		"count": 4,
		"resource": "res://resources/images/tiles/nine-bamboo-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 1,
		"count": 4,
		"resource": "res://resources/images/tiles/one-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 2,
		"count": 4,
		"resource": "res://resources/images/tiles/two-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 3,
		"count": 4,
		"resource": "res://resources/images/tiles/three-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 4,
		"count": 4,
		"resource": "res://resources/images/tiles/four-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 5,
		"count": 4,
		"resource": "res://resources/images/tiles/five-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 6,
		"count": 4,
		"resource": "res://resources/images/tiles/six-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 7,
		"count": 4,
		"resource": "res://resources/images/tiles/seven-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 8,
		"count": 4,
		"resource": "res://resources/images/tiles/eight-character-tile.png"
	},
	{
		"type": "number",
		"suit": "character",
		"number": 9,
		"count": 4,
		"resource": "res://resources/images/tiles/nine-character-tile.png"
	},
	{
		"type": "honor",
		"subtype": "east-wind",
		"count": 4,
		"resource": "res://resources/images/tiles/east-wind-tile.png"
	},
	{
		"type": "honor",
		"subtype": "north-wind",
		"count": 4,
		"resource": "res://resources/images/tiles/north-wind-tile.png"
	},
	{
		"type": "honor",
		"subtype": "west-wind",
		"count": 4,
		"resource": "res://resources/images/tiles/west-wind-tile.png"
	},
	{
		"type": "honor",
		"subtype": "south-wind",
		"count": 4,
		"resource": "res://resources/images/tiles/south-wind-tile.png"
	},
	{
		"type": "honor",
		"subtype": "red-dragon",
		"count": 4,
		"resource": "res://resources/images/tiles/red-dragon-tile.png"
	},
	{
		"type": "honor",
		"subtype": "white-dragon",
		"count": 4,
		"resource": "res://resources/images/tiles/white-dragon-tile.png"
	},
	{
		"type": "honor",
		"subtype": "green-dragon",
		"count": 4,
		"resource": "res://resources/images/tiles/green-dragon-tile.png"
	},
	{
		"type": "flower",
		"subtype": "plum",
		"number": 1,
		"count": 1,
		"resource": "res://resources/images/tiles/one-flower-plum-tile.png"
	},
	{
		"type": "flower",
		"subtype": "orchid",
		"number": 2,
		"count": 1,
		"resource": "res://resources/images/tiles/two-flower-orchid-tile.png"
	},
	{
		"type": "flower",
		"subtype": "daisy",
		"number": 3,
		"count": 1,
		"resource": "res://resources/images/tiles/three-flower-daisy-tile.png"
	},
	{
		"type": "flower",
		"subtype": "bamboo",
		"number": 4,
		"count": 1,
		"resource": "res://resources/images/tiles/four-flower-bamboo-tile.png"
	},
	{
		"type": "flower",
		"subtype": "spring",
		"number": 1,
		"count": 1,
		"resource": "res://resources/images/tiles/one-flower-spring-tile.png"
	},
	{
		"type": "flower",
		"subtype": "summer",
		"number": 2,
		"count": 1,
		"resource": "res://resources/images/tiles/two-flower-summer-tile.png"
	},
	{
		"type": "flower",
		"subtype": "autumn",
		"number": 3,
		"count": 1,
		"resource": "res://resources/images/tiles/three-flower-autumn-tile.png"
	},
	{
		"type": "flower",
		"subtype": "winter",
		"number": 4,
		"count": 1,
		"resource": "res://resources/images/tiles/four-flower-winter-tile.png"
	},
]

# Create instances of game tiles
func create_game_tiles(tile_scene):
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
				tile.subtype if tile.has("subtype") else "", 
				tile.number if tile.has("number") else -1)
			game_tiles.append(tile_object)
	
	return game_tiles 
