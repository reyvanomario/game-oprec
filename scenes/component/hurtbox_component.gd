extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: Node
@export var floating_label_scene: PackedScene


func _ready() -> void:
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	var hitbox_component = other_area as HitboxComponent
	
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	if owner is CharacterBody2D:
		owner.hit_animation_player.play("hit_flash")
	
	
	
	var floating_label_instance = floating_label_scene.instantiate() as Node2D
	get_tree().root.add_child(floating_label_instance)
	floating_label_instance.global_position = owner.global_position
	floating_label_instance.get_node("Label").text = str(hitbox_component.damage)
	
	
	# supaya damagenya ga double, return klo arrow, damage dihandle di script arrow
	# (masih perbaikan kasar)
	if hitbox_component.get_parent().is_in_group("arrow"):
		return
	
	health_component.damage(hitbox_component.damage)
	
	# signal hit buat sfx
	if owner.is_in_group("enemy"):
		hit.emit()
	
	
	
