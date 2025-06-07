#define STATE_ON "on"
#define STATE_OFF "off"

/obj/structure/machinery/sensor
	name = "\improper UE-04 Grid Sensor"
	desc = "Field deployed sensor unit with the purpose of lasing targets for UH-99 Smart Rocket Launcher system in a wide range."
	icon = 'icons/obj/structures/machinery/fob_machinery/sensor.dmi'
	icon_state = "sensor"
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	var/datum/shape/rectangle/square/range_bounds
	var/state = STATE_OFF

/obj/structure/machinery/sensor/proc/turn_off()
	if(state == STATE_ON)
		state = STATE_OFF
		SSsensors.sensors -= src

/obj/structure/machinery/sensor/proc/turn_on()
	if(state == STATE_OFF)
		state = STATE_ON
		if(!SSsensors.sensors)
			return
		SSsensors.sensors |= src

/obj/structure/machinery/sensor/attackby(obj/item/attack_item, mob/user)
	if(!HAS_TRAIT(attack_item, TRAIT_TOOL_WRENCH))
		return

	new /obj/item/sensor(loc)
	qdel(src)

/obj/structure/machinery/sensor/Initialize(mapload, ...)
	range_bounds = SQUARE(x, y, 15)

	AddComponent(/datum/component/fob_defense, CALLBACK(src, PROC_REF(turn_on)), CALLBACK(src, PROC_REF(turn_off)))

	if(GLOB.transformer?.is_active())
		turn_on()

	. = ..()

/obj/structure/machinery/sensor/Destroy()
	SSsensors.sensors -= src

	. = ..()

#undef STATE_ON
#undef STATE_OFF

/obj/item/sensor
	name = "folded UE-04 Grid Sensor"
	desc = "Field deployed sensor unit with the purpose of lasing targets for UH-99 Smart Rocket Launcher system in a wide range."
	icon = 'icons/obj/structures/machinery/fob_machinery/sensor.dmi'
	icon_state = "sensor_undeployed"

/obj/item/sensor/attack_self(mob/user)
	if(SSinterior.in_interior(user))
		to_chat(user, SPAN_WARNING("It's too cramped in here to deploy [src]."))
		return

	var/turf/target_turf = get_step(user, user.dir)

	var/blocked = FALSE
	for(var/obj/potential_blocker in target_turf)
		if(potential_blocker.density)
			blocked = TRUE
			break

	for(var/mob/blocking_mob in target_turf)
		blocked = TRUE
		break

	var/area/area = get_area(target_turf)

	if(!area.allow_construction || !area.is_landing_zone)
		to_chat(user, SPAN_WARNING("You cannot deploy \a [src] here!"))
		return

	if(istype(target_turf, /turf/open))
		var/turf/open/floor = target_turf
		if(!floor.allow_construction)
			to_chat(user, SPAN_WARNING("You cannot deploy \a [src] here, find a more secure surface!"))
			return FALSE
	else
		blocked = TRUE

	if(blocked)
		to_chat(user, SPAN_WARNING("You need a clear, open area to build \a [src], something is blocking the way in front of you!"))
		return

	to_chat(user, SPAN_INFO("You begin deploying [src]..."))

	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	for(var/obj/potential_blocker in target_turf)
		if(potential_blocker.density)
			blocked = TRUE
			break

	for(var/mob/blocking_mob in target_turf)
		blocked = TRUE
		break

	if(blocked)
		to_chat(user, SPAN_WARNING("You need a clear, open area to build \a [src], something is blocking the way in front of you!"))
		return

	to_chat(user, SPAN_INFO("You deploy [src]..."))

	new /obj/structure/machinery/sensor(target_turf)
	qdel(src)
