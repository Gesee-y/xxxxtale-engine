extends Bullet

signal blasting

@onready var blaster = $Blaster
@onready var beam = $Blaster/cont/Beam
@onready var cont = $Blaster/cont
@onready var collision = $Blaster/hitbox/CollisionShape2D
@onready var crash_collision = $Blaster/hitbox/crashCollision
@onready var crash_zone = $Blaster/crashZone

var bla = load("res://Objects/Bullets/gaster_blaster.tscn")
var xscale : float = 1


@export var blaster_res : BlasterData = null
var state : int = 0
var time : float = 0
var hold : int = 0
var accel : float = 1
var spd : float = 2
var blast_spd : float = 3
var start_pos : Vector2 =Vector2.ZERO
var pos : Vector2 = Vector2(320,100)
var angle : float = 45
var accel_time : float = 0
var wave_fac :float = 2.5
var wave_spd : float = 6
var wait : int = 0
var style : String = "blast"

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	no_clear = true
	position = start_pos
	blaster.sprite_frames = blaster_res.sprite
	scale.x = xscale
	blaster.scale = Vector2(blaster_res.blaster_size,blaster_res.blaster_size)
	collision.shape.height = 3000
	collision.position.y+= 450
	collision.shape.radius = 22 * blaster_res.beam_size
	crash_collision.shape.radius = 26.0 / blaster_res.blaster_size
	crash_collision.shape.height = 26.0 /blaster_res.blaster_size
	beam.size.y = 3000
	beam.position.y += blaster_res.beam_offset
	crash_zone.size.y = 3000
	crash_zone.position.y = -1000
	crash_zone.visible = false
	cont.scale.x = 0
	collision.disabled = true
	crash_collision.disabled = true
	blaster.play("idle")
	cont.visible = false
	free_on_contact = false
	

func _process(delta):
	modulate = type_color[type]
	if style == "blast":
		if state >= 3:
			blaster.position.y -= accel
			beam.size.y += 50
			collision.shape.height += 20
			collision.position.y+= 10
			accel = lerpf(accel,40,accel_time)
			accel_time+=delta/10.0
		if state < 5:
			cont.modulate.a = 1
		
		match state:
			0:
				if time == 0:
					Global.sound_player.play_sfx("res://Sounds/SFX/mus_sfx_segapower.wav")
				if position.distance_to(pos) > 0.25:
					position = position.lerp(pos,time)
					rotation_degrees = lerpf(rotation_degrees,angle,time)
					time += (delta/10.0)*spd
					time = clampf(time,0,1)
				else:
					state = 1 if wait > 0 else 2
					time = 0
			1:
				if time < wait:
					time += 1
				else:
					state = 2
					time = 0
			2:
				blaster.play("steady")
				blaster.animation_finished.connect(func():
					if blaster.animation == "steady":
						state=3
						time = 0)
			3:
				collision.disabled = false
				if cont.scale.x < blaster_res.beam_size:
					blast(delta)
				else:
					time = 0
					wave_beam()
					state = 4 if hold > 0 else 5
			4:
				if time < hold:
					time+=1
					wave_beam()
				else:
					cont.scale.x = blaster_res.beam_size
					state = 5
					time = 0
			5:
				collision.disabled = true
				cont.modulate.a = lerpf(1,0,time*1.75)
				cont.scale.x =lerpf(cont.scale.x,0,time/2.0)
				time += delta*blast_spd
				if cont.scale.x <= 0:
					state = 6
			6:
				time+=1
				if time > 5:
					queue_free()
					
	else:
		match state:
			0:
				if time == 0:
					position = pos
					rotation_degrees = angle
					Global.sound_player.play_sfx("res://Sounds/SFX/warning.ogg")
				crash_zone.visible = true
				blaster.position.y=-600
				if time < wait:
					crash_zone.modulate = Color.RED if int(time) %5 ==0 else Color.YELLOW
					time += 1
				else:
					state = 1
					time = 0
			1:
				if time ==0:
					Global.sound_player.play_sfx("res://Sounds/SFX/mus_sfx_segapower.wav")
				crash_zone.visible = false
				crash_collision.disabled = false
				if time <= 1:
					blaster.position.y = lerpf(blaster.position.y,1000,time)
					time+=delta*spd/5.1
				else:
					state = 2
					time = 0
			2:
				queue_free()
				

func wave_beam():
	if cont.modulate.a == 1:
		cont.scale.x = blaster_res.beam_size +sin(deg_to_rad(time)*wave_spd)/wave_fac

func blast(delta):
	if time == 0:
		emit_signal("blasting")
		blaster.play("blast")
		var main : BattleManager= get_node("/root/BattleRoom")
		if main != null : main.camera.shake = 5
		Global.sound_player.play_sfx("res://Sounds/SFX/mus_sfx_rainbowbeam_1.wav")
	time += delta*blast_spd
	cont.visible = true
	cont.scale.x = lerpf(cont.scale.x,blaster_res.beam_size,time)

