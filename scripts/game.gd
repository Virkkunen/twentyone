extends Node2D

@export var player_score : int

@onready var Deck = $Deck
@onready var Player = $Player
@onready var House = $House

func _ready() -> void:
	Global.screen_size = get_viewport_rect().size
	Deck.create_deck()
	Deck.deck.shuffle()
	deal_cards(Player, 2)
	deal_cards(House, 2)

func deal_cards(whose : Node2D, how_many_cards : int) -> void:
	for index in how_many_cards:
		var card = Deck.deck.pop_front()
		whose.hand.append(card)

		if whose == House and index == 1:
			card.face_down = true

		whose.display_card(card)
	whose.calc_total()