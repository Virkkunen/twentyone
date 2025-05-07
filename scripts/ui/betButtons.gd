extends GridContainer

var bet_buttons_data: Array = []

@onready var ButtonReset: Button = $ButtonReset
@onready var ButtonPlay: Button = $ButtonPlay

func _ready() -> void:
	bet_buttons_data = [
		[$Minus/ButtonMinusOne, 1, "minus"],
		[$Minus/ButtonMinusFive, 5, "minus"],
		[$Minus/ButtonMinusTen, 10, "minus"],
		[$Plus/ButtonPlusOne, 1, "plus"],
		[$Plus/ButtonPlusFive, 5, "plus"],
		[$Plus/ButtonPlusTen, 10, "plus"]
	]

	for button_entry in bet_buttons_data:
		var button_node: Button = button_entry[0]
		var amount: int = button_entry[1]
		var type: String = button_entry[2]

		button_node.pressed.connect(_on_adjust_bet_button_pressed.bind(amount, type))
		
	ButtonReset.pressed.connect(_on_action_button_pressed.bind("reset"))
	ButtonPlay.pressed.connect(_on_action_button_pressed.bind("play"))
	Global.pot_changed.connect(_update_button_state)
	Global.player_total_changed.connect(_update_button_state)

	_update_button_state()

func _on_adjust_bet_button_pressed(amount: int, operation: String) -> void:
	Input.vibrate_handheld(2)
	
	match operation:
		"plus":
			if Global.player_chips >= amount:
				Global.player_chips -= amount
				Global.pot += amount
		"minus":
			if Global.pot >= amount:
				Global.player_chips += amount
				Global.pot -= amount

func _on_action_button_pressed(type: String) -> void:
	Input.vibrate_handheld(3, 0.8)
	
	match type:
		"reset":
			if Global.pot > 0:
				Global.player_chips += Global.pot
				Global.pot = 0
		"play":
			if Global.pot > 0:
				SceneTransition.transition_to("res://scenes/game.tscn")

func _update_button_state() -> void:
	for button_entry in bet_buttons_data:
		var button_node: Button = button_entry[0]
		var amount: int = button_entry[1]
		var type: String = button_entry[2]

		if type == "minus":
			button_node.disabled = not (Global.pot >= amount)
		elif type == "plus":
						button_node.disabled = not (Global.player_chips >= amount)

	ButtonPlay.disabled = not (Global.pot >= 1)
	ButtonReset.disabled = not (Global.pot >= 1)
