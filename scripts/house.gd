extends Node2D

signal house_total_changed

@export var hand : Array = []
@export var total : int = 0:
	get:
		return total
	set(value):
		total = value
		Global.house_total = total

@onready var Box = $CanvasLayer/Control/CenterContainer/HBoxContainer

var Card = preload("res://scripts/card.gd")

func calc_total() -> void:
	var local_total = 0
	var ace_count = 0
	for card in hand:
		if card.card_rank != Card.CardRank.ACE:
			local_total += card.card_value
		else:
			ace_count += 1
			local_total += 1

	while ace_count > 0 and local_total <= 11:
		local_total += 10
		ace_count -= 1

	total = local_total

func display_card(card : Node2D) -> void:
	var new_card = TextureRect.new()

	var texture_path = "res://assets/cards/" + str(card.CardRank.keys()[card.card_rank].to_lower()) + "_" + str(card.CardSuit.keys()[card.card_suit].to_lower()) + ".png"
	var texture = load(texture_path)
	new_card.texture = texture

	Box.add_child(new_card)

func face_down_card() -> void:
	var card = $CanvasLayer/Control/CenterContainer/HBoxContainer.get_child(1)
	var card_back = TextureRect.new()
	var texture_back = load("res://assets/cards/card_back.png")
	card_back.texture = texture_back
	card_back.name = "cardback"
	card.add_child(card_back)

func check_insurance():
	if hand[0].card_rank == Card.CardRank.ACE:
		# show UI with button yes/no to buy insurance
		# check rules for insurance
		pass
