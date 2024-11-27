extends CanvasLayer

@onready var LabelPlayerTotal = $Control/MarginContainer/VBoxContainer/PlayerHand/Total
@onready var LabelHouseTotal = $Control/MarginContainer/VBoxContainer/HouseHand/Total
@onready var LabelChips = $Control/MarginContainer/VBoxContainer/ChipsAndPot/Chips
@onready var LabelPot = $Control/MarginContainer/VBoxContainer/ChipsAndPot/Pot
@onready var InfoLabel = $Control/MarginContainer/VBoxContainer/Center/InfoLabel

func _ready() -> void:
	Global.player_total_changed.connect(_on_player_total_changed)
	Global.house_total_changed.connect(_on_house_total_changed)
	Global.player_chips_changed.connect(_on_player_chips_changed)
	Global.pot_changed.connect(_on_pot_changed)
	Global.info_label_changed.connect(_on_info_label_changed)

func _on_player_total_changed() -> void:
	LabelPlayerTotal.text = "Total: " + str(Global.player_total)

func _on_house_total_changed() -> void:
	LabelHouseTotal.text = "Total: " + str(Global.house_total)

func _on_player_chips_changed() -> void:
	LabelChips.text = "Chips: " + str(Global.player_chips)

func _on_pot_changed() -> void:
	LabelPot.text = "Pot: " + str(Global.pot)

func _on_info_label_changed() -> void:
	InfoLabel.text = Global.info_label