extends Node2D

@export var floating_speed: Vector2 = Vector2(0, -150)


func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	

func _process(delta: float) -> void:
	position += floating_speed * delta


func on_timer_timeout():
	queue_free()
