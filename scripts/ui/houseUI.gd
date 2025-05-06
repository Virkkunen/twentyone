extends VBoxContainer

@onready var LabelHouseTotal: Label = $HouseTotal

func _ready() -> void:
	Global.house_total_changed.connect(_on_house_total_changed)

func _on_house_total_changed() -> void:
	LabelHouseTotal.text = "Total: %s" % [Global.house_total]
