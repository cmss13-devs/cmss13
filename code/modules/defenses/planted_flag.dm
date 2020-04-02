#define PLANTED_FLAG_BUFF 3 // CO level aura
#define PLANTED_FLAG_RANGE 2

/obj/structure/machinery/defenses/planted_flag
	name = "\improper JIMA planted flag"
	desc = "A planted flag with the iconic USCM flag plastered all over it, you feel a burst of energy by its mere sight."
	var/list/effects_placed = list()
	handheld_type = /obj/item/defenses/handheld/planted_flag

/obj/structure/machinery/defenses/planted_flag/Initialize()
	. = ..()

	if(turned_on)
		setup_area_effect()
	update_icon()

/obj/structure/machinery/defenses/planted_flag/update_icon()
	..()

	overlays.Cut()
	if(stat == DEFENSE_DAMAGED)
		overlays += "planted_flag_destroyed"
		return

	if(turned_on)
		overlays += "planted_flag"
	else
		overlays += "planted_flag_off"


/obj/structure/machinery/defenses/planted_flag/power_on_action()
	clear_area_effect()
	setup_area_effect()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short ring, as it comes alive.")]")

/obj/structure/machinery/defenses/planted_flag/power_off_action()
	clear_area_effect()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a beep and powers down.")]")

/obj/structure/machinery/defenses/planted_flag/proc/clear_area_effect()
	for(var/obj/effect/flag_effect/FE in effects_placed)
		qdel(FE)

	for(var/mob/living/carbon/human/H in orange(PLANTED_FLAG_RANGE, loc))
		H.deactivate_order_buff(COMMAND_ORDER_HOLD)
		H.deactivate_order_buff(COMMAND_ORDER_FOCUS)

/obj/structure/machinery/defenses/planted_flag/proc/setup_area_effect()
	clear_area_effect()
	for(var/turf/T in orange(PLANTED_FLAG_RANGE, loc))
		if(T.density)
			continue

		var/obj/effect/flag_effect/FE = new /obj/effect/flag_effect(T)
		FE.linked_flag = src
		effects_placed += FE

	for(var/mob/living/carbon/human/H in orange(PLANTED_FLAG_RANGE, loc))
		if(H.stat == DEAD)
			return

		H.activate_order_buff(COMMAND_ORDER_HOLD, PLANTED_FLAG_BUFF, 0)
		H.activate_order_buff(COMMAND_ORDER_FOCUS, PLANTED_FLAG_BUFF, 0)

/obj/effect/flag_effect
	name = "flag effect"
	anchored = TRUE
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE
	var/obj/structure/machinery/defenses/planted_flag/linked_flag

/obj/effect/flag_effect/Dispose()
	if(linked_flag)
		linked_flag.effects_placed -= src
		linked_flag = null
	. = ..()

/obj/effect/flag_effect/Crossed(var/atom/movable/A)
	if(!linked_flag)
		qdel(src)
		return

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.stat == DEAD)
			return
		H.activate_order_buff(COMMAND_ORDER_HOLD, PLANTED_FLAG_BUFF, 0)
		H.activate_order_buff(COMMAND_ORDER_FOCUS, PLANTED_FLAG_BUFF, 0)

/obj/effect/flag_effect/Uncrossed(var/atom/movable/A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.deactivate_order_buff(COMMAND_ORDER_HOLD)
		H.deactivate_order_buff(COMMAND_ORDER_FOCUS)

#undef PLANTED_FLAG_BUFF
#undef PLANTED_FLAG_RANGE