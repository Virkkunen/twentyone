extends Node2D

var card_being_dragged : Node2D

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, Global.screen_size.x), clamp(mouse_pos.y, 0, Global.screen_size.y))

# this is blackjack, cards don't need to be dragged
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

func check_for_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	var result = space_state.intersect_point(params)
	return result[0].collider.get_parent() if result.size() > 0 else null
