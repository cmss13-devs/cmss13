#define RESOURCE_INCOME_TELECOMMS 0.15

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms
	var/datum/techtree/xeno_tree
	var/datum/techtree/marine_tree

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/process(delta_time)
	if(!toggled && !corrupted)
		STOP_PROCESSING(SSslowobj, src)
		return

	if(ROUND_TIME < XENO_COMM_ACQUISITION_TIME)
		return

	var/datum/techtree/tree
	if(corrupted)
		tree = xeno_tree
	else if(toggled)
		tree = marine_tree

	if(tree)
		tree.on_process()
		tree.add_points(RESOURCE_INCOME_TELECOMMS)

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/New()
	. = ..()
	marine_tree = GET_TREE(TREE_MARINE)
	xeno_tree = GET_TREE(TREE_XENO)

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/update_state()
	if(toggled)
		START_PROCESSING(SSslowobj, src)
	..()

/datum/techtree/marine/on_process()
	SSobjectives.comms.score_new_points(RESOURCE_INCOME_TELECOMMS)

#undef RESOURCE_INCOME_TELECOMMS
