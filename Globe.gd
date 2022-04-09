extends Sprite
class_name Globe

signal moving
signal stopped

# when we pass the tree more than this amount player will die
const MAX_TREE_PASS_COUNT = 2 # just for testing value will be 20

var tree_pass_count := 0

onready var tree: AnimatedSprite = $Tree
onready var tree_collision: Area2D = $Tree/Area2D
onready var screen_notifier: VisibilityNotifier2D = $Tree/VisibilityNotifier2D

func _ready() -> void:
	tree.play()
	tree_collision.connect('body_exited', self, '_on_tree_passed')
	screen_notifier.connect('screen_exited', self, '_on_tree_exit')


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('walk_left'):
		emit_signal('moving', false)
	
	if Input.is_action_just_pressed('walk_right'):
		emit_signal('moving', true)
	
	if Input.is_action_just_released('walk_left') or Input.is_action_just_released('walk_right'):
		emit_signal('stopped')
	
	if Input.is_action_pressed('walk_left') and not Input.is_action_pressed('walk_right'):
		var updated_degrees = rotation_degrees + 0.6
		rotation_degrees = updated_degrees
	
	if Input.is_action_pressed('walk_right') and not Input.is_action_pressed('walk_left'):
		var updated_degress = rotation_degrees - 0.6
		rotation_degrees = updated_degress


func _on_tree_passed(_body: StaticBody2D) -> void:
	tree_collision.set_deferred('monitoring', false)
	
	tree_pass_count += 1
	
	if tree_pass_count == MAX_TREE_PASS_COUNT:
		print("You've been Godot")
	else:
		print('Count: ', tree_pass_count)


func _on_tree_exit() -> void:
	print("Bye")
	tree_collision.set_deferred('monitoring', true)
