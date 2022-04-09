extends Sprite
class_name Globe


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("walk_left") and not Input.is_action_pressed("walk_right"):
		var updated_degrees = rotation_degrees + 0.6
		rotation_degrees = updated_degrees
	
	if Input.is_action_pressed("walk_right") and not Input.is_action_pressed("walk_left"):
		var updated_degress = rotation_degrees - 0.6
		rotation_degrees = updated_degress
