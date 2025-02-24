extends Control

@onready var grid_container = $GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvents.inventory_updated.connect(_on_inventory_update)
	_on_inventory_update()



func _on_inventory_update():
	clear_grid_container()
	# add slot for each item in array
	for item in GlobalEvents.inv:
		var slot = GlobalEvents.inv_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
