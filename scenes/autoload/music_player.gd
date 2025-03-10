extends AudioStreamPlayer
signal final_stage_ready

var final_stage_music = preload("res://assets/audio/Battle Ready.ogg")


func _ready() -> void:
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)
	final_stage_ready.connect(on_final_stage_ready)
	

func emit_final_stage_ready():
	final_stage_ready.emit()
	

func on_finished():
	$Timer.start()
	

func on_timer_timeout():
	play()
	

func on_final_stage_ready():
	stream = final_stage_music
	play()
