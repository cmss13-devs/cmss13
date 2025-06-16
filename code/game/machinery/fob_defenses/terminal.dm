#define STATE_UNDEPLOYED "undeployed"
#define STATE_ON "on"
#define STATE_OFF "off"

/obj/structure/machinery/terminal
	name = "\improper UE-09 Service Terminal"
	desc = "Terminal used to monitor the power levels of marine defenses."
	icon = 'icons/obj/structures/machinery/fob_machinery/service_terminal.dmi'
	icon_state = "terminal_undeployed"
	density = TRUE
	anchored = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	var/state = STATE_UNDEPLOYED

/obj/structure/machinery/terminal/Initialize(mapload, ...)
	. = ..()

	AddComponent(/datum/component/fob_defense, CALLBACK(src, PROC_REF(turn_on)), CALLBACK(src, PROC_REF(turn_off)))

/obj/structure/machinery/terminal/proc/turn_off()
	if(state == STATE_ON)
		state = STATE_OFF
	update_icon()

/obj/structure/machinery/terminal/proc/turn_on()
	if(state == STATE_OFF)
		state = STATE_ON
	update_icon()

/obj/structure/machinery/terminal/update_icon()
	switch (state)
		if(STATE_UNDEPLOYED)
			icon_state = "terminal_undeployed"
		if(STATE_ON)
			icon_state = "terminal"
		if(STATE_OFF)
			icon_state = "terminal_off"

/obj/structure/machinery/terminal/attackby(obj/item/attack_item, mob/user)
	if(istype(attack_item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = attack_item
		if(clamp.loaded || state != STATE_UNDEPLOYED)
			return
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return

	if(!HAS_TRAIT(attack_item, TRAIT_TOOL_WRENCH))
		return

	var/area/current_area = get_area(src)
	if(!current_area.is_landing_zone)
		to_chat(user, SPAN_WARNING("[src] can only be deployed at the landing zone."))
		return

	to_chat(user, SPAN_INFO("You start [state == STATE_UNDEPLOYED ? "deploying" : "undeploying"] [src]."))
	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return
	to_chat(user, SPAN_INFO("You [state == STATE_UNDEPLOYED ? "deploy" : "undeploy"] [src]."))

	if(state == STATE_UNDEPLOYED)
		if(GLOB.transformer.is_active())
			state = STATE_ON
		else
			state = STATE_OFF
		anchored = TRUE
	else
		anchored = FALSE
		state = STATE_UNDEPLOYED

	update_icon()

/obj/structure/machinery/terminal/attack_hand(mob/user)
	if(state == STATE_UNDEPLOYED)
		to_chat(user, SPAN_INFO("[src] is undeployed, use a wrench to deploy it."))
	else if(state == STATE_ON)
		if(GLOB.transformer?.backup)
			to_chat(user, SPAN_INFO("All system nominal, backup power active for another [timeleft(GLOB.transformer.backup.timer) / 10] seconds."))
		else if(GLOB.transformer?.shutdown_timer)
			to_chat(user, SPAN_INFO("Power anomaly detected, estimated time until total grid failure: [timeleft(GLOB.transformer.shutdown_timer) / 10] seconds."))
		else
			to_chat(user, SPAN_INFO("All systems nominal."))
	else
		to_chat(user, SPAN_INFO("The display is turned off, it doesn't seem to be working."))

#undef STATE_UNDEPLOYED
#undef STATE_ON
#undef STATE_OFF
