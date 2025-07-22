#define PAUSE_TIME 6 SECONDS
#define MAX_RAILS_IN_NETWORK 16

//A manager for rails that are used to move a shooting target. Overwatches the target, the network "integrity" and new connections.
/datum/target_rail_manager
	var/network_id = 000000
	///unsorted rail list, they're in order of which user had wrenched them.
	var/list/complete_rail_list = list()
	/// a list after A* sorting, both ends of the rails located at ends of the list
	var/list/turf/sorted_list = list()
	///reference to the target itself.
	var/obj/structure/target/linked_target = null
	///Where the shooting target is at right now.
	var/obj/structure/shooting_target_rail/current_rail = null
	///Both ends of the rail network
	var/list/obj/structure/shooting_target_rail/rail_ends = list()
	///if we're currently moving and processing
	var/in_motion = FALSE
	///if we're going back or forward
	var/direction = TRUE
	///if the network is deemed invalid, and must be recreated to function.
	var/network_invalidated = FALSE
	///if we should be paused and not moving
	var/paused = FALSE

/datum/target_rail_manager/New()
	. = ..()
	network_id = rand(111111, 999999)


//if we allow more rails to be connected to the manager
/datum/target_rail_manager/proc/allow_connection()
	if(length(complete_rail_list) >= MAX_RAILS_IN_NETWORK)
		return FALSE
	if(in_motion)
		return FALSE
	return TRUE

/datum/target_rail_manager/Destroy(force, ...)
	. = ..()
	UnregisterSignal(linked_target, COMSIG_SHOOTING_TARGET_DOWN)

/datum/target_rail_manager/process(delta_time)
	if(!linked_target)
		STOP_PROCESSING(SSfastobj, src)
	if(!in_motion || paused)
		return
	if(LAZYACCESS(sorted_list, current_rail+1) && direction)
		walk_to(linked_target, sorted_list?[current_rail+1])
		current_rail = sorted_list.Find(sorted_list[current_rail+1])
	else
		if(!LAZYACCESS(sorted_list, current_rail-1))
			direction = TRUE
			walk_to(linked_target, sorted_list?[current_rail+1])
			current_rail = sorted_list.Find(sorted_list[current_rail+1])
			return
		direction = FALSE
		walk_to(linked_target, sorted_list?[current_rail-1])
		current_rail = sorted_list.Find(sorted_list[current_rail-1])

///assemble the rail list using astar, called once when a shooting target is installed.
/datum/target_rail_manager/proc/on_target_link(obj/structure/shooting_target_rail/dragged_rail)
	if(network_invalidated)
		return
	linked_target.anchored = TRUE
	find_corner_rails()
	sorted_list.Cut()
	sorted_list = AStar(get_turf(rail_ends[1]), get_turf(rail_ends[2]), /turf/proc/adjacent_turf_with_rails, /turf/proc/Distance, 0, 30) //right over here
	START_PROCESSING(SSfastobj, src)
	current_rail = sorted_list.Find(dragged_rail)
	RegisterSignal(linked_target, COMSIG_SHOOTING_TARGET_DOWN, PROC_REF(pause_movement))
	RegisterSignal(linked_target, COMSIG_PARENT_QDELETING, PROC_REF(target_unlink))
	in_motion = TRUE

/datum/target_rail_manager/proc/target_unlink()
	SIGNAL_HANDLER
	UnregisterSignal(linked_target, COMSIG_PARENT_QDELETING)
	linked_target = null

/datum/target_rail_manager/proc/invalidate_network(obj/structure/shooting_target_rail/deleted_rail)
	if(network_invalidated)
		return
	if(in_motion && linked_target)
		STOP_PROCESSING(SSfastobj, src)
		in_motion = FALSE
		linked_target.langchat_speech("Rail network was invalidated!", get_mobs_in_view(7, linked_target) , GLOB.all_languages, skip_language_check = TRUE)
		playsound(linked_target.loc, 'sound/machines/buzz-sigh.ogg', 50, 1, 7)
	if(linked_target)
		walk(linked_target, 0)
		linked_target.anchored = FALSE
		UnregisterSignal(linked_target, COMSIG_SHOOTING_TARGET_DOWN)
		UnregisterSignal(linked_target, COMSIG_PARENT_QDELETING)
		linked_target = null
	network_invalidated = TRUE
	var/deconstructed_index = sorted_list.Find(get_turf(deleted_rail))
	if(deconstructed_index > MAX_RAILS_IN_NETWORK/2)
		for(var/rail_up_for_deletion_turf in deconstructed_index+1 to MAX_RAILS_IN_NETWORK)
			var/obj/structure/shooting_target_rail/rail_up_for_deletion = locate(/obj/structure/shooting_target_rail) in sorted_list[rail_up_for_deletion_turf]
			qdel(rail_up_for_deletion)
		if(LAZYACCESS(sorted_list, deconstructed_index-1))
			var/obj/structure/shooting_target_rail/rail_update_icon = locate(/obj/structure/shooting_target_rail) in sorted_list[deconstructed_index-1]
			rail_update_icon.update_icon()
	else
		for(var/rail_up_for_deletion_turf in 1 to deconstructed_index-1)
			var/obj/structure/shooting_target_rail/rail_up_for_deletion = locate(/obj/structure/shooting_target_rail) in sorted_list[rail_up_for_deletion_turf]
			qdel(rail_up_for_deletion)
		if(LAZYACCESS(sorted_list, deconstructed_index+1))
			var/obj/structure/shooting_target_rail/rail_update_icon = locate(/obj/structure/shooting_target_rail) in sorted_list[deconstructed_index+1]
			rail_update_icon.update_icon()
	network_invalidated = FALSE


/datum/target_rail_manager/proc/pause_movement(obj/shooting_target, seconds = PAUSE_TIME)
	SIGNAL_HANDLER
	in_motion = FALSE
	addtimer(VARSET_CALLBACK(src, in_motion, TRUE), seconds)

/turf/proc/adjacent_turf_with_rails() //rules for assembling the list
	var/list/possible_directions = new()
	for(var/direction in GLOB.cardinals)
		var/turf/turf_direction = get_step(src, direction)
		if(istype(turf_direction) && !turf_direction.density)
			var/obj/structure/shooting_target_rail/rail_on_turf = locate(/obj/structure/shooting_target_rail) in turf_direction
			var/obj/structure/shooting_target_rail/rail_on_turf_dir = locate(/obj/structure/shooting_target_rail) in get_turf(src)
			if(rail_on_turf && rail_on_turf.manager_reference == rail_on_turf_dir.manager_reference)
				possible_directions.Add(turf_direction)
	return possible_directions


/datum/target_rail_manager/proc/find_corner_rails()
	rail_ends.Cut()
	for(var/obj/structure/shooting_target_rail/rail_in_list in complete_rail_list)
		if(length(rail_in_list.finalized_connection) == 1)
			rail_ends += rail_in_list



