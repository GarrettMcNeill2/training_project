extends Area3D

class_name hitbox

var previous: Array[hurtbox]
var disabled: Array[hurtbox]
var current: Array[hurtbox]

signal hurtbox_collided(hb: hurtbox, repeat: bool)
signal hurtbox_exited(hb: hurtbox)

@export var enabled: bool = true

func _ready() -> void:
	previous = []
	disabled = []
	current = []

# the following code is great for teaching new programmers about lazy array operators
func _physics_process(_delta: float) -> void:
	# move hurtboxes that have been disabled to the "disabled" array
	var turned_off = current.filter(func(v): return not v.enabled)
	for v in turned_off:
		current.erase(v)
	disabled.append_array(turned_off)
	
	# move hurtboxes that have been enabled back to "current" array
	var turned_on = disabled.filter(func(v): return v.enabled)
	for v in turned_on:
		disabled.erase(v)
	current.append_array(turned_on)
	
	# determine which hurtboxes are entering, repeating, or exiting
	var entering = current.filter(func(v): return not previous.has(v))
	var repeat = current.filter(func(v): return previous.has(v))
	var exiting = previous.filter(func(v): return current.has(v))
	
	# emit signals for each collider
	if self.enabled:
		for collider in entering:
			hurtbox_collided.emit(collider, false)
		for collider in repeat:
			hurtbox_collided.emit(collider, true)
		for collider in exiting:
			hurtbox_exited.emit(collider)
	
	# reset for next frame
	previous.clear()
	for v in current:
		previous.append(v)

func _on_area_entered(hb: hurtbox):
	if hb.enabled:
		current.append(hb)
	else:
		disabled.append(hb)

func _on_area_exited(hb: hurtbox):
	if current.has(hb):
		current.erase(hb)
	if disabled.has(hb):
		disabled.erase(hb)
