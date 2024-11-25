extends Node2D

var Card : Resource = preload("res://scripts/card.gd")

@export var deck: Array = []

var card_being_dragged : Node2D

func _ready() -> void:
	create_deck()
	shuffle_deck()
	DEBUG_show_deck()

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, Global.screen_size.x), clamp(mouse_pos.y, 0, Global.screen_size.y))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("click")
			var card = check_for_card()
			if card:
				card_being_dragged = card
		else:
			print("release")
			card_being_dragged = null

func create_deck() -> void:
	for suit in Card.CardSuit.values():
		for rank in Card.CardRank.values():
			var card = load("res://scenes/card.tscn").instantiate()
			card.card_suit = suit
			card.card_rank = rank
			card.suit_colour = Card.SuitColour.RED if suit in [Card.CardSuit.HEARTS, Card.CardSuit.DIAMONDS] else Card.SuitColour.BLACK
			card.is_face = true if rank in [Card.CardRank.JOKER, Card.CardRank.QUEEN, Card.CardRank.KING] else false

			card.name = str(Card.CardRank.keys()[rank]) + " OF " + str(Card.CardSuit.keys()[suit])
			deck.append(card)

func shuffle_deck() -> void:
	deck.shuffle()

func DEBUG_show_deck() -> void:
	var start_pos = Vector2(10, 10)
	var card_offset = Vector2(70, 20)
	
	for card in deck:
		add_child(card)
		card.position = start_pos
		start_pos += card_offset
		card.update_card()

func check_for_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	var result = space_state.intersect_point(params)
	return result[0].collider.get_parent() if result.size() > 0 else null