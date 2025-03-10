extends CanvasLayer

var is_defeated = false

func _ready() -> void:
	get_tree().paused = true
	
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)
	
	$AnimationPlayer.play("transition_in")
	
	
func set_defeat():
	is_defeated = true
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You lost!"
	
	play_jingle(true)
	

func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()


func on_restart_button_pressed():
		
	get_tree().paused = false
	if not is_defeated:
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
		
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	var checkpoint_manager = get_parent().get_node("CheckpointManager")
	
	if checkpoint_manager == null:
		print("null")
		return
		
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		# Reset state player
		player.reset_player_state()
		
		# Aktifkan collision
		player.get_node("CollisionShape2D").disabled = false
		
		
		# Reset posisi dan health
		player.position = checkpoint_manager.last_location
		player.health_component.current_health = player.health_component.max_health
		player.update_health_display() 
		
		
		
		# Aktifkan proses
		player.set_process(true)
		player.set_physics_process(true)
		
		player.animation_player.stop()
		player.animation_player.play("idle")
		
		print("count sebelum: " + str(get_parent().get_node("GoblinHouse").count))
		
		print("count setelah respawn: " + str(get_parent().get_node("GoblinHouse").count))
		
	
	# queue free end screen
	queue_free()
	

func on_quit_button_pressed():
	get_tree().quit()
	
