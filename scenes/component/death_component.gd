extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D


func _ready() -> void:
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)
	
	if sprite:
		var texture = sprite.texture
		
		# size texturenya 1344, 576
		# 1344 : 7 (banyak hframe) x 576 : 3 (banyak vframe)
		var frame_size = Vector2(192, 192)

		var region_rect = Rect2(Vector2.ZERO, frame_size)

		# Buat AtlasTexture untuk memotong frame tertentu
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = texture
		atlas_texture.region = region_rect
		
		$GPUParticles2D.texture = atlas_texture


func on_died():
	if owner == null || not owner is Node2D || not owner.is_in_group("enemy"):
		return
		
	var spawn_position = owner.global_position
	
	var entities = get_tree().get_first_node_in_group("entities_layer")
	
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	
	$AnimationPlayer.play("default")
	$HitRandomAudioPlayerComponent.play_random()
	
