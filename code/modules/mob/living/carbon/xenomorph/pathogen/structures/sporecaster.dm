#define SPORECASTER_RANGE 2

//sporecasterer - Basically a big reusable egg
/obj/effect/alien/resin/special/sporecaster
	name = PATHOGEN_STRUCTURE_SPORECASTER
	desc = "A disgusting biomass generator that reeks of rotting flesh. Capable of producing spore clouds on its own."
	icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
	icon_state = "sporecaster"
	health = 400
	appearance_flags = KEEP_TOGETHER
	layer = FACEHUGGER_LAYER
	pixel_x = -12
	pixel_y = -24

	///How many spore clouds are stored in the sporecaster currently.
	var/stored_sporeclouds = 0
	///Max amount of spore clouds that can be stored in the sporecaster.
	var/max_sporeclouds = 6
	///Datum used for mob detection.
	var/datum/shape/range_bounds
	///How long it takes to generate one facehugger.
	var/spore_grow_time = 120 SECONDS
	COOLDOWN_DECLARE(grow_cooldown)
	///Temporary holding list for people in the process of being infected, to stop wasted clouds.
	var/list/temp_infect_list = list()


/obj/effect/alien/resin/special/sporecaster/Initialize(mapload, hive_ref)
	. = ..()
	COOLDOWN_START(src, grow_cooldown, spore_grow_time)
	range_bounds = SQUARE(x, y, SPORECASTER_RANGE)
	update_minimap_icon()

/obj/effect/alien/resin/special/sporecaster/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, get_minimap_flag_for_faction(linked_hive?.hivenumber), image('icons/mob/pathogen/neo_blips.dmi', null, "sporecaster"))

/obj/effect/alien/resin/special/sporecaster/Destroy()
	if(stored_sporeclouds && linked_hive)
		//Hugger explosion, like a carrier
		var/obj/item/clothing/mask/facehugger/F
		var/chance = 60
		visible_message(SPAN_XENOWARNING("The chittering mass of tiny aliens is trying to escape [src]!"))
		for(var/i in 1 to stored_sporeclouds)
			if(prob(chance))
				F = new(loc, linked_hive.hivenumber)
				step_away(F,src,1)

	range_bounds = null
	SSminimaps.remove_marker(src)
	. = ..()

/obj/effect/alien/resin/special/sporecaster/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("\nIt has <b>[stored_sporeclouds] spore clouds within</b>, with [max(0, max_sporeclouds - stored_sporeclouds)] more to produce and a total capacity of [max_sporeclouds].")

		if(stored_sporeclouds < max_sporeclouds)
			. += SPAN_NOTICE("It'll produce another spore cloud in <b>[COOLDOWN_SECONDSLEFT(src, grow_cooldown)] seconds.</b>")

/obj/effect/alien/resin/special/sporecaster/attackby(obj/item/item, mob/user)
	if(!isxeno(user))
		return ..(item, user)

	return ..(item, user)

/obj/effect/alien/resin/special/sporecaster/update_icon()
	..()
	appearance_flags |= KEEP_TOGETHER
	overlays.Cut()
	underlays.Cut()
	underlays += "[icon_state]_underlay"

/obj/effect/alien/resin/special/sporecaster/process()
	check_cloud_target()

	if(!linked_hive || !COOLDOWN_FINISHED(src, grow_cooldown) || stored_sporeclouds == max_sporeclouds)
		return

	COOLDOWN_START(src, grow_cooldown, spore_grow_time)
	if(stored_sporeclouds < max_sporeclouds)
		stored_sporeclouds = min(max_sporeclouds, stored_sporeclouds + 1)

/obj/effect/alien/resin/special/sporecaster/proc/check_cloud_target()
	if(!range_bounds)
		range_bounds = SQUARE(x, y, SPORECASTER_RANGE)

	var/list/targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_FILTER_LIVING)
	if(isnull(targets) || !length(targets))
		return

	for(var/target in targets)
		if(target in temp_infect_list)
			targets -= target

	for(var/mob/living/carbon/xenomorph/xeno in targets)
		targets -= xeno //Don't add xenomorphs to the list of possible players we hug.

	for(var/mob/living/carbon/human/human in targets)
		if(!infectable(human))
			targets -= human


	if(!length(targets))
		return
	var/target = pick(targets)
	temp_infect_list += target
	if(isnull(target))
		return

	HasProximity(target)

/obj/effect/alien/resin/special/sporecaster/proc/infectable(mob/living/carbon/human/human_target)
	if(!istype(human_target))
		return FALSE
	var/obj/item/mask = human_target.wear_mask
	var/obj/item/helmet = human_target.head
	if(mask?.flags_inventory & SPOREPROOF)
		return FALSE
	if(helmet?.flags_inventory & SPOREPROOF)
		return FALSE
	return TRUE

/obj/effect/alien/resin/special/sporecaster/HasProximity(atom/movable/AM as mob|obj)
	if(!stored_sporeclouds || issynth(AM) || !ishuman(AM))
		temp_infect_list -= AM
		return

	if(!linked_hive)
		temp_infect_list -= AM
		return

	var/mob/living/carbon/human/human_target = AM
	if(!can_hug(human_target, linked_hive.hivenumber))
		temp_infect_list -= human_target
		return

	stored_sporeclouds = max(0, stored_sporeclouds - 1)

	var/obj/effect/pathogen/spore_cloud/cloud = new(loc)
	if(isyautja(human_target))//We're forcing infection here to bypass gas masks, but infectable() already makes sure they're not entirely immune.
		cloud.attempt_yautja_inhale(human_target, TRUE)
	else
		cloud.attempt_inhale(human_target, TRUE)
	temp_infect_list -= human_target

/obj/effect/alien/resin/special/sporecaster/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M))
		return attack_hand(M)
	if(!linked_hive || (M.hivenumber != linked_hive.hivenumber))
		return ..(M)
	if(stored_sporeclouds)
		//this way another hugger doesn't immediately spawn after we pick one up
		if(stored_sporeclouds == max_sporeclouds)
			COOLDOWN_START(src, grow_cooldown, spore_grow_time)

		to_chat(M, SPAN_XENONOTICE("You cause the sporecaster to release a spore cloud."))
		stored_sporeclouds = max(0, stored_sporeclouds - 1)
		new /obj/effect/pathogen/spore_cloud(loc)
		return XENO_NONCOMBAT_ACTION
	..(M)

#undef SPORECASTER_RANGE

/datum/construction_template/xenomorph/sporecaster
	name = PATHOGEN_STRUCTURE_SPORECASTER
	description = "Produces spore clouds to infect targets brought close."
	build_type = /obj/effect/alien/resin/special/sporecaster
	build_icon_state = "sporecaster"

/datum/construction_template/xenomorph/sporecaster/set_structure_image()
	build_icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
