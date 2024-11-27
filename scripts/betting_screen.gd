extends CanvasLayer

@onready var LabelChips = $Control/MarginContainer/VBoxContainer/ChipsAndPot/Chips
@onready var LabelPot = $Control/MarginContainer/VBoxContainer/ChipsAndPot/Pot
@onready var InfoLabel = $Control/MarginContainer/VBoxContainer/Center/InfoLabel

func _ready() -> void:
	initial_state()
	Global.player_chips_changed.connect(_on_player_chips_changed)
	Global.pot_changed.connect(_on_pot_changed)
	Global.info_label_changed.connect(_on_info_label_changed)

func initial_state() -> void:
	LabelChips.text = "Chips: " + str(Global.player_chips)
	LabelPot.text = "Pot: " + str(Global.pot)
	InfoLabel.text = Global.info_label

func _on_player_chips_changed() -> void:
	LabelChips.text = "Chips: " + str(Global.player_chips)

func _on_pot_changed() -> void:
	LabelPot.text = "Pot: " + str(Global.pot)

func _on_info_label_changed() -> void:
	InfoLabel.text = Global.info_label
