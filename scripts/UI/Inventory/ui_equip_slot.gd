extends Control

# scene-0tree node refrences
@onready var icon = $InnerBoarder/ItemIcon
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel

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
	pass
	
#create items withnew_item dictionary
func set_item(new_item):
	item = new_item
	icon.texture = item["texture"]
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else:
		item_effect.text = ""
		
