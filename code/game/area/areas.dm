// Areas.dm

// ===
/area
	var/atmosalm = 0
	var/poweralm = 1

	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREAS_LAYER
	plane = BLACKNESS_PLANE
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1

	/// Bitfield of special area features
	var/flags_area = NO_FLAGS

	var/flags_alarm_state = NO_FLAGS

	var/unique = TRUE

	var/has_gravity = 1
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = list()		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = 0
	var/statistic_exempt = FALSE

	var/global/global_uid = 0
	var/uid
	var/ceiling = CEILING_NONE //the material the ceiling is made of. Used for debris from airstrikes and orbital beacons in ceiling_debris()
	var/fake_zlevel // for multilevel maps in the same z level
	var/gas_type = GAS_TYPE_AIR
	var/temperature = T20C
	var/pressure = ONE_ATMOSPHERE
	var/can_build_special = FALSE
	var/is_resin_allowed = TRUE	// can xenos weed, place resin holes or dig tunnels at said areas
	var/is_landing_zone = FALSE // primarily used to prevent mortars from hitting this location
	var/resin_construction_allowed = TRUE	// Allow construction of resin walls, and other special

	// Weather
	var/weather_enabled = TRUE	// Manual override for weather if set to false

	// Ambience sounds
	var/list/soundscape_playlist = list() //Clients in this area will hear one of the sounds in this list from time to time
	var/soundscape_interval = INITIAL_SOUNDSCAPE_COOLDOWN //The base interval between each soundscape.
	var/ceiling_muffle = TRUE //If true, this area's ceiling type will alter the muffling of the ambience sound
	var/base_muffle = 0 //Ambience will always be muffled by this ammount at minimum
						//NOTE: Values from 0 to -10000 ONLY. The rest won't work
	/// Default sound to play as ambience for clients entering the area
	VAR_PROTECTED/ambience_exterior
	/// Default sound environment to use for the area, as list or int BYOND preset: http://www.byond.com/docs/ref/#/sound/var/environment
	var/sound_environment = SOUND_ENVIRONMENT_ROOM

	//Power stuff
	var/powernet_name = "default" //Default powernet name. Change to something else to make completely separate powernets
	var/requires_power = 1
	var/unlimited_power = 0
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	//which channels are powered
	var/power_equip = TRUE
	var/power_light = TRUE
	var/power_environ = TRUE

	//how much each channel is draining power
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0
	var/used_oneoff = 0 //one-off power usage


/area/New()
	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if(unique)
		GLOB.areas_by_type[type] = src
	..()
	master = src //moved outside the spawn(1) to avoid runtimes in lighting.dm when it references loc.loc.master ~Carn

	related = list(src)
	initialize_power_and_lighting()

/area/Initialize(mapload, ...)
	icon_state = "" //Used to reset the icon overlay, I assume.
	layer = AREAS_LAYER
	uid = ++global_uid
	. = ..()
	active_areas += src
	all_areas += src
	reg_in_areas_in_z()

/area/proc/initialize_power_and_lighting(override_power)
	if(requires_power)
		luminosity = 0
		if(override_power) //Reset everything if you want to override.
			power_light = TRUE
			power_equip = TRUE
			power_environ = TRUE
			if(lighting_use_dynamic)
				SetDynamicLighting()
	else
		power_light = FALSE			//rastaf0
		power_equip = FALSE			//rastaf0
		power_environ = FALSE		//rastaf0
		luminosity = 1
		lighting_use_dynamic = 0

	power_change()		// all machines set to current power level, also updates lighting icon
	InitializeLighting()

/// Returns the correct ambience sound track for a client in this area
/area/proc/get_sound_ambience(client/target)
	return ambience_exterior

