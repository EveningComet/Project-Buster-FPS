## Base class for a state that defines how the player should move.
class_name PLState
extends State

# Every state has something to do with the player's movement, so cache the thing that let's us move
var cb: CharacterBody3D

# Speed, acceleration & friction

## How fast we move
@export var move_speed:      float = 10   # How fast this state moves
@export var ground_accel:    float = 60.0
@export var ground_friction: float = 50.0
@export var air_accel:       float = 20.0
@export var air_friction:    float = 20.0
@export var rot_speed:       float = 10.0 # How fast we rotate

# Jump & gravity
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
@export var max_jump_height:   float = 4   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
var max_jump_velocity: float = 0
var min_jump_velocity: float = 0
var gravity:           float = 9.8

# Ledge grab raycasts for the states that need them
var vertical_ledge_ray:   RayCast3D
var horizontal_ledge_ray: RayCast3D

# Every state needs to keep track of their movement vector and input
var velocity:  Vector3 = Vector3.ZERO
var input_dir: Vector3 = Vector3.ZERO

var floor_check: RayCast3D

## Handle our animations.
var animation_tree: AnimationTree 

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	cb             = new_sm.character_body
	#animation_tree = my_state_machine.animation_tree
	
	# Raycasts for ledge grabs
#	vertical_ledge_ray   = my_state_machine.vertical_ray
#	horizontal_ledge_ray = my_state_machine.horizontal_ray

func handle_animations(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_move( delta )

func handle_move(delta: float) -> void:
	pass

func handle_gravity(delta: float) -> void:
	pass

func get_input_vector() -> void:
	pass

func apply_movement(delta: float) -> void:
	pass

func apply_friction(delta: float) -> void:
	pass

func check_if_on_ground_or_ceiling() -> void:
	# Don't calculate gravity if we're on the ground and make us fall down when hitting the ceiling
	if cb.is_on_floor() == true or cb.is_on_ceiling() == true:
		velocity.y = 0
