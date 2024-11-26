extends Node2D

@export var player_score : int

@onready var Deck = $Deck
@onready var Player = $Player
@onready var House = $House
@onready var TimerHouse = $HouseTimer
@onready var InfoLabel = $HUD/CanvasLayer/Control/MarginContainer/InfoLabel
@onready var Buttons = $HUD/PlayerCanvas/Control/PlayerHUD/Buttons
@onready var ButtonHit = $HUD/PlayerCanvas/Control/PlayerHUD/Buttons/ButtonHit

func _ready() -> void:
	Global.screen_size = get_viewport_rect().size
	Deck.create_deck()
	Deck.deck.shuffle()
	deal_cards(Player, 2)
	deal_cards(House, 2)

	ButtonHit.pressed.connect(_on_buttonhit_pressed)
	Global.player_bust.connect(_on_player_bust)
	TimerHouse.timeout.connect(house_turn)


func deal_cards(whose : Node2D, how_many_cards : int) -> void:
	for index in how_many_cards:
		var card = Deck.deck.pop_front()
		whose.hand.append(card)

		if whose == House and index == 1:
			card.face_down = true

		whose.display_card(card)
	whose.calc_total()

func check_insurance() -> void:
	pass

func house_turn() -> void:
	InfoLabel.text = "house turn"
	House.find_child("cardback").queue_free()
	wait(2)
	# check if blackjack for insurance
	if Global.house_total < 17:
		deal_cards(House, 1)
		TimerHouse.wait_time = 4
		TimerHouse.start()

func wait(seconds : float) -> void:
	print("wait ", seconds)
	await get_tree().create_timer(seconds).timeout

# hit will be deal_cards 1
func _on_buttonhit_pressed() -> void:
	print("click")
	deal_cards(Player, 1)

func _on_player_bust() -> void:
	Buttons.visible = false
	InfoLabel.text = "Player bust"
	TimerHouse.wait_time = 4
	TimerHouse.start()
