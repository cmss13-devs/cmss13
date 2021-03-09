#define PLANTED_FLAG_BUFF 3 // CO level aura
#define PLANTED_FLAG_RANGE 5

/obj/structure/machinery/defenses/planted_flag
	name = "\improper JIMA planted flag"
	icon = 'icons/obj/structures/machinery/defenses/planted_flag.dmi'
	desc = "A planted flag with the iconic USCM flag plastered all over it, you feel a burst of energy by its mere sight."
	handheld_type = /obj/item/defenses/handheld/planted_flag
	disassemble_time = 10
	var/datum/shape/rectangle/range_bounds
	var/area_range = PLANTED_FLAG_RANGE
	var/buff_intensity = PLANTED_FLAG_BUFF


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
		overlays += "[defense_type] planted_flag_destroyed"
		return

	if(turned_on)
		overlays += "[defense_type] planted_flag"
	else
		overlays += "[defense_type] planted_flag_off"

/obj/structure/machinery/defenses/planted_flag/power_on_action()
	apply_area_effect()
	start_processing()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short ring, as it comes alive.")]")

/obj/structure/machinery/defenses/planted_flag/power_off_action()
	stop_processing()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] gives a beep and powers down.")]")

/obj/structure/machinery/defenses/planted_flag/process()
	if(!turned_on)
		stop_processing()

	apply_area_effect()

/obj/structure/machinery/defenses/planted_flag/proc/apply_area_effect()
	if(!range_bounds)
		range_bounds = RECT(x, y, area_range, area_range)

	var/list/targets = SSquadtree.players_in_range(RECT(x, y, area_range, area_range), z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(!targets)
		return

	for(var/mob/living/carbon/human/H in targets)
		if(!(H.get_target_lock(faction_group)))
			continue

		apply_buff_to_player(H)

/obj/structure/machinery/defenses/planted_flag/proc/apply_buff_to_player(var/mob/living/carbon/human/H)
	H.activate_order_buff(COMMAND_ORDER_HOLD, buff_intensity, 1.5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_intensity, 1.5 SECONDS)

/obj/structure/machinery/defenses/planted_flag/range
	name = "extended JIMA planted flag"
	area_range = PLANTED_FLAG_RANGE * 2 // Double range
	handheld_type = /obj/item/defenses/handheld/planted_flag/range

/obj/structure/machinery/defenses/planted_flag/warbanner
	name = "JIMA planted warbanner"
	var/list/flags_in_range
	wrenchable = FALSE
	handheld_type = /obj/item/defenses/handheld/planted_flag/warbanner

/obj/structure/machinery/defenses/planted_flag/warbanner/Initialize()
	. = ..()
	LAZYINITLIST(flags_in_range)

	for(var/obj/structure/machinery/defenses/planted_flag/warbanner/WB in range(area_range))
		WB.flags_in_range.Add(src)
		flags_in_range.Add(WB)

/obj/structure/machinery/defenses/planted_flag/warbanner/Destroy()
	for(var/O in flags_in_range)
		var/obj/structure/machinery/defenses/planted_flag/warbanner/WB = O
		WB.flags_in_range.Remove(src)
		flags_in_range.Remove(O)

	flags_in_range = null
	return ..()


/obj/structure/machinery/defenses/planted_flag/warbanner/apply_buff_to_player(var/mob/living/carbon/human/H)
	var/to_buff = buff_intensity * LAZYLEN(flags_in_range)

	H.activate_order_buff(COMMAND_ORDER_HOLD, to_buff, 1.5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_FOCUS, to_buff, 1.5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_MOVE, to_buff, 1.5 SECONDS)

/obj/item/device/jima
	name = "JIMA frame mount"
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "rto_backpack"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	var/area_range = PLANTED_FLAG_RANGE
	var/buff_intensity = PLANTED_FLAG_BUFF/2

/obj/item/device/jima/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_BACK)
		START_PROCESSING(SSobj, src)


/obj/item/device/jima/process()
	if(!ismob(loc))
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/M = loc

	if(M.back != src)
		STOP_PROCESSING(SSobj, src)
		return

	if(!M.x && !M.y && !M.z)
		return

	var/list/targets = SSquadtree.players_in_range(RECT(M.x, M.y, area_range, area_range), M.z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	targets |= M

	for(var/mob/living/carbon/human/H in targets)
		if(!(H.get_target_lock(M.faction_group)))
			continue

		H.activate_order_buff(COMMAND_ORDER_MOVE, buff_intensity, 3 SECONDS)
		H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_intensity, 3 SECONDS)

#undef PLANTED_FLAG_BUFF
#undef PLANTED_FLAG_RANGE
