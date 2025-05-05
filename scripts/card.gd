extends Node2D

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

@export var card_suit : CardSuit
@export var card_rank : CardRank
@export var is_face : bool
@export var card_value : int

func _ready() -> void:
	check_if_face()
	calc_value()

func calc_value() -> void:
	if card_rank >= CardRank.TWO and card_rank <= CardRank.TEN:
		card_value = card_rank + 1
	elif is_face:
		card_value = 10

func check_if_face() -> void:
	match card_rank:
		CardRank.JOKER, CardRank.QUEEN, CardRank.KING:
			is_face = true
