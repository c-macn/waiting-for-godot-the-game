extends Node2D

onready var globe: Sprite = $Globe
onready var player: AnimatedSprite = $Player

func _ready() -> void:
	player.play()
	globe.connect('moving', self, '_on_moving')
	globe.connect('stopped', self, '_on_stopped')


func _on_moving(should_flip: bool) -> void:
	player.set_speed_scale(1)
	player.set_flip_h(should_flip)
	player.play('walk')


func _on_stopped() -> void:
	player.set_speed_scale(0.4)
	player.play('default')
