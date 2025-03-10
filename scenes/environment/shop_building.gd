extends Area2D

@export var shop_screen_scene: PackedScene

@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	body_entered.connect(on_body_entered)
	
	

func show_shop_screen():
	if shop_screen_scene:
		var upgrade_manager = get_parent().get_parent().get_node("UpgradeManager")
		
		if upgrade_manager == null:
			return
			
		upgrade_manager.spawn_shop_screen()
		
		
func on_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		var main = get_parent().get_parent()
		
		show_shop_screen()
		
		
		
