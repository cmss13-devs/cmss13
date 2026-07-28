#define BT_NODE_DECORATOR 1 // For modifying the underlying node. IE "If success then return false" for a negative decorator or whatever custom thing you do.
#define BT_NODE_LEAF 2 // "Behavior"
//following are the control nodes - normally I'd list first but there are more types that can be created and fewer line changes is good and keeping numbers is also cool.
#define BT_NODE_SEQUENCE 3 // executes nodes in order until one fails, then goes up to parent.
#define BT_NODE_SELECTOR 4	// executes nodes in order until one succeeds then goes to the parent.
#define BT_NODE_PARALLEL_UNTIL_ONE_SUCCEED 5 // executes all nodes at the same time until one suceeds, then it goes to the parent.
#define BT_NODE_PARALLEL_UNTIL_ONE_SUCCEED_OR_FAIL 6 // executes all nodes at the same time until one suceeds or fails, then goes to the parent.


#define BT_NODE_RETURN_SUCCESS 1
#define BT_NODE_RETURN_FAIL 2
#define BT_NODE_RETURN_PROCESSING 3


/datum/rezai/bt/node/
	var/datum/rezai/bt/parent
	var/list/datum/rezai/bt/node/child_nodes = list()
	var/current_index = 1
	var/node_type
	var/datum/rezai/bt/node/decorator/pre_decorator
	//var/post_decorator
	proc/update()
		if ( !isnull(pre_decorator) )
			pre_decorator.update()
		// override
	proc/reset()
		current_index = 1
		for( var/datum/rezai/bt/node/child in child_nodes )
			child.reset()

//actual tree - derrives from node
/datum/rezai/bt/node/behaviour_tree/
	//var/datum/rezai/bt/blackboard/bboard
	//var/datum/rezai/bt/node/root_node
	update()
		//message_admins("updating muh ai - rezzer")
		if( child_nodes[1] )
			if ( child_nodes[1].update() != BT_NODE_RETURN_PROCESSING )
				reset()



/datum/rezai/bt/node/sequence_node/
	node_type = BT_NODE_SEQUENCE
	update()
		..() // parent update for decorator
		if ( child_nodes.len < 1 || current_index > child_nodes.len )
			return BT_NODE_RETURN_SUCCESS
		var/child_return = child_nodes[current_index].update()
		if ( child_return == BT_NODE_RETURN_FAIL )
			return BT_NODE_RETURN_FAIL
		if ( child_return == BT_NODE_RETURN_SUCCESS )
			current_index += 1
			if (current_index <= child_nodes.len)
				child_nodes[current_index].reset()
		return BT_NODE_RETURN_PROCESSING

/datum/rezai/bt/node/selector_node/
	node_type = BT_NODE_SELECTOR
	update()
		..() // parent update for decorator
		if ( child_nodes.len < 1 || current_index > child_nodes.len )
			return BT_NODE_RETURN_SUCCESS
		var/child_return = child_nodes[current_index].update()
		if ( child_return == BT_NODE_RETURN_FAIL )
			current_index += 1
			if (current_index <= child_nodes.len)
				child_nodes[current_index].reset()
			if ( current_index > child_nodes.len )
				return BT_NODE_RETURN_FAIL
		if ( child_return == BT_NODE_RETURN_SUCCESS )
			return BT_NODE_RETURN_SUCCESS
		return BT_NODE_RETURN_PROCESSING


/datum/rezai/bt/node/decorator/
	var/foobar = 1


/datum/rezai/bt/node/leaf_node/
	node_type = BT_NODE_LEAF
	var/datum/callback/behaviour
	update()
		..()
		if (!behaviour)
			return BT_NODE_RETURN_FAIL
		return behaviour.Invoke()
