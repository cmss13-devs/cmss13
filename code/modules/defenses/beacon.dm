/obj/structure/machinery/defenses/beacon
	name = "dropship landing beacon"
	icon = 'icons/obj/structures/machinery/defenses/beacon.dmi'
	desc = "A beacon to allow a dropship to land in the vicinity."
	handheld_type = /obj/item/defenses/handheld/beacon
	var/range = 12
	var/identifier
	var/static/beacon_identifiers = 1

/obj/structure/machinery/defenses/beacon/Initialize()
	. = ..()

	identifier = "DS-[beacon_identifiers]"
	beacon_identifiers++

	if(turned_on)
		power_on_action()

	update_icon()

/obj/structure/machinery/defenses/beacon/update_icon()
	. = ..()

	overlays.Cut()

	if(stat == DEFENSE_DAMAGED || stat == DEFENSE_DESTROYED)
		overlays += "broken"
		return

	if(turned_on)
		overlays += "on"
	else
		overlays += "off"

/obj/structure/machinery/defenses/beacon/power_on_action(mob/user)
	GLOB.active_beacons += src
	apply_ranged_effect()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[src] emits a series of loud beeps as it comes alive.")]")

	if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_BEACON_RADIO))
		return

	ai_silent_announcement("Beacon [identifier] is now available.", ":j")
	TIMER_COOLDOWN_START(src, COOLDOWN_BEACON_RADIO, 20 SECONDS)


/obj/structure/machinery/defenses/beacon/power_off_action(mob/user)
	GLOB.active_beacons -= src
	remove_ranged_effect()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[src] gives a beep and powers down.")]")

	if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_BEACON_RADIO))
		return

	ai_silent_announcement("Beacon [identifier] is no longer available.", ":j")
	TIMER_COOLDOWN_START(src, COOLDOWN_BEACON_RADIO, 20 SECONDS)

/obj/structure/machinery/defenses/beacon/destroyed_action()
	power_off_action()
	update_icon()

/obj/structure/machinery/defenses/beacon/damaged_action(damage)
	. = ..()

	if(stat == DEFENSE_DAMAGED)
		power_off_action()
		update_icon()

/obj/structure/machinery/defenses/beacon/proc/apply_ranged_effect()
	for(var/turf/current_turf in block(locate(x - range, y - range, z), locate(x + range, y + range, z)))
		ENABLE_BITFIELD(current_turf.flags_turf, TURF_LANDABLE)

/obj/structure/machinery/defenses/beacon/proc/remove_ranged_effect()
	for(var/turf/current_turf in block(locate(x - range, y - range, z), locate(x + range, y + range, z)))
		DISABLE_BITFIELD(current_turf.flags_turf, TURF_LANDABLE)

/obj/item/defenses/handheld/beacon
	name = "handheld dropship landing beacon"
	icon = 'icons/obj/structures/machinery/defenses/beacon.dmi'
	icon_state = "handheld"
	defense_type = /obj/structure/machinery/defenses/beacon
	deployment_time = 5 SECONDS
