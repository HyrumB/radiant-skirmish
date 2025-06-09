extends Node3D	

# -- sprites --
@onready var f_head      : Sprite3D = $BodyFront/Head
@onready var f_torso     : Sprite3D = $BodyFront/Torso
@onready var f_arm_left  : Sprite3D = $BodyFront/Arm_Left
@onready var f_arm_right : Sprite3D = $BodyFront/Arm_Right
@onready var f_leg_left  : Sprite3D = $BodyFront/Leg_Left
@onready var f_leg_right : Sprite3D = $BodyFront/Leg_Right

@onready var b_head      : Sprite3D = $BodyBack/Head
@onready var b_torso     : Sprite3D = $BodyBack/Torso
@onready var b_arm_left  : Sprite3D = $BodyBack/Arm_Left
@onready var b_arm_right : Sprite3D = $BodyBack/Arm_Right
@onready var b_leg_left  : Sprite3D = $BodyBack/Leg_Left
@onready var b_leg_right : Sprite3D = $BodyBack/Leg_Right

@onready var f_helmet      : Sprite3D = $ArmorFront/Helmet
@onready var f_shirt       : Sprite3D = $ArmorFront/Shirt
@onready var f_glove_left  : Sprite3D = $ArmorFront/Glove_Left
@onready var f_glove_right : Sprite3D = $ArmorFront/Glove_Right
@onready var f_pelvis      : Sprite3D = $ArmorFront/Pelvis
@onready var f_pant_left   : Sprite3D = $ArmorFront/Pant_Left
@onready var f_pant_right  : Sprite3D = $ArmorFront/Pant_Right

@onready var b_helmet      : Sprite3D = $ArmorBack/Helmet
@onready var b_shirt       : Sprite3D = $ArmorBack/Shirt
@onready var b_glove_left  : Sprite3D = $ArmorBack/Glove_Left
@onready var b_glove_right : Sprite3D = $ArmorBack/Glove_Right
@onready var b_pelvis      : Sprite3D = $ArmorBack/Pelvis
@onready var b_pant_left   : Sprite3D = $ArmorBack/Pant_Left
@onready var b_pant_right  : Sprite3D = $ArmorBack/Pant_Right

@export var left_arm  : Limbs
@export var right_arm : Limbs
@export var left_leg  : Limbs
@export var right_leg : Limbs



func _ready() -> void:
	pass

func get_left_arm():
	return left_arm
	
func get_right_arm():
	return right_arm
	
func get_left_leg():
	return left_leg
	
func get_right_leg():
	return right_arm
	

func set_left_arm(new_arm):
	left_arm = new_arm
	f_arm_left = right_arm.get_paper_doll_texture()
	b_arm_left = right_arm.get_paper_doll_texture()
	
func set_right_arm(new_arm):
	right_arm = new_arm
	f_arm_right = right_arm.get_paper_doll_texture()
	b_arm_right = right_arm.get_paper_doll_texture()
	
func set_left_leg(new_leg):
	left_leg = new_leg
	f_leg_left = right_arm.get_paper_doll_texture()
	b_leg_left = right_arm.get_paper_doll_texture()
	
func set_right_leg(new_leg):
	right_leg = new_leg
	f_leg_right = right_arm.get_paper_doll_texture()
	b_leg_right = right_arm.get_paper_doll_texture()

func set_equipment_texture(texture, armor_type):
	match armor_type:
		"helmet": 
			f_helmet.texture = texture
			b_helmet.texture = texture
		"shirt":
			f_shirt.texture = texture
			b_shirt.texture = texture
		"pants":
			f_pant_left.texture = texture["left"]
			f_pant_right.texture = texture["right"]
			f_pelvis.texture = texture["pelvis"]
			b_pant_left.texture = texture["left"]
			b_pant_right.texture = texture["right"]
			b_pelvis.texture = texture["pelvis"]
		"gloves":
			f_glove_left.texture = texture["left"]
			f_glove_right.texture = texture["right"]
			b_glove_left.texture = texture["left"]
			b_glove_right.texture = texture["right"]

func set_body_texture(texture, limb_type):
	match limb_type:
		"left_arm":
			pass
		"right_arm":
			pass
		"left_leg":
			pass
		"right_leg":
			pass
