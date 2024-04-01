## State for when the player is wall sliding.
class_name PLWallSliding
extends PLState

## How fast we will slide down a wall.
@export var wallslide_speed:       float = 10.0
@export var wall_jump_away_force:  float = 15.0
@export var wall_jump_away_height: float = 30.0

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	# We should exit now
	if cb.is_on_floor() == true or cb.is_on_wall() == false:
		my_state_machine.change_to_state("PLGroundMove")
		return
	
	if Input.is_action_just_pressed("jump"):
		var normal = cb.get_wall_normal()
		velocity = normal * wall_jump_away_force
		
		my_state_machine.change_to_state(
			"PLAir",
			{velocity = velocity, "wall_jump_away_height" = wall_jump_away_height}
		)
		
	# Go downwards
	velocity.y -= wallslide_speed * delta
	cb.set_velocity( velocity )
	cb.move_and_slide()
