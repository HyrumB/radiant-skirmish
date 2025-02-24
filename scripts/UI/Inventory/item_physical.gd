extends RigidBody3D

@export var item_data : Item

@export var item_quantity:int

var scene_path: String = "res://scripts/item_physical.gd" 

var player_in_range = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#item._init()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		pickup_item()

func pickup_item():
		var item = {
			"quantity": item_quantity,
			"data": item_data,
		}
		
		if GlobalEvents.player_node:
			GlobalEvents.add_item(item)
			self.queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		body.interact_ui.visible = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		body.interact_ui.visible = false
