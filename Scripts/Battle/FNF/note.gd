extends Area2D

var speed : float = 3

func _process(_delta):
	position.x -= speed
