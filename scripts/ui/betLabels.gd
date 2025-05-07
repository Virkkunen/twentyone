extends VBoxContainer

@onready var LabelChips = $BettingChipsLabel
@onready var LabelPot = $BettingPotLabel

func _ready() -> void:
	LabelPot.text = "Pot: %s" % [Global.pot]
	LabelChips.text = "Chips: %s" % [Global.player_chips]

	Global.pot_changed.connect(_on_pot_changed)
	Global.player_chips_changed.connect(_on_player_chips_changed)

func _on_pot_changed() -> void:
	LabelPot.text = "Pot: %s" % [Global.pot]

func _on_player_chips_changed() -> void:
	LabelChips.text = "Chips: %s" % [Global.player_chips]
