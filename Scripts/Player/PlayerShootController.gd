## Handles shooting for the player.
class_name PlayerShootController
extends Node

## The node storing our raycast for aiming.
@export var aim_cast: RayCast3D

## How often we can fire
@export var fire_rate: float = 0.25
var curr_fire_time:    float = 0.0

## The weapon the player currently has equipped.
@export var curr_weapon: Weapon = null

## TODO: Other weapon types.

func _ready() -> void:
	curr_fire_time = curr_weapon.fire_rate

func _physics_process(delta: float) -> void:
	
	# Tick our fire cooldown
	curr_fire_time += delta
	curr_fire_time = clamp(curr_fire_time, 0.0, fire_rate)
	
	# Handle the charge shot
	if curr_fire_time >= curr_weapon.fire_rate:
		set_aim_direction()
		if Input.is_action_just_pressed("shoot"):
			curr_weapon.on_fire_button_down()
		elif Input.is_action_pressed("shoot"):
			curr_weapon.on_fire_button_held( delta )
		elif Input.is_action_just_released("shoot"):
			curr_weapon.on_fire_button_released()
			curr_fire_time = 0

func set_aim_direction() -> void:
	# Get the position from where the projectile where will fire from
	var origin:     Vector3 = curr_weapon.get_fire_position()
	var aim_target: Vector3 = aim_cast.global_transform * aim_cast.target_position

	# Get our camera and viewport. This is to help get the direction and center of the screen
	var cam        = get_parent().get_node("Head/Camera3D")
	var viewport   = get_viewport().get_size()

	# Set the direction to where the player is looking at (using our aimcast)
	var ray_origin = cam.project_ray_origin(viewport / 2)
	var ray_dir    = (aim_target - ray_origin).normalized()

	var aim_dir:     Vector3 = ray_dir
	curr_weapon.set_aim_direction( aim_dir )
	curr_weapon.set_shooter( get_parent() )

