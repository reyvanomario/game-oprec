extends Node2D

@onready var animated_sprite = $Node2D/AnimatedSprite2D
@onready var animation_player = $Node2D/AnimationPlayer

var dynamite_damage = 15
@onready var hitbox: HitboxComponent = $HitboxComponent

const SPEED = 0.7

var target_position
var is_thrown = false


func _ready() -> void:
	$ExplosionTimer.timeout.connect(on_timer_timeout)
	animated_sprite.animation_finished.connect(on_animation_finished)
	
	hitbox.damage = dynamite_damage
	
	
	$Node2D/AnimationPlayer.play("rotate_throwed")



func _process(delta: float) -> void:
	if not is_thrown:
		target_position = get_target_position()
		is_thrown = true 
	
	global_position = global_position.lerp(target_position, SPEED * delta)
	
	
	
func get_target_position():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return player_node.global_position
	return global_position
	

	

func on_timer_timeout():
	$RandomStreamPlayer2DComponent.play_random()
	animated_sprite.play("explode")
	animation_player.play("hitbox_on")
	

func on_animation_finished():
	if animated_sprite.animation == "explode":
		queue_free()
