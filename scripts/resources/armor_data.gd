class_name Armor extends Item

@export var armor_type : String
@export var armor_value  : float 

@export var paper_doll_texture: Texture2D
@export var paper_doll_texture_damaged: Texture2D
@export var paper_doll_texture_destroyed: Texture2D

var durability = 100

func _physics_process(_delta):
	if durability < 70:
		emit_signal("update_equipped")
	elif durability < 30:
		emit_signal("update_equipped")
	else:
		emit_signal("update_equipped")

func get_armor_type():
	return armor_type.to_lower()

func get_armor_value():
	return armor_value

func get_paper_doll_texture():
	if (durability > 70):
		return paper_doll_texture
	
	elif(durability > 30):
		return paper_doll_texture_damaged
	
	else:
		return paper_doll_texture_destroyed
