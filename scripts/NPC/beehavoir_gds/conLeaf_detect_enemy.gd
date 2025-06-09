class_name InRange extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.is_raycast_colliding():
		return SUCCESS
	else:
		return FAILURE
