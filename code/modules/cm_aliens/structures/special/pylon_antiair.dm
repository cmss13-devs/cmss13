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


/obj/effect/alien/resin/special/antiair_pylon/proc/can_build_here(turf/target_turf)
	if(!target_turf)
		return FALSE

	// Must be built on hive weeds
	var/obj/effect/alien/weeds/weeds_on_turf = locate() in target_turf
	if(!weeds_on_turf)
		return FALSE

	// Must be on weeds from the same hive
	if(weeds_on_turf.linked_hive != linked_hive)
		return FALSE

	if(!weeds_on_turf.weed_strength || weeds_on_turf.weed_strength < WEED_LEVEL_HIVE)
		return FALSE

	return TRUE

/obj/effect/alien/resin/special/antiair_pylon/proc/apply_antiair_field()
	var/turf/center = get_turf(src)
	if(!center)
		return

	protected_turfs.Cut()

	for(var/turf/protected_turf in range(protection_range, center))
		var/already_protected = (protected_turf.turf_protection_flags & TURF_PROTECTION_ANTIAIR)

		protected_turf.turf_protection_flags |= TURF_PROTECTION_ANTIAIR
		if(!protected_turf.antiair_effect_type)
			protected_turf.antiair_effect_type = /datum/dropship_antiair/boiler_corrosion
		// Set the antiair applier to reference this pylon's hive for announcements
		if(!protected_turf.antiair_applier)
			protected_turf.antiair_applier = linked_hive
		protected_turfs += protected_turf

		// Only create overlays if this turf wasn't already protected
		if(!already_protected)
			// Create protection flag overlay for pilots to see
			if(!protected_turf.protection_flag_overlay)
				protected_turf.protection_flag_overlay = new /obj/effect/overlay/temp/protection_flag/antiair(protected_turf)

			// Visual telegraph for pylons, idk if it's too distracting so only boiler/queen skyspit shows it for now
			//if(!protected_turf.skyspit_overlay)
			//	protected_turf.skyspit_overlay = new /obj/effect/xenomorph/xeno_telegraph/antiair(protected_turf, -1) // -1 = permanent

/obj/effect/alien/resin/special/antiair_pylon/proc/remove_antiair_field()
	for(var/turf/protected_turf as anything in protected_turfs)
		if(!protected_turf)
			continue

		// Check if this turf is still protected by other systems or pylons
		var/still_protected = FALSE

		// Check for other antiair pylons
		for(var/obj/effect/alien/resin/special/antiair_pylon/other_pylon in range(protection_range, protected_turf))
			if(other_pylon != src && !QDELETED(other_pylon))
				still_protected = TRUE
				break

		// Check for active skyspit in this area
		if(!still_protected && protected_turf.skyspit_active)
			still_protected = TRUE

		if(!still_protected)
			protected_turf.turf_protection_flags &= ~TURF_PROTECTION_ANTIAIR
			protected_turf.antiair_effect_type = null
			protected_turf.antiair_applier = null
			// Only remove overlays if we're sure no other protection systems need them
			if(protected_turf.protection_flag_overlay)
				qdel(protected_turf.protection_flag_overlay)
				protected_turf.protection_flag_overlay = null
			if(protected_turf.skyspit_overlay)
				qdel(protected_turf.skyspit_overlay)
				protected_turf.skyspit_overlay = null

	protected_turfs.Cut()
