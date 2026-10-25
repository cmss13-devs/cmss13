/datum/cas_signal
	var/signal_loc
	var/name = "Unknown Electronic Signal"
	var/target_id = 0
	var/obj/structure/machinery/camera/cas/linked_cam
	var/z_initial
	var/datum/weakref/designator_ref // only lases will receive target selection feedback from CAS
	/// Locked on targets may only be used for direct fire.
	var/direct_fire_only = FALSE
	/// Tactical designators can lase through any roof.
	var/penetrates_roof = FALSE

/datum/cas_signal/New(location)
	z_initial = z_descend(location)
	signal_loc = location

/datum/cas_signal/Destroy()
	QDEL_NULL(linked_cam)
	signal_loc = null
	. = ..()

/datum/cas_signal/proc/get_name()
	var/area/laser_area = get_area(signal_loc)
	var/obstructed = obstructed_signal()?"OBSTRUCTED":""
	if(laser_area)
		return "[name] ([laser_area.name]) [obstructed]"
	return "[name] [obstructed]"

//prevents signal from being triggered from pockets. It has to be on turf
/datum/cas_signal/proc/valid_signal()
	var/obj/object = signal_loc
	var/area/laser_area = get_area(signal_loc)
	var/new_z = z_descend(signal_loc)
	return istype(object) && istype(object.loc,/turf/) && istype(laser_area) && (penetrates_roof || laser_area.ceiling < CEILING_DEEP_UNDERGROUND_METAL) && new_z == z_initial

/datum/cas_signal/proc/obstructed_signal()
	var/area/laser_area = get_area(signal_loc)
	return !istype(laser_area) || (!penetrates_roof && CEILING_IS_PROTECTED(laser_area.ceiling, CEILING_PROTECTION_TIER_2))

/// Prevents direct fire from penetrating metal roofs when a locked target is under one
/proc/cas_direct_fire_visible(atom/target)
	var/turf/target_turf = get_turf(target)
	var/area/target_area = get_area(target_turf)
	return target_turf && is_ground_level(target_turf.z) && target_area && (target_area.ceiling == CEILING_NONE || target_area.ceiling == CEILING_GLASS)

/proc/z_descend(loc)
	var/sloc = loc
	while(sloc && !sloc:z)
		sloc = sloc:loc
	if(!sloc)
		return null
	return sloc:z

/// Designator feedback requires a comms route and an airborne dropship.
/proc/send_cas_target_feedback(obj/designator, obj/effect/overlay/temp/laser_target/laser, obj/structure/machinery/computer/dropship_weapons/console, attack_type = null)
	var/turf/location = get_turf(designator)
	if(QDELETED(laser) || !location || !is_ground_level(location.z))
		return FALSE
	if(!has_cas_feedback_comms(laser.user, location))
		return FALSE
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(console.shuttle_tag)
	if(!dropship || !istype(dropship.get_docked(), /obj/docking_port/stationary/transit))
		return FALSE
	if(attack_type)
		playsound(designator, attack_type == "direct fire" ? 'sound/machines/twobeep.ogg' : 'sound/machines/beepalert.ogg', 15, FALSE)
		to_chat(laser.user, SPAN_NOTICE("The designator signals: [dropship.name] is engaging your laser."))
		return TRUE
	playsound(designator, 'sound/machines/chime.ogg', 15, FALSE)
	to_chat(laser.user, SPAN_NOTICE("The designator chirps: [dropship.name] has acquired your laser."))
	return TRUE

/// Notify the original designator.
/datum/cas_signal/proc/notify_cas_fire(obj/structure/machinery/computer/dropship_weapons/console, is_firemission = FALSE)
	var/obj/designator = designator_ref?.resolve()
	if(!designator || !istype(signal_loc, /obj/effect/overlay/temp/laser_target))
		return FALSE
	return send_cas_target_feedback(designator, signal_loc, console, is_firemission ? "a firemission" : "direct fire")

/// Tcomms, ARC, RTO Backpack and Scout Helmet allow feedback ping.
/proc/has_cas_feedback_comms(mob/living/carbon/human/user, turf/location)
	if(!location || !is_ground_level(location.z))
		return FALSE
	for(var/obj/structure/machinery/telecomms/relay/relay in SSradio.tcomm_machines_ground)
		if(relay.on && !relay.inoperable(EMPED))
			return TRUE
	if(!QDELETED(user) && user.z == location.z)
		if(istype(user.back, /obj/item/storage/backpack/marine/satchel/rto) || istype(user.head, /obj/item/clothing/head/helmet/marine/radio_helmet/scout))
			return TRUE
	for(var/obj/vehicle/multitile/arc/arc in GLOB.all_multi_vehicles)
		if(QDELETED(arc) || arc.z != location.z || arc.health <= 0 || !arc.antenna_deployed)
			continue
		var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in arc.hardpoints
		if(antenna && antenna.health > 0 && !antenna.deploying)
			return TRUE
	return FALSE
