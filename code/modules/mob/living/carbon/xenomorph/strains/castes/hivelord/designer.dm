/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "You give up direct resin building, lose some plasma and health, but gain stronger pheromones and longer vision. You can place up to 36 design nodes: optimized nodes boost building by 50%, flexible nodes reduce plasma cost by 50%, and construct nodes allow anyone to donate plasma to build weedbound resin walls or doors, even on surfaces where we can't normally build. Some castes like hivelord, carrier, burrower and queen can stimulate construct nodes to make thick weedbound variant including plasma fruit. You can mark nodes as walls or doors, remotely thicken structures, control doors, and remove nodes. Using Greater Resin Surge turns all design nodes into weaker reflective walls for temporary hive defense. Your tackle is slightly stronger, causing longer knockdowns."
	flavor_description = "You are hive's designer, while you no longer build with your own claws, your influence shapes the very foundation of the swarm, allowing it to expand and adapt beyond limits."
	icon_state_prefix = "Designer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/change_design, //macro 2, macro 1 is for weeds
		/datum/action/xeno_action/activable/place_design, //macro 3
		/datum/action/xeno_action/onclick/toggle_design_icons, //macro 4
		/datum/action/xeno_action/activable/greater_resin_surge, //macro 5
		/datum/action/xeno_action/onclick/toggle_long_range/designer,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)

	behavior_delegate_type = /datum/behavior_delegate/hivelord_designer

/datum/xeno_strain/designer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.available_design = list(
		/obj/effect/alien/resin/design/speed_node,
		/obj/effect/alien/resin/design/cost_node,
		/obj/effect/alien/resin/design/construct_node,
		/obj/effect/alien/resin/design/upgrade,
		/obj/effect/alien/resin/design/remove,
	)
	hivelord.selected_design = /obj/effect/alien/resin/design/speed_node
	hivelord.selected_design_mark = /datum/design_mark/resin_wall
	hivelord.plasma_types = list(PLASMA_NUTRIENT, PLASMA_PHEROMONE)
	hivelord.max_design_nodes = 36
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.health_modifier -= XENO_HEALTH_MOD_LARGE
	hivelord.phero_modifier += XENO_PHERO_MOD_LARGE
	hivelord.speed_modifier += XENO_SPEED_TIER_3 //Lost 30% plasma in sac, you lost some weight
	hivelord.plasmapool_modifier = 0.7 //-30% plasma pool
	hivelord.tacklestrength_min = 5
	hivelord.tacklestrength_max = 6
	hivelord.recalculate_everything()

	// Also change the primacy value for our abilities (because we want the same place but have another primacy ability)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		if(istype(action, /datum/action/xeno_action/activable/place_construction))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			continue
		if(istype(action, /datum/action/xeno_action/active_toggle/toggle_meson_vision))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			continue
		if(istype(action, /datum/action/xeno_action/active_toggle/toggle_speed))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			continue

/datum/behavior_delegate/hivelord_designer
	name = "Hivelord Designer Behavior Delegate"

/datum/behavior_delegate/hivelord_designer/append_to_stat()
	. = list()
	. += "Nodes sustained: [length(bound_xeno.current_design)] / [bound_xeno.max_design_nodes]"

// ""animations"" (effects)
/obj/effect/resin_construct/fastweak
	icon_state = "WeakReflectiveFast"

/obj/effect/resin_construct/speed_node
	icon_state = "speednode"

/obj/effect/resin_construct/cost_node
	icon_state = "costnode"

/obj/effect/resin_construct/construct_node
	icon_state = "constructnode"

/obj/effect/resin_construct/construct_doorslow
	icon_state = "DoorConstrucSlow"

/obj/effect/resin_construct/construct_wallslow
	icon_state = "WeakConstructSlow"

/obj/effect/resin_construct/thickfast
	icon_state = "ThickConstructFast"

/obj/effect/resin_construct/thickdoorfast
	icon_state = "ThickDoorConstructFast"
	layer = FIREDOOR_CLOSED_LAYER

/obj/effect/resin_construct/transparent/thickfast
	icon_state = "WeakTransparentConstructFast"

//Marks

/datum/design_mark
	var/name = "xeno_declare"
	var/icon_state = "empty"
	var/desc = "Xenos make psychic markers with this meaning as positional lasting communication to eachother"

/datum/design_mark/resin_wall
	name = "Resin Wall"
	desc = "Place resin wall here!"
	icon_state = "mark_wall"

/datum/design_mark/resin_door
	name = "Resin Door"
	desc = "Place resin door here!"
	icon_state = "mark_door"

// Far-sight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	delay = 0

//////////////////////////
/// Designer... Paths. ///
//////////////////////////

/obj/effect/alien/resin/design
	name = "Design Node"
	desc = "A weird node, it looks mutated."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "static_speednode"
	density = FALSE
	opacity = FALSE
	layer = RESIN_UNDER_STRUCTURE_LAYER
	plane = FLOOR_PLANE
	health = HEALTH_RESIN_XENO_STICKY

	var/datum/design_mark/mark_meaning = /datum/design_mark/resin_wall
	var/mob/living/carbon/xenomorph/bound_xeno
	var/obj/effect/alien/weeds/bound_weed
	var/hivenumber = XENO_HIVE_NORMAL
	var/plasma_cost = 0

	var/image/choosenMark

