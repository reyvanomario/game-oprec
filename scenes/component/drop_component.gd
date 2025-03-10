extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node
@export var gold_scene: PackedScene



func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)
	
	

func on_died():
	# random drop sesuai drop percent
	if randf() > drop_percent:
		return
	
	
	if gold_scene == null:
		return
		
	if not owner is Node2D:
		return
	
	
	spawn_gold()
	
	

func spawn_gold():
	var spawn_position = (owner as Node2D).global_position
	
	var gold_instance = gold_scene.instantiate() as Node2D
	gold_instance.get_node("AnimationPlayer").stop()

	owner.get_parent().add_child(gold_instance)
	
	gold_instance.get_node("AnimationPlayer").play("spawn")
	gold_instance.global_position = spawn_position
	

	
