extends CanvasGroup

@onready var HouseHUD = $HouseCanvas/Control/HouseHUD
@onready var PlayerHUD = $PlayerCanvas/Control/PlayerHUD/VBoxContainer
@onready var ButtonHit = $PlayerCanvas/Control/PlayerHUD/VBoxContainer/Buttons/ButtonHit

func _ready() -> void:
	Global.connect("player_total_changed", _on_player_total_changed)
	Global.connect("house_total_changed", _on_house_total_changed)

func _on_player_total_changed() -> void:
	PlayerHUD.get_node("Total").text = "Total: " + str(Global.player_total)

func _on_house_total_changed() -> void:
	HouseHUD.get_node("Total").text = "Total: " + str(Global.house_total)
