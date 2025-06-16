#define STATE_UNDEPLOYED "undeployed"
#define STATE_ON "on"
#define STATE_OFF "off"

/obj/structure/machinery/illuminator
	name = "\improper UE-92 Area Illuminator"
	desc = "Large deployable floodlight designed to illuminate large areas."
	icon = 'icons/obj/structures/machinery/fob_machinery/illuminator.dmi'
	icon_state = "floodlight_undeployed"
	density = TRUE
	anchored = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = ABOVE_MOB_LAYER
	needs_power = FALSE
	var/state = STATE_UNDEPLOYED
	var/on_light_range = 18

/obj/structure/machinery/illuminator/Initialize(mapload, ...)
	. = ..()

	AddComponent(/datum/component/fob_defense, CALLBACK(src, PROC_REF(turn_on)), CALLBACK(src, PROC_REF(turn_off)))

/obj/structure/machinery/illuminator/proc/turn_off()
	if(state == STATE_ON)
		state = STATE_OFF
		set_light(0)
	update_icon()

/obj/structure/machinery/illuminator/proc/turn_on()
	if(state == STATE_OFF)
		state = STATE_ON
		set_light(18)
	update_icon()

/obj/structure/machinery/illuminator/update_icon()
	switch (state)
		if(STATE_UNDEPLOYED)
			icon_state = "floodlight_undeployed"
		if(STATE_ON)
			icon_state = "floodlight"
		if(STATE_OFF)
			icon_state = "floodlight_off"

/obj/structure/machinery/illuminator/attackby(obj/item/attack_item, mob/user)
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
			set_light(18)
		else
			state = STATE_OFF
		anchored = TRUE
	else
		anchored = FALSE
		state = STATE_UNDEPLOYED

	update_icon()

#undef STATE_UNDEPLOYED
#undef STATE_ON
#undef STATE_OFF
