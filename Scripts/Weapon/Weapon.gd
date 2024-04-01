## Base class for a weapon.
class_name Weapon
extends Node3D

## Just used to help with cooldowns.
signal fired

## How long, in seconds, before this weapon can attack again.
@export var fire_rate: float = 0.25

## Where should the projectiles come out of this weapon?
@export var fire_position: Node3D

# TODO: Ammo.

## The person shooting us. Helps prevent us from hurting ourselves.
var shooter

## Where the projectiles should go.
var aim_dir: Vector3 = Vector3.ZERO

## What should this weapon do when the player has just pressed down the button to attack?
func on_fire_button_down() -> void:
	pass

## What should this weapon do when the player is holding down the button to attack?
func on_fire_button_held(delta: float) -> void:
	pass

## What should this weapon do when the player releases the button to attack? 
func on_fire_button_released() -> void:
	pass

## Perform the attack.
func fire() -> void:
	pass

## Return the position that projectiles should exit.
func get_fire_position() -> Vector3:
	return fire_position.global_transform.origin

## When firing the projectile, make sure it follows where the player/shooter is facing.
func set_aim_direction(desired_aim_dir: Vector3) -> void:
	aim_dir = desired_aim_dir

func set_shooter(new_shooter) -> void:
	shooter = new_shooter
