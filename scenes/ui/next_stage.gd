extends StaticBody2D


func _ready() -> void:
	$Area2D.body_entered.connect(on_body_entered)
	

func on_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		
		var final_stage_path = "res://scenes/main/final_stage.tscn"
		
		get_tree().change_scene_to_file(final_stage_path)
