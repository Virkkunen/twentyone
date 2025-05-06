extends MarginContainer

func _ready() -> void:
	_apply_system_insets()

func _apply_system_insets() -> void:
	# wait a frame to ensure DisplayServer info is up to date
	await get_tree().process_frame
	
	var window_size := get_window().size
	
	var margin_top = DisplayServer.get_display_safe_area().position.y
	var margin_bottom = int(window_size.y * 0.05)
	var margin_sides = int(window_size.x * 0.05)
	
	set("theme_override_constants/margin_top", margin_top)
	set("theme_override_constants/margin_bottom", margin_bottom)
	set("theme_override_constants/margin_left", margin_sides)
	set("theme_override_constants/margin_right", margin_sides)
	
