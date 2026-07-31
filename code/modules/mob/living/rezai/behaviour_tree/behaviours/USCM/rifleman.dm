

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
	bt.child_nodes += new /datum/rezai/bt/node/sequence_node // change to selector & make follow SL one of the last behaviours in the selector.
	bboard.current_mob = arg_human
	//bboard.move_delay = bboard.current_mob.move_delay

	//create leaf node
	var/datum/rezai/bt/node/leaf_node/find_sl = new
	find_sl.behaviour = CALLBACK( src, PROC_REF(identify_squad_leader) )
	bt.child_nodes[1].child_nodes += find_sl

	var/datum/rezai/bt/node/leaf_node/move_to_sl_coherency = new
	move_to_sl_coherency.behaviour = CALLBACK( src, PROC_REF(follow_squad_leader) )
	bt.child_nodes[1].child_nodes += move_to_sl_coherency


/datum/rezai/bt/uscm/rifleman/proc/identify_squad_leader()
	//bboard.squad_leader_mob = bboard.current_mob.locate_squad_leader()
	bboard.squad_leader_mob = bboard.current_mob.locate_squad_leader()
	//message_admins("rezai find SL - rezzer")
	//human_mob.locate_squad_leader()
	if (bboard.squad_leader_mob)
		return BT_NODE_RETURN_SUCCESS
	return BT_NODE_RETURN_FAIL


/datum/rezai/bt/uscm/rifleman/proc/follow_squad_leader()
	if (!bboard.squad_leader_mob)
		return BT_NODE_RETURN_FAIL

	if (get_dist(bboard.current_mob, bboard.squad_leader_mob) <= bboard.squad_leader_coherency_distance)
		message_admins("rezai AT SL - rezzer")
		return BT_NODE_RETURN_SUCCESS

	message_admins("rezai moving to SL - rezzer")
	if ( bboard.next_move_time < world.time )
		bboard.next_move_time = world.time + bboard.current_mob.movement_delay()
		walk_to( bboard.current_mob, bboard.squad_leader_mob, bboard.squad_leader_coherency_distance, bboard.current_mob.movement_delay() )
		return BT_NODE_RETURN_PROCESSING
	// bboard.current_mob.move_delay

	return BT_NODE_RETURN_PROCESSING

