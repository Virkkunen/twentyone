extends VBoxContainer

@onready var LabelPlayerTotal: Label = $PlayerTotal

func _ready() -> void:
	Global.player_total_changed.connect(_on_player_total_changed)

func _on_player_total_changed() -> void:
	LabelPlayerTotal.text = "Total: %s" % [Global.player_total]
