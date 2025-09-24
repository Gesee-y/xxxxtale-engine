extends NinePatchRect

@export var typer : TyperData = load("res://Resources/Typers/Sans.tres")
@onready var writer : Writer = $Writer

# Called when the node enters the scene tree for the first time.
func _ready():
	writer.typer = typer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	writer.typer = typer
	writer.text_box_size.x = size.x - 41
	writer.text_box_size.y = size.y - 16
	visible = !writer.stop
	
