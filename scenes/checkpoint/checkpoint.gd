extends Area2D

@export var floating_label_scene: PackedScene

var checkpoint_manager

var already_pressed = false

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
	checkpoint_manager = get_parent().get_node("CheckpointManager")
	$AnimationPlayer.play("default")
	

func on_body_entered(other_body: Node2D):
	if other_body.is_in_group("player") and already_pressed == false:
		$RandomStreamPlayer2DComponent.play_random()
		
		checkpoint_manager.last_location = $RespawnPoint.global_position
		print("press")
		$AnimationPlayer.play("pressed")
		
		var floating_label_instance = floating_label_scene.instantiate() as Node2D
		get_tree().root.add_child(floating_label_instance)
		floating_label_instance.global_position = other_body.global_position
		floating_label_instance.get_node("Label").text = "Checkpoint"
		
		already_pressed = true
