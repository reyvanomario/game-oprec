extends Node2D

var is_spawned = false

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	$AnimationPlayer.play("idle")
	
	
	

func on_area_entered(other_area: Area2D):
	$RandomStreamPlayer2DComponent.play_random()
	GameEvents.emit_gold_collected(1)
	$AnimationPlayer.play("picked_up")
	await $AnimationPlayer.animation_finished
	queue_free()
