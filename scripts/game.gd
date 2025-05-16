extends Node2D

@onready var DeckNode: Node2D = $Deck
@onready var PlayerNode: Node2D = $Player
@onready var HouseNode: Node2D = $House
@onready var PlayerHandContainer: FlowContainer = $UI/Middle/Player/PlayerHand
@onready var HouseHandContainer: FlowContainer = $UI/Middle/House/HouseHand
@onready var CentreText: Label = $UI/Middle/Centre/CentreLabel
@onready var CardAnim: AnimationPlayer = $UI/CardAnimControl/CardAnim

var first_round = true

func _ready() -> void:
	Global.game_state_changed.connect(_on_game_state_changed)
	Global.game_action_changed.connect(_on_game_action_changed)
	Global.house_total_changed.connect(_on_house_total_changed)
	Global.round_winner_changed.connect(_on_round_winner_changed)
	_setup_game()

func _on_game_state_changed() -> void:
	match Global.game_state:
		Global.GameStates.SETUP:
			_setup_game()
		Global.GameStates.HOUSE_TURN:
			_house_turn()
		Global.GameStates.ROUND_OVER:
			_on_round_over()

func _on_game_action_changed() -> void:
	match Global.game_action:
		Global.GameActions.PLAYER_HIT:
			_on_player_hit()
		Global.GameActions.PLAYER_STAND:
			_on_player_stand()
		Global.GameActions.PLAYER_BUST:
			_on_player_bust()
		Global.GameActions.PLAYER_BLACKJACK:
			_on_player_blackjack()
		Global.GameActions.HOUSE_HIT:
			_on_house_hit()
		Global.GameActions.HOUSE_STAND:
			_on_house_stand()
		Global.GameActions.HOUSE_BUST:
			_on_house_bust()
		Global.GameActions.HOUSE_BLACKJACK:
			_on_house_blackjack()
		_:
			pass

func _setup_game() -> void:
	first_round = true
	Global.player_blackjack = false
	Global.player_chips = Global.player_chips
	Global.pot = Global.pot

	_deal_cards(PlayerNode, 2)
	_deal_cards(HouseNode, 2)
	HouseHandContainer.get_child(1).flip_card(true)

	Global.game_state = Global.GameStates.PLAYER_TURN
	first_round = false
	_change_info("Your turn", Global.ctp_blue)

func _deal_cards(side: Node2D, count: int) -> void:
	Global.game_action = Global.GameActions.DEALING
	for cards in count:
		var card = DeckNode.deck.pop_front()
		var current_parent = card.get_parent()
		current_parent.remove_child(card)
		if not first_round:
			CardAnim.play("deal_player") if side == PlayerNode else CardAnim.play("deal_house")
			await CardAnim.animation_finished
		side.add_card_to_hand(card)
	side.calc_total()

func _change_info(text: String, colour: String = "#cdd6f4") -> void:
	Global.centre_text = text
	CentreText.add_theme_color_override("font_color", colour)

#
# Player turn
#
func _on_player_hit() -> void:
	_change_info("You hit", Global.ctp_lavender)
	_deal_cards(PlayerNode, 1)

func _on_player_stand() -> void:
	_change_info("You stand", Global.ctp_yellow)
	Global.game_state = Global.GameStates.WAITING
	Global.game_action = Global.GameActions.NONE
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.HOUSE_TURN

func _on_player_bust() -> void:
	Input.vibrate_handheld(5, 0.8)
	_change_info("Bust!", Global.ctp_maroon)
	Global.game_state = Global.GameStates.WAITING
	Global.game_action = Global.GameActions.NONE
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.HOUSE_TURN

func _on_player_blackjack() -> void:
	_change_info("twentyone!", Global.ctp_green)
	Global.player_blackjack = true
	Global.game_state = Global.GameStates.WAITING
	Global.game_action = Global.GameActions.NONE
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.HOUSE_TURN

#
# House turn
#
func _house_turn() -> void:
	_change_info("House turn")
	Global.game_action = Global.GameActions.NONE
	if HouseNode.first_turn and Global.game_state == Global.GameStates.HOUSE_TURN:
		HouseNode.first_turn = false
		HouseHandContainer.get_child(1).flip_card(false)
		HouseNode.calc_total()

func _on_house_total_changed() -> void:
	if Global.game_state == Global.GameStates.HOUSE_TURN:
		await get_tree().create_timer(2).timeout
		if Global.house_total > 21:
			Global.game_action = Global.GameActions.HOUSE_BUST
		elif Global.house_total == 21:
			Global.game_action = Global.GameActions.HOUSE_BLACKJACK
		elif Global.house_total >= 17:
			Global.game_action = Global.GameActions.HOUSE_STAND
		else:
			Global.game_action = Global.GameActions.HOUSE_HIT

func _on_house_hit() -> void:
	_change_info("house hits")
	_deal_cards(HouseNode, 1)

func _on_house_bust() -> void:
	_change_info("house busts!", Global.ctp_maroon)
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.ROUND_OVER

func _on_house_stand() -> void:
	_change_info("house stands", Global.ctp_yellow)
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.ROUND_OVER

func _on_house_blackjack() -> void:
	_change_info("House gets a twentyone!", Global.ctp_green)
	await get_tree().create_timer(2).timeout
	Global.game_state = Global.GameStates.ROUND_OVER

#
# Round over
#
func _on_round_over() -> void:
	Global.game_action = Global.GameActions.CALCULATING
	if Global.player_total > 21:
		Global.round_winner = Global.RoundWinner.BUST
	elif Global.house_total > 21:
		Global.round_winner = Global.RoundWinner.PLAYER
	elif Global.player_total == Global.house_total:
		Global.round_winner = Global.RoundWinner.DRAW
	elif Global.player_total > Global.house_total:
		Global.round_winner = Global.RoundWinner.PLAYER
	else:
		Global.round_winner = Global.RoundWinner.HOUSE
		
func _on_round_winner_changed() -> void:
	match Global.round_winner:
		Global.RoundWinner.PLAYER:
			Global.pot *= 1.5
			if Global.player_blackjack:
				Global.pot *= 2
			_change_info("You win! Payout: %s" % [Global.pot], Global.ctp_green)
		Global.RoundWinner.HOUSE, Global.RoundWinner.BUST:
			Global.pot = 0
			_change_info("You lose!", Global.ctp_red)
		Global.RoundWinner.DRAW:
			_change_info("It's a draw", Global.ctp_yellow)
	await get_tree().create_timer(2).timeout
	if not _check_if_game_over():
		_payout()
	else:
		_game_over()

func _check_if_game_over() -> bool:
	if Global.player_chips > 0:
		return false

	var lost_outcomes := [Global.RoundWinner.HOUSE, Global.RoundWinner.BUST]
	if Global.round_winner in lost_outcomes:
		return true

	return false

func _payout() -> void:
	Global.player_chips += Global.pot
	Global.pot = 0
	await get_tree().create_timer(2.5).timeout
	SceneTransition.transition_to("res://scenes/betting.tscn")

func _game_over() -> void:
	Global.pot = 0
	_change_info("Game over :(", Global.ctp_red)
	await get_tree().create_timer(2).timeout
	_change_info("The game was rigged\nfrom the start", Global.ctp_red)
	await get_tree().create_timer(2).timeout
	Global.player_chips = 50
	SceneTransition.transition_to("res://scenes/menu.tscn")
	# add a first round variable
