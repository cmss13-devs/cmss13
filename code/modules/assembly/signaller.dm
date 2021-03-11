/obj/item/device/assembly/signaller
	name = "remote signaling device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaller"
	matter = list("metal" = 1000, "glass" = 200, "waste" = 100)

	wires = WIRE_ASSEMBLY_RECEIVE|WIRE_ASSEMBLY_PULSE|WIRE_RADIO_PULSE|WIRE_RADIO_RECEIVE

	secured = 1

	var/code = 30
	var/frequency = 1457
	var/delay = 0
	var/airlock_wire = null
	var/datum/radio_frequency/radio_connection
	var/deadman = 0

/obj/item/device/assembly/signaller/Initialize(mapload, ...)
	. = ..()
	set_frequency(frequency)

/obj/item/device/assembly/signaller/attackby(obj/item/O as obj, mob/user as mob)
	if(issignaller(O))
		var/obj/item/device/assembly/signaller/S = O
		code = S.code
		set_frequency(S.frequency)

		SStgui.update_uis(src)
		to_chat(user, SPAN_NOTICE("You set the frequence of [src] to [frequency] and code to [code]."))
		return
	. = ..()

/obj/item/device/assembly/signaller/activate()
	if(cooldown > 0)	return 0
	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown), 1 SECONDS)

	signal()
	return 1

/obj/item/device/assembly/signaller/update_icon()
	if(holder)
		holder.update_icon()
	return

#define SIGNALLER_FREQ_MAX 1600
#define SIGNALLER_FREQ_MIN 1200

#define SIGNALLER_CODE_MAX 100
#define SIGNALLER_CODE_MIN 1

/obj/item/device/assembly/signaller/interact(mob/user, flag1)
	if(!secured)
		to_chat(user, SPAN_WARNING("The [name] is unsecured!"))
		return

	tgui_interact(user)


/obj/item/device/assembly/signaller/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Signaller", "Signaller")
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/item/device/assembly/signaller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	if(!secured)
		return

	switch(action)
		if("set_freq")
			set_frequency(clamp(round(text2num(params["value"])), SIGNALLER_FREQ_MIN, SIGNALLER_FREQ_MAX))
			. = TRUE

		if("set_signal")
			code = clamp(text2num(params["value"]), SIGNALLER_CODE_MIN, SIGNALLER_CODE_MAX)
			. = TRUE

		if("send_signal")
			signal()
			. = TRUE

/obj/item/device/assembly/signaller/ui_data(mob/user)
	. = list()

	.["current_freq"] = frequency
	.["current_signal"] = code

/obj/item/device/assembly/signaller/ui_static_data(mob/user)
	. = list()

	.["max_freq"] = SIGNALLER_FREQ_MAX
	.["min_freq"] = SIGNALLER_FREQ_MIN

	.["max_signal"] = SIGNALLER_CODE_MAX
	.["min_signal"] = SIGNALLER_CODE_MIN

/obj/item/device/assembly/signaller/proc/signal()
	if(!radio_connection) return

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	radio_connection.post_signal(src, signal)
	return

/obj/item/device/assembly/signaller/pulse(var/radio = 0)
	if(istype(src.loc, /obj/structure/machinery/door/airlock) && src.airlock_wire && src.wires)
		var/obj/structure/machinery/door/airlock/A = src.loc
		A.pulse(src.airlock_wire)
	else if(holder)
		holder.process_activation(src, 1, 0)
	else
		..(radio)
	return 1


/obj/item/device/assembly/signaller/receive_signal(datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.encryption != code)
		return FALSE
	if(!(src.wires & WIRE_RADIO_RECEIVE))
		return FALSE

	pulse(TRUE)

	if(!holder)
		playsound(loc, 'sound/machines/twobeep.ogg', 15)
	return TRUE


/obj/item/device/assembly/signaller/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/assembly/signaller/Destroy()
	radio_connection = null
	return ..()
