extends Sprite2D
class_name OWCutscene

@export var Cutscene_script : Script = null
@export var main : Overworld = null

func _on_area_2d_body_entered(body):
	if body is OWPlayer:
		body.lock = true
		var cutscene = Cutscene.new()
		cutscene.set_script(Cutscene_script)
		cutscene.player = main.player
		cutscene.text_box = main.text_box
		cutscene.camera = main.camera
		main.player.stop()
		add_child(cutscene)
		cutscene.start_scene()

