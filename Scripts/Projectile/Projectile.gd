## Base class for an object that can be shot.
class_name Projectile
extends CharacterBody3D

## The effect that should play when we hit something.
@export var hit_effect: GPUParticles3D

## How fast this projectile moves.
@export var move_speed: float = 10.0

## How much damage this does on impact.
@export var damage: int = 1

## Gravity for projectiles that should drop.
@export var gravity: float = 0

@export var can_bounce: bool = false
@export var speed_bounce_retention_percentage: float = 0.8

## The longest this projectile is allowed to live before being destroyed.
@export var max_lifetime: float = 10.0
var curr_lifetime:        float = 0.0

## The person that fired this projectile. This helps us not hit ourselves.
var shooter: Node = null

var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Ignore our parent's rotations
	set_as_top_level(true)

func _physics_process(delta: float) -> void:
	curr_lifetime += delta
	velocity = direction * delta * move_speed
	velocity.y -= gravity * delta
	var collision = move_and_collide(velocity)
	
	# Check if there was a collision
	if collision:
		var collider = collision.get_collider()
		if collider and collider.has_node("Damageable"):
			
			# Don't hit the shooter
			if shooter != null and collider == shooter:
				if can_bounce == true:
					direction = direction.bounce(collision.get_normal(0)) * speed_bounce_retention_percentage
				return
			
			# Make the hit thing take damage
			var dmgable: Damageable = collider.get_node("Damageable")
			dmgable.take_damage( damage )
			
		# Clear this projectile, since it can't bounce.
		if can_bounce == false:
			
			get_node("GFX").visible = false
			if hit_effect:
				hit_effect.emitting = true
				await get_tree().create_timer(1.0, false).timeout
			queue_free()
		
		if can_bounce == true:
			direction = direction.bounce(collision.get_normal(0)) * speed_bounce_retention_percentage
			return
	
	if curr_lifetime > max_lifetime:
		queue_free()

func set_shooter(new_shooter: Node) -> void:
	shooter = new_shooter

func set_direction(new_direction: Vector3) -> void:
	direction = new_direction
