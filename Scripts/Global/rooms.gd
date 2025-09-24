extends Node

# This script just contain all the variable about the game rooms
# Syntax

# var RoomN[room_name] = path

var Room : Dictionary = {}

# Main scene
func _ready():
	# Engine Scenes
	Room["LoadScreen"] = "res://Scenes/Rooms/Utils/load_reset_screen.tscn"
	Room["NameScreen"] = "res://Scenes/Rooms/Utils/name_screen.tscn"
	Room["GameOver"] = "res://Scenes/Rooms/game_over.tscn"
	Room["BattleRoom"] = "res://Scenes/battle/BattleRoom.tscn"
	
	# Your game scene
	Room["StartRoom"] = "res://Scenes/Rooms/test_room1.tscn"
	
	# Test Rooms #
	Room["Test1"] = "res://Scenes/Rooms/test_room1.tscn"
	Room["Test2"] = "res://Scenes/Rooms/test_room2.tscn"
