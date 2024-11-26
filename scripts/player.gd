extends Node2D

@export var hand : Array = []
@export var total : int

var Card = preload("res://scripts/card.gd")

func calc_total() -> void:
	var local_total = 0
	var ace_count = 0
	print("Hand: ", hand)
	for card in hand:
		print("Card: ", card)
		if card.card_rank != Card.CardRank.ACE:
			local_total += card.card_value
		else:
			ace_count += 1
			local_total += 1

	while ace_count > 0 and local_total <= 11:
		local_total += 10
		ace_count -= 1

	total = local_total
	Global.player_total = total