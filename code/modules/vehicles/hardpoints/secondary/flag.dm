#define PLANTED_FLAG_BUFF 4
#define PLANTED_FLAG_RANGE 11

/obj/item/hardpoint/secondary/united_americas_flag
	name = "\improper Mounted UA Flag"
	desc = "An United Americas flag on a mounting support for the M34A2-A Multipurpose Turret. You feel a burst of energy by its mere sight."

	icon_state          = "mounted_flag"
	disp_icon           = "tank"
	disp_icon_state     = "mountedflag"
	activatable         = FALSE // Cannot be toggled - always active when mounted
	health              = 300
	use_muzzle_flash    = FALSE
	var/buff_range      = PLANTED_FLAG_RANGE
	var/buff_strength   = PLANTED_FLAG_BUFF
	var/faction         = FACTION_MARINE
	var/flag_active     = FALSE
	var/datum/shape/range_bounds
	var/luminosity_strength = 3

	///  lets a fitted tank be selected as a laser/airstrike aiming point, same system as a planted flag turret
	var/datum/cas_signal/signal
	/// Dedicated per-tank-flag counter for the display name below
	var/static/tank_flag_count = 0
	var/flag_number

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 1),
		"4" = list(0, 0),
		"8" = list(0, 1)
	)


/obj/item/hardpoint/secondary/united_americas_flag/Destroy()
	if(flag_active)
		deactivate_flag()
	range_bounds = null
	return ..()

/obj/item/hardpoint/secondary/united_americas_flag/on_install(obj/vehicle/multitile/vehicle)
	..()
	activate_flag()

/obj/item/hardpoint/secondary/united_americas_flag/on_uninstall(obj/vehicle/multitile/vehicle)
	if(flag_active)
		deactivate_flag()
	..()

/obj/item/hardpoint/secondary/united_americas_flag/proc/activate_flag()
	if(flag_active)
		return
	if(!owner)
		return
	flag_active = TRUE
	set_light(luminosity_strength)
	start_processing()
	activate_signal()

/obj/item/hardpoint/secondary/united_americas_flag/proc/deactivate_flag()
	if(!flag_active)
		return

	flag_active = FALSE
	set_light(0)
	stop_processing()
	range_bounds = null
	deactivate_signal()

/obj/item/hardpoint/secondary/united_americas_flag/proc/activate_signal()
	if(signal || !owner)
		return
	if(!faction || !GLOB.cas_groups[faction])
		return

	if(!flag_number)
		flag_number = ++tank_flag_count

	// signal_loc = owner (the tank itself, a movable atom) rather than a snapshotted turf
	signal = new(owner)
	signal.target_id = ++GLOB.cas_tracking_id_increment
	signal.name = "TANK-[flag_number < 10 ? "0[flag_number]" : "[flag_number]"]"
	signal.linked_cam = new(get_turf(owner), signal.name)
	GLOB.cas_groups[faction].add_signal(signal)

/obj/item/hardpoint/secondary/united_americas_flag/proc/deactivate_signal()
	if(!signal)
		return
	if(faction && GLOB.cas_groups[faction])
		GLOB.cas_groups[faction].remove_signal(signal)
	QDEL_NULL(signal)

/obj/item/hardpoint/secondary/united_americas_flag/proc/start_processing()
	START_PROCESSING(SSobj, src)

/obj/item/hardpoint/secondary/united_americas_flag/proc/stop_processing()
	STOP_PROCESSING(SSobj, src)

/obj/item/hardpoint/secondary/united_americas_flag/process()
	if(!flag_active || !owner)
		stop_processing()
		return

	if(health <= 0)
		deactivate_flag()
		return

	apply_area_effect()

/obj/item/hardpoint/secondary/united_americas_flag/proc/apply_area_effect()
	if(!owner || !flag_active)
		return

	// Update range bounds to follow the vehicle
	var/turf/owner_turf = get_turf(owner)
	if(!owner_turf)
		return

	// Keep the CAS signal's z-lock in sync with the tank's real position
	if(signal && signal.z_initial != owner_turf.z)
		signal.z_initial = owner_turf.z

	// Keep the CAS camera view following the tank.
	if(signal?.linked_cam && signal.linked_cam.loc != owner_turf)
		signal.linked_cam.forceMove(owner_turf)

	range_bounds = SQUARE(owner_turf.x, owner_turf.y, buff_range)

	var/list/targets = SSquadtree.players_in_range(range_bounds, owner_turf.z, QTREE_SCAN_MOBS | QTREE_FILTER_LIVING)
	if(!targets)
		return

	for(var/mob/living/carbon/human/H in targets)
		// Check if the human is of the correct faction
		if(!H.faction || !(faction in H.faction_group))
			continue

		apply_buff_to_player(H)

/obj/item/hardpoint/secondary/united_americas_flag/proc/apply_buff_to_player(mob/living/carbon/human/H)
	H.activate_order_buff(COMMAND_ORDER_HOLD, buff_strength, 5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_strength, 5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_MOVE, buff_strength, 5 SECONDS)

/obj/item/hardpoint/secondary/united_americas_flag/on_destroy()
	if(flag_active)
		deactivate_flag()
	..()

#undef PLANTED_FLAG_BUFF
#undef PLANTED_FLAG_RANGE
