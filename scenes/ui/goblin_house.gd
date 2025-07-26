extends StaticBody2D

signal player_ready



@export var torch_goblin: PackedScene
@export var tnt_goblin: PackedScene

@onready var spawn_point = $SpawnPoint
@onready var animation_player = $AnimationPlayer

var count = 15
var is_destroyed = false

var is_game_completed = false

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	player_ready.connect(on_player_ready)
	$HurtboxComponent/CollisionShape2D.disabled = true
	animation_player.play("default")
	
	

func _process(delta: float) -> void:
	if count == 0:
		$HurtboxComponent/CollisionShape2D.disabled = false
		$Timer.stop()
		if is_destroyed:
			$HurtboxComponent/CollisionShape2D.disabled = true
			if not is_game_completed:
				if get_tree().get_nodes_in_group("enemy").size() == 0:
					is_game_completed = true
					await get_tree().create_timer(3.0).timeout
					get_parent().get_node("EnemyManager").emit_all_enemy_defeated()
	

func spawn_goblin():
	if randf() > 0.5:
		var torch_goblin_instance = torch_goblin.instantiate() as Node2D
		get_parent().add_child(torch_goblin_instance)
		torch_goblin_instance.global_position = spawn_point.global_position
		
		torch_goblin_instance.get_node("SightArea2D").body_exited.disconnect(torch_goblin_instance.on_sight_area_body_exited)
		torch_goblin_instance.is_player_in_sight = true
		torch_goblin_instance.is_chasing = true
		torch_goblin_instance.skill_controller.cooldown_timer.wait_time = 0.8
		torch_goblin_instance.hitbox_component.damage = 10
		
	else:
		var tnt_goblin_instance = tnt_goblin.instantiate() as Node2D
		get_parent().add_child(tnt_goblin_instance)
		tnt_goblin_instance.global_position = spawn_point.global_position
		
		#tnt_goblin_instance.get_node("SightArea2D").body_exited.disconnect(tnt_goblin_instance.on_sight_area_body_exited)
		#tnt_goblin_instance.is_player_in_sight = true
		#tnt_goblin_instance.is_chasing = true
		
	count -= 1
	
	if count == 10:
		$Timer.wait_time = 6
		$Timer.start()
	elif count == 7:
		$Timer.wait_time = 5
		$Timer.start()
	elif count == 5:
		$Timer.wait_time = 4
		$Timer.start()
	elif count == 3:
		$Timer.wait_time = 2
		$Timer.start()
	
		

func on_timer_timeout():
	print("timeout")
	spawn_goblin()
	
		
func on_player_ready():
	on_timer_timeout()
	print("wpw")
	$Timer.start()
