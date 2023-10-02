extends Sprite
class_name Globe

signal moving
signal stopped

# when we pass the tree more than this amount player will die
const MAX_TREE_PASS_COUNT = 20
const MIN_TREE_PASS_COUNT = 2

var tree_pass_count := 0
var can_end := false

onready var tree: AnimatedSprite = $Tree
onready var tree_collision: Area2D = $Tree/Area2D
onready var screen_notifier: VisibilityNotifier2D = $Tree/VisibilityNotifier2D
onready var estragon: Sprite = $Estragon
onready var action_label: RichTextLabel = $Control/ActionLabel
onready var estragon_text: RichTextLabel = $Control/EstragonText
onready var estragon_audio: AudioStreamPlayer = $Estragon/AudioStreamPlayer

func _ready() -> void:
	tree.play()
	action_label.set_visible(false)
	estragon.set_visible(false)
	estragon_text.set_visible(false)
	tree_collision.connect('body_entered', self, '_on_tree_entered')
	tree_collision.connect('body_exited', self, '_on_tree_passed')
	screen_notifier.connect('screen_exited', self, '_on_tree_exit')


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('walk_left'):
		emit_signal('moving', false)

	if Input.is_action_just_pressed('walk_right'):
		emit_signal('moving', true)

	if Input.is_action_just_released('walk_left') or Input.is_action_just_released('walk_right'):
		emit_signal('stopped')

	if Input.is_action_pressed('walk_left') and not Input.is_action_pressed('walk_right'):
		var updated_degrees = rotation_degrees + 0.3
		rotation_degrees = updated_degrees

	if Input.is_action_pressed('walk_right') and not Input.is_action_pressed('walk_left'):
		var updated_degress = rotation_degrees - 0.3
		rotation_degrees = updated_degress

	if Input.is_action_just_pressed('can_end') and can_end:
		$AnimationPlayer.play('go_to_end')


func _on_tree_entered(_body: StaticBody2D) -> void:
	if tree_pass_count >= MIN_TREE_PASS_COUNT:
		_estragon_actions()
		can_end = true
		action_label.set_deferred('visible', true)


func _on_tree_passed(_body: StaticBody2D) -> void:
	action_label.set_deferred('visible', false)
	tree_collision.set_deferred('monitoring', false)

	tree_pass_count += 1
	can_end = false


func _on_tree_exit() -> void:
	tree_collision.set_deferred('monitoring', true)

	if tree_pass_count >= MIN_TREE_PASS_COUNT:
		estragon.set_deferred('visible', true)
		estragon_text.set_deferred('visible', false)


func _estragon_actions() -> void:
	if estragon.visible:
		estragon_audio.play()
		estragon_text.set_deferred('visible', true)


func _go_to_end() -> void:
	get_tree().change_scene('res://End.tscn')