/obj/effect/alien/resin/design/Initialize(mapload, obj/effect/alien/weeds/weeds, mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		return INITIALIZE_HINT_QDEL

	bound_xeno = xeno
	bound_weed = weeds
	hivenumber = xeno.hivenumber

	RegisterSignal(bound_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))
	RegisterSignal(bound_xeno, COMSIG_PARENT_QDELETING, PROC_REF(on_xeno_expire))

	set_hive_data(src, hivenumber)
	. = ..()

	if(bound_weed.hivenumber != bound_xeno.hivenumber)
		qdel(src)

	if(xeno.selected_design_mark)
		mark_meaning = new xeno.selected_design_mark

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive)
		hive.designer_marks += src
		if(mark_meaning)
			var/icon_state_to_use = get_marker_icon_state()
			if(icon_state_to_use)
				choosenMark = image(icon, src, icon_state_to_use, ABOVE_HUD_LAYER, "pixel_y" = 5)
				choosenMark.plane = ABOVE_HUD_PLANE
				choosenMark.appearance_flags = RESET_COLOR

				for(xeno in hive.totalXenos)
					if(xeno.client)
						xeno.hud_set_design_marks()
						refresh_marker()

/obj/effect/alien/resin/design/Destroy()
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive)
		hive.designer_marks -= src
		for(var/mob/living/carbon/xenomorph/xeno in hive.totalXenos)
			if(xeno.client && choosenMark)
				xeno.client.images -= choosenMark
				xeno.hud_set_design_marks()

	if(!QDELETED(bound_xeno))
		bound_xeno.current_design.Remove(src)
	unregister_weed_expiration_signal_design()
	bound_xeno = null
	bound_weed = null
	choosenMark = null
	return ..()

/obj/effect/alien/resin/design/proc/refresh_marker()
	if(!choosenMark || !mark_meaning)
		return

	if(bound_xeno.selected_design_mark == /datum/design_mark/resin_wall || bound_xeno.selected_design_mark == /datum/design_mark/resin_door)
		choosenMark.icon_state = mark_meaning.icon_state

/obj/effect/alien/resin/design/proc/get_marker_icon_state()
	if(!mark_meaning)
		return null
	return mark_meaning.icon_state

/obj/effect/alien/resin/design/proc/on_weed_expire()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/alien/resin/design/proc/on_xeno_expire()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/alien/resin/design/proc/check_hivenumber_match()
	if(!bound_weed || !bound_xeno)
		visible_message(SPAN_XENOWARNING("The node shudders and decays back into the weeds."))
		qdel(src)
	else if(bound_weed.hivenumber != bound_xeno.hivenumber)
		visible_message(SPAN_XENOWARNING("The node withers away."))
		qdel(src)

/obj/effect/alien/resin/design/proc/unregister_weed_expiration_signal_design()
	if(bound_weed)
		UnregisterSignal(bound_weed, COMSIG_PARENT_QDELETING)

/obj/effect/alien/resin/design/proc/register_weed_expiration_signal_design(obj/effect/alien/weeds/new_weed)
	RegisterSignal(new_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))
	bound_weed = new_weed
	check_hivenumber_match()

/obj/effect/alien/resin/design/proc/hud_set_queen_overwatch()
	return

/obj/effect/alien/resin/design/speed_node
	name = "Design Optimized Node (50)"
	icon_state = "static_speednode"
	plasma_cost = 50

/obj/effect/alien/resin/design/speed_node/refresh_marker()
	if(!choosenMark || !mark_meaning)
		return

	if(bound_xeno.selected_design_mark == /datum/design_mark/resin_wall || bound_xeno.selected_design_mark == /datum/design_mark/resin_door)
		choosenMark.icon_state = mark_meaning.icon_state + "_speed"
	else
		..()

/obj/effect/alien/resin/design/speed_node/get_marker_icon_state()
	if(!mark_meaning)
		return null
	return mark_meaning.icon_state + "_speed"

/obj/effect/alien/resin/design/speed_node/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this node looks like it has a big green oozing bulb at its center, making the weeds under it twitch...")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("You sense that building on top of this node will speed up your construction speed by [SPAN_BOLDNOTICE("50%")].")

/obj/effect/alien/resin/design/cost_node
	name = "Design Flexible Node (60)"
	icon_state = "static_costnode"
	plasma_cost = 60

/obj/effect/alien/resin/design/cost_node/refresh_marker()
	if(!choosenMark || !mark_meaning)
		return

	if(bound_xeno.selected_design_mark == /datum/design_mark/resin_wall || bound_xeno.selected_design_mark == /datum/design_mark/resin_door)
		choosenMark.icon_state = mark_meaning.icon_state + "_cost"
	else
		..()

/obj/effect/alien/resin/design/cost_node/get_marker_icon_state()
	if(!mark_meaning)
		return null
	return mark_meaning.icon_state + "_cost"

/obj/effect/alien/resin/design/cost_node/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this node looks like its made of smaller blue bulbs grown together, making the weeds under them look soft and squishy.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("You sense that building on top of this node will decrease plasma cost of basic resin structures by [SPAN_BOLDNOTICE("50%")].")

/obj/effect/alien/resin/design/construct_node
	name = "Design Construct Node (70)"
	icon_state = "static_constructnode"
	plasma_cost = 70
	var/plasma_donation = 70
	var/building = FALSE
	var/thick_build = FALSE
	var/obj/effect/resin_construct/build_overlay

/obj/effect/alien/resin/design/construct_node/Initialize(mapload)
	. = ..()
	var/area/area = get_area(src)
	if(area)
		if(area.linked_lz)
			AddComponent(/datum/component/resin_cleanup)
		area.current_resin_count++

