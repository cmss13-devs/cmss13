/obj/item/hardpoint/support/sensor_array
	name = "\improper AQ-133 Acquisition System"
	desc = "A heavy-duty array of sensors for the AD-19D chimera."

	icon_state = "warray"
	disp_icon = "tank"
	disp_icon_state = "warray"

	health = 250

	var/active = FALSE

	/// Range of the wallhacks
	var/sensor_radius = 45
	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()

/obj/item/hardpoint/support/sensor_array/proc/toggle()
	if(active)
		active = FALSE
		STOP_PROCESSING(SSslowobj, src)
		for(var/datum/weakref/xeno as anything in minimap_added)
			SSminimaps.remove_marker(xeno.resolve())
			minimap_added.Remove(xeno)
	else
		active = TRUE
		START_PROCESSING(SSslowobj, src)

/obj/item/hardpoint/support/sensor_array/process(delattime)
	var/turf/chimera_turf = get_turf(src)
	var/obj/vehicle/multitile/chimera/chimera_owner = owner
	if((health <= 0) || !chimera_owner.visible_in_tacmap || !is_ground_level(chimera_turf.z))
		return

	chimera_owner.battery = max(0, chimera_owner.battery - delattime)

	if(health <= 0 || chimera_owner.battery <= 0)
		for(var/datum/weakref/xeno as anything in minimap_added)
			SSminimaps.remove_marker(xeno.resolve())
			minimap_added.Remove(xeno)

		active = FALSE
		STOP_PROCESSING(SSslowobj, src)
		return

	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		var/turf/xeno_turf = get_turf(current_xeno)
		if(!is_ground_level(xeno_turf.z))
			continue

		var/datum/weakref/xeno_weakref = WEAKREF(current_xeno)

		if(get_dist(src, current_xeno) <= sensor_radius)
			if(xeno_weakref in minimap_added)
				continue

			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker(MINIMAP_FLAG_USCM|MINIMAP_FLAG_XENO)
			minimap_added += xeno_weakref
		else if(xeno_weakref in minimap_added)
			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker()
			minimap_added -= xeno_weakref
