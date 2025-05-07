extends VBoxContainer

@onready var ButtonPlay: Button = $ButtonPlay
@onready var ButtonExit: Button = $ButtonExit

func _ready() -> void:
	ButtonPlay.pressed.connect(_on_button_play)
	ButtonExit.pressed.connect(_on_button_exit)

func _on_button_play() -> void:
	SceneTransition.transition_to("res://scenes/betting.tscn")

func _on_button_exit() -> void:
	get_tree().quit()
