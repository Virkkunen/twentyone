extends Node2D

@onready var BetButtons = $Screen/Control/MarginContainer/VBoxContainer/Buttons
@onready var ButtonIncrease = BetButtons.get_node("ButtonIncrease")
@onready var ButtonDecrease = BetButtons.get_node("ButtonDecrease")
@onready var ButtonResetBet = BetButtons.get_node("ButtonResetBet")
@onready var ButtonConfirmBet = BetButtons.get_node("ButtonConfirmBet")

func _ready() -> void:
	Global.info_label = "Place your bet"
	ButtonIncrease.pressed.connect(func(): _on_bet_button_pressed("increase"))
	ButtonDecrease.pressed.connect(func(): _on_bet_button_pressed("decrease"))
	ButtonResetBet.pressed.connect(func(): _on_bet_button_pressed("reset"))
	ButtonConfirmBet.pressed.connect(func(): _on_bet_button_pressed("confirm"))


func _on_bet_button_pressed(which : String) -> void:
	match which:
		"increase":
			if Global.player_chips > 0:
				Global.player_chips -= 1
				Global.pot += 1

		"decrease":
			if Global.pot > 0:
				Global.player_chips += 1
				Global.pot -= 1

		"reset":
			Global.player_chips += Global.pot
			Global.pot = 0

		"confirm":
			if Global.pot < 1:
				Global.info_label = "You need to bet something!"
			else:
				get_tree().change_scene_to_file("res://scenes/game.tscn")
