/datum/simulator

	// Necessary to prevent multiple users from simulating at the same time.
	var/static/detonation_cooldown = 0
	var/static/sim_reboot_state = TRUE

	var/looking_at_simulation = FALSE
	var/detonation_cooldown_time = 2 MINUTES
	var/dummy_mode = CLF_MODE
	var/obj/structure/machinery/camera/simulation/sim_camera
	var/grid_clearing_size = 16

	// garbage collection,
	var/static/list/delete_targets = list()

	/*
	unarmoured humans are unnencessary clutter as they tend to explode easily
	and litter the sim room with body parts, best left out.
	*/
	var/static/list/target_types = list(
		UPP_MODE = /mob/living/carbon/human,
		CLF_MODE = /mob/living/carbon/human,
		RUNNER_MODE = /mob/living/carbon/xenomorph/runner,
		SPITTER_MODE = /mob/living/carbon/xenomorph/spitter,
		DEFENDER_MODE = /mob/living/carbon/xenomorph/defender,
		RAVAGER_MODE = /mob/living/carbon/xenomorph/ravager,
		CRUSHER_MODE = /mob/living/carbon/xenomorph/crusher,
	)

/datum/simulator/proc/start_watching(mob/living/user)

	if(looking_at_simulation)
		to_chat(user, SPAN_WARNING("You are already looking at the simulation."))
		return
	if(!sim_camera)
		sim_camera = SAFEPICK(GLOB.simulator_cameras)
	if(!sim_camera)
		to_chat(user, SPAN_WARNING("GPU damaged! Unable to start simulation."))
		return
	if(user.client.view != GLOB.world_view_size)
		to_chat(user, SPAN_WARNING("You're too busy looking at something else."))
		return
	user.reset_view(sim_camera)
	looking_at_simulation = TRUE

/datum/simulator/proc/stop_watching(mob/living/user)
	user.unset_interaction()
	user.reset_view(null)
	user.cameraFollow = null
	looking_at_simulation = FALSE

/datum/simulator/proc/sim_turf_garbage_collection()

	// initial grid needs an offset to the bottom left so it can get the most coverage within the users pov.
	var/turf/sim_grid_start_pos = locate(sim_camera.x - 9,sim_camera.y - 9,1)
	if(!sim_grid_start_pos)
		sim_reboot_state = FALSE
		return

	QDEL_LIST(delete_targets)

	// 16x16 grid, clears from left to right like so
	// the user's pov should be near the center of the grid.
	/*
	y:16| x: 1 2 3 4 ... 16
	... | ...
	y:2 | x: 1 2 3 4 ... 16
	y:1 | x: 1 2 3 4 ... 16
	*/
	for (var/y_pos in 1 to grid_clearing_size)// outer y
		for (var/x_pos in 1 to grid_clearing_size) // inner x
			var/turf/current_grid = locate(sim_grid_start_pos.x + x_pos,sim_grid_start_pos.y + y_pos,sim_grid_start_pos.z)

			current_grid.empty(/turf/open/floor/engine)

/datum/simulator/proc/spawn_mobs(mob/living/user)

	if(!sim_reboot_state)
		to_chat(user, SPAN_WARNING("GPU damaged! Unable to start simulation."))
		return

	COOLDOWN_START(src, detonation_cooldown, detonation_cooldown_time)

	var/spawn_path = target_types[dummy_mode]
	for(var/spawn_loc in GLOB.simulator_targets)
		if( dummy_mode == CLF_MODE || dummy_mode == UPP_MODE)
			var/mob/living/carbon/human/human_dummy = new spawn_path(get_turf(spawn_loc))
			switch(dummy_mode)
				if(CLF_MODE)
					user.client.cmd_admin_dress_human(human_dummy, "CLF Soldier", no_logs = TRUE)
				if(UPP_MODE)
					user.client.cmd_admin_dress_human(human_dummy, "UPP Conscript", no_logs = TRUE)
			human_dummy.name = "simulated human"

			delete_targets += human_dummy
			continue

		var/mob/living/carbon/xenomorph/xeno_dummy = new spawn_path(get_turf(spawn_loc))
		xeno_dummy.hardcore = TRUE
		delete_targets += xeno_dummy

	addtimer(CALLBACK(src, PROC_REF(sim_turf_garbage_collection)), 30 SECONDS, TIMER_STOPPABLE)

