/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	matter = list("metal" = 500, "glass" = 50, "waste" = 10)


	wires = WIRE_ASSEMBLY_PULSE

	secured = 0

	var/timing = 0
	var/time = 4 SECONDS

/obj/item/device/assembly/timer/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/assembly/timer/activate()
	if(!..())	return 0//Cooldown check

	timing = !timing
	if(timing)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

	update_icon()
	return 0


/obj/item/device/assembly/timer/toggle_secure()
	secured = !secured
	if(secured && timing)
		START_PROCESSING(SSobj, src)
	else if(!secured)
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/timer/proc/timer_end()
	if(!secured)	return 0
	pulse(0)
	if(!holder)
		visible_message("[icon2html(src, hearers(src))] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown), 1 SECONDS)
	STOP_PROCESSING(SSobj, src)
	return


/obj/item/device/assembly/timer/process(delta_time)
	if(timing && (time > 0))
		time -= delta_time SECONDS
	if(timing && time <= 0)
		timing = 0
		timer_end()
		time = 10 SECONDS
	return


/obj/item/device/assembly/timer/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "timer_timing"
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()
	return

/obj/item/device/assembly/timer/interact(mob/user)
	if(!secured)
		to_chat(user, SPAN_WARNING("The [name] is unsecured!"))
		return

	tgui_interact(user)


/obj/item/device/assembly/timer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Timer", "Timer Assembly")
		ui.open()
		ui.set_autoupdate(timing)

#define TIMER_MINIMUM_TIME (2 SECONDS)
#define TIMER_MAXIMUM_TIME (120 SECONDS)

/obj/item/device/assembly/timer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	if(!secured)
		return

	switch(action)
		if("set_timing")
			timing = text2num(params["should_time"])
			ui.set_autoupdate(timing)

			if(!timing)
				time = clamp(round(time), TIMER_MINIMUM_TIME, TIMER_MAXIMUM_TIME)
				STOP_PROCESSING(SSobj, src)
			else
				START_PROCESSING(SSobj, src)

			update_icon()
			. = TRUE

		if("set_time")
			time = clamp(round(text2num(params["time"])) SECONDS, TIMER_MINIMUM_TIME, TIMER_MAXIMUM_TIME)
			. = TRUE

/obj/item/device/assembly/timer/ui_data(mob/user)
	. = list()
	.["current_time"] = time *0.1
	.["is_timing"] = timing

/obj/item/device/assembly/timer/ui_static_data(mob/user)
	. = list()
	.["min_time"] = TIMER_MINIMUM_TIME * 0.1
	.["max_time"] = TIMER_MAXIMUM_TIME * 0.1
