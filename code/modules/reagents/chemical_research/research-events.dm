GLOBAL_DATUM_INIT(ddi_experiment, /datum/research_event/ddi_experiment, new)

/datum/research_event/ddi_experiment
	var/DDI_experiment_triggered = FALSE
	var/DDI_experiment_xeno = null
	var/timer
	var/total_points_given = 0

/datum/research_event/ddi_experiment/proc/trigger(xeno)
	if(DDI_experiment_triggered)
		return
	DDI_experiment_triggered = TRUE
	DDI_experiment_xeno = xeno

	ai_announcement("Notice: Unidentified lifesign detected at research containment created through DNA disintegration, analyzing data...")
	sleep(5 SECONDS)
	ai_announcement("Notice: Lifeform biostructural data can be analyzed further for tech point reward at a rate of 1 tech point per minute.")

	timer = world.time
	START_PROCESSING(SSprocessing, src)

/datum/research_event/ddi_experiment/process(delta_time)
	if(total_points_given >= 20)
		STOP_PROCESSING(SSprocessing, src)
		ai_announcement("Notice: Lifeform biostructural data fully analyzed, 20 total tech points and research credits awarded. Recommend termination of lifeform.")
		return

	var/mob/living/carbon/xenomorph/xeno = DDI_experiment_xeno
	var/area/xeno_loc = get_area(xeno.loc)

	if(!xeno || xeno.stat == DEAD || !istype(xeno_loc, /area/almayer/medical/containment))
		if(total_points_given < 20)
			ai_announcement("Notice: Lifeform terminated or missing, biostructrual data not fully analyzed. Only [total_points_given] out of [20] tech and research points awarded.")
			STOP_PROCESSING(SSprocessing, src)
			return

	if(world.time >= timer + 1 MINUTES)
		timer = world.time
		GLOB.chemical_data.update_credits(1)
		var/datum/techtree/tree = GET_TREE(TREE_MARINE)
		tree.add_points(1)
		total_points_given++
