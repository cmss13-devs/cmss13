/datum/component/tracking_bullets
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/mob/living/shooter
	var/timerid
	var/ping_range = 9
	var/ping_accum = 0
	var/list/active_blips = list()

/datum/component/tracking_bullets/Initialize(mob/living/fired_by)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	shooter = fired_by
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_target_death))
	START_PROCESSING(SSdcs, src)
	timerid = addtimer(CALLBACK(src, PROC_REF(expire)), 10 SECONDS, TIMER_STOPPABLE)

/datum/component/tracking_bullets/InheritComponent(datum/component/tracking_bullets/old_component, is_dupe, mob/living/fired_by)
	if(timerid)
		deltimer(timerid)
	timerid = addtimer(CALLBACK(src, PROC_REF(expire)), 10 SECONDS, TIMER_STOPPABLE)

/datum/component/tracking_bullets/Destroy()
	if(timerid)
		deltimer(timerid)
		timerid = null
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, COMSIG_MOB_DEATH)
	for(var/list/blip_data as anything in active_blips)
		var/mob/living/carbon/human/viewer = blip_data[1]
		var/obj/effect/detector_blip/blip_effect = blip_data[2]
		if(viewer && viewer.client)
			viewer.client.remove_from_screen(blip_effect)
		qdel(blip_effect)
	active_blips = null
	shooter = null
	return ..()

/datum/component/tracking_bullets/proc/expire()
	timerid = null
	qdel(src)

/datum/component/tracking_bullets/proc/on_target_death(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/tracking_bullets/process(delta_time)
	if(QDELETED(parent))
		qdel(src)
		return

	ping_accum += delta_time
	if(ping_accum < 1)
		return
	ping_accum -= 1

	var/mob/living/tagged_mob = parent
	var/turf/target_turf = get_turf(tagged_mob)
	if(!target_turf)
		return

	var/datum/shape/rectangle/square/range_bounds = new
	range_bounds.set_shape(target_turf.x, target_turf.y, ping_range * 2)

	var/list/candidates = SSquadtree.players_in_range(range_bounds, target_turf.z, QTREE_FILTER_LIVING | QTREE_SCAN_MOBS)

	for(var/mob/living/carbon/human/viewer as anything in candidates)
		if(!ishuman(viewer))
			continue
		if(!viewer.client)
			continue
		if(viewer.stat != CONSCIOUS)
			continue
		if(!shooter || viewer.faction != shooter.faction)
			continue
		show_tracker_blip(viewer, tagged_mob)

	playsound(target_turf, pick('sound/items/detector_ping_1.ogg', 'sound/items/detector_ping_2.ogg', 'sound/items/detector_ping_3.ogg', 'sound/items/detector_ping_4.ogg'), 60, 0, 7, 2) // play even if nobody is present to simulate "its a bullet bro"

/datum/component/tracking_bullets/proc/show_tracker_blip(mob/living/carbon/human/viewer, mob/living/tagged_mob)
	if(!viewer.client)
		return
	if(QDELETED(tagged_mob))
		return

	var/obj/effect/detector_blip/blip_effect = new /obj/effect/detector_blip()

	var/c_view = viewer.client.view
	var/view_x_offset = 0
	var/view_y_offset = 0
	if(c_view > 7) //screenwide
		if(viewer.client.get_pixel_x() >= 0)
			view_x_offset = floor(viewer.client.get_pixel_x() / 32)
		else
			view_x_offset = ceil(viewer.client.get_pixel_x() / 32)
		if(viewer.client.get_pixel_y() >= 0)
			view_y_offset = floor(viewer.client.get_pixel_y() / 32)
		else
			view_y_offset = ceil(viewer.client.get_pixel_y() / 32)

	var/diff_dir_x = 0
	var/diff_dir_y = 0
	if(tagged_mob.x > viewer.x + c_view + view_x_offset)
		diff_dir_x = 4
	else if(tagged_mob.x < viewer.x - c_view + view_x_offset)
		diff_dir_x = 8
	if(tagged_mob.y > viewer.y + c_view + view_y_offset)
		diff_dir_y = 1
	else if(tagged_mob.y < viewer.y - c_view + view_y_offset)
		diff_dir_y = 2

	if(diff_dir_x || diff_dir_y)
		blip_effect.icon_state = "detector_blip_dir"
		blip_effect.setDir(diff_dir_x + diff_dir_y)
	else
		blip_effect.icon_state = "detector_blip"
		blip_effect.setDir(initial(blip_effect.dir))

	blip_effect.screen_loc = "[clamp(c_view + 1 - view_x_offset + (tagged_mob.x - viewer.x), 1, 2*c_view+1)],[clamp(c_view + 1 - view_y_offset + (tagged_mob.y - viewer.y), 1, 2*c_view+1)]"
	viewer.client.add_to_screen(blip_effect)

	var/list/blip_data = list(viewer, blip_effect)
	active_blips += list(blip_data)
	addtimer(CALLBACK(src, PROC_REF(clear_tracker_blip), viewer, blip_effect, blip_data), 1 SECONDS)

/datum/component/tracking_bullets/proc/clear_tracker_blip(mob/living/carbon/human/viewer, obj/effect/detector_blip/blip_effect, list/blip_data)
	active_blips -= list(blip_data)
	if(viewer && viewer.client)
		viewer.client.remove_from_screen(blip_effect)
	qdel(blip_effect)
