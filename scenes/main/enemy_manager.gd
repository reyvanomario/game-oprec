extends Node

signal all_enemy_defeated

@export var end_screen_scene: PackedScene

@onready var enemy_count = 0


func _ready() -> void:
	all_enemy_defeated.connect(on_all_enemy_defeated)
	

func show_victory_screen():
	if end_screen_scene:
		var end_screen = end_screen_scene.instantiate()
		add_child(end_screen)
		end_screen.play_jingle()
		

func emit_all_enemy_defeated():
	all_enemy_defeated.emit()
	
	
func on_all_enemy_defeated():	
	show_victory_screen()
		
		
