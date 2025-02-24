extends Control

# ------- icon textures-----------
@export var base_icon_helmet : CompressedTexture2D
@export var base_icon_shirt  : CompressedTexture2D
@export var base_icon_pants  : CompressedTexture2D
@export var base_icon_gloves : CompressedTexture2D


# ------- paper doll textures---------
@export var arm_left_texture  : CompressedTexture2D
@export var arm_right_texture : CompressedTexture2D
@export var leg_left_texture  : CompressedTexture2D
@export var leg_right_texture : CompressedTexture2D
@export var torso_texture     : CompressedTexture2D
@export var head_texture      : CompressedTexture2D
#@export var hair_texture : Texture2D

# ------- equip slots -------
@onready var icon_helmet_texture  = $gear/outfit/head/TextureRect
@onready var icon_shirt_texture   = $gear/outfit/shirt/TextureRect
@onready var icon_pants_texture   = $gear/outfit/pants/TextureRect
@onready var icon_gloves_texture  = $gear/outfit/gloves/TextureRect


# ------- basic sprites --------
@onready var arm_left_sprite  : Sprite2D = $stats/Character_View/Naked/Arm_left
@onready var arm_right_sprite : Sprite2D = $stats/Character_View/Naked/Arm_right
@onready var leg_left_sprite  : Sprite2D =  $stats/Character_View/Naked/Leg_left
@onready var leg_right_sprite : Sprite2D = $stats/Character_View/Naked/Leg_right
@onready var torso_sprite     : Sprite2D = $stats/Character_View/Naked/Body
@onready var head_sprite      : Sprite2D = $stats/Character_View/Naked/Head
#@onready var hair_sprite : Sprite2D

@onready var pant_left_sprite   : Sprite2D = $stats/Character_View/Armor/Pants/Pant_Left
@onready var pant_right_sprite  : Sprite2D = $stats/Character_View/Armor/Pants/Pant_Right
@onready var pelvis_sprite      : Sprite2D = $stats/Character_View/Armor/Pants/Pelvis
@onready var glove_left_sprite  : Sprite2D = $stats/Character_View/Armor/Gloves/Glove_Left
@onready var glove_right_sprite : Sprite2D = $stats/Character_View/Armor/Gloves/Glove_Right
@onready var shirt_sprite       : Sprite2D = $stats/Character_View/Armor/Shirt/Shirt
@onready var helmet_sprite      : Sprite2D = $stats/Character_View/Armor/Hat/Hat

func _ready():
	init_sprites()
	GlobalEvents.update_equipped.connect(_on_update_equipped)

func _process(delta):
	pass


func init_sprites():
	arm_left_sprite.texture = arm_left_texture
	arm_right_sprite.texture = arm_right_texture
	leg_left_sprite.texture = leg_left_texture
	leg_right_sprite.texture = leg_right_texture
	torso_sprite.texture = torso_texture
	head_sprite.texture = head_texture
	#hair_sprite.texture = hair_texture
	
func _on_update_equipped():
	var helmet = GlobalEvents.get_helmet()
	var shirt = GlobalEvents.get_shirt()
	var pants = GlobalEvents.get_pants()
	var gloves = GlobalEvents.get_gloves()
	if (helmet != null):
		equip_helmet(helmet)
	if (shirt != null):
		equip_shirt(shirt)
	if (pants != null):
		equip_pants(pants)	
	if (gloves != null):
		equip_gloves(gloves)	
		
func equip_helmet(item: Armor):
	icon_helmet_texture.texture = item.get_texture()
	helmet_sprite.texture = item.get_paper_doll_texture()
	
func equip_shirt(item: Armor):
	icon_shirt_texture.texture = item.get_texture()
	shirt_sprite.texture = item.get_paper_doll_texture()
	
	
func equip_pants(item: Armor):
	icon_pants_texture.texture = item.get_texture()
	var textures = item.get_paper_doll_texture()
	if (GlobalEvents.left_leg > 0):
		pant_left_sprite.texture = textures[2]
	if (GlobalEvents.right_leg > 0):
		pant_right_sprite.texture = textures[1]
	pelvis_sprite.texture = textures[0]
	
func equip_gloves(item: Armor):
	icon_gloves_texture.texture = item.get_texture()
	var textures = item.get_paper_doll_texture()
	if (GlobalEvents.left_arm > 0):
		arm_left_sprite.texture = textures[1]
	if (GlobalEvents.right_arm > 0):
		arm_right_sprite.texture = textures[0]

func _on_texture_button_pressed() -> void:
	pass # Replace with function body.
