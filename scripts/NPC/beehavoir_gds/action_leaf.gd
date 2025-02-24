extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.deal_damage()
	return SUCCESS
