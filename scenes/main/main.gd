extends Node2D
signal archer_purchased

@export var end_screen_scene: PackedScene
@onready var timer = $Timer

@onready var checkpoint_manager = $CheckpointManager

@onready var textbox_2_show_area = $TextboxesArea2D/Textbox2ShowArea2D
@onready var textbox_3_show_area = $TextboxesArea2D/Textbox3ShowArea2D
@onready var textbox_4_show_area = $TextboxesArea2D/Textbox4ShowArea2D
@onready var textbox_4_close_area = $TextboxesArea2D/Textbox4CloseArea2D
@onready var textbox_5_show_area = $TextboxesArea2D/Textbox5ShowArea2D
@onready var textbox_6_show_area = $TextboxesArea2D/Textbox6ShowArea2D

var current_textbox = null

var textbox = preload("res://scenes/ui/text_box.tscn")
var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")


func _ready() -> void:
	textbox_2_show_area.body_entered.connect(on_textbox_2_showed)
	textbox_3_show_area.body_entered.connect(on_textbox_3_showed)
	textbox_4_show_area.body_entered.connect(on_textbox_4_showed)
	textbox_4_close_area.body_entered.connect(on_textbox_4_closed)
	textbox_5_show_area.body_entered.connect(on_textbox_5_showed)
	textbox_6_show_area.body_entered.connect(on_textbox_6_showed)
	archer_purchased.connect(on_archer_purchased)
	
	$FinalStageArea2D.body_entered.connect(on_final_stage_entered)
	
	timer.timeout.connect(on_timer_timeout)
	
	current_textbox = textbox.instantiate()
	add_child(current_textbox)
	current_textbox.start_textbox("You can attack by left-clicking in any direction. Try attack these sheeps.")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
		

func remove_last_textbox():
	if current_textbox != null:
		current_textbox.queue_free()
		current_textbox = null
	

func emit_archer_purchased():
	archer_purchased.emit()
	

func on_player_died():	
	timer.start()

	

func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
		

func on_textbox_2_showed(other_body: Node2D):
	if other_body.is_in_group("player"):
		if current_textbox != null:
			remove_last_textbox()
		
		current_textbox = textbox.instantiate()
		
		add_child(current_textbox)
		current_textbox.start_textbox("Collect golds to buy upgrades.")
		
		textbox_2_show_area.queue_free()
	
	
func on_textbox_3_showed(other_body: Node2D):
	if other_body.is_in_group("player"):
		if current_textbox != null:
			remove_last_textbox()
		
		current_textbox = textbox.instantiate()
		add_child(current_textbox)
		current_textbox.start_textbox("The target is to kill all enemies and destroy the Goblin House. Good Luck.")
		
		textbox_3_show_area.queue_free()
		

func on_textbox_4_showed(other_body: Node2D):
	if other_body.is_in_group("player"):
		if current_textbox != null:
			remove_last_textbox()
		
		current_textbox = textbox.instantiate()
		add_child(current_textbox)
		current_textbox.start_textbox("Click this button to add checkpoint.")
		
		textbox_4_show_area.queue_free()
		

func on_textbox_4_closed(other_body: Node2D):
	if other_body.is_in_group("player"):
		remove_last_textbox()	
		textbox_4_close_area.queue_free()
		

func on_textbox_5_showed(other_body: Node2D):
	if other_body.is_in_group("player"):
		if current_textbox != null:
			remove_last_textbox()
			
		current_textbox = textbox.instantiate()
		add_child(current_textbox)
		current_textbox.start_textbox("You can get near to this building to open shop.")
		
		textbox_5_show_area.queue_free()
		
		await get_tree().create_timer(2.7).timeout
		
		remove_last_textbox()
		

func on_textbox_6_showed(other_body: Node2D):
	if other_body.is_in_group("player"):
		if current_textbox != null:
			remove_last_textbox()
			
		current_textbox = textbox.instantiate()
		add_child(current_textbox)
		current_textbox.start_textbox("This goblin can throw exploding dynamite.")
		
		textbox_6_show_area.queue_free()
		
		await get_tree().create_timer(6.0).timeout
		
		remove_last_textbox()
		

func on_final_stage_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		current_textbox = textbox.instantiate()
		add_child(current_textbox)
		current_textbox.start_textbox("Final stage. Defeat all enemies and destroy the Goblin House.")
		
		$FinalStageArea2D.queue_free()
		
		await get_tree().create_timer(6.0).timeout
		
		remove_last_textbox()
		

func on_archer_purchased():
	var shop_screen = get_node("ShopScreen")
	shop_screen.archer_troops_button.pressed.disconnect(shop_screen.on_archer_troops_button_pressed)
	shop_screen.archer_troops_button.text = "Purchased"
	
	print("kena")
	if current_textbox != null:
		remove_last_textbox()
		
	current_textbox = textbox.instantiate()
	add_child(current_textbox)
	current_textbox.start_textbox("Remember, you must guide your archer to move.")
	
	await get_tree().create_timer(5.0).timeout
	
	remove_last_textbox()
