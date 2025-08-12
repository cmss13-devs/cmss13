/obj/effect/alien/resin/special/antiair_pylon
	name = XENO_STRUCTURE_PYLON_ANTIAIR
	desc = "A tall, bulbous structure that pulsates and writhes with acid. It seems to constantly emit an acidic gas passively into the sky."
	icon = 'icons/mob/xenos/structures64x64.dmi'
	icon_state = "pylon_antiair"

	light_system = MOVABLE_LIGHT

	health = 1000
	block_range = 0

	var/list/protected_turfs = list()
	var/protection_range = 5 // 11x11

/obj/effect/alien/resin/special/antiair_pylon/Initialize(mapload, hive_ref)
	. = ..()
	set_light(3, 3, COLOR_GREEN)
	apply_antiair_field()
	update_minimap_icon()

/obj/effect/alien/resin/special/antiair_pylon/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_XENO, "antiair_pylon")

/obj/effect/alien/resin/special/antiair_pylon/Destroy()
	set_light(0)
	remove_antiair_field()
	SSminimaps.remove_marker(src)
	return ..()

/obj/effect/alien/resin/special/antiair_pylon/proc/can_build_here(turf/T)
	if(!T)
		return FALSE

	// Must be built on hive weeds
	var/obj/effect/alien/weeds/W = locate() in T
	if(!W)
		return FALSE

	// Must be on weeds from the same hive
	if(W.linked_hive != linked_hive)
		return FALSE

	if(!W.weed_strength || W.weed_strength < WEED_LEVEL_HIVE)
		return FALSE

	return TRUE

/obj/effect/alien/resin/special/antiair_pylon/proc/apply_antiair_field()
	var/turf/center = get_turf(src)
	if(!center)
		return

	protected_turfs.Cut()

	for(var/turf/T in range(protection_range, center))
		var/already_protected = (T.turf_protection_flags & TURF_PROTECTION_ANTIAIR)

		T.turf_protection_flags |= TURF_PROTECTION_ANTIAIR
		if(!T.antiair_effect_type)
			T.antiair_effect_type = /datum/dropship_antiair/boiler_corrosion
		// Set the antiair applier to reference this pylon's hive for announcements
		if(!T.antiair_applier)
			T.antiair_applier = linked_hive
		protected_turfs += T

		// Only create overlays if this turf wasn't already protected
		if(!already_protected)
			// Create protection flag overlay for pilots to see
			if(!T.protection_flag_overlay)
				T.protection_flag_overlay = new /obj/effect/overlay/temp/protection_flag/antiair(T)

			// Visual telegraph for pylons, idk if it's too distracting so only boiler/queen skyspit shows it for now
			//if(!T.skyspit_overlay)
			//	T.skyspit_overlay = new /obj/effect/xenomorph/xeno_telegraph/antiair(T, -1) // -1 = permanent

/obj/effect/alien/resin/special/antiair_pylon/proc/remove_antiair_field()
	for(var/turf/T as anything in protected_turfs)
		if(!T)
			continue

		// Check if this turf is still protected by other systems or pylons
		var/still_protected = FALSE

		// Check for other antiair pylons
		for(var/obj/effect/alien/resin/special/antiair_pylon/other_pylon in range(protection_range, T))
			if(other_pylon != src && !QDELETED(other_pylon))
				still_protected = TRUE
				break

		// Check for active skyspit in this area
		if(!still_protected && T.skyspit_active)
			still_protected = TRUE

		if(!still_protected)
			T.turf_protection_flags &= ~TURF_PROTECTION_ANTIAIR
			T.antiair_effect_type = null
			T.antiair_applier = null
			// Only remove overlays if we're sure no other protection systems need them
			if(T.protection_flag_overlay)
				qdel(T.protection_flag_overlay)
				T.protection_flag_overlay = null
			if(T.skyspit_overlay)
				qdel(T.skyspit_overlay)
				T.skyspit_overlay = null

	protected_turfs.Cut()
