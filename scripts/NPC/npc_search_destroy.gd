extends NpcRootScript
class_name NpcSearchDestroy

var dum = 10



func _on_sleep_timer_timeout() -> void:
	wake_up()
