class_name Deck extends Node

const CardScene = preload("res://scenes/card.tscn")

@export var deck : Array[Card] = []

func _ready() -> void:
	_create_deck()
	shuffle_deck()
	
func _create_deck() -> void:
	for suit in Global.CardSuit.values():
		for rank in Global.CardRank.values():
			var card := CardScene.instantiate()
			add_child(card)
			card.initialize(suit, rank)
			deck.append(card)

func shuffle_deck() -> void:
	deck.shuffle()
