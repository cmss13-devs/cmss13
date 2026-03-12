SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 2
	init_order = SS_INIT_LIGHTING

	//debug var for tracking updates before init is complete
	var/duplicate_shadow_updates_in_init = 0
	///Total times shadows were updated, debug
	var/total_shadow_calculations = 0

	///Whether the SS has begun setting up yet
	var/started = FALSE

	var/static/list/static_sources_queue = list() //! List of static lighting sources queued for update.
	var/static/list/corners_queue = list() //! List of lighting corners queued for update.
	var/static/list/objects_queue = list() //! List of lighting objects queued for update.

	var/static/list/mask_queue = list() //! List of hybrid lighting sources queued for update.

/datum/controller/subsystem/lighting/Initialize(timeofday)
	started = TRUE
	if(!initialized)
		//Handle static lightnig
		create_all_lighting_objects()
	fire(FALSE, TRUE)
	return SS_INIT_SUCCESS


/datum/controller/subsystem/lighting/stat_entry()
	. = ..("ShCalcs:[total_shadow_calculations]|SourcQ:[length(static_sources_queue)]|CcornQ:[length(corners_queue)]|ObjQ:[length(objects_queue)]|HybrQ:[length(mask_queue)]")

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(4)
	if(!init_tick_checks)
		MC_SPLIT_TICK
	// anything added while processing gets deferred to the next tick
	var/current_index = 0
	while(current_index < length(static_sources_queue))
		current_index += 1
		var/datum/static_light_source/source = static_sources_queue[current_index]
		source.update_corners()
		// source.update_corners() can qdel(source) in certain conditions,
		// and we don't include them in the count to cut because they're already removed
		if(!QDELING(source))
			source.needs_update = LIGHTING_NO_UPDATE
		else
			current_index -= 1
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			static_sources_queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		static_sources_queue.Cut(1, current_index + 1)
		current_index = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	while(current_index < length(corners_queue))
		current_index += 1
		var/datum/static_lighting_corner/corner = corners_queue[current_index]
		corner.update_objects()
		corner.needs_update = FALSE //update_objects() can call qdel if the corner is storing no data
		if(QDELING(corner))
			current_index -= 1

		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			corners_queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		corners_queue.Cut(1, current_index + 1)
		current_index = 0
	if(!init_tick_checks)
		MC_SPLIT_TICK

	while(current_index < length(objects_queue))
		current_index += 1
		var/atom/movable/static_lighting_object/lighting_object = objects_queue[current_index]
		// these can't delete themselves in update() and so nothing in this should be qdeleted
		ASSERT(!QDELETED(lighting_object))
		lighting_object.update()
		lighting_object.needs_update = FALSE
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			objects_queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		objects_queue.Cut(1, current_index + 1)
		current_index = 0
	if(!init_tick_checks)
		MC_SPLIT_TICK

	while(current_index < length(mask_queue))
		current_index += 1
		var/atom/movable/lighting_mask/mask_to_update = mask_queue[current_index]
		ASSERT(!QDELETED(mask_to_update)) // nothing in this list should be qdeleted when we loop
		mask_to_update.calculate_lighting_shadows()
		if(init_tick_checks)
			if(!TICK_CHECK)
				continue
			mask_queue.Cut(1, current_index + 1)
			current_index = 0
			stoplag()
		else if (MC_TICK_CHECK)
			break
	if(current_index)
		mask_queue.Cut(1, current_index + 1)

/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	return ..()
