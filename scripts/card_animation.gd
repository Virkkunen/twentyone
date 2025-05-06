extends TextureRect

@export var hover_amount: float = 10.0
@export var hover_speed: float = 1.0

@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var anim_lib := AnimationLibrary.new()
	var anim := Animation.new()

	anim_lib.add_animation("hover", anim)
	AnimPlayer.add_animation_library("", anim_lib)

	var track_idx := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, "position:y")

	anim.track_insert_key(track_idx, 0.0, 0.0)
