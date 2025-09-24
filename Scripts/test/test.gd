extends Node2D

var items_manager : DataManager = DataManager.new()
var items_file : String = "res://Resources/Items/Items.md"

# Called when the node enters the scene tree for the first time.
func _ready():
	items_manager.file_path = items_file
	var it = items_manager.get_data_from_csv("Pie",1)
	print(items_manager.convert_data(it))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
