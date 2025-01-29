#define PLANTED_FLAG_BUFF 4 // CO level aura plus one
#define PLANTED_FLAG_RANGE 7

/obj/structure/machinery/defenses/planted_flag
	name = "\improper JIMA planted flag"
	icon = 'icons/obj/structures/machinery/defenses/planted_flag.dmi'
	desc = "A planted flag with the iconic USCM flag plastered all over it, you feel a burst of energy by its mere sight."
	handheld_type = /obj/item/defenses/handheld/planted_flag
	disassemble_time = 10
	var/datum/shape/range_bounds
	var/area_range = PLANTED_FLAG_RANGE
	var/buff_intensity = PLANTED_FLAG_BUFF
	health = 200
	health_max = 200

	can_be_near_defense = TRUE

	choice_categories = list(
		SENTRY_CATEGORY_IFF = list(FACTION_MARINE, SENTRY_FACTION_WEYLAND, SENTRY_FACTION_HUMAN),
	)

	selected_categories = list(
		SENTRY_CATEGORY_IFF = FACTION_MARINE,
	)

	var/faction = FACTION_MARINE
	var/datum/cas_signal/signal
	var/luminosity_strength = 5

/obj/structure/machinery/defenses/planted_flag/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_ATOM_TURF_CHANGE, PROC_REF(turf_changed))

	if(turned_on)
		apply_area_effect()
		start_processing()

	range_bounds = SQUARE(x, y, PLANTED_FLAG_RANGE)
	update_icon()

/obj/structure/machinery/defenses/planted_flag/Destroy()
	. = ..()
	range_bounds = null
	deactivate_signal()

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

/obj/structure/machinery/defenses/planted_flag/proc/activate_signal()
	if(faction && GLOB.cas_groups[faction])
		signal = new(src)
		signal.target_id = ++GLOB.cas_tracking_id_increment
		signal.name = "J-[signal.target_id]"
		signal.linked_cam = new(loc, name)
		GLOB.cas_groups[faction].add_signal(signal)

/obj/structure/machinery/defenses/planted_flag/proc/deactivate_signal()
	if(signal)
		GLOB.cas_groups[faction].remove_signal(signal)
		QDEL_NULL(signal)

/obj/structure/machinery/defenses/planted_flag/power_on_action()
	apply_area_effect()
	set_light(luminosity_strength)
	start_processing()
	activate_signal()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short ring, as it comes alive.")]")

/obj/structure/machinery/defenses/planted_flag/power_off_action()
	set_light(0)
	stop_processing()
	deactivate_signal()
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] gives a beep and powers down.")]")

/obj/structure/machinery/defenses/planted_flag/process()
	if(!turned_on)
		stop_processing()

	apply_area_effect()

/obj/structure/machinery/defenses/planted_flag/proc/apply_area_effect()
	if(!range_bounds)
		range_bounds = SQUARE(x, y, area_range)

	var/list/targets = SSquadtree.players_in_range(SQUARE(x, y, area_range), z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(!targets)
		return

	for(var/mob/living/carbon/human/H in targets)
		if(!(H.get_target_lock(faction_group)))
			continue

		apply_buff_to_player(H)

/obj/structure/machinery/defenses/planted_flag/proc/turf_changed()
	SIGNAL_HANDLER
	if(range_bounds)
		QDEL_NULL(range_bounds)

/obj/structure/machinery/defenses/planted_flag/proc/apply_buff_to_player(mob/living/carbon/human/H)
	H.activate_order_buff(COMMAND_ORDER_HOLD, buff_intensity, 1.5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_intensity, 1.5 SECONDS)

/obj/structure/machinery/defenses/planted_flag/range
	name = "extended JIMA planted flag"
	health = 150
	health_max = 150
	area_range = PLANTED_FLAG_RANGE * 2 // Double range
	disassemble_time = 1.5 SECONDS
	handheld_type = /obj/item/defenses/handheld/planted_flag/range
	defense_type = "Range"
	luminosity_strength = 7

/obj/structure/machinery/defenses/planted_flag/warbanner
	name = "JIMA planted warbanner"
	disassemble_time = 0.5 SECONDS
	health = 250
	health_max = 250
	density = FALSE
	wrenchable = FALSE
	handheld_type = /obj/item/defenses/handheld/planted_flag/warbanner
	defense_type = "Warbanner"

/obj/structure/machinery/defenses/planted_flag/warbanner/apply_buff_to_player(mob/living/carbon/human/H)
	H.activate_order_buff(COMMAND_ORDER_HOLD, buff_intensity, 5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_intensity, 5 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_MOVE, buff_intensity, 5 SECONDS)

/obj/structure/machinery/defenses/planted_flag/wy
	name = "WY planted flag"
	desc = "A planted flag with the iconic WY flag plastered all over it, you feel a burst of energy by its mere sight."
	icon = 'icons/obj/structures/machinery/defenses/wy_defenses.dmi'
	disassemble_time = 6 SECONDS
	hack_time = 25 SECONDS
	health = 300
	health_max = 300
	area_range = 11
	handheld_type = /obj/item/defenses/handheld/planted_flag/wy
	defense_type = "WY"
	selected_categories = list(
		SENTRY_CATEGORY_IFF = SENTRY_FACTION_WEYLAND,
	)

	faction = FACTION_WY

/obj/structure/machinery/defenses/planted_flag/wy/apply_buff_to_player(mob/living/carbon/human/H)
	H.activate_order_buff(COMMAND_ORDER_HOLD, buff_intensity, 2 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_intensity, 2 SECONDS)
	H.activate_order_buff(COMMAND_ORDER_MOVE, buff_intensity, 2 SECONDS)

/obj/structure/machinery/defenses/planted_flag/upp
	name = "UPP planted flag"
	desc = "A planted flag with the iconic UPP flag plastered all over it, you feel a burst of energy by its mere sight."
	icon = 'icons/obj/structures/machinery/defenses/upp_defenses.dmi'
	disassemble_time = 5 SECONDS
	health = 300
	health_max = 300
	area_range = 11
	handheld_type = /obj/item/defenses/handheld/planted_flag/upp
	defense_type = "UPP"
	selected_categories = list(
		SENTRY_CATEGORY_IFF = FACTION_UPP,
	)

	faction = FACTION_UPP

/obj/item/storage/backpack/jima
	name = "JIMA frame mount"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	icon_state = "flag_backpack"
	max_storage_space = 10
	worn_accessible = TRUE
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	var/area_range = PLANTED_FLAG_RANGE-2
	var/buff_intensity = PLANTED_FLAG_BUFF/2

/obj/item/storage/backpack/jima/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_BACK)
		START_PROCESSING(SSobj, src)

/obj/item/storage/backpack/jima/process()
	if(!ismob(loc))
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/M = loc

	if(M.back != src)
		STOP_PROCESSING(SSobj, src)
		return

	if(!M.x && !M.y && !M.z)
		return

	var/list/targets = SSquadtree.players_in_range(SQUARE(M.x, M.y, area_range), M.z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	targets |= M

	for(var/mob/living/carbon/human/H in targets)
		if(!(H.get_target_lock(M.faction_group)))
			continue

		H.activate_order_buff(COMMAND_ORDER_MOVE, buff_intensity, 3 SECONDS)
		H.activate_order_buff(COMMAND_ORDER_FOCUS, buff_intensity, 3 SECONDS)

#undef PLANTED_FLAG_BUFF
#undef PLANTED_FLAG_RANGE
