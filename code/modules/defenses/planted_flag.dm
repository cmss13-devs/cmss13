#define PLANTED_FLAG_BUFF 3 // CO level aura
#define PLANTED_FLAG_RANGE 5

/obj/structure/machinery/defenses/planted_flag
	name = "\improper JIMA planted flag"
	desc = "A planted flag with the iconic USCM flag plastered all over it, you feel a burst of energy by its mere sight."
	handheld_type = /obj/item/defenses/handheld/planted_flag
	var/datum/shape/rectangle/range_bounds

/obj/structure/machinery/defenses/planted_flag/Initialize()
	. = ..()

	if(turned_on)
		apply_area_effect()
		start_processing()

	range_bounds = RECT(x, y, PLANTED_FLAG_RANGE, PLANTED_FLAG_RANGE)
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
	apply_area_effect()
	start_processing()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short ring, as it comes alive.")]")

/obj/structure/machinery/defenses/planted_flag/power_off_action()
	stop_processing()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a beep and powers down.")]")

/obj/structure/machinery/defenses/planted_flag/process()
	if(!turned_on)
		stop_processing()

	apply_area_effect()

/obj/structure/machinery/defenses/planted_flag/proc/apply_area_effect()
	if(!range_bounds)
		range_bounds = RECT(x, y, PLANTED_FLAG_RANGE, PLANTED_FLAG_RANGE)

	var/list/targets = SSquadtree.players_in_range(RECT(x, y, PLANTED_FLAG_RANGE, PLANTED_FLAG_RANGE), z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(!targets)
		return

	for(var/mob/living/carbon/human/H in targets)
		if(!(H.faction in belonging_to_faction))
			continue
		
		H.activate_order_buff(COMMAND_ORDER_HOLD, PLANTED_FLAG_BUFF, 1.5 SECONDS)
		H.activate_order_buff(COMMAND_ORDER_FOCUS, PLANTED_FLAG_BUFF, 1.5 SECONDS)

#undef PLANTED_FLAG_BUFF
#undef PLANTED_FLAG_RANGE