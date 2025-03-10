extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var hit_animation_player = $HitAnimationPlayer

@onready var sprite: Sprite2D = $Sprite2D
@onready var skill_controller = $TorchGoblinSkillController
@onready var hitbox_component = $HitboxComponent

const PATROLLING_SPEED = 50
var patrolling_direction = 1

const MAX_SPEED = 90

var is_player_in_sight = false
var is_chasing = false
var is_attack_ready = true


var base_damage = 5

@onready var enemy_manager = get_node("/root/Main/EnemyManager")

var animation_locked = false


func _ready() -> void:
	$PatrollingTimer.timeout.connect(on_patroliing_timer_timeout)
	$SightArea2D.body_entered.connect(on_sight_area_body_entered)
	$SightArea2D.body_exited.connect(on_sight_area_body_exited)

	$AttackRangeArea2D.body_entered.connect(on_attack_range_body_entered)
	$AttackRangeArea2D.body_exited.connect(on_attack_range_body_exited)
	#health_component.died.connect(on_died)
	$HurtboxComponent.hit.connect(on_hit)
	
	hitbox_component.damage = base_damage
	

func _physics_process(delta: float) -> void:	
	if animation_locked == true:
		return
		
	if not is_player_in_sight:
		enemy_patrolling()
		move_and_slide()
		
		
	elif is_player_in_sight:
		$PatrollingTimer.stop()
		
		if is_chasing:
			skill_controller.disable_all_hitbox_shape()
			chase_player()
			
			
		else:
			if not skill_controller.is_skill_ready:
				animation_player.play("idle")
		
			
			
func enemy_patrolling():
	velocity.x = PATROLLING_SPEED * patrolling_direction
	animation_player.play("walk")
	

func chase_player():
	sprite.scale.x = 1
	var direction = get_direction_to_player()
		
		
	if direction.x < 0:
		sprite.flip_h = true
		hitbox_component.scale.x = -1
	elif direction.x > 0:
		sprite.flip_h = false
		hitbox_component.scale.x = 1
		
		
	velocity = direction * MAX_SPEED

	move_and_slide()
	
	animation_player.play("walk")
	

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
		
	return Vector2.ZERO


func reverse_patrolling_direction():
	patrolling_direction = - patrolling_direction
	sprite.scale.x *= -1
	
	

func on_patroliing_timer_timeout():
	reverse_patrolling_direction()
	

func on_sight_area_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		sprite.flip_h = false
		is_player_in_sight = true
		is_chasing = true
		
		
		
func on_sight_area_body_exited(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_player_in_sight = false
		
		
		velocity = Vector2.ZERO
		patrolling_direction = 1
		sprite.flip_h = false
		hitbox_component.scale.x = 1
		$PatrollingTimer.start()
		
		animation_player.play("walk")


func on_attack_range_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_chasing = false
		
		skill_controller.is_player_in_attack_area = true
			
	
		

func on_attack_range_body_exited(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_chasing = true
		print("keluar")
		skill_controller.is_player_in_attack_area = false
	

func on_animation_finished(anim_name: String):
	#if anim_name in ["attack_side", "attack_down", "attack_up"]:
		#is_attacking = false
	pass


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()

#func on_died():
	#if enemy_manager:
		#enemy_manager.enemy_died()