/obj/effect/alien/resin/design/construct_node/proc/complete_construction(turf/Turf, design_mark, mob/living/carbon/xenomorph/xeno)
	if(QDELETED(src) || QDELETED(Turf))
		return

	if(build_overlay && !QDELETED(build_overlay))
		qdel(build_overlay)
		build_overlay = null

	building = FALSE

	if(istype(design_mark, /datum/design_mark/resin_wall))
		if(!istype(Turf, /turf/closed/wall))
			var/turf/placed
			if(thick_build)
				placed = Turf.PlaceOnTop(/turf/closed/wall/resin/weedbound/thick)
			else
				placed = Turf.PlaceOnTop(/turf/closed/wall/resin/weedbound/normal)

			var/turf/closed/wall/resin/Res = get_turf(Turf)
			if(istype(Res))
				Res.hivenumber = src.hivenumber
				set_hive_data(Res, Res.hivenumber)

			to_chat(xeno, SPAN_NOTICE("We create a weedbound wall."))
			playsound(placed, "alien_resin_build", 25)
		else
			to_chat(xeno, SPAN_WARNING("A wall already exists here."))

	else if(istype(design_mark, /datum/design_mark/resin_door))
		if(!istype(Turf, /obj/structure/mineral_door))
			var/obj/new_structure
			if(thick_build)
				new_structure = new /obj/structure/mineral_door/resin/weedbound/thick(Turf)
			else
				new_structure = new /obj/structure/mineral_door/resin/weedbound/normal(Turf)

			var/obj/structure/mineral_door/resin/Res = locate(/obj/structure/mineral_door/resin) in get_turf(Turf)
			if(istype(Res))
				Res.hivenumber = src.hivenumber
				set_hive_data(Res, Res.hivenumber)

			to_chat(xeno, SPAN_NOTICE("We create a weedbound door."))
			playsound(new_structure, "alien_resin_build", 25)
		else
			to_chat(xeno, SPAN_WARNING("A door already exists here."))

	qdel(src)

/obj/effect/alien/resin/design/construct_node/Destroy()
	if(build_overlay && !QDELETED(build_overlay))
		qdel(build_overlay)
	if(bound_weed)
		unregister_weed_expiration_signal_design()
	var/area/area = get_area(src)
	area?.current_resin_count--
	return ..()

/obj/effect/alien/resin/design/construct_node/attack_hand(mob/user)
	if(!isxeno(user))
		to_chat(user, SPAN_WARNING("You don't understand how to interact with this strange node."))
		return

	var/mob/living/carbon/xenomorph/xeno = user

	if(!can_begin_construction(xeno))
		return

	var/total_plasma_cost = get_total_plasma_cost(xeno)
	if(xeno.plasma_stored < total_plasma_cost)
		to_chat(xeno, SPAN_WARNING("You lack the plasma to feed this node. [xeno.plasma_stored]/[total_plasma_cost]"))
		return

	xeno.plasma_stored -= total_plasma_cost
	to_chat(xeno, SPAN_NOTICE("You activate the node, it latches onto us and it forcefully consumes [total_plasma_cost] of our plasma."))

	begin_construction(xeno)

/obj/effect/alien/resin/design/construct_node/attackby(obj/item/item, mob/user)
	if(isxeno(user) && user.a_intent != INTENT_HARM)
		if(istype(item, /obj/item/reagent_container/food/snacks/resin_fruit/plasma))
			to_chat(user, SPAN_NOTICE("We squeeze plasma fruit juices on node, activating its growth."))
			qdel(item)
			thick_build = TRUE

			var/mob/living/carbon/xenomorph/xeno = user
			begin_construction(xeno)
			return

		//Do NOT call attack_hand here — that bypasses destruction
		to_chat(user, SPAN_NOTICE("You examine the node curiously, but nothing happens."))
		return

	. = ..()

/obj/effect/alien/resin/design/construct_node/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent != INTENT_HARM)
		return attack_hand(xeno)
	else
		return ..()

/obj/effect/alien/resin/design/construct_node/proc/get_total_plasma_cost(mob/living/carbon/xenomorph/xeno)
	var/area/target_area = get_area(get_turf(src))
	var/total_plasma_cost = plasma_donation

	if(target_area && target_area.openable_turf_count)
		var/density_ratio = target_area.current_resin_count / target_area.openable_turf_count
		if(density_ratio > 0.4)
			total_plasma_cost = ceil(total_plasma_cost * (density_ratio + 0.35) * 2)
			if(total_plasma_cost > xeno.plasma_max && (XENO_RESIN_BASE_COST + plasma_donation) < xeno.plasma_max)
				total_plasma_cost = xeno.plasma_max

	return total_plasma_cost

/obj/effect/alien/resin/design/construct_node/proc/can_begin_construction(mob/living/carbon/xenomorph/xeno)
	if(building)
		to_chat(xeno, SPAN_WARNING("This node is already being infused with plasma."))
		return FALSE

	if(xeno.hivenumber != src.hivenumber)
		to_chat(xeno, SPAN_WARNING("This construct node does not belong to your hive."))
		return FALSE

	if(!mark_meaning)
		to_chat(xeno, SPAN_WARNING("This node has no valid design selected."))
		return FALSE

	var/turf/Turf = get_turf(src)
	if(!istype(Turf))
		to_chat(xeno, SPAN_WARNING("This is not a valid location."))
		return FALSE

	return TRUE

