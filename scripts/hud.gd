extends Control

@onready var life_total: TextureProgressBar = $VBoxContainer/health/bar_backdrop/life_total
@onready var stamina_total: TextureProgressBar = $VBoxContainer/stamina/bar_backdrop/stamina_total

var player: CharacterBody3D = null

# Attempts to establish a connection with the player node.
# Returns: whether or not the player is found in the parent tree.
func connect_player() -> bool:
	player = get_parent().find_child("knight")
	
	if player.has_signal("health_changed") and player.has_signal("stamina_changed"):
		player.health_changed.connect(_on_health_changed)
		player.stamina_changed.connect(_on_stamina_changed)
	else:
		player = null
	
	return player != null

func _ready() -> void:
	if !connect_player():
		print("UI failed to connect to player!")

func _on_health_changed() -> void:
	life_total.value = clamp(player.health / player.max_health * 100.0, 0.0, 100.0)

func _on_stamina_changed() -> void:
	stamina_total.value = clamp(player.stamina / player.max_stamina * 100.0, 0.0, 100.0)
