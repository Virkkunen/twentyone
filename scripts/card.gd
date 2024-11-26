extends Node2D

enum CardSuit {
	CLUBS,
	SPADES,
	HEARTS,
	DIAMONDS
}

enum SuitColour {
	RED,
	BLACK
}

enum CardRank {
	ACE, TWO, THREE, FOUR, FIVE,
	SIX, SEVEN, EIGHT, NINE,
	TEN, JOKER, QUEEN, KING
}

@export var card_suit : CardSuit = CardSuit.HEARTS
@export var suit_colour : SuitColour = SuitColour.RED
@export var card_rank : CardRank = CardRank.ACE
@export var is_face : bool = false
@export var card_value : int = 0
@export var face_down : bool = false

func _ready() -> void:
	pass

func calc_value() -> void:
	# aces are being calculated at player and house hands
	if card_rank >= CardRank.TWO and card_rank <= CardRank.TEN:
		card_value = card_rank + 1
	elif is_face:
		card_value = 10

func flip_card() -> void:
	pass
