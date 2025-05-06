extends Node

#
# Types
#
enum GameStates {
	MENU,
	SETUP,
	WAITING,
	PLAYER_TURN,
	HOUSE_TURN,
	ROUND_OVER,
	GAME_OVER
}

enum GameActions {
	NONE,
	DEALING,
	CALCULATING,
	PLAYER_HIT,
	PLAYER_STAND,
	PLAYER_BUST,
	PLAYER_BLACKJACK,
	HOUSE_HIT,
	HOUSE_STAND,
	HOUSE_BUST,
	HOUSE_BLACKJACK
}

enum RoundWinner {
	PLAYER,
	HOUSE,
	DRAW,
	BUST
}

enum CardSuit {
	CLUBS,
	SPADES,
	HEARTS,
	DIAMONDS
}

enum CardRank {
	ACE, TWO, THREE, FOUR, FIVE,
	SIX, SEVEN, EIGHT, NINE,
	TEN, JOKER, QUEEN, KING
}

#
# Signals
#
signal game_state_changed
signal game_action_changed
signal player_chips_changed
signal player_total_changed
signal player_blackjacked
signal house_total_changed
signal pot_changed
signal centre_text_changed
signal round_winner_changed

@export var game_state: GameStates = GameStates.SETUP:
	get: return game_state
	set(value):
		game_state = value
		emit_signal("game_state_changed")
		print("STATE: " + str(GameStates.keys()[game_state]))

@export var game_action: GameActions = GameActions.NONE:
	get: return game_action
	set(value):
		game_action = value
		emit_signal("game_action_changed")
		print("ACTION: " + str(GameActions.keys()[game_action]))

@export var pot: int = 10:
	get: return pot
	set(value):
		pot = value
		emit_signal("pot_changed")

@export var player_chips: int = 50:
	get: return player_chips
	set(value):
		player_chips = value
		emit_signal("player_chips_changed")

@export var player_total: int = 0:
	get: return player_total
	set(value):
		player_total = value
		emit_signal("player_total_changed")
		if player_total == 21:
			game_action = GameActions.PLAYER_BLACKJACK
		elif player_total > 21:
			game_action = GameActions.PLAYER_BUST

@export var house_total: int = 0:
	get: return house_total
	set(value):
		house_total = value
		emit_signal("house_total_changed")

@export var centre_text: String = "twentyone":
	get: return centre_text
	set(value):
		centre_text = value
		emit_signal("centre_text_changed")

@export var round_winner: RoundWinner:
	get: return round_winner
	set(value):
		round_winner = value
		emit_signal("round_winner_changed")

@export var player_blackjack: bool = false:
	get: return player_blackjack
	set(value):
		player_blackjack = value
		emit_signal("player_blackjacked")
