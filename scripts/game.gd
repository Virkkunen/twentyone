extends Node2D

@onready var DeckNode: Node2D = $Deck
@onready var PlayerNode: Node2D = $Player
@onready var HouseNode: Node2D = $House
@onready var PlayerHandContainer: HBoxContainer = $UI/SafeMargin/VBoxContainer/Player/PlayerHand
@onready var HouseHandContainer: HBoxContainer = $UI/SafeMargin/VBoxContainer/House/HouseHand

func _ready() -> void:
	Global.game_state_changed.connect(_on_game_state_changed)
	Global.game_action_changed.connect(_on_game_action_changed)
	_setup_game()

func _on_game_state_changed() -> void:
	match Global.game_state:
		Global.GameStates.SETUP:
			_setup_game()
		Global.GameStates.HOUSE_TURN:
			_house_turn()

func _on_game_action_changed() -> void:
	match Global.game_action:
		Global.GameActions.PLAYER_HIT:
			_on_player_hit()
		Global.GameActions.PLAYER_STAND:
			_on_player_stand()
		Global.GameActions.PLAYER_BUST:
			_on_player_bust()
		Global.GameActions.HOUSE_HIT:
			_on_house_hit()
		Global.GameActions.HOUSE_STAND:
			_on_house_stand()
		Global.GameActions.HOUSE_BUST:
			_on_house_bust()

func _setup_game() -> void:
	Global.player_chips = Global.player_chips
	Global.pot = Global.pot

	Global.game_state = Global.GameStates.DEALING
	_deal_cards(PlayerNode, 2)
	_deal_cards(HouseNode, 2)
	HouseHandContainer.get_child(1).flip_card(true)

	Global.game_state = Global.GameStates.PLAYER_TURN
	Global.centre_text = "Your turn"

func _deal_cards(side: Node2D, count: int) -> void:
	Global.game_action = Global.GameActions.NONE
	for cards in count:
		var card = DeckNode.deck.pop_front()
		var current_parent = card.get_parent()
		current_parent.remove_child(card)
		side.add_card_to_hand(card)
		if side == PlayerNode:
			PlayerHandContainer.add_child(card)
		elif side == HouseNode:
			HouseHandContainer.add_child(card)

#
# Player turn
#
func _on_player_hit() -> void:
	Global.centre_text = "Hit"
	_deal_cards(PlayerNode, 1)

func _on_player_stand() -> void:
	Global.centre_text = "Stand"
	Global.game_state = Global.GameStates.HOUSE_TURN

func _on_player_bust() -> void:
	Global.centre_text = "Bust!"
	Global.game_state = Global.GameStates.HOUSE_TURN

#
# House turn
#
func _house_turn() -> void:
	await get_tree().create_timer(2).timeout
	Global.centre_text = "House turn"
	Global.game_action = Global.GameActions.NONE
	HouseNode.first_turn = false
	HouseHandContainer.get_child(1).flip_card(false)
	HouseNode.calc_total()

	while Global.house_total < 17 and Global.game_action == Global.GameActions.NONE:
		Global.game_action = Global.GameActions.HOUSE_HIT

func _on_house_hit() -> void:
	await get_tree().create_timer(2).timeout
	Global.centre_text = "House Hit"
	_deal_cards(HouseNode, 1)
	Global.game_action = Global.GameActions.NONE

func _on_house_bust() -> void:
	Global.centre_text = "House Busts!"
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.ROUND_OVER

func _on_house_stand() -> void:
	Global.centre_text = "House stands"
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.ROUND_OVER
