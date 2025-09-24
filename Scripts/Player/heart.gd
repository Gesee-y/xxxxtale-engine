extends CharacterBody2D
class_name PlayerSoul

signal damage(_damage:int,_curse:int)
signal throwed(_direction)

const SPEED = 9000
const MAX_JUMP_TIME = 0.5
const MAX_FALL_TIME = 0.6

@export var jump_height : float = 75
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.35

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak ) * -1.0
@onready var jump_gravity : float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

enum MODE {
	RED,
	BLUE,
	GREEN
}

var soul_mode : MODE = MODE.RED
var direction : String = "down"
var wasd : bool = false
var lock : bool = false: # If the player can move
	set(value):
		if value:inv_frames=false
		lock = value

# Shield properties
var protecting : bool = false
var shield_active : bool = false
var shield_locked : bool = false
var shield_amount : float = 100
var shield_cost = 3
var shield_cost_pressed = 1

var can_die = true
var type:int = 0
var slam : bool = false
var slam_power : float = 1.5
var last : Vector2 = Vector2.ZERO # the player last position
var soul_type : Array = ["red"]
var spd_multiplier :float = 1
var cooldown : int = 0 :
	set(value):
		if value != 0:
			inv_frames = true
		cooldown = value
var darken = false
var inv_frames : bool = false
var is_moving : bool = false
var can_flee : bool = false
var box : Box = null
var jump_timer : float = 0
var fall_timer : float = 0
var jump_interp : float = 0
var falling : bool = false
var tick_delay : int = 1
var inside:bool = false
var variety : int = 0
var UI_attack : bool = false

var gameover_screen_path : String = "res://Scenes/Rooms/game_over.tscn"
@onready var soul : AnimatedSprite2D = $Sprite
@onready var hurtbox = $Hurtbox
@onready var ins = $Sprite/in
@onready var shields = $Shields

var mode_color = [Color.RED,Color.BLUE,Color.DARK_GREEN]

func _ready() -> void:
	damage.connect(_on_damage)

func _physics_process(delta) -> void:
	
	if cooldown > 0 : cooldown -= 1
	if Input.is_action_pressed("cancel"):spd_multiplier = 0.5
	else : spd_multiplier = 1
	
	match soul_mode:
		MODE.RED:
			red_mode(delta,variety)
		MODE.BLUE:
			if !lock:blue_mode(delta,direction)
		MODE.GREEN:
			if !lock:green_mode()
		
	if shield_active : set_shield()
		
	shields.visible = (soul_mode == MODE.GREEN)
	inv_frames = true if cooldown >0 else false
	set_invincible_color(inv_frames)
	tick_karma(delta)
	if (cooldown <= 0 and (!lock or UI_attack)) : CheckDamage()
	
	move_and_slide()
	ins.visible = inside
	
	if !is_alive() : 
		if !Global.debug and !Global.player_immortal : kill_player()

func set_shield():
	if Input.is_action_pressed("menu") && shield_amount > 0 && !shield_locked:
		shield_amount -= shield_cost_pressed
		if shield_amount > (shield_cost+shield_cost_pressed) : protecting = true
	else:
		shield_amount += 0.5
		protecting = false
	
	shield_amount = clampf(shield_amount,0,100)

func move(_delta:float,_type:int) -> void:
	if _type in [0,3]:
		var dir = Input.get_vector("left","right","up","down")
		if wasd: dir = Input.get_vector("a","d","w","s")
		dir.normalized()
		is_moving = dir != Vector2.ZERO
		horizontal_movement(_delta,dir.x)
		vertical_movement(_delta,dir.y)

func red_mode(delta,_variety:int=0) -> void:
	soul.rotation_degrees = 0
	soul.material.set_shader_parameter("type",_variety)
	var dir_angle = {
		"up":180,
		"down":0,
		"left":90,
		"right":-90
	}
	
	if variety > 0 : soul.rotation_degrees = dir_angle.get(direction,0)
	if !lock:move(delta,0)

