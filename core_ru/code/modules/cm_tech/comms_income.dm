#define RESOURCE_INCOME_TELECOMMS_DELAY 60 SECONDS
#define RESOURCE_INCOME_TELECOMMS 0.3

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms
	var/next_income_timer = 0
	var/datum/techtree/xeno_tree
	var/datum/techtree/marine_tree

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/process(delta_time)
	if(!toggled && !corrupted)
		STOP_PROCESSING(SSobj, src)
		return

	if(world.time < next_income_timer)
		return

	next_income_timer = world.time + RESOURCE_INCOME_TELECOMMS_DELAY

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
		START_PROCESSING(SSobj, src)
	..()

/datum/techtree/marine/on_process()
	SSobjectives.comms.score_new_points(RESOURCE_INCOME_TELECOMMS)

#undef RESOURCE_INCOME_TELECOMMS_DELAY
#undef RESOURCE_INCOME_TELECOMMS
