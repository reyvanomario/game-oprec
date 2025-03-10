extends Node

const ARROW = preload("res://scenes/game_object/archer/arrow.tscn")


@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = owner.get_node("AnimationPlayer")
@onready var shoot_delay_timer = owner.get_node("ShootDelayTimer")


var is_attacking = false

var is_bow_ready = true


func _ready() -> void:
	cooldown_timer.timeout.connect(on_timer_timeout)
	animation_player.animation_finished.connect(on_animation_finished)
	
	shoot_delay_timer.timeout.connect(on_shoot_delay_timer_timeout)
	


func attack():
	if is_attacking or not is_bow_ready:
		#print(is_attacking)
		return 
		
	
	is_attacking = true
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	animation_player.play("shoot")
	
	shoot_delay_timer.start()
	
	
func spawn_arrow():
	var arrow_instance = ARROW.instantiate()
	
	arrow_instance.global_position = $%ShootingPoint.global_position
	arrow_instance.global_rotation = $%ShootingPoint.global_rotation
	
	
	get_tree().root.add_child(arrow_instance)
	
	is_bow_ready = false
	$CooldownTimer.start()
	



func stop_attacking():
	is_attacking = false
	#is_skill_ready = true
	#cooldown_timer.stop()  # Hentikan cooldown
	animation_player.stop()  # Hentikan animasi
	shoot_delay_timer.stop()
	owner.rotation = 0
	animation_player.play("idle")
	
	

func on_timer_timeout():
	#print("ready")
	is_bow_ready = true
	
	attack()
	

func on_shoot_delay_timer_timeout():
	spawn_arrow()
	
	
func on_animation_finished(anim_name: String):
	if anim_name == "shoot":
		# Setelah animasi selesai, reset is_attacking
		is_attacking = false
