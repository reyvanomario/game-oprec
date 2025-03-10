extends Node

var current_gold_number = 0


@onready var gold_counter_label = %GoldCounterLabel



func _ready() -> void:
	GameEvents.gold_collected.connect(on_gold_collected)
	
	
	GameEvents.gold_spent.connect(on_gold_spent)
	

func increment_gold_number(number: float):
	current_gold_number += number
	gold_counter_label.text = ": " + str(current_gold_number)
	print(current_gold_number)
	

func decrement_gold_number(number: float):
	current_gold_number -= number
	gold_counter_label.text = ": " + str(current_gold_number)
	print(current_gold_number)
	
	
func on_gold_collected(number: float):
	increment_gold_number(number)
	

func on_gold_spent(number: float):
	decrement_gold_number(number)
