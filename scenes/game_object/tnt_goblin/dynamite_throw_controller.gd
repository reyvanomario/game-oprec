extends Node

signal dynamite_throwed

@export var dynamite_throw_ability: PackedScene

@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = owner.get_node("AnimationPlayer")
@onready var dynamite_throw_delay_timer = owner.get_node("DynamiteThrowDelayTimer")

var is_attacking = false

var is_skill_ready = true
var is_player_in_attack_area = false
var already_attack = false


func _ready() -> void:
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	animation_player.animation_finished.connect(on_animation_finished)
	
	dynamite_throw_delay_timer.timeout.connect(on_throw_delay_timer_timeout)
	
	$AnimationUnlockTimer.timeout.connect(on_animation_unlock_timer_timeout)

func _process(delta: float) -> void:
	if is_player_in_attack_area:
		if is_skill_ready:
			if not already_attack:
				attack()
	

func attack():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	owner.animation_locked = true
	
	animation_player.play("throw_dynamite")
	
	$AnimationUnlockTimer.start()
	already_attack = true
	
	
	dynamite_throw_delay_timer.start()
	is_skill_ready = false
	
	
func spawn_dynamite():
	var dynamite_instance = dynamite_throw_ability.instantiate() as Node2D
	get_tree().root.add_child(dynamite_instance)
	dynamite_instance.global_position = owner.global_position

	
	
	cooldown_timer.start()
	is_skill_ready = false
	
	

func on_cooldown_timer_timeout():
	already_attack = false
	is_skill_ready = true
	

func on_throw_delay_timer_timeout():
	spawn_dynamite()
	
	
func on_animation_finished(anim_name: String):
	if anim_name == "throw_dynamite":
		# Setelah animasi selesai, reset is_attacking
		is_attacking = false
	
	

func on_animation_unlock_timer_timeout():
	owner.animation_locked = false
