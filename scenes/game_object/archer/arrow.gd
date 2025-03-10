extends Node2D

class_name Arrow

var SPEED = 600

@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox_component.area_entered.connect(on_arrow_hitbox_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(on_visible_on_screen_notifier_2d_screen_exited)
	
	hitbox_component.damage = 5
	$AnimationPlayer.play("default")
	
func _physics_process(delta: float) -> void:
	# ngambil rotation bullet
	
	var direction = Vector2.RIGHT.rotated(rotation) 
	
	position += direction * SPEED * delta


func on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	

func on_arrow_hitbox_area_entered(other_area: Area2D):
	if other_area is HurtboxComponent:
		var hurtbox_component = other_area as HurtboxComponent
		
		hurtbox_component.health_component.damage(hitbox_component.damage)
		print(hurtbox_component.health_component.current_health)
		
		
		queue_free()
