extends Node

@export var arm_left_texture  : Texture2D
@export var arm_right_texture : Texture2D
@export var leg_left_texture  : Texture2D
@export var leg_right_texture : Texture2D
@export var torso_texture     : Texture2D
@export var head_texture      : Texture2D

var equip_size      :int = 3
var consumable_size :int = 12
var invSize         :int = 20

# ------ initalise inventory ------
var inv = []
var left_equip = []
var right_equip = []
var consumables = []

# ---- limbs ----
@export var left_arm  : Limbs = load("res://scripts/resources/items/limbs/Your_Left_Arm.tres")
@export var right_arm : Limbs = load("res://scripts/resources/items/limbs/Your_Right_Arm.tres")
@export var left_leg  : Limbs = load("res://scripts/resources/items/limbs/Your_Left_Leg.tres")
@export var right_leg : Limbs = load("res://scripts/resources/items/limbs/Your_Right_Leg.tres")

# ---- armor/apparal ----
var helmet : Dictionary = {"quantity": null, "data": null}
var shirt  : Dictionary = {"quantity": null, "data": null}
var gloves : Dictionary = {"quantity": null, "data": null}
var pants  : Dictionary = {"quantity": null, "data": null}


#scene and node refrences
var player_node: Node = null
@onready var inv_slot_scene = preload("res://scenes/ui/inventory/UI_inventory_slot.tscn")
@onready var equip_scene = preload("res://scenes/ui/inventory/UI_equip.tscn")

# custom signals
signal inventory_updated 
signal update_equipped
signal traitor_alert(traitor: CharacterBody3D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	sets the size of inv to inv size
	inv.resize(invSize) 
	right_equip.resize(equip_size)
	left_equip.resize(equip_size)
	consumables.resize(consumable_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_traitor_alert(traitor: CharacterBody3D):
	traitor.add_to_group(traitor.outcast_group)

func add_item(item):
	#checks if incoming item already exists and adds incoming item to the pile if it does
	for i in range(inv.size()):
		if (inv[i] != null && inv[i]["data"].get_item_type() == item["data"].get_item_type() && 
		inv[i]["data"].get_item_desc() == item["data"].get_item_desc()):
			inv[i]["quantity"]+=item["quantity"] 
			inventory_updated.emit()
			return true
		# throws new items in their own spot if their is room for them
		elif inv[i] == null:
			inv[i] = item
			inventory_updated.emit()
			return true
		
	return false
	 
func remove_item(_item_type, _item_effect):
	pass
	#for i in range(inv.size()):
		#if inv[i] != null && inv[i]["type"] == item_type && inv[i]["effect"] == item_effect:
			#inv[i]["quantity"] -= 1
			#if inv[i]["quantity"] <= 0:
				#inv[i] = null
			#inventory_updated.emit()
			#return true
		#return false
	
func increse_inventory_size():
	inventory_updated.emit()
	
func set_player_reference(player):
	player_node = player
	
func set_helmet(item):
	helmet = item
	player_node.set_armorvalue(item["data"].get_armor_value(), item["data"].get_armor_type())
	player_node.paperdoll.set_equipment_texture(item["data"].get_paper_doll_texture(), item["data"].get_armor_type())
	emit_signal("update_equipped")


func set_shirt(item):
	shirt = item
	player_node.set_armorvalue(item["data"].get_armor_value(), item["data"].get_armor_type())
	player_node.paperdoll.set_equipment_texture(item["data"].get_paper_doll_texture(), item["data"].get_armor_type())
	emit_signal("update_equipped")
	

func set_pants(item):
	pants = item
	player_node.set_armorvalue(item["data"].get_armor_value(), item["data"].get_armor_type())
	player_node.paperdoll.set_equipment_texture(item["data"].get_paper_doll_texture(), item["data"].get_armor_type())
	emit_signal("update_equipped")

func set_gloves(item):
	gloves = item
	player_node.set_armorvalue(item["data"].get_armor_value(), item["data"].get_armor_type())
	player_node.paperdoll.set_equipment_texture(item["data"].get_paper_doll_texture(), item["data"].get_armor_type())
	emit_signal("update_equipped")
	
func reset_helmet():
	helmet = {"quantity": null, "data": null}
	
func reset_shirt():
	shirt = {"quantity": null, "data": null}
	
func reset_pants():
		pants = {"quantity": null, "data": null}
	
func reset_gloves():
		gloves = {"quantity": null, "data": null}
		
func get_helmet():
	return helmet["data"]

func get_shirt():
	return shirt["data"]
	
func get_pants():
	return pants["data"]
	
func get_gloves():
	return gloves["data"]

# inventory stuff