/obj/effect/alien/resin/design/construct_node/proc/begin_construction(mob/living/carbon/xenomorph/xeno)
	if(!can_begin_construction(xeno))
		return

	var/turf/Turf = get_turf(src)
	building = TRUE

	var/obj/effect/resin_construct/overlay

	if(istype(mark_meaning, /datum/design_mark/resin_wall))
		overlay = new /obj/effect/resin_construct/construct_wallslow(Turf)
	else if(istype(mark_meaning, /datum/design_mark/resin_door))
		overlay = new /obj/effect/resin_construct/construct_doorslow(Turf)

	build_overlay = overlay

	if(bound_weed.weed_strength >= WEED_LEVEL_HIVE)
		thick_build = TRUE

	if((xeno.caste_type in XENO_CONSTRUCT_NODE_BOOST) && !istype(xeno.strain, /datum/xeno_strain/designer))
		thick_build = TRUE

	addtimer(CALLBACK(src, PROC_REF(complete_construction), Turf, mark_meaning, xeno), 4 SECONDS)

/obj/effect/alien/resin/design/construct_node/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this node looks like big blub composed of smaller purple glowing cups, pumping some strange liquid trough weeds.")
	if(isxeno(user) || isobserver(user))
		var/mob/living/carbon/xenomorph/xeno = user
		var/total_plasma_cost = get_total_plasma_cost(xeno)
		. += SPAN_NOTICE("You sense that feeding [SPAN_BOLDNOTICE("[total_plasma_cost]")] plasma with our hand to this node will secrete a [SPAN_BOLDNOTICE("[mark_meaning]")], you also heard that using plasma fruit works too.")

//Should not be upgradable because its not "stable" but special actions should create thick variant
/turf/closed/wall/resin/weedbound //NEVER use this variant, use subtypes
	name = "weedbound resin wall"
	desc = "An oddly solidified resin wall with a layered pattern that reminds you of flower buds."
	icon_state = "weedboundresin"
	walltype = WALL_WEEDBOUND_RESIN

	var/obj/effect/alien/weeds/bound_weed
	var/old_hivenumber

/turf/closed/wall/resin/weedbound/Initialize()
	. = ..()
	bound_weed = locate(/obj/effect/alien/weeds) in get_turf(src)
	if(!bound_weed)
		addtimer(CALLBACK(src, PROC_REF(check_weed_replacement)), 3 SECONDS)
		return
	if(bound_weed)
		old_hivenumber = bound_weed.hivenumber
		RegisterSignal(bound_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))

/turf/closed/wall/resin/weedbound/Destroy()
	if(bound_weed)
		UnregisterSignal(bound_weed, COMSIG_PARENT_QDELETING)
		bound_weed = null

	var/turf/Turf = get_turf(src)
	if(Turf)
		visible_message(SPAN_ALERT("The weedbound wall collapses into a puddle of sticky slime."))
		spawn_nutriplasm(Turf)

	return ..()

/turf/closed/wall/resin/weedbound/proc/spawn_nutriplasm(turf/Turf)
	return

/turf/closed/wall/resin/weedbound/proc/on_weed_expire()
	SIGNAL_HANDLER

	if(!old_hivenumber)
		ScrapeAway()
		return

	addtimer(CALLBACK(src, PROC_REF(check_weed_replacement)), 1 DECISECONDS)

/turf/closed/wall/resin/weedbound/proc/check_weed_replacement()
	var/turf/Turf = get_turf(src)
	if(!Turf)
		ScrapeAway()
		return

	var/obj/effect/alien/weeds/new_weed = locate(/obj/effect/alien/weeds) in Turf

	if(new_weed && new_weed.hivenumber == old_hivenumber)
		bound_weed = new_weed
		RegisterSignal(bound_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))
	else
		playsound(src, "alien_resin_break", 25)
		ScrapeAway()

/turf/closed/wall/resin/weedbound/normal/spawn_nutriplasm(turf/Turf)
	new /obj/effect/alien/resin/sticky/weak_nutriplasm(Turf)

/turf/closed/wall/resin/weedbound/normal/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this strange wall appears to have merged with the resin below to hold itself together.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("You sense that this resin wall will collapse if the weeds it is merged with disappear.")

/turf/closed/wall/resin/weedbound/thick
	name = "thick weedbound resin wall"
	desc = "An oddly solidified thick resin wall with a layered pattern that reminds you of flower buds."
	icon_state = "thickweedboundresin"
	damage_cap = HEALTH_WALL_XENO_THICK
	walltype = WALL_THICK_WEEDBOUND_RESIN

/turf/closed/wall/resin/weedbound/thick/spawn_nutriplasm(turf/Turf)
	new /obj/effect/alien/resin/sticky/strong_nutriplasm(Turf)

/turf/closed/wall/resin/weedbound/thick/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this strange darker wall appears to have merged with the resin below to hold itself together.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("You sense that this thick resin wall will collapse if the weeds it is merged with disappear.")

/obj/structure/mineral_door/resin/weedbound //NEVER use this variant, use subtypes
	name = "weedbound resin door"
	desc = "A weird resin door that solidified strangely, forming a petal-like pattern."
	icon_state = "weedbound resin"
	mineralType = "weedbound resin"
	hardness = 1.4

	var/obj/effect/alien/weeds/bound_weed
	var/old_hivenumber

/obj/structure/mineral_door/resin/weedbound/Initialize()
	. = ..()
	bound_weed = locate(/obj/effect/alien/weeds) in get_turf(src)
	if(!bound_weed)
		addtimer(CALLBACK(src, PROC_REF(check_weed_replacement)), 3 SECONDS)
		return
	if(bound_weed)
		old_hivenumber = bound_weed.hivenumber
		RegisterSignal(bound_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))

/obj/structure/mineral_door/resin/weedbound/Destroy()
	if(bound_weed)
		UnregisterSignal(bound_weed, COMSIG_PARENT_QDELETING)
		bound_weed = null

	var/turf/Turf = get_turf(src)
	if(Turf)
		visible_message(SPAN_ALERT("The weedbound wall collapses into a puddle of sticky slime."))
		spawn_nutriplasm(Turf)

	return ..()

