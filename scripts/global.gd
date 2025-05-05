extends Node

signal game_state_changed
signal pot_changed
signal player_chips_changed
signal player_total_changed
signal house_total_changed

enum GameStates {
	SETUP,
	PLAYER_TURN,
	HOUSE_TURN,
	ROUND_OVER,
	GAME_OVER
}

@export var game_state : GameStates = GameStates.SETUP:
	get: return game_state
	set(value):
		game_state = value
		emit_signal("game_state_changed")
		match game_state:
				GameStates.PLAYER_TURN:
					return

@export var pot : int = 0:
	get: return pot
	set(value):
		pot = value
		emit_signal("pot_changed")

@export var player_chips : int = 50:
	get: return player_chips
	set(value):
		player_chips = value
		emit_signal("player_chips_changed")

@export var player_total : int = 0:
	get: return player_total
	set(value):
		player_total = value
		emit_signal("player_total_changed")

@export var house_total : int = 0:
	get: return house_total
	set(value):
		house_total = value
		emit_signal("house_total_changed")
