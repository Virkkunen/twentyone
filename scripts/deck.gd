extends Node2D

var Card = preload("res://scripts/card.gd")

@export var deck: Array = []

@onready var Box = $CanvasLayer/Control/BoxContainer

# var card_being_dragged : Node2D

func _ready() -> void:
	pass
	# create_deck()
	# shuffle_deck()

# func _process(delta: float) -> void:
# 	if card_being_dragged:
# 		var mouse_pos = get_global_mouse_position()
# 		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, Global.screen_size.x), clamp(mouse_pos.y, 0, Global.screen_size.y))

# this is blackjack, cards don't need to be dragged
# func _input(event: InputEvent) -> void:
# 	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
# 		if event.pressed:
# 			print("click")
# 			var card = check_for_card()
# 			if card:
# 				card_being_dragged = card
# 		else:
# 			print("release")
# 			card_being_dragged = null

func create_deck() -> void:
	for suit in Card.CardSuit.values():
		for rank in Card.CardRank.values():
			var card = load("res://scenes/card.tscn").instantiate()
			card.card_suit = suit
			card.card_rank = rank
			card.suit_colour = Card.SuitColour.RED if suit in [Card.CardSuit.HEARTS, Card.CardSuit.DIAMONDS] else Card.SuitColour.BLACK
			card.is_face = true if rank in [Card.CardRank.JOKER, Card.CardRank.QUEEN, Card.CardRank.KING] else false
			card.calc_value()

			card.name = str(Card.CardRank.keys()[rank]) + " OF " + str(Card.CardSuit.keys()[suit])

			var texture_path = "res://assets/cards/" + str(Card.CardRank.keys()[rank].to_lower()) + "_" + str(Card.CardSuit.keys()[suit].to_lower()) + ".png"
			var texture = load(texture_path)
			card.get_node("TextureRect").texture = texture

			deck.append(card)

func shuffle_deck() -> void:
	deck.shuffle()

# func check_for_card() -> Node2D:
# 	var space_state = get_world_2d().direct_space_state
# 	var params = PhysicsPointQueryParameters2D.new()
# 	params.position = get_global_mouse_position()
# 	params.collide_with_areas = true
# 	var result = space_state.intersect_point(params)
# 	return result[0].collider.get_parent() if result.size() > 0 else null