/obj/structure/mineral_door/resin/weedbound/proc/spawn_nutriplasm(turf/Turf)
	return

/obj/structure/mineral_door/resin/weedbound/proc/on_weed_expire()
	SIGNAL_HANDLER

	if(!old_hivenumber)
		Dismantle()
		return

	addtimer(CALLBACK(src, PROC_REF(check_weed_replacement)), 1 DECISECONDS)

/obj/structure/mineral_door/resin/weedbound/proc/check_weed_replacement()
	var/turf/Turf = get_turf(src)
	if(!Turf)
		Dismantle()
		return

	var/obj/effect/alien/weeds/new_weed = locate(/obj/effect/alien/weeds) in Turf

	if(new_weed && new_weed.hivenumber == old_hivenumber)
		bound_weed = new_weed
		RegisterSignal(bound_weed, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_expire))
	else
		playsound(src, "alien_resin_break", 25)
		Dismantle()

/obj/structure/mineral_door/resin/weedbound/normal/spawn_nutriplasm(turf/Turf)
	new /obj/effect/alien/resin/sticky/weak_nutriplasm(Turf)

/obj/structure/mineral_door/resin/weedbound/normal/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this strange door appears to have merged with the resin below to hold itself together.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("You sense that this resin door will collapse if the weeds it is merged with disappear.")

/obj/structure/mineral_door/resin/weedbound/thick
	name = "thick weedbound resin door"
	desc = "A weird thick resin door that solidified strangely, forming a petal-like pattern."
	icon_state = "thick weedbound resin"
	mineralType = "thick weedbound resin"
	health = HEALTH_DOOR_XENO_THICK
	hardness = 1.9

/obj/structure/mineral_door/resin/weedbound/thick/spawn_nutriplasm(turf/Turf)
	new /obj/effect/alien/resin/sticky/strong_nutriplasm(Turf)

/obj/structure/mineral_door/resin/weedbound/thick/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this strange darker door appears to have merged with the resin below to hold itself together.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("You sense that this thick resin door will collapse if the weeds it is merged with disappear.")

/obj/effect/alien/resin/sticky/weak_nutriplasm
	name = "thin sticky nutriplasm"
	desc = "A thin layer of disgusting sticky slime."
	icon_state = "weak_nutriplasm"
	slow_amt = 5

/obj/effect/alien/resin/sticky/weak_nutriplasm/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this thin sticky substance remainds you of sticky resin.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("We stare at the remains of weedbound walls - nutriplasm. As edible as it sounds, it's just another kind of sticky resin.")

/obj/effect/alien/resin/sticky/strong_nutriplasm
	name = "sticky nutriplasm"
	desc = "A thick layer of disgusting sticky slime."
	icon_state = "strong_nutriplasm"
	slow_amt = 10

/obj/effect/alien/resin/sticky/strong_nutriplasm/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("On closer examination, this thick sticky substance remainds you of sticky resin.")
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("We stare at thick nutriplasm, the remains from weedbound resin, it sound delicious but you remember, its just different sticky resin.")

/obj/effect/alien/resin/design/upgrade
	name = "Thicken Resin (60)"
	desc = "Channel our plasma and nutrients to thicken structures."
	icon = 'icons/mob/hud/actions_xeno.dmi'
	icon_state = "upgrade_resin"
	plasma_cost = 60

/obj/effect/alien/resin/design/remove
	name = "Remove Design Node (25)"
	desc = "Channel our plasma to revert design node back to weeds."
	icon = 'icons/mob/hud/actions_xeno.dmi'
	icon_state = "remove_node"
	plasma_cost = 25

//////////////////////////
// Greater Resin Surge. //
//////////////////////////

/datum/action/xeno_action/verb/verb_greater_surge()
	set category = "Alien"
	set name = "Greater Resin Surge"
	set hidden = TRUE
	var/action_name = "Greater Resin Surge"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/greater_resin_surge
	name = "Greater Resin Surge (250)"
	action_icon_state = "greater_resin_surge"
	plasma_cost = 250
	xeno_cooldown = 30 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_greater_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/greater_resin_surge/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	for(var/obj/effect/alien/resin/design/node in xeno.current_design)
		if(get_dist(xeno, node) > 7)
			continue

		var/turf/node_loc = get_turf(node.loc)
		if(node_loc)
			create_animation_overlay(node_loc, /obj/effect/resin_construct/fastweak)

	addtimer(CALLBACK(src, PROC_REF(replace_nodes)), 1 SECONDS)
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)
	return ..()

/datum/action/xeno_action/activable/greater_resin_surge/proc/replace_nodes()
	var/mob/living/carbon/xenomorph/xeno = owner
	for(var/obj/effect/alien/resin/design/node in xeno.current_design.Copy())
		if(get_dist(xeno, node) > 7)
			continue

		var/turf/node_loc = get_turf(node.loc)
		if(!node_loc)
			continue

		var/obj/effect/alien/weeds/target_weeds = node_loc.weeds
		if(target_weeds && target_weeds.hivenumber == xeno.hivenumber)
			xeno.visible_message(SPAN_XENODANGER("\The [xeno] surges the resin, creating an unstable wall!"),
				SPAN_XENONOTICE("We surge the resin, creating an unstable wall!"), null, 5)

			node_loc.PlaceOnTop(/turf/closed/wall/resin/reflective/weak)
			var/turf/closed/wall/resin/reflective/weak/good_wall = node_loc
			if(good_wall)
				good_wall.hivenumber = xeno.hivenumber
				set_hive_data(good_wall, xeno.hivenumber)
			playsound(node_loc, "alien_resin_build", 25)

		qdel(node)
		xeno.current_design -= node

