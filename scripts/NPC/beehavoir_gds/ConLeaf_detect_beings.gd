extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
		
	if actor.get_hearing_colliders_groups("Player") || actor.get_hearing_colliders_groups(actor.outcast_group):
		
		return SUCCESS
		
	else:
		return FAILURE
