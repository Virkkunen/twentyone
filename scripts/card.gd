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
@export var is_down : bool = true

@onready var label_rank : Label = $Rank
@onready var label_suit : Label = $Suit

func _ready() -> void:
	update_card()

func update_card() -> void:
	if card_rank >= CardRank.TWO and card_rank <= CardRank.TEN:
		label_rank.text = str(card_rank + 1)
	else:
		label_rank.text = CardRank.keys()[card_rank]
	label_suit.text = CardSuit.keys()[card_suit]

	if suit_colour == SuitColour.RED:
		label_suit.set("theme_override_colors/font_color", Color.RED)
		label_rank.set("theme_override_colors/font_color", Color.RED)
	else:
		label_suit.set("theme_override_colors/font_color", Color.BLACK)
		label_rank.set("theme_override_colors/font_color", Color.BLACK)

	# aces are being calculated at player and house hands
	if card_rank >= CardRank.TWO and card_rank <= CardRank.TEN:
		card_value = card_rank + 1
	elif is_face:
		card_value = 10

func flip_card() -> void:
	pass