/datum/action/xeno_action/activable/greater_resin_surge/proc/create_animation_overlay(turf/target_turf, animation_type)
	if(!istype(target_turf, /turf))
		return

	if(!ispath(animation_type, /obj/effect/resin_construct/fastweak))
		return
	var/obj/effect/resin_construct/fastweak/animation = new animation_type(target_turf)

	addtimer(CALLBACK(animation, TYPE_PROC_REF(/obj/effect/resin_construct/fastweak, delete_animation)), 2 SECONDS)

/obj/effect/resin_construct/fastweak/proc/delete_animation()
	if(!QDELETED(src))
		qdel(src)

/////////////////////////////
///     Place Design      ///
/////////////////////////////

/datum/action/xeno_action/activable/place_design
	name = "Influence"
	action_icon_state = "secrete_resin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/place_design
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 0
	var/max_reach = 10
	var/design_toggle = TRUE

/datum/action/xeno_action/verb/place_design()
	set category = "Alien"
	set name = "Place Design"
	set hidden = TRUE
	var/action_name = "Place Design"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/place_design/use_ability(atom/target_atom, mods, use_plasma = TRUE, message = TRUE)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!can_remote_build())
		to_chat(owner, SPAN_XENONOTICE("We must be standing on weeds to channel our nutrients and influence."))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(mods["click_catcher"])
		return

	if(ismob(target_atom))
		if(!can_see(xeno, target_atom, max_reach))
			to_chat(xeno, SPAN_XENODANGER("We cannot see that location!"))
			return
	else
		if(get_dist(xeno, target_atom) > max_reach)
			to_chat(xeno, SPAN_WARNING("That's too far away!"))
			return

	var/turf/target_turf = get_turf(target_atom)
	if(!istype(target_turf))
		to_chat(xeno, SPAN_WARNING("We cannot design without weeds."))
		return

	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	if(!target_weeds)
		to_chat(xeno, SPAN_WARNING("The are no weeds to create a connection!"))
		return

	if(target_weeds.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_WARNING("These weeds do not belong to our hive; they reject our influence."))
		return

	var/plasma_cost
	if(xeno.selected_design && xeno.selected_design.plasma_cost)
		plasma_cost = xeno.selected_design.plasma_cost

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/upgrade))
		if(!(istype(target_atom, /turf/closed/wall/resin) || istype(target_atom, /turf/closed/wall/resin/membrane) || istype(target_atom, /obj/structure/mineral_door/resin)))
			to_chat(xeno, SPAN_XENOWARNING("We can only upgrade resin walls, membrane and doors!"))
			return

		if(istype(target_atom, /turf/closed/wall/resin) || istype(target_atom, /turf/closed/wall/resin/membrane))
			var/turf/closed/wall/resin/wall = target_atom

			if(wall.hivenumber != xeno.hivenumber)
				to_chat(xeno, SPAN_XENOWARNING("[wall] does not belong to our hive!"))
				return

			if(wall.upgrading_now) //<--- Prevent spam and waste of plasma
				to_chat(xeno, SPAN_WARNING("This wall is already being reinforced!"))
				return

			wall.upgrading_now = TRUE

			if(wall.type == /turf/closed/wall/resin)
				var/obj/thick_wall = new /obj/effect/resin_construct/thickfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
					qdel(thick_wall)
					wall.upgrading_now = FALSE
					return
				qdel(thick_wall)
				wall.ChangeTurf(/turf/closed/wall/resin/thick)

			else if(wall.type == /turf/closed/wall/resin/membrane)
				var/obj/thick_membrane = new /obj/effect/resin_construct/transparent/thickfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
					qdel(thick_membrane)
					wall.upgrading_now = FALSE
					return
				qdel(thick_membrane)
				wall.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
			else
				to_chat(xeno, SPAN_XENOWARNING("[wall] can't be made thicker."))
				return

			wall.upgrading_now = FALSE

		else if(istype(target_atom, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/door = target_atom

			if(door.hivenumber != xeno.hivenumber)
				to_chat(xeno, SPAN_XENOWARNING("[door] does not belong to your hive!"))
				return

			if(door.upgrading_now)
				to_chat(xeno, SPAN_WARNING("This door is already being reinforced!"))
				return

			if(door.hardness == 1.5)
				door.upgrading_now = TRUE
				var/obj/thick_door = new /obj/effect/resin_construct/thickdoorfast(target_turf, src, xeno)
				if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
					qdel(thick_door)
					door.upgrading_now = FALSE
					return
				qdel(thick_door)
				var/oldloc = door.loc
				qdel(door)
				new /obj/structure/mineral_door/resin/thick(oldloc, door.hivenumber)
			else
				if(xeno.try_toggle_resin_door(door))
					if(!check_and_use_plasma_owner())
						return TRUE
					return
				return

		else
			to_chat(xeno, SPAN_XENOWARNING("We can only upgrade resin structures!"))
			return

		if(!check_and_use_plasma_owner(plasma_cost))
			return

		xeno.visible_message(SPAN_XENONOTICE("Weeds around [target_atom] start to twitch and pump substance towards it, thickening it in process!"),
			SPAN_XENONOTICE("We start to channel nutrients towards [target_atom], using [plasma_cost] plasma."), null, 5)
		playsound(target_atom, "alien_resin_build", 25)

		target_atom.add_hiddenprint(xeno) //Tracks who reinforced it for admins
		return TRUE

	if(xeno.try_toggle_resin_door(target_atom))
		if(!check_and_use_plasma_owner())
			return TRUE
		return

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/remove))
		var/obj/effect/alien/resin/design/target_node = locate(/obj/effect/alien/resin/design) in target_turf
		if(!target_node)
			to_chat(xeno, SPAN_XENOWARNING("There is no resin node here to remove!"))
			return

		if(target_node.hivenumber != xeno.hivenumber)
			to_chat(xeno, SPAN_XENOWARNING("This node does not belong to your hive!"))
			return

		if(target_node.bound_xeno != xeno)
			to_chat(xeno, SPAN_XENOWARNING("You cannot remove a node placed by another sister!"))
			return

		qdel(target_node)
		to_chat(xeno, SPAN_XENONOTICE("We sever the bond to the node, causing it to dissolve into the ground."))
		playsound(xeno.loc, "alien_resin_move2", 25)
		return

	if(length(xeno.current_design) >= xeno.max_design_nodes) //Check if there are more nodes than lenght that was defined
		to_chat(xeno, SPAN_XENOWARNING("We cannot sustain another node, one will wither away to allow this one to live!"))
		var/obj/effect/alien/resin/design/old_design = xeno.current_design[1] //Check with node is first for deletion on list
		xeno.current_design.Remove(old_design) //Removes first node stored inside list
		qdel(old_design) //Delete node.

	var/selected_design = xeno.selected_design

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/speed_node)) //Check path you selected from list
		if(!is_turf_clean(target_turf, check_resin_doors = TRUE))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		var/obj/speed_warn = new /obj/effect/resin_construct/speed_node(target_turf, src, xeno) //Create "Animation" overlay
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) || selected_design != xeno.selected_design)
			qdel(speed_warn) //Delete "Animation" overlay after defined time
			return
		qdel(speed_warn) //Delete again just in case overlay don't get deleted
		if(!is_turf_clean(target_turf)) //Recheck the turf again just in case
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("\The [xeno] channel nutrients and shape it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno) //Create node you selected from list
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find node to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design) //Add Node to list.

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/cost_node))
		if(!is_turf_clean(target_turf, check_resin_doors = TRUE))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		var/obj/cost_warn = new /obj/effect/resin_construct/cost_node(target_turf, src, xeno)
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) || selected_design != xeno.selected_design)
			qdel(cost_warn)
			return
		qdel(cost_warn)
		if(!is_turf_clean(target_turf))
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("The [xeno] channel nutrients and shape it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno)
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find node to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design)

	if(ispath(xeno.selected_design, /obj/effect/alien/resin/design/construct_node))
		if(!is_turf_clean(target_turf, check_resin_doors = TRUE))
			to_chat(src, SPAN_WARNING("There's something built here already."))
			return
		if(!xeno.check_alien_construction(target_turf, check_doors = FALSE))
			return FALSE
		var/obj/const_warn = new /obj/effect/resin_construct/construct_node(target_turf, src, xeno)
		if(!do_after(xeno, 0.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) || selected_design != xeno.selected_design)
			qdel(const_warn)
			return
		qdel(const_warn)
		if(!is_turf_clean(target_turf))
			to_chat(xeno, SPAN_XENOWARNING("Something else has taken root here before us."))
			return
		if(!check_and_use_plasma_owner(plasma_cost))
			return
		xeno.visible_message(SPAN_XENONOTICE("The [xeno] channel nutrients and shape it into a node!"))
		var/obj/effect/alien/resin/design/design = new xeno.selected_design(target_weeds.loc, target_weeds, xeno)
		if(!design)
			to_chat(xeno, SPAN_XENOHIGHDANGER("Couldn't find node to place! Contact a coder!"))
			return
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_design.Add(design)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/place_design/proc/can_remote_build()
	if(!locate(/obj/effect/alien/weeds) in get_turf(owner))
		return FALSE
	return TRUE