/area/proc/poweralert(var/state, var/obj/source as obj)
	if (state != poweralm)
		poweralm = state
		if(istype(source))	//Only report power alarms on the z-level where the source is located.
			var/list/cameras = list()
			for (var/area/RA in related)
				for (var/obj/structure/machinery/camera/C in RA)
					cameras += C
					if(state == 1)
						C.network.Remove(CAMERA_NET_POWER_ALARMS)
					else
						C.network.Add(CAMERA_NET_POWER_ALARMS)
			for (var/mob/living/silicon/aiPlayer in ai_mob_list)
				if(aiPlayer.z == source.z)
					if (state == 1)
						aiPlayer.cancelAlarm("Power", src, source)
					else
						aiPlayer.triggerAlarm("Power", src, cameras, source)
			for(var/obj/structure/machinery/computer/station_alert/a in machines)
				if(a.z == source.z)
					if(state == 1)
						a.cancelAlarm("Power", src, source)
					else
						a.triggerAlarm("Power", src, cameras, source)
	return

/area/proc/atmosalert(danger_level)
//	if(type==/area) //No atmos alarms in space
//		return 0 //redudant

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/area/RA in related)
		for (var/obj/structure/machinery/alarm/AA in RA)
			if ( !(AA.inoperable()) && !AA.shorted)
				danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		if (danger_level < 1 && atmosalm >= 1)
			//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
			air_doors_open()

		if (danger_level < 2 && atmosalm >= 2)
			for(var/area/RA in related)
				for(var/obj/structure/machinery/camera/C in RA)
					C.network.Remove(CAMERA_NET_ATMOSPHERE_ALARMS)
			for(var/mob/living/silicon/aiPlayer in ai_mob_list)
				aiPlayer.cancelAlarm("Atmosphere", src, src)
			for(var/obj/structure/machinery/computer/station_alert/a in machines)
				a.cancelAlarm("Atmosphere", src, src)

		if (danger_level >= 2 && atmosalm < 2)
			var/list/cameras = list()
			for(var/area/RA in related)
				//updateicon()
				for(var/obj/structure/machinery/camera/C in RA)
					cameras += C
					C.network.Add(CAMERA_NET_ATMOSPHERE_ALARMS)
			for(var/mob/living/silicon/aiPlayer in ai_mob_list)
				aiPlayer.triggerAlarm("Atmosphere", src, cameras, src)
			for(var/obj/structure/machinery/computer/station_alert/a in machines)
				a.triggerAlarm("Atmosphere", src, cameras, src)
			air_doors_close()

		atmosalm = danger_level
		for(var/area/RA in related)
			for (var/obj/structure/machinery/alarm/AA in RA)
				AA.update_icon()

		return 1
	return 0

/area/proc/air_doors_close()
	if(!src.master.air_doors_activated)
		src.master.air_doors_activated = 1
		for(var/obj/structure/machinery/door/firedoor/E in src.master.all_doors)
			if(!E:blocked)
				if(E.operating)
					E:nextstate = OPEN
				else if(!E.density)
					INVOKE_ASYNC(E, /obj/structure/machinery/door.proc/close)

/area/proc/air_doors_open()
	if(src.master.air_doors_activated)
		src.master.air_doors_activated = 0
		for(var/obj/structure/machinery/door/firedoor/E in src.master.all_doors)
			if(!E:blocked)
				if(E.operating)
					E:nextstate = OPEN
				else if(E.density)
					INVOKE_ASYNC(E, /obj/structure/machinery/door.proc/open)


