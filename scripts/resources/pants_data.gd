class_name Pants extends Armor

@export var paper_doll_texture_leg_right: Texture2D
@export var paper_doll_texture_leg_left: Texture2D


func get_armor_value():
	return armor_value

func get_paper_doll_texture():
	var arr : Array = [paper_doll_texture, paper_doll_texture_leg_right, paper_doll_texture_leg_left]
	return arr
