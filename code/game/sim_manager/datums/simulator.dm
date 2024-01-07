#define LOWER_BOUND 0
#define UPPER_BOUND 1

/datum/simulator

	// Necessary to prevent multiple users from simulating at the same time.
	var/static/detonation_cooldown = 0
	var/static/detonation_cooldown_time = 2 MINUTES
	var/static/sim_reboot_state = TRUE

	var/dummy_mode = CLF_MODE
	var/obj/structure/machinery/camera/simulation/sim_camera

	// garbage collection,
	var/static/list/delete_targets = list()
	// used in the garbage collection proc to clear from the lower and upper bounds of the sim room.
	var/turf/lower_bound
	var/turf/upper_bound

	// list of users currently inside the simulator
	var/static/list/users_in_sim = list()

	var/static/list/target_types = list(
		HUMAN_MODE = /mob/living/carbon/human,
		UPP_MODE = /mob/living/carbon/human,
		CLF_MODE = /mob/living/carbon/human,
		RUNNER_MODE = /mob/living/carbon/xenomorph/runner,
		SPITTER_MODE = /mob/living/carbon/xenomorph/spitter,
		DEFENDER_MODE = /mob/living/carbon/xenomorph/defender,
		RAVAGER_MODE = /mob/living/carbon/xenomorph/ravager,
		CRUSHER_MODE = /mob/living/carbon/xenomorph/crusher,
	)


/datum/simulator/New()
	. = ..()
	sim_camera = SAFEPICK(GLOB.simulator_cameras)
	// could of hard coded it, but I guess it's better to be safe if someone chooses to modify the sim room size in the future.
	lower_bound = locate_sim_bound(sim_camera.x, sim_camera.y, sim_camera.z, bound_type = LOWER_BOUND)
	upper_bound = locate_sim_bound(sim_camera.x, sim_camera.y, sim_camera.z, bound_type = UPPER_BOUND)

/datum/simulator/proc/start_watching(mob/living/user)

	if(user in users_in_sim)
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
	users_in_sim += user

/datum/simulator/proc/stop_watching(mob/living/user)
	if(!(user in users_in_sim))
		return
	user.unset_interaction()
	user.reset_view(null)
	user.cameraFollow = null
	users_in_sim -= user

/datum/simulator/proc/sim_turf_garbage_collection()

	if(!sim_camera)
		sim_reboot_state = FALSE
		return

	QDEL_LIST(delete_targets)

	// clears from left to right like so
	/*
	... | ...
	y:2 | x: 1 2 3 4 ...
	y:1 | x: 1 2 3 4 ...
	*/
	for (var/y_pos in 1 to (upper_bound.y - lower_bound.y))// outer y
		for (var/x_pos in 1 to (upper_bound.x - lower_bound.x)) // inner x
			var/turf/current_turf = locate(lower_bound.x + x_pos, lower_bound.y + y_pos, lower_bound.z)
			current_turf.empty(/turf/open/floor/engine)

/**
 * Recursive function that finds the lower or upper bound for the sim room, assumption being the sim room size may be changed in the future.
 * Maybe better to just find the upper and lower bounds via the area's turf on init?
 *
 * Arguments:
 * * x_pos: x coordinate value on a grid plane
 * * y_pos: y coordinate value on a grid plane
 * * z_pos: y coordinate value on a grid plane
 * * bound_type: determines where the grid coordinates iterate to, either the upper right or lower left corner.
 *
 */
/datum/simulator/proc/locate_sim_bound(x_pos, y_pos, z_pos, bound_type)
	var/valid_turf
	var/turf/current_turf = locate(x_pos, y_pos, z_pos)
	if(current_turf.density)
		return FALSE

	if(bound_type == LOWER_BOUND)
		valid_turf = locate_sim_bound(current_turf.x - 1, current_turf.y, current_turf.z, bound_type)
		if(valid_turf)
			current_turf = valid_turf
		valid_turf = locate_sim_bound(current_turf.x, current_turf.y - 1, current_turf.z, bound_type)
		if(valid_turf)
			current_turf = valid_turf
	else
		valid_turf = locate_sim_bound(current_turf.x + 1,  current_turf.y, current_turf.z, bound_type)
		if(valid_turf)
			current_turf = valid_turf
		valid_turf = locate_sim_bound(current_turf.x, current_turf.y + 1,  current_turf.z, bound_type)
		if(valid_turf)
			current_turf = valid_turf

	return current_turf


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

#undef LOWER_BOUND
#undef UPPER_BOUND
