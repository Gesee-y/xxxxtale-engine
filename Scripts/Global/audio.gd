extends Node
class_name AudioManager

# To be use only for playing sound effects and musics

# since you can't get it back to stop it when it's necesarry

var playlist : Instantier = Instantier.new()
var now_playing : Dictionary

# --------- Script ---------- #

func play_sfx(path:String) -> void:
	var sound : AudioStreamPlayer = AudioStreamPlayer.new()
	sound.stream = get_sound(path)
	if sound.stream != null:
		add_child(sound)
		sound.play()
		sound.bus = "SFX" # set the sound to the SFX bus so it can be managed later
		sound.connect("finished",Callable(sound,"queue_free")) # We free the sound when it's finish
	else:
		sound.queue_free()
	

func play_bgm(path:String,seek:float = 0) -> void:
	var sound : AudioStreamPlayer = AudioStreamPlayer.new()
	sound.stream = get_sound(path)
	if sound.stream != null:
		now_playing[path] = sound
		add_child(sound)
		sound.play()
		sound.seek(seek)
		sound.bus = "BGM" # Same as for the SFX
		sound.connect("finished",func(): now_playing.erase(path))
		sound.connect("finished",func(): sound.queue_free())
				
	else:
		sound.queue_free()

func is_playing(_snd:AudioStreamPlayer) -> bool:
	if now_playing.has(_snd):
		return true
	
	return false

func get_sound(_path:String):
	playlist.default_value = null
	if !playlist.has_object(_path):
		playlist.add_to_list(_path,load(_path))
	return playlist.get_object(_path)

func stop_all_music():
	for i in now_playing.keys():
		now_playing[i].stop()

func fade_all_music(_spd:float=0.5):
	for i in now_playing.values():
		create_tween().tween_property(i,"volume_db",-100,_spd)

func free_all_music():
	for i in now_playing.keys():
		now_playing[i].queue_free()
		now_playing.erase(i)

func pause_music(path:String):
	var snd = now_playing.get(path,null)
	if snd != null : snd.stream_paused = true

func resume_music(path:String):
	var snd = now_playing.get(path,null)
	if snd == null : play_bgm(path)
	else : snd.stream_paused = false

# ---------- End ---------- #
