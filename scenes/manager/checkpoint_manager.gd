extends Node

var last_location
var player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	last_location = player.global_position
