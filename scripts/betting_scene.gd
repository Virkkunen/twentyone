extends Node2D

@onready var BetButtons = $Screen/Control/MarginContainer/VBoxContainer/Buttons
@onready var ButtonIncrease = BetButtons.get_node("ButtonIncrease")
@onready var ButtonDecrease = BetButtons.get_node("ButtonDecrease")
@onready var ButtonResetBet = BetButtons.get_node("ButtonResetBet")
@onready var ButtonConfirmBet = BetButtons.get_node("ButtonConfirmBet")
@onready var ButtonDecreaseTen = BetButtons.get_node("DecreasePresets").get_node("ButtonDecrease10")
@onready var ButtonDecreaseFive = BetButtons.get_node("DecreasePresets").get_node("ButtonDecrease5")
@onready var ButtonIncreaseFive = BetButtons.get_node("IncreasePresets").get_node("ButtonIncrease5")
@onready var ButtonIncreaseTen = BetButtons.get_node("IncreasePresets").get_node("ButtonIncrease10")

func _ready() -> void:
	Global.info_label = "Place your bet"

	Global.pot_changed.connect(_on_pot_changed)
	Global.player_chips_changed.connect(_on_player_chips_changed)
	ButtonIncrease.pressed.connect(func(): _on_bet_button_pressed("increase"))
	ButtonIncreaseTen.pressed.connect(func(): _on_bet_button_pressed("increase_ten"))
	ButtonIncreaseFive.pressed.connect(func(): _on_bet_button_pressed("increase_five"))
	ButtonDecrease.pressed.connect(func(): _on_bet_button_pressed("decrease"))
	ButtonDecreaseFive.pressed.connect(func(): _on_bet_button_pressed("decrease_five"))
	ButtonDecreaseTen.pressed.connect(func(): _on_bet_button_pressed("decrease_ten"))
	ButtonResetBet.pressed.connect(func(): _on_bet_button_pressed("reset"))
	ButtonConfirmBet.pressed.connect(func(): _on_bet_button_pressed("confirm"))


func _on_bet_button_pressed(which : String) -> void:
	match which:
		"increase":
			if Global.player_chips >= 1:
				Input.vibrate_handheld(4)
				Global.player_chips -= 1
				Global.pot += 1

		"increase_ten":
			if Global.player_chips >= 10:
				Input.vibrate_handheld(4)
				Global.player_chips -= 10
				Global.pot += 10

		"increase_five":
			if Global.player_chips >= 5:
				Input.vibrate_handheld(4)
				Global.player_chips -= 5
				Global.pot += 5

		"decrease":
			if Global.pot >= 1:
				Input.vibrate_handheld(4)
				Global.player_chips += 1
				Global.pot -= 1

		"decrease_five":
			if Global.pot >= 5:
				Input.vibrate_handheld(4)
				Global.player_chips += 5
				Global.pot -= 5

		"decrease_ten":
			if Global.pot >= 10:
				Input.vibrate_handheld(4)
				Global.player_chips += 10
				Global.pot -= 10

		"reset":
			Input.vibrate_handheld(28, 0.7)
			Global.player_chips += Global.pot
			Global.pot = 0

		"confirm":
			if Global.pot < 1:
				Input.vibrate_handheld(100)
				Global.info_label = "You need to bet something!"
			else:
				Input.vibrate_handheld(56, 0.7)
				get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_pot_changed() -> void:
	ButtonDecreaseTen.disabled = false if Global.pot >= 10 else true
	ButtonDecreaseFive.disabled = false if Global.pot >= 5 else true
	ButtonDecrease.disabled = false if Global.pot >= 1 else true
	ButtonConfirmBet.disabled = false if Global.pot >= 1 else true
	ButtonResetBet.disabled = false if Global.pot >= 1 else true

func _on_player_chips_changed() -> void:
	ButtonIncrease.disabled = false if Global.player_chips >= 1 else true
	ButtonIncreaseFive.disabled = false if Global.player_chips >= 5 else true
	ButtonIncreaseTen.disabled = false if Global.player_chips >= 10 else true
	
