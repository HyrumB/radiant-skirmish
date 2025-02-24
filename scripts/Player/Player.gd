extends CharacterBody3D


const MOUSE_SENSITIVITY: float = 0.06
var camera

var dir = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head_origin : Node3D = $Head_origin_point
@onready var head : Node3D = $Head_origin_point/Rotation_helper
@onready var body : CollisionShape3D = $Body
@onready var _original_height = body.shape.height

@onready var helmet : Sprite3D = $helmet
@onready var shirt : Sprite3D
	
const ACCEL: float = 10
const DEACCEL: float = 30

const SPEED: float = 5 # 5
const SPRINT_MULT: float = 2.6 # 2.5
const CROUCH_MULTI: float = .8 # 0.8
const JUMP_VELOCITY: float = 4.5 # 4.5

var stamina_modifier: float = 0.15
var crouch_translate: float = 0.7
var is_crouched : bool = false
var is_sprinting : bool = false


#------------visual var-------------
@onready var health_bar : ProgressBar = $Head_origin_point/Rotation_helper/Camera3D/Health_bar
@onready var stamina_bar : ProgressBar = $Head_origin_point/Rotation_helper/Camera3D/Stamina_bar
@onready var interact_ui : CanvasLayer = $Head_origin_point/Rotation_helper/Camera3D/Interact_ui

var vp = get_viewport()

#-------------armor values-------------
var helmet_av : float = 0
var shirt_av  : float = 0
var glove_av  : float = 0
var greive_av : float = 0
#-------------damage related var-------------
var damage            : float = 50
var blood_damage      : float = 50
var armor_value       : float =  helmet_av + shirt_av + glove_av + greive_av
var can_hit           : bool = true
var overlapping       : bool = false
var bodies_hit        : Dictionary = {}
@onready var i_time    : Timer  = $I_Timer # iframes  
@onready var raycast: RayCast3D = $Head_origin_point/Rotation_helper/Camera3D/RayCast3D

#-------------stats-------------
var vitality     : float = 10 #determins max health
var endurance    : float = 10 #determins stamina and max carry weight
var dexterity    : float = 10
var strength     : float = 10
var intellegence : float = 10

#-------------stat relatives ----------------
var player_health         : float = vitality * 12
var player_max_health     : float = vitality * 12
var player_stamina        : float = endurance * 12
var player_max_stamina    : float = endurance * 12


func _ready():
	GlobalEvents.set_player_reference(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	# This section controls your player camera. Sensitivity can be changed.
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = head.rotation
		camera_rot.x = clampf(camera_rot.x, -1.4, 1.4)
		head.rotation = camera_rot


func _physics_process(delta):
	set_health_bar()
	set_stamina_bar()
	refill_stamina()
	
	#if player_health <= 0:
		#print("death")
	
	var _moving = false
	# Add the gravity. Pulls value from project settings.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#if Input.is_action_just_pressed("ui_cancel"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("attack"):
		deal_damage()
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# acceleration
	var accel
	if dir.dot(velocity) > 0:
		accel = ACCEL
		_moving = true
	else:
		accel = DEACCEL
		_moving = false


	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * accel * delta
	
	if Input.is_action_pressed("sprint"):
		if player_stamina >= 0:
			is_sprinting = true
			direction = direction * SPRINT_MULT
		player_stamina -= stamina_modifier
		
	elif Input.is_action_just_released("sprint"):
		is_sprinting = false	
		
	elif Input.is_action_pressed("crouch"):
		is_crouched = true
		direction = direction * CROUCH_MULTI
		handle_crouch()
		
	if Input.is_action_just_released("crouch"):
		is_crouched = false
		handle_crouch()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func deal_damage():
	if raycast.is_colliding() != null:
		var external_body = raycast.get_collider()
		if external_body != null:
			#print(external_body.get_groups())
			if external_body.is_in_group("NPC") && can_hit:
				external_body.take_damage(damage, blood_damage)

func set_health_bar():
	health_bar.set_size(Vector2(vitality*15, 20))
	health_bar.value = ( player_health/player_max_health) * 100

func set_stamina_bar():
	stamina_bar.set_size(Vector2(endurance*15, 20))
	stamina_bar.value = (player_stamina/player_max_stamina) * 100

func refill_stamina():
	if player_stamina <= player_max_stamina && !is_sprinting:
		player_stamina += stamina_modifier * 2.5

func handle_crouch():
	head.position = Vector3(0,(-crouch_translate if is_crouched else -.6), 0)
	body.shape.height = _original_height - crouch_translate if is_crouched else _original_height

func take_damage(incoming_damage):
	#print("timer going")
	#print(i_time.time_left)
	if i_time.is_stopped():
		player_health -= (armor_value/100)+incoming_damage
		print((armor_value/100)+incoming_damage)
		i_time.start()

func set_armorvalue(new_av, av_type):
	match av_type:
		"helmet": 
			helmet_av = new_av
		"shirt":
			shirt_av = new_av
		
func set_equipment_texture(texture, armor_type):
	match armor_type:
		"helmet": 
			helmet.texture = texture
		"shirt":
			shirt.texture = texture
		
