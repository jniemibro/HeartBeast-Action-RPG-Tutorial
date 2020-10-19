extends Node2D

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")
	# hooked up to 'animation finished through code
	animatedSprite.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	queue_free()