/area/proc/firealert()
	if(name == "Space") //no fire alarms in space
		return
	if(!(flags_alarm_state & ALARM_WARNING_FIRE))
		flags_alarm_state |= ALARM_WARNING_FIRE
		master.flags_alarm_state |= ALARM_WARNING_FIRE		//used for firedoor checks
		updateicon()
		mouse_opacity = 0
		for(var/obj/structure/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = CLOSED
				else if(!D.density)
					INVOKE_ASYNC(D, /obj/structure/machinery/door.proc/close)
		var/list/cameras = list()
		for(var/area/RA in related)
			for (var/obj/structure/machinery/camera/C in RA)
				cameras.Add(C)
				C.network.Add(CAMERA_NET_FIRE_ALARMS)
		for (var/mob/living/silicon/ai/aiPlayer in ai_mob_list)
			aiPlayer.triggerAlarm("Fire", src, cameras, src)
		for (var/obj/structure/machinery/computer/station_alert/a in machines)
			a.triggerAlarm("Fire", src, cameras, src)

/area/proc/firereset()
	if(flags_alarm_state & ALARM_WARNING_FIRE)
		flags_alarm_state &= ~ALARM_WARNING_FIRE
		master.flags_alarm_state &= ~ALARM_WARNING_FIRE		//used for firedoor checks
		mouse_opacity = 0
		updateicon()
		for(var/obj/structure/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = OPEN
				else if(D.density)
					INVOKE_ASYNC(D, /obj/structure/machinery/door.proc/open)
		for(var/area/RA in related)
			for (var/obj/structure/machinery/camera/C in RA)
				C.network.Remove(CAMERA_NET_FIRE_ALARMS)
		for (var/mob/living/silicon/ai/aiPlayer in ai_mob_list)
			aiPlayer.cancelAlarm("Fire", src, src)
		for (var/obj/structure/machinery/computer/station_alert/a in machines)
			a.cancelAlarm("Fire", src, src)

/area/proc/readyalert()
	if(!(flags_alarm_state & ALARM_WARNING_READY))
		flags_alarm_state |= ALARM_WARNING_READY
		updateicon()

/area/proc/readyreset()
	if(flags_alarm_state & ALARM_WARNING_READY)
		flags_alarm_state &= ~ALARM_WARNING_READY
		updateicon()
/*
/area/proc/toggle_evacuation() //toggles lights and creates an overlay.
	flags_alarm_state ^= ALARM_WARNING_EVAC
	master.flags_alarm_state ^= ALARM_WARNING_EVAC
	//if(flags_alarm_state & ALARM_WARNING_EVAC)
	//	master.lightswitch = FALSE
		//lightswitch = FALSE //Lights going off.
//	else
	//	master.lightswitch = TRUE
		//lightswitch = TRUE //Coming on.
	master.updateicon()

	//master.power_change()


/area/proc/toggle_shut_down()
	flags_alarm_state ^= ALARM_WARNING_DOWN
	updateicon()

/area/proc/destroy_area() //Just overlays for now to make it seem like nothing is left.
	flags_alarm_state = NO_FLAGS
	active_areas -= src //So it doesn't process anymore.
	icon_state = "area_destroyed"
*/

/area/proc/updateicon()
	var/I //More important == bottom. Fire normally takes priority over everything.
	if(flags_alarm_state && (!requires_power || power_environ)) //It either doesn't require power or the environment is powered. And there is an alarm.
		if(flags_alarm_state & ALARM_WARNING_READY) I = "alarm_ready" //Area is ready for something.
		if(flags_alarm_state & ALARM_WARNING_EVAC) I = "alarm_evac" //Evacuation happening.
		if(flags_alarm_state & ALARM_WARNING_ATMOS) I = "alarm_atmos"	//Atmos breach.
		if(flags_alarm_state & ALARM_WARNING_FIRE) I = "alarm_fire" //Fire happening.
		if(flags_alarm_state & ALARM_WARNING_DOWN) I = "alarm_down" //Area is shut down.

	if(icon_state != I) icon_state = I //If the icon state changed, change it. Otherwise do nothing.

/area/proc/powered(var/chan)		// return true if the area has power to given channel
	if(!master.requires_power)
		return 1
	if(master.always_unpowered)
		return 0
	switch(chan)
		if(POWER_CHANNEL_EQUIP)
			return master.power_equip
		if(POWER_CHANNEL_LIGHT)
			return master.power_light
		if(POWER_CHANNEL_ENVIRON)
			return master.power_environ

	return 0

/area/proc/update_power_channels(var/equip, var/light, var/environ)
	if(!master)
		CRASH("CALLED update_power_channels on non-master channel!")
	var/changed = FALSE
	if(master.power_equip != equip)
		master.power_equip = equip
		changed = TRUE
	if(master.power_light != light)
		master.power_light = light
		changed = TRUE
	if(master.power_environ != environ)
		master.power_environ = environ
		changed = TRUE
	if(changed) //Something got changed power-wise, time for an update!
		power_change()

// called when power status changes
/area/proc/power_change()
	for(var/area/RA in related)
		for(var/obj/structure/machinery/M in RA)	// for each machine in the area
			if(!M.gc_destroyed)
				M.power_change()				// reverify power status (to update icons etc.)
		if(flags_alarm_state)
			RA.updateicon()

/area/proc/usage(var/chan, var/reset_oneoff = FALSE)
	var/used = 0
	switch(chan)
		if(POWER_CHANNEL_LIGHT)
			used += master.used_light
		if(POWER_CHANNEL_EQUIP)
			used += master.used_equip
		if(POWER_CHANNEL_ENVIRON)
			used += master.used_environ
		if(POWER_CHANNEL_ONEOFF)
			used += master.used_oneoff
			if(reset_oneoff)
				master.used_oneoff = 0
		if(POWER_CHANNEL_TOTAL)
			used += master.used_light + master.used_equip + master.used_environ + master.used_oneoff
			if(reset_oneoff)
				master.used_oneoff = 0

	return used

/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(POWER_CHANNEL_EQUIP)
			master.used_equip += amount
		if(POWER_CHANNEL_LIGHT)
			master.used_light += amount
		if(POWER_CHANNEL_ENVIRON)
			master.used_environ += amount
		if(POWER_CHANNEL_ONEOFF)
			master.used_oneoff += amount

/area/Entered(A,atom/OldLoc)
	if(ismob(A))
		if(!OldLoc)
			return
		var/mob/M = A
		var/area/old_area = get_area(OldLoc)
		if(old_area.master == master)
			return
		if(isliving(M))
			var/mob/living/L = M
			L.update_weather()
		M?.client?.soundOutput?.update_ambience(src, null, TRUE)
	else if(istype(A, /obj/structure/machinery))
		add_machine(A)

/area/Exited(A)
	if(istype(A, /obj/structure/machinery))
		remove_machine(A)
	else if(ismob(A))
		var/mob/exiting_mob = A
		exiting_mob?.client?.soundOutput?.update_ambience(target_area = null, ambience_override = null, force_update = TRUE)

/area/proc/add_machine(var/obj/structure/machinery/M)
	SHOULD_NOT_SLEEP(TRUE)
	if(istype(M))
		use_power(M.calculate_current_power_usage(), M.power_channel)
		M.power_change()

/area/proc/remove_machine(var/obj/structure/machinery/M)
	SHOULD_NOT_SLEEP(TRUE)
	if(istype(M))
		use_power(-M.calculate_current_power_usage(), M.power_channel)

/area/proc/gravitychange(var/gravitystate = 0, var/area/A)

	A.has_gravity = gravitystate

	for(var/area/SubA in A.related)
		SubA.has_gravity = gravitystate

		if(gravitystate)
			for(var/mob/living/carbon/human/M in SubA)
				thunk(M)
			for(var/mob/M1 in SubA)
				M1.make_floating(0)
		else
			for(var/mob/M in SubA)
				if(M.Check_Dense_Object() && istype(src,/mob/living/carbon/human/))
					var/mob/living/carbon/human/H = src
					if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.flags_inventory & NOSLIPPING))  //magboots + dense_object = no floaty effect
						H.make_floating(0)
					else
						H.make_floating(1)
				else
					M.make_floating(1)

/area/proc/thunk(M)
	if(istype(get_turf(M), /turf/open/space)) // Can't fall onto nothing.
		return

	if(istype(M,/mob/living/carbon/human/))  // Only humans can wear magboots, so we give them a chance to.
		var/mob/living/carbon/human/H = M
		if((istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.flags_inventory & NOSLIPPING)))
			return
		H.AdjustStunned(5)
		H.AdjustKnockeddown(5)

	to_chat(M, "Gravity!")




//atmos related procs

/area/return_air()
	return list(gas_type, temperature, pressure)

/area/return_pressure()
	return pressure

/area/return_temperature()
	return temperature

/area/return_gas()
	return gas_type


// A hook so areas can modify the incoming args
/area/proc/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	return flags

/area/proc/reg_in_areas_in_z()
	if(!length(contents))
		return

	var/list/areas_in_z = SSmapping.areas_in_z
	var/z
	for(var/i in contents)
		var/atom/thing = i
		if(!thing)
			continue
		z = thing.z
		break
	if(!z)
		WARNING("No z found for [src]")
		return
	if(!areas_in_z["[z]"])
		areas_in_z["[z]"] = list()
	areas_in_z["[z]"] += src

