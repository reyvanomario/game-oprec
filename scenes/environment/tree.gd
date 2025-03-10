extends StaticBody2D

@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	animation_player.play("idle")


func _process(delta: float) -> void:
	pass
