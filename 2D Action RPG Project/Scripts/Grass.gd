extends Node2D

func create_grass_effect():
	var GrassEffectScene = load("res://Scenes/GrassEffect.tscn")
	var grassEffectInstance = GrassEffectScene.instance()
	#var world = get_tree().current_scene
	#world.add_child(grassEffect)
	get_parent().add_child(grassEffectInstance)
	grassEffectInstance.global_position = global_position


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
