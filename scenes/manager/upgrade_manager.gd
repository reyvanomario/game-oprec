extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var shop_node: Node
@export var player_collectible_manager: Node
@export var floating_label_scene: PackedScene

var current_upgrades = {}



func apply_upgrade(upgrade: AbilityUpgrade):
	if player_collectible_manager.current_gold_number < upgrade.cost:
		print("Gold not enough")
		
		var floating_label_instance = floating_label_scene.instantiate() as Node2D
		shop_node.add_child(floating_label_instance)  
		floating_label_instance.global_position = Vector2(560, 100) 
		
		# set warna text ke merah klo gold ga cukup
		floating_label_instance.get_node("Label").add_theme_color_override("font_color", Color(1, 0, 0))
		floating_label_instance.get_node("Label").text = "Gold not enough"


		return
	
	buy_upgrade(upgrade)
	
		
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
		
		print("Berhasil upgrade")
		print(upgrade.id)
	
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
		
	var floating_label_instance = floating_label_scene.instantiate() as Node2D
	shop_node.add_child(floating_label_instance)  
	floating_label_instance.global_position = Vector2(500, 100)  
	
	print(current_upgrades[upgrade.id])
	# set warna text ke hijau kalau gold cukup
	floating_label_instance.get_node("Label").add_theme_color_override("font_color", Color(0, 1, 0))
	floating_label_instance.get_node("Label").text = "Upgrade successfull. "\
	 + str(current_upgrades[upgrade.id]["resource"].description)
		
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	

func buy_upgrade(upgrade: AbilityUpgrade):
	GameEvents.emit_gold_spent(upgrade.cost)
	

func spawn_shop_screen():
	if shop_node:
		shop_node.upgrade_selected.connect(on_upgrade_selected) 
		shop_node.play_transition_in()
		
	
func on_upgrade_selected(upgrade_index: int):
	var chosen_upgrade = upgrade_pool[upgrade_index]
	
	if chosen_upgrade == null:
		return
	
		
	apply_upgrade(chosen_upgrade)
