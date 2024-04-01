## Dashing state for the player.
class_name PLDash
extends PLState

@export var max_dash_time: float = 0.2   # How long the player can stay in the dash state.
@export var dash_accel:    float = 100.0 # Dash acceleration power
@export var dash_friction: float = 15.0  # Dash friction power
var curr_dash_time:        float = 0.0

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	# Setup the gravity
	gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	max_jump_velocity = sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity * min_jump_height)

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'input_dir': var i_d, 'velocity': var v}:
			input_dir   = i_d
			velocity = v
			velocity.y  = 0
			
			# The player entered with no movement, so just move where they're facing
			if i_d == Vector3.ZERO:
				input_dir = -cb.global_transform.basis.z
	
	print("PLDash :: Entered.")

func exit() -> void:
#	my_state_machine.get_parent().get_node("GPU Dash Effect").emitting = false
	velocity = Vector3.ZERO
	curr_dash_time = 0

func handle_move(delta: float) -> void:
	# Increment our allowed dash time
	curr_dash_time += delta
	
	# Apply our dash speed
	velocity.x = input_dir.x * move_speed
	velocity.z = input_dir.z * move_speed
	#velocity.x = velocity.move_toward(input_dir * move_speed, dash_accel * delta).x
	#velocity.z = velocity.move_toward(input_dir * move_speed, dash_accel * delta).z
	
	# Apply our dash friction
	velocity = velocity.move_toward(Vector3.ZERO, dash_friction * delta)
	
	velocity.y -= gravity * delta
	
	if cb.is_on_floor() == true:
		velocity.y = 0
	
	# Allow us to jump in this state
	if cb.is_on_floor() == true and Input.is_action_just_pressed("jump"):
		velocity.y = max_jump_velocity
		print("Pressing jump in dash.")
	if Input.is_action_just_released("jump") and velocity.y > min_jump_velocity:
		velocity.y = min_jump_velocity
	
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	# We have reached the max dash time, so bail
	if curr_dash_time >= max_dash_time or cb.is_on_wall() == true:
		if cb.is_on_floor() == false:
			my_state_machine.change_to_state("PLAir", {velocity = velocity})
		else:
			my_state_machine.change_to_state("PLGroundMove", {velocity = velocity})
