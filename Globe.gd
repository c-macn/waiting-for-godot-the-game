extends Sprite
class_name Globe

signal moving
signal stopped


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('walk_left'):
		emit_signal('moving', false)
	
	if Input.is_action_just_pressed('walk_right'):
		emit_signal('moving', true)
	
	if Input.is_action_just_released('walk_left') or Input.is_action_just_released('walk_right'):
		emit_signal('stopped')
	
	if Input.is_action_pressed("walk_left") and not Input.is_action_pressed("walk_right"):
		var updated_degrees = rotation_degrees + 0.6
		rotation_degrees = updated_degrees
	
	if Input.is_action_pressed("walk_right") and not Input.is_action_pressed("walk_left"):
		var updated_degress = rotation_degrees - 0.6
		rotation_degrees = updated_degress
