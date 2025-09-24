extends BattleContinuity

signal time_as_come

var last_pos : float = 0
var flags:Dictionary={
	"intro":false
}
var start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	Global.players[0].attack = 1.5
	Global.players[0].hp = 20
	enemy.visible = false
	main.event_manager.set_target()
	attacks.attack_ended.connect(func():turn = randi_range(0,2))

func Intro():
	time_as_come.connect(func():flags["intro"] = true)
	super.Intro()
	main.menu_no = [-3,0]
	main.event_manager.turn = -1
	attacks.pre_attack()
	Global.current_phase = Global.phase.ENEMY_ATTACK
	enemy.visible = false
	start = true
	await time_as_come
	attacks.start_attack()

func _process(_delta):
	if start:
		if !flags["intro"]:
			time_as(2.7)

func get_turn() -> int:
	return randi_range(0,2)

func battle_status(_turn:int) -> String:
	if main.event_manager.turn == 0:
		return "Blaster & Co block your way."
	if enemy.enemies[0].current_hp > 300:
		match _turn:
			0:
				return "Wondering which animal this skull come from."
			1:
				return "The blasters fly over you.~Making random noise."
			2:
				return "You remember a joke about bone."
	else:
		match _turn:
			0:
				return "Blaster regret why he attack you in the first place"
			1:
				return "Blaster seem to want to flee{P1}, but has too much pride to flee from child"
			2:
				return "Blaster is reconsidering his options."
	
	return ""


func time_as(_time:float):
	var sound : AudioStreamPlayer = Global.sound_player.now_playing["res://Sounds/BGM/gb_theme.ogg"]
	var actual_pos = sound.get_playback_position()
	var t = (actual_pos-last_pos)/(_time-last_pos)
	if t>=1:
		emit_signal("time_as_come")
		return true
	last_pos = actual_pos
	return false
