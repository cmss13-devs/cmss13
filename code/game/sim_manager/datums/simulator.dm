/datum/simulator
	// Necessary to prevent multiple users from simulating at the same time. This needs to be shared across all instances.
	var/static/detonation_cooldown = 0

	var/looking_at_simulation = FALSE
	var/detonation_cooldown_time = 2 MINUTES
	var/dummy_mode = HUMAN_MODE
	var/obj/structure/machinery/camera/simulation/sim_camera

	var/list/target_types = list(
		HUMAN_MODE = /mob/living/carbon/human,
		UPP_MODE = /mob/living/carbon/human,
		CLF_MODE = /mob/living/carbon/human,
		RUNNER_MODE = /mob/living/carbon/xenomorph/runner,
		SPITTER_MODE = /mob/living/carbon/xenomorph/spitter,
		DEFENDER_MODE = /mob/living/carbon/xenomorph/defender,
		RAVAGER_MODE = /mob/living/carbon/xenomorph/ravager,
		CRUSHER_MODE = /mob/living/carbon/xenomorph/crusher,
	)

/datum/simulator/proc/start_watching(mob/living/user)
	if(!sim_camera)
		sim_camera = SAFEPICK(GLOB.simulator_cameras)
	if(!sim_camera)
		to_chat(user, SPAN_WARNING("GPU damaged! Unable to start simulation."))
		return
	if(user.client.view != world_view_size)
		to_chat(user, SPAN_WARNING("You're too busy looking at something else."))
		return
	user.reset_view(sim_camera)
	looking_at_simulation = TRUE

/datum/simulator/proc/stop_watching(mob/living/user)
	user.unset_interaction()
	user.reset_view(null)
	user.cameraFollow = null
	looking_at_simulation = FALSE

/datum/simulator/proc/spawn_mobs(mob/living/user)
	COOLDOWN_START(src, detonation_cooldown, detonation_cooldown_time)

	var/spawn_path = target_types[dummy_mode]

	for(var/spawn_loc in GLOB.simulator_targets)
		if(dummy_mode == HUMAN_MODE || dummy_mode == CLF_MODE || dummy_mode == UPP_MODE)
			var/mob/living/carbon/human/human_dummy = new spawn_path(get_turf(spawn_loc))
			switch(dummy_mode)
				if(CLF_MODE)
					user.client.cmd_admin_dress_human(human_dummy, "CLF Soldier", no_logs = TRUE)
				if(UPP_MODE)
					user.client.cmd_admin_dress_human(human_dummy, "UPP Conscript", no_logs = TRUE)
			human_dummy.name = "simulated human"
			QDEL_IN(human_dummy, detonation_cooldown_time - 10 SECONDS)
		else
			var/mob/living/carbon/xenomorph/xeno_dummy = new spawn_path(get_turf(spawn_loc))
			xeno_dummy.hardcore = TRUE
			QDEL_IN(xeno_dummy, detonation_cooldown_time - 10 SECONDS)
