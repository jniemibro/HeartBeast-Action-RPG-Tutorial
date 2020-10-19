extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffectScene = load("res://Scenes/GrassEffect.tscn")
		var grassEffectInstance = GrassEffectScene.instance()
		#var world = get_tree().current_scene
		#world.add_child(grassEffect)
		get_parent().add_child(grassEffectInstance)
		grassEffectInstance.global_position = global_position
		queue_free()
