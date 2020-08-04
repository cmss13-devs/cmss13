var/datum/subsystem/item_cleanup/SSitem_cleanup

var/global/list/item_cleanup_list = list()

/datum/subsystem/item_cleanup
	name = "Item Cleanup"
	wait = MINUTES_10 //should be adjusted for WO
	var/start_processing_time = MINUTES_35 //should be adjusted for WO
	var/percentage_of_garbage_to_delete = 0.5 //should be adjusted for WO
	//We keep a separate, private list
	//So we don't get instant deletions of items
	//Each iteration we move items from the global list into here
	//And delete them during the next iteration
	var/list/items_to_clean_up = list()

/datum/subsystem/item_cleanup/New()
	..()
	NEW_SS_GLOBAL(SSitem_cleanup)
	SSitem_cleanup = src

/datum/subsystem/item_cleanup/fire()
	set background = 1
	if(world.time < start_processing_time)
		//Do nothing for the first 35 minutes to preserve the colony look for the first drop
		return

	var/to_delete = items_to_clean_up.len * percentage_of_garbage_to_delete
	var/deleted = 0
	var/total_items = items_to_clean_up.len //save total before we start deleting stuff
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
	while(!isnull(item_cleanup_list) && item_cleanup_list.len > 0)
		addToListNoDupe(items_to_clean_up, item_cleanup_list[item_cleanup_list.len])
		item_cleanup_list -= item_cleanup_list[item_cleanup_list.len]

	log_debug("item_cleanup deleted [deleted] garbage out of total [total_items]")

/datum/subsystem/item_cleanup/proc/delete_almayer()
	//Should only be called for Whiskey Outpost!
	delete_z_level(MAIN_SHIP_Z_LEVEL)

/datum/subsystem/item_cleanup/proc/delete_surface()
	//Should only be called when lag is really bad and everyone is off the surface, including the dropships
	delete_z_level(SURFACE_Z_LEVEL)

/datum/subsystem/item_cleanup/proc/delete_z_level(var/z_level)
	set background = 1
	for(var/atom/o in object_list)
		if(QDELETED(o) || isnull(o.loc))
			continue
		if(o.loc.z == z_level) //item is on the proper Z-level
			qdel(o)

/proc/add_to_garbage(var/atom/a)
	addToListNoDupe(item_cleanup_list, a)

/proc/remove_from_garbage(var/atom/a)
	item_cleanup_list -= a
	if(SSitem_cleanup)
		SSitem_cleanup.items_to_clean_up -= a