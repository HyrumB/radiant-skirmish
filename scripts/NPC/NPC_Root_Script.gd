extends CharacterBody3D
class_name NpcRootScript

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var damage : float = 50
@export var max_health_points : float = 100
@export var current_health_points : float = 100

@export var max_blood_points : float  = 150
@export var current_blood_points : float = 150

@export var move_speed : float = 3
@export var accel : float  = 2.5
#@export var gravity : float = 9.8

@export var linear_vel : Vector3
@export var nav_force : Vector3
@export var wander_radius : float = 12
@export var enable_navigation : bool = true
@export var nav_unstuck_active : bool = false

var current_group : String = "red"
var outcast_group : String = current_group + "_outcast"

# --- private ---

var sleep_translate = 0.9
var is_sleeping : bool = false

@onready var paperdoll : Node3D = $Head/PaperDoll
@onready var body : CollisionShape3D = $Body

@onready var raycast : RayCast3D = $Head/RayCast3D

@onready var hearing_collision : Area3D = $Area3D

@onready var _original_height = body.shape.height

@onready var head : Node3D = $Head

@onready var Attack_cooldown : Timer = $AttackCooldownTimer
@onready var Sleep_timer     : Timer = $SleepTimer
@onready var Attention_span  : Timer = $AttentionTimer

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

@onready var health_bar : ProgressBar = $BarRoot/SubViewport/HealthBar
@onready var health_visual : Sprite3D = $BarRoot/HealthVisual

@onready var start_path_desired_distance = nav_agent.path_desired_distance

@onready var start_position : Vector3 = global_position

@onready var player = $/root/Main/Player

var last_enemy : CharacterBody3D

func _process(delta: float) -> void:

	# gravity
	if !is_on_floor():
		velocity.y -= gravity * delta

	#current_health_points -= .01
	if is_sleeping && Sleep_timer.is_stopped():
		handle_sleep()
	
	if !is_sleeping && enable_navigation && is_on_floor():
		_navigate(delta)
	
	show_health()
	set_health_bar()
	handle_death()	
	detect_body()
	move_and_slide()
	
func _navigate(_delta: float):
	if is_at_destination():
		toggle_navigation(false)
		return
	
	if nav_agent.is_navigation_finished():
		linear_vel = Vector3.ZERO
		nav_force = Vector3.ZERO
		return

	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_horizontal_velocity: Vector3 = global_position.direction_to(next_path_position) * move_speed

	# Ensure head looks at target only if there's a target
	if nav_agent.target_position != global_position + velocity:
		head.look_at(nav_agent.target_position, Vector3.UP)

	nav_agent.set_velocity(new_horizontal_velocity)
	
func new_wander_target(_radius : float = wander_radius):
	set_target((random_on_unit_circle() * _radius) + global_position)
	
func set_target(target: Vector3):
	# do not let a new target be set when unstuck is running
	if nav_unstuck_active:
		return
	else:
		var map_rid = nav_agent.get_navigation_map()
		var target_on_nav_mesh = NavigationServer3D.map_get_closest_point(map_rid, target)
		nav_agent.set_target_position(target_on_nav_mesh)
		
func set_target_last_enemy():
#	sets the nav.target to the last enemy 
	if last_enemy != null:
		set_target(last_enemy.global_position) 

func toggle_navigation(b : bool):
	enable_navigation = b
	# if unstuck is running, turn it off
	nav_unstuck_active = false
	
	if b == false:
		nav_force = Vector3.ZERO
		#if !enable_slide:
			#linear_velocity = Vector3.ZERO

func is_at_destination() -> bool:
	# This optional step can prevent lag in some rare cases
	# but it also causes issues where the agents will just sit and do nothing
	#if !nav_agent.is_target_reachable():
	#	return true
	if nav_agent.is_target_reached():
		
		return true
	else:
		return false

func random_on_unit_circle():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var angle = rng.randf_range(0, TAU)
	var x = cos(angle)
	var z = sin(angle)
	
	return Vector3(x, 0, z)

func get_hearing_colliders_location(group: String):
	var bodies = hearing_collision.get_overlapping_bodies() 
	#while overlapping:
		# "b" represents all entitys within collision shape
	for b in bodies:
		if b.is_in_group(group):
			#print(bodies_hit)
			set_target(b.global_position)

func get_hearing_colliders_groups(group: String):
	var bodies = hearing_collision.get_overlapping_bodies() 
	#while overlapping:
		# "b" represents all entitys within collision shape
	for b in bodies:
		if b.is_in_group(group):
			#print(bodies_hit)
			return true

	return false

func detect_body():
	var bodies = hearing_collision.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group(outcast_group):
			last_enemy = b
		elif b.is_in_group("Player"):
			set_target(player.global_position)
		elif b.is_in_group("items"):
			#print("ITEM")
			set_target(b.global_position)
		
func is_raycast_colliding():
	if raycast.is_colliding():
		var external_body = raycast.get_collider()
		if external_body != null :
			#if body.is_in_group("hostile"):
			return true
		else:
			return false

func deal_damage():
	if raycast.is_colliding() && !is_sleeping:
		var external_body = raycast.get_collider()
		# add cooldown
		
		if external_body != null:
			
			if external_body.is_in_group(current_group) && !external_body.is_in_group(outcast_group):
				GlobalEvents._on_traitor_alert(self)
			
			if external_body.is_in_group("NPC") || external_body.is_in_group("Player"):
				external_body.take_damage(damage)

func show_health():
	if current_health_points < max_health_points:
		health_visual.visible = true
	else:
		health_visual.visible = false

func set_health_bar():
	health_bar.value = current_health_points

func take_damage(incoming_health_damage : float, incoming_blood_damage : float = 5):
	#if Sleep_timer.is_stopped():
		current_health_points -= incoming_health_damage
		current_blood_points -= incoming_blood_damage
		#Sleep_timer.start()
	
func sprite_rotate(newrot:float):
	paperdoll.rotation.z = newrot

func handle_sleep():
	body.shape.height = _original_height - sleep_translate
	sprite_rotate(30)
	velocity = Vector3.ZERO
	Sleep_timer.start()
	
func wake_up():
	is_sleeping = false
	toggle_navigation(true)
	current_health_points = max_health_points
	current_blood_points = max_blood_points
	sprite_rotate(0)
	body.shape.height = _original_height
	
func handle_death():
	if current_health_points <= 0:
		is_sleeping = true
		toggle_navigation(false)
		
	if current_blood_points <= 0:
		self.queue_free()

func _on_sleep_timer_timeout() -> void:
	wake_up()

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
# Blend the safe horizontal velocity with the current vertical velocity
	if !is_sleeping:
		velocity.x = safe_velocity.x
		velocity.z = safe_velocity.z
