## Manages the camera for the player.
class_name CameraController
extends Node3D

var mouse_sensitivity: float = 0.1 # TODO: Clamp this between 0.1 and 1. Also, make this a global setting.
var controller_sensitivity: float = 3.0 # TODO: Make this a global setting.
var min_pitch: float = -75.0
var max_pitch: float = 25.0

var target: Node3D
var offset: Vector3
var wrap_0:   float = 0.0
var wrap_max: float = 360.0

func _ready() -> void:
	set_as_top_level(true)

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_BACKSPACE):
		push_warning("CameraController :: Player pressed the back key. Quitting the game. Please put a cleaner way to quit.")
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		# Rotate the x, and clamp the values
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
			
		# Rotate for the y, and clamp the values so it doesn't go over values for reasons
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, wrap_0, wrap_max)
		
		# TODO: Rotate the y axis of the character.
	
func _process(delta) -> void:
	apply_controller_rotation()

func apply_controller_rotation() -> void:
	var axis_vector = Vector2.ZERO
	axis_vector.y = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.x = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	if InputEventJoypadMotion:
		# Handle the controller's x rotation
		rotation_degrees.x -= axis_vector.x * controller_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
		
		# Handle the controller's y rotation
		rotation_degrees.y -= axis_vector.y * controller_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, wrap_0, wrap_max)
		
		# TODO: Rotate the y axis of the character
