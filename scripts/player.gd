class_name Player extends Node2D

@export var hand: Array[Card] = []

func _ready() -> void:
	pass

func add_card_to_hand(card: Card) -> void:
	hand.append(card)

func calc_total() -> void:
	Global.game_action = Global.GameActions.CALCULATING
	var total := 0
	var ace_count := 0

	for card in hand:
		total += card.card_value
		if card.card_rank == Global.CardRank.ACE:
			ace_count += 1

	while total > 21 and ace_count > 0:
		total -= 10
		ace_count -= 1

	Global.player_total = total

func clear_hand() -> void:
	for card in hand:
		if is_instance_valid(card):
			card.queue_free()
		hand.clear()
