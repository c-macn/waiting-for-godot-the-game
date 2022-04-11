extends Node2D

enum TRANSITION_TYPE {
	NIGHTTODAY = 0
	DAYTONIGHT = 1
}

var current_transition_type = TRANSITION_TYPE.NIGHTTODAY

onready var globe: Sprite = $Globe
onready var player: AnimatedSprite = $Player/Sprite
onready var player_audio: AudioStreamPlayer = $Player/AudioStreamPlayer
onready var title_timer: Timer = $Sprite/Timer
onready var day_sky: Sprite = $Sky
onready var sun: AnimatedSprite = $Sky/Sun
onready var night_sky: Sprite = $NightSky

func _ready() -> void:
	player.play()
	globe.connect('moving', self, '_on_moving')
	globe.connect('stopped', self, '_on_stopped')
	title_timer.connect('timeout', self, '_on_timeout')


func _on_moving(should_flip: bool) -> void:
	player.set_speed_scale(1)
	player.set_flip_h(should_flip)
	player.play('walk')
	player_audio.play()
	_transition_cycle(current_transition_type)


func _on_stopped() -> void:
	player.set_speed_scale(0.4)
	player.play('default')
	player_audio.stop()
	$Tween.stop_all()


func _on_timeout() -> void:
	$Tween.interpolate_property($Sprite, 'position', Vector2.ZERO, Vector2(0, -800), 8.0)
	$Tween.start()


func _transition_cycle(transition_type: int) -> void:
	if transition_type == TRANSITION_TYPE.NIGHTTODAY:
		$Tween.interpolate_property(night_sky, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0),
			30.0, Tween.TRANS_QUAD, Tween.EASE_IN)
			
		$Tween.interpolate_callback(self, 30.0, '_update_transition', TRANSITION_TYPE.DAYTONIGHT)
		$Tween.start()
	
	if transition_type == TRANSITION_TYPE.DAYTONIGHT:
		$Tween.interpolate_property(night_sky, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1),
			30.0, Tween.TRANS_QUAD, Tween.EASE_IN)
			
		$Tween.interpolate_callback(self, 30.0, '_update_transition', TRANSITION_TYPE.NIGHTTODAY)
		$Tween.start()


func _update_transition(transition_type: int) -> void:
	current_transition_type = transition_type
	_transition_cycle(current_transition_type)
