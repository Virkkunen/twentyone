extends HBoxContainer

@onready var LabelChips: Label = $Chips
@onready var LabelPot: Label = $Pot

func _ready() -> void:
	Global.player_chips_changed.connect(_on_player_chips_changed)
	Global.pot_changed.connect(_on_pot_changed)
	
func _on_player_chips_changed() -> void:
	LabelChips.text = "Chips: %s" % [Global.player_chips]
	
func _on_pot_changed() -> void:
	LabelPot.text = "Pot: %s" % [Global.pot]
