extends MarginContainer

@onready var LabelCentre: Label = $CentreLabel

func _ready() -> void:
	Global.centre_text_changed.connect(_on_centre_text_changed)
	
func _on_centre_text_changed() -> void:
	LabelCentre.text = str(Global.centre_text)