func blue_mode(delta,_dir:String) -> void:
	soul.material.set_shader_parameter("type",1)
	var wasd_dir_input : Dictionary = {
		"up" : "w",
		"left" : "a",
		"down" : "s",
		"right": "d",
	}
	var dir_angle = {
		"up":180,
		"down":0,
		"left":90,
		"right":-90
	}
	soul.rotation_degrees = dir_angle[_dir]
	var y_axis = ["up","down"]
	var x_axis = ["left","right"]
	var coef : float = 1
	var dir = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
			Input.get_action_strength("down")- Input.get_action_strength("up"))
	if wasd: dir = Vector2(Input.get_action_strength("d")-Input.get_action_strength("a"),
					Input.get_action_strength("s")- Input.get_action_strength("w"))
	is_moving = (dir != Vector2.ZERO)
	var jump_input = ""
	if _dir in y_axis:
		horizontal_movement(delta,dir.x)
		
		coef = 1 if _dir == "up" else -1
		jump_input = "up" if _dir == "down" else "down"
		if !on_floor(_dir):
			if slam_power != 0 : velocity.y = -slam_power*coef
		else:
			velocity.y = 0
			jump_timer = 0
			if slam_power > 0:
				slam_power = 0
				get_node("/root/BattleRoom").camera.shake = 3
				Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg")
			falling = false
	
	if _dir in x_axis:
		vertical_movement(delta,dir.y)
		coef = -1 if _dir == "left" else 1
		jump_input = "right" if _dir == "left" else "left"
		if !on_floor(_dir):
			if slam_power != 0 : velocity.x = slam_power*coef
		else:
			velocity.x = 0
			fall_timer = 0
			jump_timer = 0
			falling = false
			if slam_power > 0:
				get_node("/root/BattleRoom").camera.shake = 5
				Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg")
			slam_power = 0
	
	
	var inp : bool = Input.is_action_pressed(jump_input)
	if wasd : 
		inp = Input.is_action_pressed(wasd_dir_input[jump_input])
	if falling: inp = false
	if on_floor(_dir) and inp:
		if _dir in y_axis : velocity.y = -jump_velocity*coef
		if _dir in x_axis : velocity.x = jump_velocity*coef
		jump_timer += delta
	
	if !falling:
		if inp:
			var jump_factor : float = jump_timer/MAX_JUMP_TIME
			jump_timer += delta
			if _dir in y_axis:
				velocity.y = lerpf(velocity.y,-jump_velocity*coef,1.0-jump_factor)
					
			if _dir in x_axis : 
				velocity.x = lerpf(velocity.x,jump_velocity*coef,1.0-jump_factor)
		
		elif !on_floor(_dir):
			falling = true
			jump_timer = 0
		
		if jump_timer >= MAX_JUMP_TIME:
			falling = true
			jump_timer = 0
	else:
		var fall_factor : float = jump_timer/MAX_FALL_TIME
		jump_timer += delta
		if _dir in y_axis:
			velocity.y = lerpf(velocity.y,jump_velocity*coef,fall_factor)
					
		if _dir in x_axis : 
			velocity.x = lerpf(velocity.x,-jump_velocity*coef,fall_factor)
		if on_floor(_dir):
			falling = false
			jump_timer = 0
		

func green_mode():
	shields.visible = true
	shields.two_shield = bool(type)
	shields.update_shield()
	soul.material.set_shader_parameter("type",2)

func set_mode(_mode:MODE,_dir:String = "down",_slam : bool = false,_type:int=0) -> void:
	var dir_angle = {
		"up":180,
		"down":0,
		"left":90,
		"right":-90
	}
	
	if soul_mode != _mode : 
		var spr = glow(0.5,mode_color[int(_mode)],4)
		spr.rotation_degrees = rotation_degrees
		var red_cond = (_mode == MODE.RED && _type > 0)
		var blue_cond = (_mode == MODE.BLUE)
		if red_cond || blue_cond:
			spr.rotation_degrees = dir_angle[_dir]
	
	soul_mode = _mode
	direction = _dir.to_lower()
	falling = true
	velocity = Vector2.ZERO
	type = _type
	if _slam and _mode == MODE.BLUE: 
		emit_signal("throwed",_dir)
		slam_power = 500
	fall_timer = 0
	variety = type
	jump_timer = 0
	

