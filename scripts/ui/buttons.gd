extends GridContainer

@onready var ButtonHit: Button = $ButtonHit
@onready var ButtonStand: Button = $ButtonStand

func _ready() -> void:
	Global.game_state_changed.connect(_on_game_state_changed)
	ButtonHit.pressed.connect(_on_button_hit)
	ButtonStand.pressed.connect(_on_button_stand)

func _on_button_hit() -> void:
	Input.vibrate_handheld(4)
	Global.game_action = Global.GameActions.PLAYER_HIT

func _on_button_stand() -> void:
	Input.vibrate_handheld(6)
	Global.game_action = Global.GameActions.PLAYER_STAND

func _on_game_state_changed() -> void:
	match Global.game_state:
		Global.GameStates.PLAYER_TURN:
			ButtonHit.disabled = false
			ButtonStand.disabled = false
		Global.GameStates.HOUSE_TURN:
			ButtonHit.disabled = true
			ButtonStand.disabled = true
