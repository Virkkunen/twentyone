extends Node2D

@export var player_score : int
@export var player_hand : Array
@export var house_hand : Array

@onready var Deck = $Deck

func _ready() -> void:
	Global.screen_size = get_viewport_rect().size

func deal_cards() -> void:
	pass

func calc_card_value(_card) -> void:
	pass
