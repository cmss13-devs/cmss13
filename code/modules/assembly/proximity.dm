/obj/item/device/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	matter = list("metal" = 800, "glass" = 200, "waste" = 50)
	wires = WIRE_ASSEMBLY_PULSE
	secured = FALSE

	var/scanning = 0
	var/timing = FALSE
	var/time = 10 SECONDS
	var/range = 2
	var/iff_signal = FACTION_MARINE

	var/delay = 1 //number of seconds between sensing and pulsing
	var/delaying = FALSE

/obj/item/device/assembly/prox_sensor/activate()
	if(!..())
		return FALSE//Cooldown check
	timing = !timing
	update_icon()
	return FALSE


/obj/item/device/assembly/prox_sensor/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		scanning = 0
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/prox_sensor/HasProximity(atom/movable/AM)
	if((!holder && !secured) || !scanning || cooldown>0 || delaying)
		return
	if(has_moved_recently(AM))
		sense()


/obj/item/device/assembly/prox_sensor/proc/has_moved_recently(atom/movable/AM)
	if(world.time-AM.l_move_time <= 20)
		return TRUE
	return FALSE


/obj/item/device/assembly/prox_sensor/proc/sense()
	var/turf/mainloc = get_turf(src)
	mainloc.visible_message(SPAN_DANGER("You hear a proximity sensor beep!"), SPAN_DANGER("You hear a proximity sensor beep!"))
	playsound(mainloc, 'sound/machines/twobeep.ogg', 50, 1)

	delaying = TRUE
	addtimer(CALLBACK(src, PROC_REF(pulse), 0), delay*10)

	cooldown = 2
	addtimer(CALLBACK(src, PROC_REF(process_cooldown)),10)
	return


/obj/item/device/assembly/prox_sensor/pulse()
	delaying = FALSE
	..()


/obj/item/device/assembly/prox_sensor/process(delta_time)
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/M in range(range,mainloc))
			if(M.get_target_lock(iff_signal))
				continue
			HasProximity(M)

	if(timing && (time >= 0))
		time -= delta_time SECONDS
	if(timing && time <= 0)
		timing = 0
		toggle_scan()
		time = 10 SECONDS
	return


/obj/item/device/assembly/prox_sensor/proc/toggle_scan()
	if(!secured)
		return 0
	scanning = !scanning
	update_icon()
	return


/obj/item/device/assembly/prox_sensor/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "prox_timing"
		attached_overlays += "prox_timing"
	if(scanning)
		overlays += "prox_scanning"
		attached_overlays += "prox_scanning"
	if(holder)
		holder.update_icon()
	return

/obj/item/device/assembly/prox_sensor/interact(mob/user)
	if(!secured)
		to_chat(user, SPAN_WARNING("The [name] is unsecured!"))
		return FALSE

	tgui_interact(user)

/obj/item/device/assembly/prox_sensor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Proximity", "Proximity Assembly")
		ui.open()
		ui.set_autoupdate(timing)

#define PROXY_MINIMUM_TIME (2 SECONDS)
#define PROXY_MAXIMUM_TIME (120 SECONDS)

#define PROXY_MINIMUM_RANGE 1
#define PROXY_MAXIMUM_RANGE 5

#define PROXY_MINIMUM_DELAY 1
#define PROXY_MAXIMUM_DELAY 10

/obj/item/device/assembly/prox_sensor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	if(!secured)
		return

	switch(action)
		if("set_arming")
			timing = text2num(params["should_start_arming"])
			ui.set_autoupdate(timing)

			if(!timing)
				time = clamp(time, PROXY_MINIMUM_TIME, PROXY_MAXIMUM_TIME)
			update_icon()
			. = TRUE

		if("set_arm_time")
			time = clamp(text2num(params["arm_time"]) SECONDS, PROXY_MINIMUM_TIME, PROXY_MAXIMUM_TIME)
			. = TRUE

		if("set_armed")
			scanning = text2num(params["armed"])
			update_icon()
			. = TRUE

		if("set_delay")
			delay = clamp(text2num(params["value"]), PROXY_MINIMUM_DELAY, PROXY_MAXIMUM_DELAY)
			. = TRUE

		if("set_range")
			range = clamp(text2num(params["value"]), PROXY_MINIMUM_RANGE, PROXY_MAXIMUM_RANGE)
			. = TRUE

/obj/item/device/assembly/prox_sensor/ui_data(mob/user)
	. = list()
	.["current_arm_time"] = time *0.1
	.["is_arming"] = timing

	.["current_delay"] = delay
	.["current_range"] = range

	.["armed"] = scanning


/obj/item/device/assembly/prox_sensor/ui_static_data(mob/user)
	. = list()
	.["min_time"] = PROXY_MINIMUM_TIME *0.1
	.["max_time"] = PROXY_MAXIMUM_TIME *0.1

	.["min_range"] = PROXY_MINIMUM_RANGE
	.["max_range"] = PROXY_MAXIMUM_RANGE

	.["min_delay"] = PROXY_MINIMUM_DELAY
	.["max_delay"] = PROXY_MAXIMUM_DELAY

/obj/item/device/assembly/prox_sensor/attack_alien(mob/living/carbon/xenomorph/xeno)
	. = ..()
	if(scanning)
		playsound(loc, "alien_claw_metal", 25, 1)
		xeno.animation_attack_on(src)
		xeno.visible_message(SPAN_XENOWARNING("[xeno] slashes [src], turning it off!"), SPAN_XENONOTICE("You slash [src], turning it off!"))
		toggle_scan()
	return XENO_ATTACK_ACTION
