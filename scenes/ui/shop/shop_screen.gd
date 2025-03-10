extends CanvasLayer

signal upgrade_selected(upgrade_index: int)

@onready var archer_troops_button = $%ArcherTroopsButton


func _ready() -> void:
	$%CloseShopButton.pressed.connect(on_close_shop_button_pressed)
	
	$%SwordCooldownButton.pressed.connect(on_sword_cooldown_button_pressed)
	$%SwordDamageButton.pressed.connect(on_sword_damage_button_pressed)
	$%MovementSpeedButton.pressed.connect(on_movement_speed_button_presses)
	$%ArcherTroopsButton.pressed.connect(on_archer_troops_button_pressed)
	
	

func play_transition_in():
	get_tree().paused = true
	$AnimationPlayer.play("transition_in")
	$RandomStreamPlayerComponent.play_random()
	

func on_close_shop_button_pressed():
	get_tree().paused = false
	$AnimationPlayer.play("transition_out")
	await $AnimationPlayer.animation_finished
	

func on_sword_cooldown_button_pressed():
	upgrade_selected.emit(0)
	

func on_sword_damage_button_pressed():
	upgrade_selected.emit(1)
	
	
func on_movement_speed_button_presses():
	upgrade_selected.emit(2)
	

func on_archer_troops_button_pressed():
	upgrade_selected.emit(3)
	
