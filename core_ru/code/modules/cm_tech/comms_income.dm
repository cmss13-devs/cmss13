#define RESOURCE_INCOME_TELECOMMS_DELAY 35 SECONDS
#define RESOURCE_INCOME_TELECOMMS 0.1

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/var/next_income = 0
/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/var/datum/techtree/xeno_tree
/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/var/datum/techtree/marine_tree

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/process(delta_time)
	if (!toggled && !corrupted)
		STOP_PROCESSING(SSobj, src)
		return

	var/datum/techtree/tree

	if (corrupted) tree = xeno_tree
	else if(toggled) tree = marine_tree
	else tree = null

	if (!tree)
		return

	if (next_income > 0)
		next_income -= 1
		return

	next_income = RESOURCE_INCOME_TELECOMMS_DELAY / 10

	if (tree)
		tree.on_process()
		tree.add_points(RESOURCE_INCOME_TELECOMMS)

#undef RESOURCE_INCOME_TELECOMMS_DELAY

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/New()
	. = ..()
	marine_tree = GET_TREE(TREE_MARINE)
	xeno_tree = GET_TREE(TREE_XENO)

/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/update_state()
	if (toggled)
		START_PROCESSING(SSobj, src)
	..()

/datum/techtree/marine/on_process()
	SSobjectives.comms.score_new_points(RESOURCE_INCOME_TELECOMMS)

/datum/techtree/xeno/on_process()
	SSobjectives.comms.score_new_points(RESOURCE_INCOME_TELECOMMS)
