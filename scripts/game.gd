extends Node2D

@export var player_score : int

@onready var Deck = $Deck
@onready var Player = $Player
@onready var House = $House
@onready var TimerHouse = $HouseTimer
@onready var InfoLabel = $HUD/CanvasLayer/Control/MarginContainer/InfoLabel
@onready var Buttons = $HUD/PlayerCanvas/Control/PlayerHUD/Buttons
@onready var ButtonHit = $HUD/PlayerCanvas/Control/PlayerHUD/Buttons/ButtonHit
@onready var ButtonStand = $HUD/PlayerCanvas/Control/PlayerHUD/Buttons/ButtonStand

func _ready() -> void:
	Global.screen_size = get_viewport_rect().size
	Deck.create_deck()
	Deck.deck.shuffle()
	deal_cards(Player, 2)
	deal_cards(House, 2)
	House.face_down_card()
	House.check_insurance()

	ButtonHit.pressed.connect(_on_player_hit)
	ButtonStand.pressed.connect(_on_player_stand)
	Global.player_bust.connect(_on_player_bust)
	Global.house_bust.connect(_on_house_bust)
	# TimerHouse.timeout.connect(house_turn)


func deal_cards(whose : Node2D, how_many_cards : int) -> void:
	for index in how_many_cards:
		var card = Deck.deck.pop_front()
		whose.hand.append(card)
		whose.display_card(card)
	whose.calc_total()

func check_cards() -> void:
	pass

func check_score() -> void:
	if Global.house_total < 17:
		_on_house_hit()
	elif Global.house_total >=17 and Global.house_total <= 21:
		_on_house_stand()

func check_win() -> void:
	if Global.player_busted and Global.house_busted:
		InfoLabel.text = "No one won"
	elif Global.house_busted:
		InfoLabel.text = "Player wins!"
	elif Global.player_busted:
		InfoLabel.text = "House wins!"
		await wait(2)
		InfoLabel.text = "The game was rigged from the start"
	elif Global.player_total == Global.house_total:
		InfoLabel.text = "Tie"
	elif Global.player_total > Global.house_total:
		InfoLabel.text = "Player wins!"
	else:
		InfoLabel.text = "House wins!"

func wait(seconds : float) -> void:
	print("wait ", seconds)
	await get_tree().create_timer(seconds).timeout

func _on_player_hit() -> void:
	deal_cards(Player, 1)

func _on_player_bust() -> void:
	Buttons.visible = false
	InfoLabel.text = "Player busts"
	await wait(3)
	house_start_turn()
	# house turn

func _on_player_stand() -> void:
	Buttons.visible = false
	InfoLabel.text = "Player stands"
	await wait(3)
	house_start_turn()
	# house turn

func _on_player_split() -> void:
	# split decks, create second row and move second card there
	# clone hit and stand button, won't allow split and dd
	pass

func _on_player_double_down() -> void:
	# read the rules on this one
	pass

func house_start_turn() -> void:
	InfoLabel.text = "House turn"
	$House/CanvasLayer/Control/CenterContainer/HBoxContainer.get_child(1).get_child(0).queue_free()
	await wait(2)
	if Global.house_total < 17:
		_on_house_hit()
	else:
		_on_house_stand()

func _on_house_hit() -> void:
	InfoLabel.text = "House hits"
	deal_cards(House, 1)
	await wait(2)
	check_score()
	# deal card

func _on_house_stand() -> void:
	InfoLabel.text = "House stands"
	await wait(2)
	check_win()
	# hits to 17 or more
	# calc scores, restart game

func _on_house_bust() -> void:
	InfoLabel.text = "House busts"
	await wait(2)
	check_win()
	# calc scores

func _on_house_blackjack() -> void:
	InfoLabel.text = "Blackjack!"
	await wait(2)
	check_win()