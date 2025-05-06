extends CanvasLayer

func transition_to(scene: String) -> void:
	%Fade.play("fade")
	await %Fade.animation_finished
	get_tree().change_scene_to_file(scene)
	%Fade.play_backwards("fade")
