extends Node2D

var Card = preload("res://scripts/card.gd")

@export var deck: Array = []

func _ready() -> void:
	pass

func create_deck() -> void:
	for suit in Card.CardSuit.values():
		for rank in Card.CardRank.values():
			var card = load("res://scenes/card.tscn").instantiate()
			card.card_suit = suit
			card.card_rank = rank
			card.suit_colour = Card.SuitColour.RED if suit in [Card.CardSuit.HEARTS, Card.CardSuit.DIAMONDS] else Card.SuitColour.BLACK
			card.is_face = true if rank in [Card.CardRank.JOKER, Card.CardRank.QUEEN, Card.CardRank.KING] else false
			card.calc_value()

			card.name = str(Card.CardRank.keys()[rank]) + " OF " + str(Card.CardSuit.keys()[suit])

			var texture_path = "res://assets/cards/" + str(Card.CardRank.keys()[rank].to_lower()) + "_" + str(Card.CardSuit.keys()[suit].to_lower()) + ".png"
			var texture = load(texture_path)
			card.get_node("TextureRect").texture = texture

			deck.append(card)