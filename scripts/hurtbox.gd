extends Area3D

class_name hurtbox

enum HurtboxType {
	Player,
	Enemy,
	Environment
}

signal hitbox_collided

## The damage this hurtbox deals to its target.
@export var hurt_damage: int = 1

## The knockback this hurtbox deals to its target.
@export var knockback: float = 100.0

## What kind of damage this hurtbox deals. There are three types:
## - Environment: e.g. lava, spikes, or killzone
## - Enemy: e.g. zombie, enemy trap, or enemy projectile
## - Player: e.g. melee, player bomb, or player projectile
@export var type: HurtboxType = HurtboxType.Environment

## Activation of hurtbox.
@export var enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_entered(hb: hitbox):
	if hb.enabled and self.enabled:
		emit_signal("hitbox_collided", hb)
