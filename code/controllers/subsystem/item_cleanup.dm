GLOBAL_LIST_EMPTY(item_cleanup_list)

SUBSYSTEM_DEF(item_cleanup)
	name = "Item Cleanup"
	wait = 10 MINUTES //should be adjusted for WO
	var/start_processing_time = 35 MINUTES //should be adjusted for WO
	var/percentage_of_garbage_to_delete = 0.5 //should be adjusted for WO
	//We keep a separate, private list
	//So we don't get instant deletions of items
	//Each iteration we move items from the global list into here
	//And delete them during the next iteration
	var/list/items_to_clean_up = list()
	flags = SS_NO_INIT

/datum/controller/subsystem/item_cleanup/fire()
	set background = 1
	if(world.time < start_processing_time)
		//Do nothing for the first 35 minutes to preserve the colony look for the first drop
		return

	var/to_delete = length(items_to_clean_up) * percentage_of_garbage_to_delete
	var/deleted = 0
	var/total_items = length(items_to_clean_up) //save total before we start deleting stuff
	for (var/atom/o in items_to_clean_up)
		if(QDELETED(o))
			items_to_clean_up -= o
			remove_from_garbage(o)
		else if(isnull(o.loc) || isturf(o.loc)) //item is in null (probably a decal), or on the ground (as in, not on a person, but on a turf)
			items_to_clean_up -= o
			qdel(o)
			deleted++
		if(deleted > to_delete)
			//we've deleted enough, end
			break

	//We transfer items from the global garbage list onto the next iteration list
	while(!isnull(GLOB.item_cleanup_list) && length(GLOB.item_cleanup_list) > 0)
		addToListNoDupe(items_to_clean_up, GLOB.item_cleanup_list[length(GLOB.item_cleanup_list)])
		GLOB.item_cleanup_list -= GLOB.item_cleanup_list[length(GLOB.item_cleanup_list)]

	log_debug("item_cleanup deleted [deleted] garbage out of total [total_items]")

/datum/controller/subsystem/item_cleanup/proc/delete_almayer(ensure_observer_landmark_ground = TRUE)
	delete_z_level(SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP))
	if(ensure_observer_landmark_ground && !length(GLOB.observer_starts))
		var/turf/center = SSmapping.get_ground_center()
		new /obj/effect/landmark/observer_start(center)

/datum/controller/subsystem/item_cleanup/proc/delete_surface(ensure_observer_landmark_ship = TRUE)
	//Should only be called when lag is really bad and everyone is off the surface, including the dropships
	delete_z_level(SSmapping.levels_by_trait(ZTRAIT_GROUND))
	if(ensure_observer_landmark_ship && !length(GLOB.observer_starts))
		var/turf/center = SSmapping.get_mainship_center()
		new /obj/effect/landmark/observer_start(center)

/datum/controller/subsystem/item_cleanup/proc/delete_z_level(list/z_levels)
	set background = 1
	for(var/obj/thing in world)
		if(QDELETED(thing) || isnull(thing.loc))
			continue
		if(thing.loc.z in z_levels) //obj is on the proper Z-level
			qdel(thing)
	for(var/mob/moob as anything in GLOB.living_mob_list)
		if(QDELETED(moob) || isnull(moob.loc))
			continue
		if(moob.loc.z in z_levels) //living mob is on the proper Z-level
			qdel(moob)

/proc/add_to_garbage(atom/a)
	addToListNoDupe(GLOB.item_cleanup_list, a)

/proc/remove_from_garbage(atom/a)
	GLOB.item_cleanup_list -= a
	if(SSitem_cleanup)
		SSitem_cleanup.items_to_clean_up -= a
