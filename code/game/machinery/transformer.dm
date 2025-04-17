#define STATE_MARINE_CAPTURED "marine"
#define STATE_BROKEN "broken"
#define STATE_XENO_CAPTURED "xeno"

/obj/structure/machinery/transformer
	name = "HVT-7T high voltage transformer"
	desc = "A static heavy-duty transformer tower disconnected from the main colony powergrid. Used to power landing zones."
	use_power = USE_POWER_NONE
	icon = 'icons/obj/structures/machinery/transformer.dmi'
	icon_state = "transformer"
	needs_power = FALSE
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	density = TRUE

	var/state = STATE_BROKEN

/obj/structure/machinery/transformer/update_icon()
	overlays.Cut()

	switch(state)
		if(STATE_MARINE_CAPTURED)
			overlays += image(icon, "marine-captured")
		if(STATE_XENO_CAPTURED)
			overlays += image(icon, "xeno-captured")

/obj/structure/machinery/transformer/attackby(obj/item/item, mob/user)
	if(state != STATE_BROKEN)
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
		return

	if(!HAS_TRAIT(item, TRAIT_TOOL_BLOWTORCH))
		to_chat(user, SPAN_WARNING("[src] is completely broken, you need a blowtorch!"))
		return

	var/obj/item/tool/weldingtool/welder = item

	if(welder.get_fuel() < 1)
		to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

	to_chat(user, SPAN_NOTICE("You start repairing [src]."))

	if(!do_after(user, 20 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return

	if(!welder.remove_fuel(1, user))
		return

	to_chat(user, SPAN_NOTICE("You repair [src]."))
	playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)

	state = STATE_MARINE_CAPTURED
	update_icon()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_ON)

/obj/structure/machinery/transformer/attack_alien(mob/living/carbon/xenomorph/alien)
	if(state != STATE_MARINE_CAPTURED)
		return

	if(user.action_busy)
		return

	if(alien.mob_size < MOB_SIZE_BIG)
		to_chat(alien, SPAN_WARNING("You are too small to damage [src]!"))
		return

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)

	if(!do_after(alien, 20 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(alien, SPAN_WARNING("You were interrupted!"))
		return

	playsound(loc, 'sound/effects/meteorimpact.ogg', 25, 1)
	state = STATE_BROKEN
	update_icon()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_TRASNFORMER_OFF)


#undef STATE_MARINE_CAPTURED
#undef STATE_BROKEN
#undef STATE_XENO_CAPTURED
