extends Area2D

@export var blocking_collision: CollisionShape2D
@export var goblin_house: StaticBody2D

var triggered = false

func _ready():
	if blocking_collision:
		blocking_collision.disabled = true
	
	# Hubungkan sinyal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if triggered or !body.is_in_group("player"):
		return
	
	triggered = true
	
	
	if blocking_collision:
		blocking_collision.disabled = false
	
	# 2. Matikan monitoring area
	monitoring = false
	
   
	goblin_house.player_ready.emit()
	
	# 4. Putuskan sinyal untuk efisiensi
	body_entered.disconnect(_on_body_entered)
	
	
	MusicPlayer.emit_final_stage_ready()
	
