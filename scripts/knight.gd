extends CharacterBody3D


# movment export 
@export var walk_speed : float = 5.0
@export var run_speed : float = 10.0


@export_group("Camera Parameters")
@export var horizontal_look_speed: float = 0.00003
@export var vertical_look_speed: float = 0.00002
@export var joystick_h_look_speed: float = 0.06
@export var joystick_v_look_speed: float = 0.06
@export var min_look_degree: float = -40
@export var max_look_degree: float = 45
@export var enable_bobbing: bool = true
@export var bob_time: float = PI / 8.0

@export_group("Combat Parameters")
@export var attack_time: float = 2.0

# scene refrences 
@onready var animation_player: AnimationPlayer = $mesh/AnimationPlayer
@onready var head: Node3D = $head


var states = ["idle", "walk", "run", "slash", "attack"]
var state = "idle"
var look_direction : Vector2
var slash_cooldown: float = 0.0
var attack_cooldown: float = 0.0

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	if slash_cooldown > 0.0:
		slash(delta)
	elif attack_cooldown > 0.0:
		attack(delta)
	elif input_direction : 
		if Input.is_action_pressed("shift") : 
			self.state = "run"
			run(delta)
		else : 
			self.state = "walk"
			walk(delta)
	else : 
		self.state = "idle"
		idle(delta)
	
	# these could also be accomplished with a Timer node...
	if (slash_cooldown > 0.0):
		slash_cooldown -= delta
	if (attack_cooldown > 0.0):
		attack_cooldown -= delta
	
	handle_rotation()
	move_and_slide()

# movement functions
#region 

func get_slash() -> void:
	if Input.is_action_just_pressed("attack") and slash_cooldown <= 0.0:
		self.state = "slash"
		slash_cooldown = attack_time

func idle (delta : float) -> void :
	# slow down towards zero 
	velocity.x = move_toward(velocity.x, 0, walk_speed)
	velocity.z = move_toward(velocity.z, 0, walk_speed)
	
	get_slash()

func slash(delta: float) -> void:
	# slow down towards zero 
	velocity.x = move_toward(velocity.x, 0, walk_speed)
	velocity.z = move_toward(velocity.z, 0, walk_speed)

func attack(delta: float) -> void:
	# slow down towards zero 
	velocity.x = move_toward(velocity.x, 0, walk_speed)
	velocity.z = move_toward(velocity.z, 0, walk_speed)

func walk (delta : float) -> void : 
	
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	# move the player 
	velocity.x = move_direction.x * walk_speed
	velocity.z = move_direction.z * walk_speed
	
	get_slash()

func run (delta : float) -> void : 
	
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	# move the player 
	velocity.x = move_direction.x * run_speed
	velocity.z = move_direction.z * run_speed
	
	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0.0:
		self.state = "attack"
		attack_cooldown = attack_time

func handle_rotation():
	# capture current mouse movement
	var current_mouse_direction: Vector2 = Input.get_last_mouse_velocity()
	
	if current_mouse_direction:
		# to move up and down we rotate along x-axis 
		look_direction.x -= current_mouse_direction.y * vertical_look_speed
		#restric user camera angles for up/ down 
		look_direction.x = clamp(look_direction.x, deg_to_rad(min_look_degree), deg_to_rad(max_look_degree))
		# get rotation for side by side which is rotating against y axis 
		look_direction.y -= current_mouse_direction.x * horizontal_look_speed
	
	
	#reset transfrom 
	transform.basis = Basis()
	rotate_y(look_direction.y)
	head.transform.basis = Basis()
	head.rotate_x(look_direction.x)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Sword And Shield Slash/mixamo_com" || anim_name == "Sword And Shield Attack/mixamo_com":
		var movement: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		if movement:
			state = "walk"
		else:
			state = "idle"
		slash_cooldown = 0.0
		attack_cooldown = 0.0
