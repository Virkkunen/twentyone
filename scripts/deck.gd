extends Node

var Card = preload("res://scripts/card.gd")

@export var deck : Array = []

func _ready() -> void:
	pass
	
func create_deck() -> void:
	for suit in Card.CardSuit.values():
		for rank in Card.CardRank.values():
			var card = load("res://assets/cards/ace_clubs.png").instantiate()
			
