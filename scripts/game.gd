extends Node2D

@export var player_score : int

@onready var Deck = $Deck
@onready var Player = $Player
@onready var House = $House
@onready var PlayerVisibleHand = $Screen/Control/MarginContainer/VBoxContainer/PlayerHand/Cards
@onready var HouseVisibleHand = $Screen/Control/MarginContainer/VBoxContainer/HouseHand/Cards
# @onready var InfoLabel = $HUD/CanvasLayer/Control/MarginContainer/InfoLabel
# @onready var InfoLabel = $Screen/Control/MarginContainer/VBoxContainer/Center/InfoLabel
# @onready var Buttons = $HUD/PlayerCanvas/Control/PlayerHUD/VBoxContainer/Buttons
@onready var Blinds = $Screen/Control/MarginContainer/Blinds
@onready var Buttons = $Screen/Control/MarginContainer/VBoxContainer/Buttons
@onready var ButtonHit = Buttons.get_node("ButtonHit")
@onready var ButtonStand = Buttons.get_node("ButtonStand")
@onready var ExtraButtons = $Screen/Control/MarginContainer/VBoxContainer/Buttons/ExtraButtons
@onready var BetButtons = $Screen/Control/MarginContainer/VBoxContainer/Buttons/BetButtons
@onready var ButtonIncrease = BetButtons.get_node("ButtonIncrease")
@onready var ButtonDecrease = BetButtons.get_node("ButtonDecrease")
@onready var ButtonResetBet = BetButtons.get_node("ButtonResetBet")
@onready var ButtonConfirmBet = BetButtons.get_node("ButtonConfirmBet")


func _ready() -> void:
	# betting phase
	# buttons are increase/decrease, accept reset
	# changes from player_chips to pot
	# minimum of 1
	betting_phase()
	# set up the game
	# button connects
	ButtonHit.pressed.connect(_on_player_hit)
	ButtonStand.pressed.connect(_on_player_stand)
	ButtonIncrease.pressed.connect(func(): _on_bet_button_pressed("increase"))
	ButtonDecrease.pressed.connect(func(): _on_bet_button_pressed("decrease"))
	ButtonResetBet.pressed.connect(func(): _on_bet_button_pressed("reset"))
	ButtonConfirmBet.pressed.connect(func(): _on_bet_button_pressed("confirm"))

	# global connects
	Global.player_bust.connect(_on_player_bust)
	Global.house_bust.connect(_on_house_bust)
	Global.player_blackjack.connect(_on_player_blackjack)
	Global.house_blackjack.connect(_on_house_blackjack)

func reset(hard: bool = false) -> void:
	if hard:
		pass
	else:
		Global.pot = 0
		Global.info_label = "twentyone"
		Player.hand = []
		House.hand = []
		Deck.deck = []
		Buttons.columns = 2
		for child in PlayerVisibleHand.get_children():
			queue_free()
		for child in HouseVisibleHand.get_children():
			queue_free()



## BET PHASE

func betting_phase() -> void:
	Global.game_state = Global.GameStates.BETTING
	BetButtons.visible = true
	ExtraButtons.visible = false
	ButtonHit.visible = false
	ButtonStand.visible = false
	Blinds.visible = true
	Global.info_label = "Place your bet"

func _on_bet_button_pressed(which : String) -> void:
	match which:
		"increase":
			if Global.player_chips > 0:
				Global.player_chips -= 1
				Global.pot += 1

		"decrease":
			if Global.pot > 0:
				Global.player_chips += 1
				Global.pot -= 1

		"reset":
			Global.player_chips += Global.pot
			Global.pot = 0

		"confirm":
			if Global.pot < 1:
				Global.info_label = "You need to bet something!"
			else:
				setup_game()

## SETUP

func setup_game() -> void:
	Global.game_state = Global.GameStates.SETUP
	Blinds.visible = false
	BetButtons.visible = false
	ButtonHit.visible = true
	ButtonStand.visible = true
	Deck.create_deck()
	Deck.deck.shuffle()
	deal_cards(Player, 2)
	deal_cards(House, 2)
	House.face_down_card() # hide the second card
	House.check_insurance() # to check if house has blackjack
	check_if_split()
	# now the game starts
	Global.game_state = Global.GameStates.PLAYER_TURN
	Buttons.visible = true

