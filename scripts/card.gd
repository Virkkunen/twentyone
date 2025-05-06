class_name Card extends Control

@onready var CardTexture: TextureRect = $CardTexture
@onready var CardBack: TextureRect = $CardBack

@export var card_suit: Global.CardSuit
@export var card_rank: Global.CardRank
@export var card_value: int
@export var card_flipped: bool = false

func initialize(suit: Global.CardSuit, rank: Global.CardRank) -> void:
	card_suit = suit
	card_rank = rank
	
	_set_card_name()
	_set_card_texture()
	_calc_value()

func _set_card_name() -> void:
	var str_suit = str(Global.CardSuit.keys()[card_suit]).to_lower()
	var str_rank = str(Global.CardRank.keys()[card_rank]).to_lower()
	name = "%s of %s" % [str_rank, str_suit]

func _set_card_texture() -> void:
	var str_suit = str(Global.CardSuit.keys()[card_suit]).to_lower()
	var str_rank = str(Global.CardRank.keys()[card_rank]).to_lower()
	var texture_path = "res://assets/cards/%s_%s.png" % [str_rank, str_suit]
	var texture = load(texture_path)
	CardTexture.texture = texture

func _check_if_face() -> bool:
	match card_rank:
		Global.CardRank.JOKER, Global.CardRank.QUEEN, Global.CardRank.KING:
			return true
		_:
			return false

func _calc_value() -> void:
	match card_rank:
		Global.CardRank.ACE:
			card_value = 11
		Global. CardRank.TEN, Global.CardRank.JOKER, Global.CardRank.QUEEN, Global.CardRank.KING:
			card_value = 10
		_:
			card_value = card_rank + 1

func flip_card(back_visible: bool) -> void:
	CardBack.visible = back_visible
	card_flipped = back_visible
