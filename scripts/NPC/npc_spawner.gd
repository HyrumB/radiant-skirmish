extends Node3D

# --- public ---
@export var mob_scene: PackedScene

@export var spawn_radius : float
@export var spawn_count : int

@onready var timer = $spawn_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	if spawn_count != 0:
		var mob = mob_scene.instantiate()
		 #Spawn the mob by adding it to the Main scene.
		add_child(mob)
		spawn_count -= 1
