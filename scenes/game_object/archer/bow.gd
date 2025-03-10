extends Area2D

const ARROW = preload("res://scenes/game_object/archer/arrow.tscn")

@export var bow_controller: Node
@onready var sprite = $WeaponPivot/Sprite2D

var is_bow_ready = true



func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0] as Node2D
		#print(target_enemy)
		look_at(target_enemy.global_position)
		
			
		update_sprite_flip(rotation)
			
		if not bow_controller.is_attacking:
			bow_controller.attack()
			
			
	else:
		bow_controller.stop_attacking()
		
		
func update_sprite_flip(angle: float) -> void:
	# Ubah sudut radian ke derajat
	var angle_deg = rad_to_deg(angle)
	
	# Jika sudut melebihi 90 derajat ke kiri atau -90 ke kanan, flip sprite
	#sprite.flip_h = (angle_deg > 90 or angle_deg < -90)
	
	# flip sprite archer juga
	owner.get_node("ArcherSprite2D").flip_h = (angle_deg > 90 or angle_deg < -90)
		
