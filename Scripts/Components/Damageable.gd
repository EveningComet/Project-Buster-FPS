## An object that can take damage and be destroyed.
class_name Damageable
extends Node

signal died
signal health_changed(new_health: int)

@export var max_health: int = 50
var curr_hp: int = 0

func _ready() -> void:
	curr_hp = max_health

func take_damage(dmg: int) -> void:
	curr_hp -= dmg
	
	# Notify anything that cares our health has changed.
	health_changed.emit( curr_hp )
	
	if curr_hp <= 0:
		die()

func heal(amt: int) -> void:
	curr_hp += amt
	curr_hp = clamp(curr_hp, 0.0, max_health)
	
	# Notify anything that cares our health has changed.
	health_changed.emit( curr_hp )

func die() -> void:
	died.emit()
	# TODO: Maybe we don't want everything to disappear on death.
	get_parent().queue_free()
