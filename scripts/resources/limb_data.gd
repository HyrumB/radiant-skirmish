class_name Limbs extends Item

@export var limb : String

@export var paper_doll_texture: Texture2D
@export var paper_doll_texture_damaged: Texture2D
@export var paper_doll_texture_destroyed: Texture2D

@export var equip_texture: Texture2D

var limb_health = 100

func _physics_process(_delta):
	if limb_health < 70:
		emit_signal("update_equipped")
	elif limb_health < 30:
		emit_signal("update_equipped")
	else:
		emit_signal("update_equipped")

func get_armor_type():
	return limb.to_lower()

func get_limb_health():
	return limb_health

func update_limb_health( modifyer: float ):
	limb_health -= modifyer
	
func get_paper_doll_texture():
	if (limb_health > 70):
		return paper_doll_texture
	
	elif(limb_health > 30):
		return paper_doll_texture_damaged
	
	else:
		return paper_doll_texture_destroyed