func horizontal_movement(_delta,_dir:float) -> void:
	velocity.x = SPEED * _delta * spd_multiplier * _dir

func vertical_movement(_delta,_dir:float) -> void:
	velocity.y = SPEED * _delta * spd_multiplier * _dir

func on_floor(_dir) -> bool:
	var arr = ["right","left","down","up"]
	var idx : int = arr.find(_dir)
	if idx < 2:
		if is_on_wall():
			if idx == 0 and get_which_wall_collided()=="right":
				return true
			elif idx == 1 and get_which_wall_collided() == "left":
				return true
		if abs(global_position.x-box.bound[idx]) < 15:
			return true
	else :
		if idx == 2 and is_on_floor():
			return true
		elif idx == 3 and is_on_ceiling():
			return true
		if abs(global_position.y-box.bound[idx]) < 15:
			return true
	
	return false

func get_which_wall_collided():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x > 0:
			return "left"
			
		elif collision.get_normal().x < 0:
			return "right"

func glow(dur:float=0.5,color:Color = Color.RED,_to : float= 3,tex_path:String = "res://Sprites/Player/battle/Player Soul.png"):
	var spr = Sprite2D.new()
	var tex = load(tex_path)
	var tween = create_tween()
	spr.texture = tex
	spr.modulate = color
	add_child(spr)
	
	tween.set_parallel()
	tween.tween_property(spr,"scale",Vector2(_to,_to),dur).set_trans(Tween.TRANS_SINE)
	tween.tween_property(spr,"modulate:a",0,dur).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(spr.queue_free)
	
	return spr

func get_gravity(_velocity:float,_way:int) -> float:
	match _way:
		1:
			if _velocity < 0.0 : return jump_gravity
		-1:
			if _velocity > 0.0 : return jump_gravity
	
	return fall_gravity

func set_invincible_color(value:bool) -> void:
	soul.material.set_shader_parameter("inv_frames",value)

func CheckDamage() -> void:
	var bodies = hurtbox.get_overlapping_areas()
	for body in bodies:
		
		if body.is_in_group("bullets"):
			var object : Bullet = body.bullet
			if object.visible:
				match object.type:
					1:
						if is_moving == true:
							emit_signal("damage",object.damage,object.b_curse)
					2:
						if is_moving == false:
							emit_signal("damage",object.damage,object.b_curse)
					_:
						emit_signal("damage",object.damage,object.b_curse)
			
			if object.free_on_contact:
				object.queue_free()

func _on_damage(_damage:int,_curse:int) -> void:
	if protecting:
		Global.sound_player.play_sfx("res://Sounds/SFX/bell.ogg")
		shield_amount -= shield_cost
	else:
		for target in Global.enemies_target:
			target.hp -= _damage * Global.damage_multiplier
			if target.kr:
				target.kr_hp -= _curse
				cooldown = 4
			else:
				get_node("/root/BattleRoom").camera.shake = 3
				cooldown = 30
		Global.sound_player.play_sfx("res://Sounds/SFX/hurt.ogg")
	

func is_alive():
	for player in Global.players:
		if ((player.hp > 0) and (!player.kr)):
			return true
		elif ((player.kr and player.kr_hp > 0)):
			return true
	
	return false

func kill_player():
	Global.death_pos = position
	get_tree().change_scene_to_file(gameover_screen_path)

func tick_karma(_delta:float):
	for player in Global.players:
		if player.hp == 0 and player.kr_hp > 1:
			player.hp = 1
		if player.hp > 0:
			if player.kr_hp > player.hp:
				var ratio : float = (player.hp/float(player.kr_hp))*15
				if tick_delay % (int(ratio)+1) == 0:
					player.kr_hp -= 1
				tick_delay += 1
		if player.kr_hp < player.hp:
			tick_delay = 0
			player.kr_hp = player.hp
