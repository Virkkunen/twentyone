class_name House extends Node2D

@export var hand : Array[Card] = []

var first_turn: bool = true

func add_card_to_hand(card: Card) -> void:
	hand.append(card)

func calc_total() -> void:
	var total = 0
	var ace_count = 0
	if not first_turn:
		for card in hand:
			total += card.card_value
			if card.card_rank == Global.CardRank.ACE:
				ace_count += 1
	else:
		total = hand[0].card_value
		if hand[0].card_rank == Global.CardRank.ACE:
				ace_count += 1

	while total > 21 and ace_count > 0:
		total -= 10
		ace_count -= 1

	Global.house_total = total

func clear_hand() -> void:
	for card in hand:
		if is_instance_valid(card):
			card.queue_free()
		hand.clear()