func deal_cards(whose : Node2D, how_many_cards : int) -> void:
	# whose: Player or House Node2D
	for cards in how_many_cards:
		var card = Deck.deck.pop_front()
		whose.hand.append(card)
		whose.display_card(card)
	whose.calc_total()

func hide_buttons() -> void:
	var buttons_array = Buttons.get_children()
	for button in buttons_array:
		button.visible = false

## PLAYER

func check_if_split() -> void:
	if Player.hand[0].card_rank == Player.hand[1].card_rank:
		Buttons.columns = 3
		ExtraButtons.get_child(0).visible = true

func _on_player_hit() -> void:
	Global.info_label = "Player hits"
	deal_cards(Player, 1)
	await get_tree().create_timer(1).timeout

func _on_player_bust() -> void:
	hide_buttons()
	Global.info_label = "Player busts"
	await get_tree().create_timer(3).timeout
	house_start_turn()
	# house turn

func _on_player_stand() -> void:
	hide_buttons()
	Global.info_label = "Player stands"
	await get_tree().create_timer(3).timeout
	house_start_turn()
	# house turn

func _on_player_split() -> void:
	# split decks, create second row and move second card there
	# clone hit and stand button, won't allow split and dd
	pass

func _on_player_double_down() -> void:
	# read the rules on this one
	pass

func _on_player_blackjack() -> void:
	Global.info_label = "Twentyone!"
	hide_buttons()
	await get_tree().create_timer(3).timeout
	house_start_turn()

## HOUSE

func house_start_turn() -> void:
	Global.game_state = Global.GameStates.HOUSE_TURN
	# this spaghetti removes the card back texture
	# $House/CanvasLayer/Control/CenterContainer/HBoxContainer.get_child(1).get_child(0).queue_free()
	$Screen/Control/MarginContainer/VBoxContainer/HouseHand/Cards.get_child(1).get_child(0).queue_free()
	await get_tree().create_timer(2).timeout
	if Global.house_total < 17:
		_on_house_hit()
	else:
		_on_house_stand()

func _on_house_hit() -> void:
	while Global.house_total < 17:
		Global.info_label = "House hits"
		deal_cards(House, 1)
		await get_tree().create_timer(2).timeout
	_on_house_stand()
	# deal card

func _on_house_stand() -> void:
	Global.info_label = "House stands"
	await get_tree().create_timer(2).timeout
	check_win()
	# hits to 17 or more
	# calc scores, restart game

func _on_house_bust() -> void:
	Global.info_label = "House busts"
	await get_tree().create_timer(2).timeout
	check_win()
	# calc scores

func _on_house_blackjack() -> void:
	Global.info_label = "Blackjack!"
	await get_tree().create_timer(2).timeout
	check_win()

## CALCULATING

func check_win() -> void:
	Global.game_state = Global.GameStates.CALCULATING
	var player_won : bool = false

	if Global.player_busted and Global.house_busted:
		Global.info_label = "No one won"
	elif Global.house_busted:
		Global.info_label = "Player wins!"
		player_won = true
		# check payout for 21, dd
	elif Global.player_busted:
		Global.info_label = "House wins!"
		await get_tree().create_timer(3).timeout
		Global.info_label = "The game was rigged from the start"
	elif Global.player_total == Global.house_total:
		Global.info_label = "Tie"
		Global.player_chips += Global.pot
		Global.pot = 0
	elif Global.player_total > Global.house_total:
		Global.info_label = "Player wins!"
		player_won = true
		# check payout for 21, dd
	else:
		Global.info_label = "House wins!"

	await get_tree().create_timer(4).timeout

	if player_won:
		check_payout()
	else:
		reset()
		betting_phase() # restart game

func check_payout() -> void:
	var multiplier : int = 2
	var payout = Global.pot

	if Global.player_blackjacked:
		multiplier = 3

	payout = payout * multiplier
	Global.player_chips += payout
	reset()
	betting_phase()
	# restart game