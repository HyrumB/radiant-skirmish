extends Control

# scene-0tree node refrences
@onready var icon = $InnerBoarder/ItemIcon
@onready var quantity_label = $InnerBoarder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
#@onready var PlayerCharacter = get_node("/root/Main/Player")
@onready var equip_scene = preload("res://scenes/ui/inventory/UI_equip.tscn")


# slot item
var item = null

func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited():
	if item != null:
		details_panel.visible = false

func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible

#	create empty slots
func set_empty():
	#item.texture = null
	quantity_label.text = ""

#create items withnew_item dictionary	
func set_item(new_item):
	item = new_item
	icon.texture = item["data"].get_texture()
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["data"].get_item_name())
	item_type.text = str(item["data"].get_item_type())
	item_effect =  str(item["data"].get_item_effect())

func _on_use_button_pressed() -> void:
	if item["data"].get_item_type() == "Armor":
		var armor_type = item["data"].get_armor_type()
		match armor_type.to_lower():
			
			"helmet":
				GlobalEvents.set_helmet(item)
				#print("helmet")
				
			"pants":
				GlobalEvents.set_pants(item)
				#print("pants")
				
			"shirt":
				GlobalEvents.set_shirt(item)
				#print("shirt")
				
			"gloves":
				GlobalEvents.set_gloves(item)
				#print("gloves")
			
		
