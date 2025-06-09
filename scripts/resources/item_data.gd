class_name Item extends Resource

#@export var quantity: int = 1
@export var inv_texture: Texture2D
@export var item_type: String
@export var item_name: String
@export var item_description: String
@export var item_effect: String
var scene_path: String = "res://scripts/item_physical.gd" 


#func get_quantity():
	#return quantity
#
#func add_quantity(adder):
	#quantity += adder

func get_texture():
	return inv_texture

func get_item_type():
	return item_type.to_lower()

func get_item_name():
	return item_name

func get_item_desc():
	return item_description

func get_item_effect():
	return item_effect

func get_scene_path():
	return scene_path