/mob/living/carbon/xenomorph/proc/try_toggle_resin_door(atom/target_atom)
	if(!istype(target_atom, /obj/structure/mineral_door/resin))
		return FALSE

	var/obj/structure/mineral_door/resin/resin_door = target_atom

	if(resin_door.hivenumber != hivenumber)
		to_chat(src, SPAN_XENOWARNING("This door does not belong to our hive!"))
		return TRUE

	if(resin_door.TryToSwitchState(src))
		if(resin_door.open)
			to_chat(src, SPAN_XENONOTICE("We focus our connection to the resin and remotely close the resin door."))
		else
			to_chat(src, SPAN_XENONOTICE("We focus our connection to the resin and remotely open the resin door."))

	return TRUE

/datum/action/xeno_action/activable/place_design/proc/is_turf_clean(turf/current_turf, check_resin_additions = FALSE, check_doors = FALSE, check_resin_doors = FALSE)
	var/has_obstacle = FALSE
	for(var/obj/target in current_turf)
		if(check_doors)
			if(istype(target, /obj/structure/machinery/door))
				to_chat(src, SPAN_WARNING("[target] is blocking the resin! There's not enough space to build that here."))
				return FALSE
		if(check_resin_additions)
			if(istype(target, /obj/effect/alien/resin/sticky) || istype(target, /obj/effect/alien/resin/spike) || istype(target, /obj/effect/alien/resin/sticky/fast))
				has_obstacle = TRUE
				to_chat(src, SPAN_WARNING("[target] is blocking the resin!"))
				return FALSE
		if(check_resin_doors)
			if(istype(target, /obj/structure/mineral_door/resin))
				to_chat(src, SPAN_WARNING("[target] is blocking the resin node! There's not enough space to build that here."))
				return FALSE
	if(current_turf.density || has_obstacle || locate(/obj/effect/alien/resin/design) in current_turf)
		return FALSE
	return TRUE

