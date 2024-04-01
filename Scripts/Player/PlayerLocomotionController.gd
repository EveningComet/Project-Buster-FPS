## Responsible for managing the player's movement.
class_name PlayerLocomotionController
extends StateMachine

## Shared dash cooldown.
@export var dash_cooldown: Timer

var character_body: CharacterBody3D
var head: Node3D

# Camera/Rotation controlling values
var mouse_sensitivity:     float = 0.1
var controller_sensitivity: float = 3.0
var min_pitch: float = -75.0
var max_pitch: float = 75.0
var wrap_0:   float = 0.0
var wrap_max: float = 360.0

func _unhandled_input(event: InputEvent) -> void:
	# Handle the mouse
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate the x, and clamp the values
		head.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, min_pitch, max_pitch)
		
		# Rotate the y
		character_body.rotate_y( deg_to_rad(-event.relative.x * mouse_sensitivity) )
		character_body.rotation_degrees.y = wrapf(
			character_body.rotation_degrees.y,
			wrap_0,
			wrap_max
		)

	curr_state.check_for_unhandled_input( event )

func set_me_up() -> void:
	head = get_parent().get_node("Head")
	character_body = get_parent()
	super()

func _process(delta: float) -> void:
	apply_controller_rotation()

func _physics_process(delta: float) -> void:
	curr_state.physics_update( delta )
	
func apply_controller_rotation() -> void:
	var axis_vector = Vector2.ZERO
	axis_vector.y = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.x = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	if InputEventJoypadMotion:
		
		# Handle the controller's x rotation
		head.rotation_degrees.x -= axis_vector.x * controller_sensitivity
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, min_pitch, max_pitch)
		
		# Handle the controller's y rotation
		character_body.rotate_y( deg_to_rad(-axis_vector.y) * controller_sensitivity )
		character_body.rotation_degrees.y = wrapf(character_body.rotation_degrees.y, wrap_0, wrap_max)
