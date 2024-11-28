extends Node

signal player_total_changed
signal house_total_changed
signal player_bust
signal house_bust
signal player_blackjack
signal house_blackjack
signal player_chips_changed
signal pot_changed
signal info_label_changed
signal game_state_changed

enum GameStates {PLAYER_TURN, HOUSE_TURN, BETTING, MENU, PAUSE, CALCULATING, SETUP, INSURANCE}

@export var game_state : GameStates = GameStates.MENU:
	get:
		return game_state
	set(value):
		game_state = value
		emit_signal("game_state_changed")
		match game_state:
			GameStates.PLAYER_TURN:
				info_label = "Player turn"
			GameStates.HOUSE_TURN:
				info_label = "House turn"

@export var player_total : int = 0:
	get:
		return player_total
	set(value):
		player_total = value
		emit_signal("player_total_changed")
		if player_total > 21:
			player_busted = true
		elif player_total == 21:
			player_blackjacked = true

@export var house_total : int = 0:
	get:
		return house_total
	set(value):
		house_total = value
		emit_signal("house_total_changed")
		if house_total > 21:
			house_busted = true
		elif house_total == 21:
			house_blackjacked = true

@export var player_busted : bool = false:
	get:
		return player_busted
	set(value):
		player_busted = value
		emit_signal("player_bust")

@export var house_busted : bool = false:
	get:
		return house_busted
	set(value):
		house_busted = value
		info_label = "House busted!"
		emit_signal("house_bust")

@export var player_chips : int = 50:
	get:
		return player_chips
	set(value):
		player_chips = value
		emit_signal("player_chips_changed")

@export var pot : int = 0:
	get:
		return pot
	set(value):
		pot = value
		emit_signal("pot_changed")

@export var player_blackjacked : bool = false:
	get:
		return player_blackjacked
	set(value):
		player_blackjacked = value
		emit_signal("player_blackjack")

@export var house_blackjacked : bool = false:
	get:
		return house_blackjacked
	set(value):
		house_blackjacked = value
		emit_signal("house_blackjack")

@export var info_label : String = "twentyone":
	get:
		return info_label
	set(value):
		info_label = value
		emit_signal("info_label_changed")
