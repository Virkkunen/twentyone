extends FlowContainer

@onready var ButtonMinusOne = $Minus/ButtonMinusOne
@onready var ButtonMinusFive = $Minus/ButtonMinusFive
@onready var ButtonMinusTen = $Minus/ButtonMinusTen
@onready var ButtonPlusOne = $Plus/ButtonPlusOne
@onready var ButtonPlusFive = $Plus/ButtonPlusFive
@onready var ButtonPlusTen = $Plus/ButtonPlusTen
@onready var ButtonReset = $HBoxContainer/ButtonReset
@onready var ButtonPlay = $HBoxContainer/ButtonPlay

func _ready() -> void:
	_on_pot_changed()
	_on_player_chips_changed()
	Global.pot_changed.connect(_on_pot_changed)
	Global.player_chips_changed.connect(_on_player_chips_changed)
	
	ButtonMinusOne.pressed.connect(func(): _on_bet_button_pressed("minus_one"))
	ButtonMinusFive.pressed.connect(func(): _on_bet_button_pressed("minus_five"))
	ButtonMinusTen.pressed.connect(func(): _on_bet_button_pressed("minus_ten"))
	ButtonPlusOne.pressed.connect(func(): _on_bet_button_pressed("plus_one"))
	ButtonPlusFive.pressed.connect(func(): _on_bet_button_pressed("plus_five"))
	ButtonPlusTen.pressed.connect(func(): _on_bet_button_pressed("plus_ten"))
	ButtonReset.pressed.connect(func(): _on_bet_button_pressed("reset"))
	ButtonPlay.pressed.connect(func(): _on_bet_button_pressed("play"))

func _on_pot_changed() -> void:
	ButtonMinusTen.disabled = false if Global.pot >= 10 else true
	ButtonMinusFive.disabled = false if Global.pot >= 5 else true
	ButtonMinusOne.disabled = false if Global.pot >= 1 else true
	ButtonPlay.disabled = false if Global.pot >= 1 else true
	ButtonReset.disabled = false if Global.pot >= 1 else true

func _on_player_chips_changed() -> void:
	ButtonPlusOne.disabled = false if Global.player_chips >= 1 else true
	ButtonPlusFive.disabled = false if Global.player_chips >= 5 else true
	ButtonPlusTen.disabled = false if Global.player_chips >= 10 else true

func _on_bet_button_pressed(button: String) -> void:
	Input.vibrate_handheld(2)
	match button:
		"plus_one":
			if Global.player_chips >= 1:
				Global.player_chips -= 1
				Global.pot += 1
		"plus_five":
			if Global.player_chips >= 5:
				Global.player_chips -= 5
				Global.pot += 5
		"plus_ten":
			if Global.player_chips >= 10:
				Global.player_chips -= 10
				Global.pot += 10
		"minus_one":
			if Global.pot >= 1:
				Global.player_chips += 1
				Global.pot -= 1
		"minus_five":
			if Global.pot >= 5:
				Global.player_chips += 5
				Global.pot -= 5
		"minus_ten":
			if Global.pot >= 10:
				Global.player_chips += 10
				Global.pot -= 10
		"reset":
			if Global.pot > 0:
				Global.player_chips += Global.pot
				Global.pot = 0
		"play":
			if Global.pot > 0:
				SceneTransition.transition_to("res://scenes/game.tscn")
