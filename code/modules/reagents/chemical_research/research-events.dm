GLOBAL_DATUM_INIT(ddi_experiment, /datum/research_event/ddi_experiment, new)
#define MAX_POINTS 20

/datum/research_event/ddi_experiment
	var/DDI_experiment_triggered = FALSE
	var/mob/living/carbon/xenomorph/linked_xeno = null
	var/client/player = null
	var/timer
	var/total_points_given = 0

/datum/research_event/ddi_experiment/proc/get_mind(mob/living/new_xeno)
	SIGNAL_HANDLER
	player = new_xeno.client

/datum/research_event/ddi_experiment/proc/trigger(xeno)
	if(DDI_experiment_triggered)
		return
	DDI_experiment_triggered = TRUE
	linked_xeno = xeno
	if(linked_xeno.client)
		player = linked_xeno.client
	RegisterSignal(linked_xeno, COMSIG_MOB_NEW_MIND, PROC_REF(get_mind)) //this works as long as the client is not forcefully set by admins

	ai_announcement("Notice: Unidentified lifesign detected at research containment created through DNA disintegration, analyzing data...")
	sleep(5 SECONDS)
	ai_announcement("Notice: Lifeform biostructural data can be analyzed further for tech point reward at a rate of 1 point per minute.")

	timer = world.time
	START_PROCESSING(SSprocessing, src)

/datum/research_event/ddi_experiment/process(delta_time)
	if(total_points_given >= 20)
		STOP_PROCESSING(SSprocessing, src)
		ai_announcement("Notice: Lifeform biostructural data fully analyzed, 20 total tech points awarded. Recommend termination of lifeform.")
		return

	if(QDELETED(linked_xeno)) //they must have evolved
		if(QDELETED(player.mob)) //no new mob? they got deleted
			ai_announcement("Notice: Lifeform terminated or missing, biostructural data not fully analyzed. Only [total_points_given] out of [20] tech points awarded.")
			STOP_PROCESSING(SSprocessing, src)
			return
		linked_xeno = player.mob //get the updated mob from the client

	var/area/xeno_loc = get_area(linked_xeno.loc)

	if(linked_xeno.stat == DEAD || !istype(xeno_loc, /area/almayer/medical/containment)) //you let it escape or die. idiot
		if(total_points_given < MAX_POINTS)
			ai_announcement("Notice: Lifeform terminated or missing, biostructural data not fully analyzed. Only [total_points_given] out of [20] tech points awarded.")
			STOP_PROCESSING(SSprocessing, src)
			return

	if(world.time >= timer + 1 MINUTES)
		timer = world.time
		var/datum/techtree/tree = GET_TREE(TREE_MARINE)
		tree.add_points(1)
		total_points_given++

#undef MAX_POINTS
