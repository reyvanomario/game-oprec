extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite: Sprite2D = $ArcherSprite2D
@onready var bow = $Bow

var is_player_in_sight = false
var is_chasing = false

const MAX_SPEED = 200

var animation_locked = false
var is_enemy_in_attack_area = false

func _ready() -> void:
	$SightArea2D.body_entered.connect(on_sight_area_body_entered)
	$SightArea2D.body_exited.connect(on_sight_area_body_exited)
	
	
	$AnimationPlayer.play("idle")
	
	print("archer ready")
	

func _physics_process(delta: float) -> void:	
	if is_chasing || is_player_in_sight == false:
		chase_player()
		
	else:
		animation_player.play("idle")
			
	

func chase_player():
	var direction = get_direction_to_player()
		
		
	if direction.x < 0:
		sprite.flip_h = true
		bow.sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		bow.sprite.flip_h = false
		
		
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	animation_player.play("walk")
		
	

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
		
	return Vector2.ZERO



func on_sight_area_body_entered(other_body: Node2D):
	if other_body.is_in_group("player"):
		is_player_in_sight = true
		is_chasing = false
		velocity = Vector2.ZERO
		#sprite.flip_h = false
		
		animation_player.play("idle")
	
		
		
func on_sight_area_body_exited(other_body: Node2D):
	if other_body.is_in_group("player"):
		sprite.scale.x = 1
		is_player_in_sight = false
		is_chasing = true
