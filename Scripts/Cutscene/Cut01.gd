extends Cutscene

func start_scene():
	var tween = create_tween()
	tween.tween_property(camera,"ind_xpos",-100,2)
	await tween.finished
	text_box.set_dialogue(["This place is not right.",
			"Maybe it will be better to go back."],true)
	text_box.talk()
	await text_box.text.dialogue_finished
	var tween2 = create_tween()
	tween2.tween_property(camera,"ind_xpos",0,2)
	await tween2.finished
	end_cutscene()
