extends Node2D

@onready var Deck = $Deck
@onready var Player = $Player
@onready var House = $House
@onready var PlayerVisibleHand = $Screen/Control/MarginContainer/VBoxContainer/PlayerHand/Cards
@onready var HouseVisibleHand = $Screen/Control/MarginContainer/VBoxContainer/HouseHand/Cards
@onready var Buttons = $Screen/Control/MarginContainer/VBoxContainer/Buttons
@onready var ButtonHit = Buttons.get_node("ButtonHit")
@onready var ButtonStand = Buttons.get_node("ButtonStand")
@onready var ExtraButtons = $Screen/Control/MarginContainer/VBoxContainer/Buttons/ExtraButtons
@onready var ButtonSplit = ExtraButtons.get_node("ButtonSplit")
@onready var ButtonDoubleDown = ExtraButtons.get_node("ButtonDoubleDown")


func _ready() -> void:
	initial_state()
	setup_game()

	# button connects
	ButtonHit.pressed.connect(_on_player_hit)
	ButtonStand.pressed.connect(_on_player_stand)

	# global connects
	Global.player_bust.connect(_on_player_bust)
	Global.house_bust.connect(_on_house_bust)
	Global.player_blackjack.connect(_on_player_blackjack)
	Global.house_blackjack.connect(_on_house_blackjack)

func initial_state() -> void:
	Global.info_label = "twentyone"
	Global.player_blackjacked = false
	Global.house_blackjacked = false
	Global.player_busted = false
	Global.house_busted = false

	Player.hand = []
	Player.total = 0
	House.hand = []
	House.total = 0
	Deck.deck = []

	ButtonHit.disabled = false
	ButtonStand.disabled = false
	ButtonSplit.disabled = true
	ButtonDoubleDown.disabled = false

	hide_house_score()

	for child in PlayerVisibleHand.get_children():
		queue_free()
	for child in HouseVisibleHand.get_children():
		queue_free()

## SETUP

func setup_game() -> void:
	Global.game_state = Global.GameStates.SETUP
	Deck.create_deck()
	Deck.deck.shuffle()
	deal_cards(Player, 2)
	deal_cards(House, 2)
	House.face_down_card() # hide the second card
	hide_house_score()
	# House.check_insurance() # to check if house has blackjack
	check_if_split()
	# now the game starts
	Global.game_state = Global.GameStates.PLAYER_TURN

func deal_cards(whose : Node2D, how_many_cards : int) -> void:
	# whose: Player or House Node2D
	for cards in how_many_cards:
		var card = Deck.deck.pop_front()
		whose.hand.append(card)
		whose.display_card(card)
	whose.calc_total()

func disable_buttons() -> void:
	ButtonHit.disabled = true
	ButtonStand.disabled = true
	ButtonSplit.disabled = true
	ButtonDoubleDown.disabled = true
## PLAYER

func check_if_split() -> void:
	if Player.hand[0].card_rank == Player.hand[1].card_rank:
		ButtonSplit.disabled = false

func _on_player_hit() -> void:
	Input.vibrate_handheld(4)
	Global.info_label = "Player hits"
	deal_cards(Player, 1)
	ButtonSplit.disabled = true
	ButtonDoubleDown.disabled = true

func _on_player_bust() -> void:
	Input.vibrate_handheld(48, 0.3)
	disable_buttons()
	Global.info_label = "Player busts"
	await get_tree().create_timer(3).timeout
	house_start_turn()
	# house turn

func _on_player_stand() -> void:
	Input.vibrate_handheld(4)
	disable_buttons()
	Global.info_label = "Player stands"
	await get_tree().create_timer(3).timeout
	print("3 seconds stand")
	house_start_turn()
	# house turn

func _on_player_split() -> void:
	# split decks, create second row and move second card there
	# hit and stand on first array, then on second
	pass

func _on_player_double_down() -> void:
	# bet extra chips and pull a single card
	# if player hits or splits, remove this button
	pass

func _on_player_blackjack() -> void:
	Input.vibrate_handheld(100, 0.8)
	Global.info_label = "Twentyone!"
	disable_buttons()
	await get_tree().create_timer(3).timeout
	house_start_turn()

## HOUSE

func hide_house_score() -> void:
	var label = $Screen/Control/MarginContainer/VBoxContainer/HouseHand/Total
	label.text = " "

func house_start_turn() -> void:
	Global.game_state = Global.GameStates.HOUSE_TURN
	var label = $Screen/Control/MarginContainer/VBoxContainer/HouseHand/Total
	label.text = "Total: " + str(Global.house_total) # show the total
	# this spaghetti removes the card back texture
	$Screen/Control/MarginContainer/VBoxContainer/HouseHand/Cards.get_child(1).get_child(0).queue_free()
	await get_tree().create_timer(2).timeout
	while Global.house_total < 17:
		await _on_house_hit()

	if Global.house_total >= 17 and Global.house_total < 21:
		_on_house_stand()

func _on_house_hit() -> void:
	Global.info_label = "House hits"
	deal_cards(House, 1)
	await get_tree().create_timer(2).timeout

func _on_house_stand() -> void:
	Global.info_label = "House stands"
	await get_tree().create_timer(2).timeout
	check_win()
	# hits to 17 or moreg
	# calc scores, restart game

func _on_house_bust() -> void:
	Global.info_label = "House busts"
	await get_tree().create_timer(2.5).timeout
	check_win()


func _on_house_blackjack() -> void:
	Global.info_label = "Twentyone!"
	await get_tree().create_timer(2).timeout
	check_win()

## CALCULATING

func check_win() -> void:
	Global.game_state = Global.GameStates.CALCULATING
	var player_won : bool = false
	var multiplier = 2
	var payout = Global.pot

	if Global.player_busted and Global.house_busted:
		Global.info_label = "No one won"
	elif Global.house_busted:
		player_won = true
		# check payout for 21, dd
	elif Global.player_busted:
		Global.info_label = "House wins!"
		await get_tree().create_timer(3).timeout
		Global.info_label = "The game was rigged from the start"
	elif Global.player_total == Global.house_total:
		Global.info_label = "Tie"
		Global.player_chips += payout
	elif Global.player_total > Global.house_total:
		player_won = true
		# check payout for 21, dd
	else:
		Global.info_label = "House wins!"

	if player_won:
		player_won = false
		Global.info_label = "Player wins!"
		await get_tree().create_timer(2).timeout

		if Global.player_blackjacked:
			multiplier = 3

		payout = payout * multiplier
		Global.info_label = "Payout: " + str(payout) + " chips"
		Global.player_chips += payout

	Global.pot = 0

	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://scenes/BettingScene.tscn")
