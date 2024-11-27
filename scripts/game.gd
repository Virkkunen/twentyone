extends Node2D

@export var player_score : int

@onready var Deck = $Deck
@onready var Player = $Player
@onready var House = $House
@onready var InfoLabel = $HUD/CanvasLayer/Control/MarginContainer/InfoLabel
@onready var Buttons = $HUD/PlayerCanvas/Control/PlayerHUD/VBoxContainer/Buttons
@onready var ButtonHit = Buttons.get_node("ButtonHit")
@onready var ButtonStand = Buttons.get_node("ButtonStand")

func _ready() -> void:
	# set up the game
	Global.screen_size = get_viewport_rect().size
	Deck.create_deck()
	Deck.deck.shuffle()
	deal_cards(Player, 2)
	deal_cards(House, 2)
	House.face_down_card() # hide the second card
	House.check_insurance() # to check if house has blackjack
	# now the game starts

	# button connects
	ButtonHit.pressed.connect(_on_player_hit)
	ButtonStand.pressed.connect(_on_player_stand)

	# global connects
	Global.player_bust.connect(_on_player_bust)
	Global.house_bust.connect(_on_house_bust)
	Global.player_blackjack.connect(_on_player_blackjack)
	Global.house_blackjack.connect(_on_house_blackjack)

func deal_cards(whose : Node2D, how_many_cards : int) -> void:
	# whose: Player or House Node2D
	for cards in how_many_cards:
		var card = Deck.deck.pop_front()
		whose.hand.append(card)
		whose.display_card(card)
	whose.calc_total()

func check_win() -> void:
	var payout : int = Global.pot
	var player_won : bool = false

	if Global.player_busted and Global.house_busted:
		InfoLabel.text = "No one won"
	elif Global.house_busted:
		InfoLabel.text = "Player wins!"
		player_won = true
		# check payout for 21, dd
	elif Global.player_busted:
		InfoLabel.text = "House wins!"
		await get_tree().create_timer(3).timeout
		InfoLabel.text = "The game was rigged from the start"
	elif Global.player_total == Global.house_total:
		InfoLabel.text = "Tie"
		Global.player_chips += payout
	elif Global.player_total > Global.house_total:
		InfoLabel.text = "Player wins!"
		player_won = true
		# check payout for 21, dd
	else:
		InfoLabel.text = "House wins!"

	if player_won:
		check_payout(payout)
	else:
		pass # restart game

func check_payout(payout : int) -> void:
	var multiplier : int = 2

	if Global.player_blackjacked:
		multiplier = 3

	Global.player_chips += (payout * multiplier)
	# restart game


func _on_player_hit() -> void:
	InfoLabel.text = "Player hits"
	deal_cards(Player, 1)
	await get_tree().create_timer(1).timeout

func _on_player_bust() -> void:
	Buttons.visible = false
	InfoLabel.text = "Player busts"
	await get_tree().create_timer(3).timeout
	house_start_turn()
	# house turn

func _on_player_stand() -> void:
	Buttons.visible = false
	InfoLabel.text = "Player stands"
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
	InfoLabel.text = "Blackjack!"
	Buttons.visible = false
	await get_tree().create_timer(3).timeout
	house_start_turn()

func house_start_turn() -> void:
	InfoLabel.text = "House turn"
	$House/CanvasLayer/Control/CenterContainer/HBoxContainer.get_child(1).get_child(0).queue_free()
	await get_tree().create_timer(2).timeout
	if Global.house_total < 17:
		_on_house_hit()
	else:
		_on_house_stand()

func _on_house_hit() -> void:
	while Global.house_total < 17:
		InfoLabel.text = "House hits"
		deal_cards(House, 1)
		await get_tree().create_timer(2).timeout
	_on_house_stand()
	# deal card

func _on_house_stand() -> void:
	InfoLabel.text = "House stands"
	await get_tree().create_timer(2).timeout
	check_win()
	# hits to 17 or more
	# calc scores, restart game

func _on_house_bust() -> void:
	InfoLabel.text = "House busts"
	await get_tree().create_timer(2).timeout
	check_win()
	# calc scores

func _on_house_blackjack() -> void:
	InfoLabel.text = "Blackjack!"
	await get_tree().create_timer(2).timeout
	check_win()
