

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


/datum/rezai/bt/uscm/rifleman/proc/follow_squad_leader()
	bboard.current_mob.locate_squad_leader()
	//human_mob.locate_squad_leader()

