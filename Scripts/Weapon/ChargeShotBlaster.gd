## A weapon that can fire charged shots.
class_name ChargeShotBlaster
extends Weapon

@export var charge_rate:   float = 25.0  # How fast we charge up our charge shot
var curr_charge_amount:    float = 0.0
var max_charge_amount:     float = 100.0
var min_charge_amount_to_display_effect: float = 5

# Charging particle effects
@export var charge_effect: GPUParticles3D

## The base projectile that this fires.
@export var charge_1_prefab: PackedScene
@export var charge_2_prefab: PackedScene


func _ready() -> void:
	charge_effect.emitting = false

func on_fire_button_down() -> void:
	curr_charge_amount = 0

func on_fire_button_held(delta: float) -> void:
	# While the player holds down the fire button, charge our shot.
	curr_charge_amount += charge_rate * delta
	curr_charge_amount = clamp(curr_charge_amount, 0.0, max_charge_amount)
	print("ChargeShotBlaster :: %s current charge amount is: %s." % [name, curr_charge_amount])
	if curr_charge_amount >= min_charge_amount_to_display_effect:
		charge_effect.emitting = true

# This weapon shoots when the attack button is released.
func on_fire_button_released() -> void:
	fire()

func fire() -> void:
	# TODO: Spawn projectile based on charge amount.
	var projectile
	if curr_charge_amount / max_charge_amount < 0.25:
		projectile = charge_1_prefab.instantiate()
	elif curr_charge_amount / max_charge_amount >= 0.25:
		projectile = charge_2_prefab.instantiate()
	
#	# Set the projectile's position and direction
	projectile.set_direction( aim_dir )
	projectile.add_collision_exception_with( shooter )
	get_parent().add_child( projectile )
	projectile.set_shooter( shooter )
	projectile.global_position = fire_position.global_transform.origin
	projectile.look_at(fire_position.global_transform.origin + aim_dir, Vector3.UP)
	
	curr_charge_amount = 0.0
	charge_effect.emitting = false
