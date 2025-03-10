extends Node


@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = owner.get_node("AnimationPlayer")

var is_attacking = false
var is_skill_ready = true

var is_player_in_attack_area = false
var already_attack = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	animation_player.animation_finished.connect(on_animation_finished)
	

func _process(delta: float) -> void:
	if is_player_in_attack_area:
		if is_skill_ready:
			if not already_attack:
				#print("attack")
				attack()
	
		
		
			

func attack():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var direction = owner.get_direction_to_player()
	
	var direction_angle = direction.angle()
	
	is_attacking = true
	
	owner.animation_locked = true
	
	
	# attack samping
	if direction_angle >= - PI/4 and direction_angle < PI/4:
		animation_player.play("attack_side")	
	# attack bawah
	elif direction_angle >= PI/4 and direction_angle < 3 * PI/4:
		animation_player.play("attack_down") 
	# attack atas
	elif direction_angle >= -3 * PI/4 and direction_angle < - PI/4:
		animation_player.play("attack_up")   
	# attack samping (player di kiri)
	else:
		animation_player.play("attack_side") 
	
	already_attack = true
	
	await animation_player.animation_finished
	owner.animation_locked = false
	
	#disable_all_hitbox_shape()
	cooldown_timer.start()
	is_skill_ready = false
	
	
func disable_all_hitbox_shape():
	for collision_shape in owner.hitbox_component.get_children():
		collision_shape.disabled = true

	

func on_cooldown_timer_timeout():
	already_attack = false
	is_skill_ready = true

	
func on_animation_finished(anim_name: String):
	if anim_name in ["attack_side", "attack_up", "attack_down"]:
		# Setelah animasi selesai, reset is_attacking
		is_attacking = false
		animation_player.play("idle")

	
