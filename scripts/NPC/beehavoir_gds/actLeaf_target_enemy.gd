extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.set_target_last_enemy()
	return SUCCESS
