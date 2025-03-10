extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var label = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/Label

func _ready() -> void:
	#start_textbox("ahefbjabtej geaj rghabjrehg aerhbgahfbjadhf gabrhsb")
	pass

func start_textbox(text: String):
	label.text = text
	
	var duration = len(text) * CHAR_READ_RATE

	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)\
	 .set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	
