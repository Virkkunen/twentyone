extends Control

@onready var AnimPlayer: AnimationPlayer = $CardAnim
@onready var CardTexture: TextureRect = $TextureRect

var window_size := Vector2(0, 0)

func deal_animation(side_pos: Vector2) -> void:
	var anim = Animation.new()
	var track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, "position")
