extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	pass
	
	
func on_area_entered(other_area: Area2D):
	if other_area is HitboxComponent:
		queue_free()