///////////////////////////////
///   Change Node Marker    ///
///////////////////////////////

/datum/action/xeno_action/verb/verb_toggle_design_icons()
	set category = "Alien"
	set name = "Change Design Mark"
	set hidden = TRUE
	var/action_name = "Change Design Mark"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/toggle_design_icons
	name = "Change Design Mark"
	action_icon_state = "design_mark_1"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_design_icons
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/toggle_design_icons/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.buckled && !xeno.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/toggle_design_icons/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if(!xeno.check_state(TRUE))
		return

	var/datum/action/xeno_action/activable/place_design/cAction = get_action(xeno, /datum/action/xeno_action/activable/place_design)

	if(!istype(cAction))
		return

	cAction.design_toggle = !cAction.design_toggle

	var/action_icon_result
	if(cAction.design_toggle)
		action_icon_result = "design_mark_1"
		to_chat(xeno, SPAN_INFO("We will now place wall markers."))
		xeno.selected_design_mark = /datum/design_mark/resin_wall
	else
		action_icon_result = "design_mark_2"
		to_chat(xeno, SPAN_INFO("We will now place door markers."))
		xeno.selected_design_mark = /datum/design_mark/resin_door

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
	return ..()

//////////////////////////
///   Change Design    ///
//////////////////////////

/datum/action/xeno_action/verb/verb_change_design()
	set category = "Alien"
	set name = "Change Design Mark"
	set hidden = TRUE
	var/action_name = "Change Design Mark"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/change_design
	name = "Choose Action"
	action_icon_state = "static_speednode"
	plasma_cost = 0
	xeno_cooldown = 0
	macro_path = /datum/action/xeno_action/verb/verb_change_design
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/change_design/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	var/static/list/options = list(
		"Optimized Node (50)" = icon(/datum/action/xeno_action::icon_file, "static_speednode"),
		"Construct Node (70)" = icon(/datum/action/xeno_action::icon_file, "static_constructnode"),
		"Thicken Resin (60)" = icon(/datum/action/xeno_action::icon_file, "upgrade_resin"),
		"Open Old UI" = icon(/datum/action/xeno_action::icon_file, "open_ui"),
		"Remove Node (25)" = icon(/datum/action/xeno_action::icon_file, "remove_node"),
		"Flexible Node (60)" = icon(/datum/action/xeno_action::icon_file, "static_costnode")
	)

	var/choice
	if(owner.client.prefs.no_radials_preference)
		choice = tgui_input_list(owner, "Choose Desing Option", "Pick", options, theme="hive_status")
	else
		choice = show_radial_menu(owner, owner?.client.eye, options, radius = 50)

	var/des = FALSE
	var/rem = FALSE
	plasma_cost = 0
	switch(choice)
		if("Optimized Node (50)")
			xeno.selected_design = /obj/effect/alien/resin/design/speed_node
			des = TRUE
		if("Flexible Node (60)")
			xeno.selected_design = /obj/effect/alien/resin/design/cost_node
			des = TRUE
		if("Construct Node (70)")
			xeno.selected_design = /obj/effect/alien/resin/design/construct_node
			des = TRUE
		if("Thicken Resin (60)")
			xeno.selected_design = /obj/effect/alien/resin/design/upgrade
			rem = TRUE
		if("Remove Node (25)")
			xeno.selected_design = /obj/effect/alien/resin/design/remove
			rem = TRUE
		if("Open Old UI")
			tgui_interact(xeno)

	if(des)
		to_chat(xeno, SPAN_NOTICE("We will now build <b>[xeno.selected_design.name]</b>."))
	if(rem)
		to_chat(xeno, SPAN_NOTICE("We will now remotely <b>[xeno.selected_design.name]</b>."))

	xeno.update_icons()
	button.overlays.Cut()
	button.overlays += image(icon_file, button, xeno.selected_design.icon_state)

	return ..()

// Below is UI for old players.

/datum/action/xeno_action/onclick/change_design/give_to(mob/living/carbon/xenomorph/xeno)
	. = ..()

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, initial(xeno.selected_design.icon_state))
	button.overlays += image(icon_file, button, action_icon_state)

/datum/action/xeno_action/onclick/change_design/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/choose_design))

/datum/action/xeno_action/onclick/change_design/ui_static_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()

	var/list/design_list = list()
	for(var/obj/effect/alien/resin/design/design as anything in xeno.available_design)
		var/list/entry = list()

		entry["name"] = initial(design.name)
		entry["desc"] = initial(design.desc)
		entry["image"] = replacetext(initial(design.icon_state), " ", "-")
		entry["id"] = "[design]"
		design_list += list(entry)

	.["design"] = design_list

/datum/action/xeno_action/onclick/change_design/ui_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()
	.["selected_design"] = xeno.selected_design

/datum/action/xeno_action/onclick/change_design/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChooseDesign", "Choose Design")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/action/xeno_action/onclick/change_design/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/action/xeno_action/onclick/change_design/ui_state(mob/user)
	return GLOB.always_state

/datum/action/xeno_action/onclick/change_design/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/xeno = ui.user
	if(!istype(xeno))
		return

	switch(action)
		if("choose_design")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in xeno.available_design))
				return

			var/obj/effect/alien/resin/design/design = selected_type
			to_chat(xeno, SPAN_NOTICE("We will now build <b>[initial(design.name)]</b> when designing."))
			//update the button's overlay with new choice
			xeno.update_icons()
			button.overlays.Cut()
			button.overlays += image(icon_file, button, action_icon_state)
			button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, initial(design.icon_state))
			xeno.selected_design = selected_type
			. = TRUE

		if("refresh_ui")
			. = TRUE
