extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var hit_animation_player = $HitAnimationPlayer


@onready var sprite: Sprite2D = $Sprite2D


@onready var dynamite_throw_controller = $DynamiteThrowController


const PATROLLING_SPEED = 50
var patrolling_direction = 1

const MAX_SPEED = 90

var is_player_in_sight = false
var is_chasing = false
var animation_locked = false

@onready var enemy_manager = get_node("/root/Main/EnemyManager")

func _ready() -> void:
	$PatrollingTimer.timeout.connect(on_patroliing_timer_timeout)
	$SightArea2D.body_entered.connect(on_sight_area_body_entered)
	$SightArea2D.body_exited.connect(on_sight_area_body_exited)

	$AttackRangeArea2D.body_entered.connect(on_attack_range_body_entered)
	$AttackRangeArea2D.body_exited.connect(on_attack_range_body_exited)
	
	$HurtboxComponent.hit.connect(on_hit)
	#health_component.died.connect(on_died)

	
func _physics_process(delta: float) -> void:
	if animation_locked == true:
		return
		
	if not is_player_in_sight:
		enemy_patrolling()
		move_and_slide()
		
		
	elif is_player_in_sight:
		$PatrollingTimer.stop()
		
		if is_chasing:
			chase_player()
			
			
		else:
			if not dynamite_throw_controller.is_skill_ready:
				animation_player.play("idle")
		
	
		

func enemy_patrolling():
	velocity.x = PATROLLING_SPEED * patrolling_direction
	animation_player.play("walk")
	

func chase_player():
	sprite.scale.x = 1
	var direction = get_direction_to_player()
		
		
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		
		
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	animation_player.play("walk")
		

func reverse_patrolling_direction():
	patrolling_direction = - patrolling_direction
	sprite.scale.x *= -1
	

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
		
	return Vector2.ZERO
	

func on_patroliing_timer_timeout():
	reverse_patrolling_direction()
	

func on_sight_area_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		sprite.scale.x = 1
		is_player_in_sight = true
		is_chasing = true
		
		
func on_sight_area_body_exited(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_player_in_sight = false
		
		
		velocity = Vector2.ZERO
		patrolling_direction = 1
		sprite.flip_h = false
		$PatrollingTimer.start()
		
		animation_player.play("walk")
		

func on_attack_range_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_chasing = false
		#animation_player.stop()
		
		dynamite_throw_controller.is_player_in_attack_area = true
		
		

func on_attack_range_body_exited(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_chasing = true
		dynamite_throw_controller.is_player_in_attack_area = false
		
		

func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
