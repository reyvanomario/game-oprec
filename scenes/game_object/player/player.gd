extends CharacterBody2D

var max_speed = 250

const ACCELERATION_SMOOTHING = 25
var direction: Vector2 = Vector2.ZERO

var textbox = preload("res://scenes/ui/text_box.tscn")

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var hit_animation_player = $HitAnimationPlayer

@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar


var is_attacking = false
var is_sword_ready = true

var base_sword_damage = 20
var base_sword_cooldown

var animation_locked: bool = false


@onready var sword_hitbox: HitboxComponent = $HitboxComponent
@onready var sword_cooldown_timer = $SwordCooldownTimer

@export var knockback_speed: float = 3000.0

var is_dead = false
var death_animation_played: bool = false

func _ready() -> void:
	$CollisionArea2D.area_entered.connect(on_collision_area_entered)
	
	animation_player.animation_finished.connect(on_animation_finished)
	health_component.health_changed.connect(on_health_changed)
	sword_cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	#health_component.max_health = max_health
	update_health_display()
	
	sword_hitbox.damage = base_sword_damage
	base_sword_cooldown = sword_cooldown_timer.wait_time
	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead:
		print("is dead")
		return
		
	var movement_vector = _get_movement_vector()
	direction = movement_vector.normalized()
	var is_moving = false
	
	if direction.x == 0 and direction.y == 0:
		is_moving = false
	else:
		is_moving = true
		
		
	if direction.x > 0:
		sprite.flip_h = false
		sword_hitbox.scale.x = 1
	elif direction.x < 0:
		sprite.flip_h = true
		sword_hitbox.scale.x = -1
	
	
	if Input.is_action_just_pressed("sword_attack_1") and is_sword_ready and not is_attacking:
		is_attacking = true
		
		is_sword_ready = false
		
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		play_sword_attack_animation(mouse_direction, is_moving)
		
		sword_cooldown_timer.start()
	
	if not is_attacking:  
		if direction.x == 0 and direction.y == 0:
			animation_player.play("idle")
		else:
			animation_player.play("walk")
		
	
	
	var target_velocity = direction * max_speed
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()



func handle_death():
	if not is_dead:  # Pastikan hanya dieksekusi sekali
		is_dead = true
		is_attacking = false
		
		# disable semua input dan physics porcess
		set_process(false)
		set_physics_process(false)
		
		# node main
		get_parent().get_parent().on_player_died()
		
		animation_player.play("die")
		await animation_player.animation_finished
		animation_player.stop()
	
		
func reset_player_state():
	is_dead = false
	is_attacking = false
	death_animation_played = false
	animation_player.stop()
	animation_player.play("idle")
	velocity = Vector2.ZERO	
	
	for child in $HitboxComponent.get_children():
		child.disabled = true
		
		
		
func _get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# down itu positif, up negatif
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
	

func update_health_display():
	health_bar.value = health_component.get_health_percent()


func knockback(other_area: Area2D):
	var direction_to_damage = (other_area.global_position - global_position)
	var direction_sign = sign(direction_to_damage.x)
	
	if direction_sign > 0:
		velocity = knockback_speed * Vector2.LEFT
	elif direction_sign < 0:
		velocity = knockback_speed * Vector2.RIGHT
			

func on_animation_finished(anim_name: String):
	if anim_name in ["slash_side_1", "slash_side_2", "slash_up_1", "slash_up_2", "slash_down_1", "slash_down_2"]:
		is_attacking = false
	
		
func on_collision_area_entered(other_area: Area2D):
	if other_area is HitboxComponent:
		# disable collision shape hitbox klo udh kena damage, supaya ga double damage
		#d
			
		hit_animation_player.play("hit_flash")
		health_component.damage((other_area as HitboxComponent).damage)
		
		
			
		knockback(other_area)
		
			
		#print(health_component.current_health)
			
		
func on_health_changed():
	$HitRandomStreamPlayer.play_random()
	GameEvents.emit_player_damage()
	update_health_display()
	
	if health_component.current_health <= 0 and !is_dead:
		print("handle current health: " + str(health_component.current_health))
		handle_death()
		return
	

func on_cooldown_timer_timeout():
	is_sword_ready = true
	

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades):
	if upgrade.id == "sword_cooldown":
		var percent_reduction = current_upgrades["sword_cooldown"]["quantity"] * 0.1
		sword_cooldown_timer.wait_time = base_sword_cooldown * (1 - percent_reduction)
		
		sword_cooldown_timer.start()
		
		print(sword_cooldown_timer.wait_time)
		
	
	elif upgrade.id == "sword_damage":
		var damage_added = current_upgrades["sword_damage"]["quantity"] * 3
		sword_hitbox.damage = base_sword_damage + damage_added
		
		print("current sword damage: " + str(sword_hitbox.damage))
	
	
	elif upgrade.id == "player_movement_speed":
		var percent_movement_speed_addition = current_upgrades["player_movement_speed"]["quantity"] * 0.05
		max_speed = max_speed * (1 + percent_movement_speed_addition)
		
		print(max_speed)
		
	
	elif upgrade.id == "archer_troops":
		var archer_scene = preload("res://scenes/game_object/archer/archer.tscn")
		
		if archer_scene == null:
			return
			
		
		var archer_instance = archer_scene.instantiate() as Node2D
		
		get_parent().add_child(archer_instance)
		archer_instance.global_position = global_position
		
		get_parent().get_parent().emit_archer_purchased()
		

func play_sword_attack_animation(mouse_direction: Vector2, is_moving: bool):
	$SwordStreamPlayer.play_random()
	
	var angle = mouse_direction.angle()

	# attack samping
	if angle >= - PI/4 and angle < PI/4:
		if not is_moving:
			animation_player.play("slash_side_1")
		else:
			animation_player.play("slash_side_2")
	# attack bawah
	elif angle >= PI/4 and angle < 3 * PI/4:
		if not is_moving:
			animation_player.play("slash_down_1") 
		else:
			animation_player.play("slash_down_2")  
	# attack atas
	elif angle >= -3 * PI/4 and angle < - PI/4:
		if not is_moving:
			animation_player.play("slash_up_1") 
		else:
			animation_player.play("slash_up_2")  
	# attack samping
	else:
		if not is_moving:
			animation_player.play("slash_side_1") 
		else:
			animation_player.play("slash_side_2") 
		
		
