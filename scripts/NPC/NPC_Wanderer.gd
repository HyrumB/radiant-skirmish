
extends NpcRootScript
class_name NpcWanderer


var enemy : Node3D

@export_category("Enemy Agent Settings")

@export var melee_range : float = 2

func _on_sleep_timer_timeout() -> void:
	wake_up()
