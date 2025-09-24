extends CharacterBody2D
class_name OWPlayer

signal encounter

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var collision : CollisionShape2D= $Collision

@export var camera : BattleCamera = null
@export var overworld : Overworld = null
const SPEED = 300.0
var last_pos : Vector2 = Vector2.ZERO
var lock :bool = false
var is_moving : bool = false
var PrepareForBattle : int = 0
var step_count : int = 0

func _ready():
	encounter.connect(_on_encounter)

func _physics_process(_delta):
	if !lock:
		camera.xpos = global_position.x
		camera.ypos = global_position.y
		var direction : Vector2 = Input.get_vector("left", "right","up","down")
		velocity = SPEED*direction
		if get_real_velocity() == Vector2.ZERO or last_pos == global_position:
			idle()
			is_moving = false
		else:
			is_moving = true
			sprite.speed_scale = 1
			if direction.x < 0 : sprite.play("left")
			elif direction.x > 0: sprite.play("right")
			elif direction.y < 0: sprite.play("up")
			elif direction.y > 0 : sprite.play("down")
			
			step_count += 1
	
	move_and_slide()

func check_for_encounter(_steps : int):
	if _steps > 500:
		GameFunc.Encounter()
		emit_signal("encounter")
		GameFunc.current_room=[overworld.RoomName,global_position]
		GameFunc.camera_pos = camera.global_position
		Global.sound_player.play_sfx("res://Sounds/SFX/warning.ogg")
		lock = true

func _on_encounter():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Rooms/battle_start.tscn")

func idle():
	sprite.speed_scale = 0
	sprite.frame = 0

func stop():
	idle()
	velocity = Vector2.ZERO
	lock = true
