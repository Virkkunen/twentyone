extends Node2D

@onready var DeckNode = $Deck
@onready var PlayerNode = $Player
@onready var HouseNode = $House
@onready var PlayerHandContainer = $UI/SafeMargin/VBoxContainer/Player/PlayerHand
@onready var HouseHandContainer = $UI/SafeMargin/VBoxContainer/House/HouseHand

func _ready() -> void:
	_setup_game()

func _setup_game() -> void:
	Global.game_state = Global.GameStates.DEALING
	_deal_cards(PlayerNode, 2)
	_deal_cards(HouseNode, 2)

func _deal_cards(side : Node2D, count : int) -> void:

	for cards in count:
		var card = DeckNode.deck.pop_front()
		var current_parent = card.get_parent()
		current_parent.remove_child(card)
		side.add_card_to_hand(card)
		if side == PlayerNode:
			PlayerHandContainer.add_child(card)
		else:
			HouseHandContainer.add_child(card)
