extends Node3D


@onready var paperdoll : Node3D = $PaperDoll

# ---inventory stuff --
var NPCinvSize    :int = 20
var NPCinv = []
# -- equip stuff --
var equip_helmet : Dictionary = {"quantity": null, "data": null}
var equip_shirt  : Dictionary = {"quantity": null, "data": null}
var equip_gloves : Dictionary = {"quantity": null, "data": null}
var equip_pants  : Dictionary = {"quantity": null, "data": null}



var helmet_av
var shirt_av
var pants_av
var gloves_av

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NPCinv.resize(NPCinvSize)  
	helmet_av = 0
	shirt_av = 0
	gloves_av = 0
	pants_av = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(equip_helmet, ": helmet")
	#print(equip_shirt, ": shirt")
	#print(equip_gloves, ": gloves")
	#print(equip_pants, ": pants")
	#print(NPCinv)
	#print ("")
	pass

	#checks if incoming item already exists and adds incoming item to the pile if it does
func add_item(item):
	for i in range(NPCinv.size()):
		
		if (NPCinv[i] != null && NPCinv[i]["data"].get_item_type() == item["data"].get_item_type() &&  
			NPCinv[i]["data"].get_item_desc() == item["data"].get_item_desc()):
			NPCinv[i]["quantity"] += item["quantity"]
			equip_from_inventory() # find a betterplace to put this call
			return true
			
		elif NPCinv[i] == null:
			NPCinv[i] = item
			equip_from_inventory() # find a betterplace to put this call
			return true
			
	return false

# Function to equip items from the inventory
func equip_from_inventory() -> void:
	# Define the equipment slots and their corresponding variables
	var equipment_slots = {
		"helmet": equip_helmet,
		"shirt": equip_shirt,
		"gloves": equip_gloves,
		"pants": equip_pants
	}

	# Iterate through the inventory
	for item in NPCinv:
		if item != null:
			var item_data = item["data"]
			var item_type = item_data.get_item_type() #get the type, "helmet", "shirt" etc.
			# Check if the item is armor and type matches an equipment slot
			if (item_type == "armor"):
				var armor_type = item_data.get_armor_type()
				if equipment_slots.has(armor_type):					
					var current_equipment = equipment_slots[armor_type] #get the current item in the slot.
					# If the slot is empty or the new item is better, equip it
					if (current_equipment["data"] == null or (item_data.get_armor_value() > current_equipment["data"].get_armor_value())):
						equip_item(item) #use the helper.
						# Remove the item from the inventory after equipping.
						#remove_item_from_inventory(item_data)

func set_armorvalue(new_av, av_type):
	match av_type:
		"helmet": 
			helmet_av = new_av
		"shirt":
			shirt_av = new_av
		"pants":
			pants_av = new_av
		"gloves":
			gloves_av = new_av
		
#func set_equipment_texture(texture, armor_type):
	#match armor_type:
		#"helmet": 
			#sprite_helmet.texture = texture
		#"shirt":
			#sprite_shirt.texture = texture
		#"pants":
			#sprite_pant_left.texture = texture["left"]
			#sprite_pant_right.texture = texture["right"]
			#sprite_pelvis.texture = texture["pelvis"]
		#"gloves":
			#sprite_glove_left.texture = texture["left"]
			#sprite_glove_right.texture = texture["right"]

func equip_item(item: Dictionary) -> void: #Added this function
	var item_data = item.get("data") #store the data, and use .get
	if item_data != null: #check if data exists
		match item_data.get_armor_type():
			"helmet":
				equip_helmet = item
				set_armorvalue(item_data.armor_value, "helmet")
				paperdoll.set_equipment_texture(item_data.get_paper_doll_texture(), "helmet")
			"shirt":
				equip_shirt = item
				set_armorvalue(item_data.armor_value, "shirt")
				paperdoll.set_equipment_texture(item_data.get_paper_doll_texture(), "shirt")
			"gloves":
				equip_gloves = item
				set_armorvalue(item_data.armor_value, "gloves")
				paperdoll.set_equipment_texture(item_data.get_paper_doll_texture(), "gloves")
			"pants":
				equip_pants = item
				set_armorvalue(item_data.armor_value, "pants")
				paperdoll.set_equipment_texture(item_data.get_paper_doll_texture(), "pants")

func remove_item_from_inventory(item: Dictionary) -> void:
	for i in range(NPCinv.size()):
		if NPCinv[i] != null and NPCinv[i]["data"] == item["data"]: #compare the data.
			NPCinv[i] = null
			return #important, remove only 1.

# --- reset items ---
func reset_helmet():
	equip_helmet = {"quantity": null, "data": null}
func reset_shirt():
	equip_shirt = {"quantity": null, "data": null}
func reset_pants():
	equip_pants = {"quantity": null, "data": null}
func reset_gloves():
	equip_gloves = {"quantity": null, "data": null}

# --- get equipped items ---
func get_helmet():
	return equip_helmet["data"]
func get_shirt():
	return equip_shirt["data"]
func get_pants():
	return equip_pants["data"]
func get_gloves():
	return equip_gloves["data"]
