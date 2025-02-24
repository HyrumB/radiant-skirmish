
class_name NewWanderTarget extends ActionLeaf

@export var radius : float = 0

func tick(actor:Node, _blackboard:Blackboard) -> int:
	if !actor.is_on_floor():
		return FAILURE
			
	if radius == 0:
		actor.new_wander_target()
	else:
		actor.new_wander_target(radius)
	
	return SUCCESS
