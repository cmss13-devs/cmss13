

/datum/rezai/bt/uscm/rifleman
	//bt.child_nodes[1]
	var/datum/rezai/bt/node/behaviour_tree/bt
	var/datum/rezai/bt/blackboard/mob/uscm/bboard
	proc/update()
		bt.update()

/datum/rezai/bt/uscm/rifleman/New(arg_human)
	. = ..()
	bt = new
	bboard = new
	bt.child_nodes += new /datum/rezai/bt/node/selector_node
	bboard.current_mob = arg_human

	//create leaf node
	var/datum/rezai/bt/node/leaf_node/find_sl = new
	find_sl.behaviour = CALLBACK( src, PROC_REF(follow_squad_leader) )
	bt.child_nodes[1].child_nodes += find_sl


/datum/rezai/bt/uscm/rifleman/proc/follow_squad_leader()
	//bboard.squad_leader_mob = bboard.current_mob.locate_squad_leader()
	bboard.squad_leader_mob = bboard.current_mob.locate_squad_leader()
	message_admins("rezai find SL - rezzer")
	//human_mob.locate_squad_leader()
	if (bboard.squad_leader_mob)
		return BT_NODE_RETURN_SUCCESS
	return BT_NODE_RETURN_FAIL

