extends Panel

func _ready() -> void:
	_apply_system_insets()

func _apply_system_insets() -> void:
	# wait a frame to ensure DisplayServer info is up to date
	await get_tree().process_frame
	var margin_top = DisplayServer.get_display_safe_area().position.y
	#set("theme_override_constants/margin_top", margin_top)
	self.custom_minimum_size = Vector2(1, margin_top)
