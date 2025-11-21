#define PYLON_REPAIR_TIME (4 SECONDS)
#define PYLON_WEEDS_REGROWTH_TIME (15 SECONDS)

/datum/action/xeno_action/activable/create_core
	name = "Create Blight Core (400)"
	action_icon_state = "morph_resin"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/activable/create_core/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/creature = owner
	if(!creature.check_state())
		return FALSE

	if(isstorage(A.loc) || creature.contains(A) || istype(A, /atom/movable/screen))
		return FALSE

	var/datum/hive_status/pathogen/hive = creature.hive
	if(!istype(hive))
		to_chat(creature, SPAN_WARNING("We cannot reach the mycelial link!"))
		return FALSE

	//Make sure construction is unrestricted
	if(IS_NORMAL_XENO(creature))
		if(!HAS_FLAG(creature.hive.hive_flags, XENO_CONSTRUCTION_NORMAL))
			to_chat(creature, SPAN_WARNING("Construction by normal creatures is currently restricted!"))
			return FALSE
	else if(IS_XENO_LEADER(creature))
		if(!HAS_FLAG(creature.hive.hive_flags, XENO_CONSTRUCTION_LEADERS))
			to_chat(creature, SPAN_WARNING("Construction by leaders is currently restricted!"))
			return FALSE
	else if(is_pathogen_overmind(creature))
		if(!HAS_FLAG(creature.hive.hive_flags, XENO_CONSTRUCTION_QUEEN))
			to_chat(creature, SPAN_WARNING("We are currently not allowed to designate construction!"))
			return FALSE
	else
		to_chat(creature, SPAN_DANGER("Something went wrong!"))
		CRASH("Something went wrong determining hive_pos during place_construction!")

	var/turf/target_turf = get_turf(A)

	var/area/AR = get_area(target_turf)
	if(isnull(AR) || !(AR.is_resin_allowed))
		if(AR.flags_area & AREA_UNWEEDABLE)
			to_chat(creature, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(creature, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	if(target_turf.z != creature.z)
		to_chat(creature, SPAN_XENOWARNING("This area is too far away to affect!"))
		return FALSE

	if(SSinterior.in_interior(creature))
		to_chat(creature, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	if(!creature.check_alien_construction(target_turf))
		return FALSE

	if(hive.hivecore_cooldown)
		to_chat(creature, SPAN_WARNING("The weeds are still recovering from the death of the hive core, wait until the weeds have recovered!"))
		return FALSE

	if(hive.has_structure(PATHOGEN_STRUCTURE_CORE))
		to_chat(creature, SPAN_WARNING("We already have a blight core!"))
		return FALSE

	if(!hive.can_build_structure(PATHOGEN_STRUCTURE_CORE))
		to_chat(creature, SPAN_WARNING("We cannot create a blight core!"))
		return FALSE

	if(!creature.check_state(TRUE))
		return FALSE
	var/structure_type = hive.hive_structure_types[PATHOGEN_STRUCTURE_CORE]
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!spacecheck(creature, target_turf, structure_template))
		return FALSE

	if(!do_after(creature, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if(!spacecheck(creature, target_turf, structure_template)) //doublechecking
		return FALSE

	// Currently, we will never get here, I think.
	if(hive.has_structure(PATHOGEN_STRUCTURE_CORE))
		if(alert(creature, "Are we sure that we want to move the confluence and destroy the old blight core?", "Confirm Move", "Yes", "No") != "Yes")
			return FALSE
		qdel(hive.hive_location)
	else if(!hive.can_build_structure(PATHOGEN_STRUCTURE_CORE))
		to_chat(creature, SPAN_WARNING("We can't build any more [PATHOGEN_STRUCTURE_CORE]s for the hive."))
		qdel(structure_template)
		return FALSE

	if(QDELETED(target_turf))
		to_chat(creature, SPAN_WARNING("We cannot build here!"))
		qdel(structure_template)
		return FALSE

	if(SSinterior.in_interior(creature))
		to_chat(creature, SPAN_WARNING("It's too tight in here to build."))
		qdel(structure_template)
		return FALSE

	if(target_turf.is_weedable < FULLY_WEEDABLE)
		to_chat(creature, SPAN_WARNING("\The [target_turf] can't support a [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	var/obj/effect/alien/weeds/weeds = locate() in target_turf
	if(weeds?.block_structures >= BLOCK_SPECIAL_STRUCTURES)
		to_chat(creature, SPAN_WARNING("\The [weeds] block the construction of any special structures!"))
		qdel(structure_template)
		return FALSE

	creature.place_construction(target_turf, structure_template)

	return ..()

// XSS Spacecheck

/datum/action/xeno_action/activable/create_core/proc/spacecheck(mob/living/carbon/xenomorph/X, turf/T, datum/construction_template/xenomorph/tem)
	if(tem.block_range)
		for(var/turf/TA in range(tem.block_range, T))
			if(!X.check_alien_construction(TA, FALSE, TRUE, ignore_nest = TRUE))
				to_chat(X, SPAN_WARNING("We need more open space to build here."))
				qdel(tem)
				return FALSE
		if(!X.check_alien_construction(T, ignore_nest = TRUE))
			to_chat(X, SPAN_WARNING("We need more open space to build here."))
			qdel(tem)
			return FALSE
		var/obj/effect/alien/weeds/alien_weeds = locate() in T
		if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE || alien_weeds.linked_hive.hivenumber != X.hivenumber)
			to_chat(X, SPAN_WARNING("We can only shape on [lowertext(GLOB.hive_datum[X.hivenumber].prefix)]hive weeds. We must find a hive node or core before we start building!"))
			qdel(tem)
			return FALSE
		if(T.density)
			qdel(tem)
			to_chat(X, SPAN_WARNING("We need empty space to build this."))
			return FALSE
	return TRUE







/datum/construction_template/xenomorph/pathogen_core
	name = PATHOGEN_STRUCTURE_CORE
	description = "Heart of the hive, grows hive weeds (which are necessary for other structures) and protects the hive from skyfire."
	build_type = /obj/effect/alien/resin/special/pylon/pathogen_core
	build_icon_state = "core"
	plasma_required = 1000
	block_range = 0

//Hive Core - Generates strong weeds, supports other buildings
/obj/effect/alien/resin/special/pylon/pathogen_core
	name = PATHOGEN_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. It looks very much alive."
	icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
	icon_state = "blight_core"
	health = 2500
	light_range = 4
	cover_range = WEED_RANGE_CORE
	node_type = /obj/effect/alien/weeds/node/pylon/pathogen_core

	forced_hive = TRUE
	hivenumber = XENO_HIVE_PATHOGEN

	var/next_attacked_message = 5 SECONDS
	var/last_attacked_message = 0
	var/warn = TRUE // should we warn of hivecore destruction?
	var/heal_amount = 100
	var/heal_interval = 10 SECONDS
	var/last_healed = 0
	var/last_attempt = 0 // logs time of last attempt to prevent spam. if you want to destroy it, you must commit.

	/// Set to TRUE when being destroyed by the pathogen creatures for relocation.
	var/blight_dissovling = FALSE

	var/mob/living/carbon/xenomorph/overmind_mob
	/// What was the name of the creature now acting as overmind?
	var/list/overmind_stored_stuff = list()

	var/last_overmind_key

	/// Is the overmind in a state of strength? (Has the core been alive a while)
	var/overmind_strengthened = FALSE
	var/overmind_timer
	var/overmind_timer_duration = 600 SECONDS

	var/list/overmind_abilities = list(
		/datum/action/xeno_action/onclick/exit_overmind,
		/datum/action/xeno_action/onclick/set_xeno_lead,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/manage_hive,
		/datum/action/xeno_action/onclick/send_thoughts,
		/datum/action/xeno_action/activable/info_marker/queen,
		/datum/action/xeno_action/onclick/eye,
		/datum/action/xeno_action/onclick/emit_pheromones/overmind,
		/datum/action/xeno_action/activable/queen_heal/pathogen_mind, //first macro
		/datum/action/xeno_action/activable/queen_give_plasma, //second macro
		/datum/action/xeno_action/activable/expand_weeds, //third macro
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/activable/secrete_resin/queen_macro, //fifth macro
		/datum/action/xeno_action/onclick/blight_wave/overmind,
		)

	var/list/overmind_abilities_strong = list(
		/datum/action/xeno_action/onclick/emit_pheromones/overmind,
		/datum/action/xeno_action/onclick/blight_wave/overmind,
		// /datum/action/xeno_action/activable/queen_heal/pathogen_mind gets strengthened by the proc too, allowing cross-map heals.
		)

	protection_level = TURF_PROTECTION_OB

	lesser_drone_spawn_limit = 0

/obj/effect/alien/weeds/node/pylon/pathogen_core
	node_range = WEED_RANGE_CORE
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/resin/special/pylon/pathogen_core/Initialize(mapload, datum/hive_status/hive_ref)
	. = ..()

	// Pick the closest xeno resource activator

	update_minimap_icon()

	if(hive_ref)
		hive_ref.set_hive_location(src, linked_hive.hivenumber)

	if(is_mainship_level(z))
		overmind_timer_duration = 120 SECONDS

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, get_minimap_flag_for_faction(linked_hive?.hivenumber), "core")

/obj/effect/alien/resin/special/pylon/pathogen_core/process()
	. = ..()
	update_minimap_icon()

	// Hive core can repair itself over time
	if(health < maxhealth && last_healed <= world.time)
		health += min(heal_amount, maxhealth-health)
		last_healed = world.time + heal_interval

/obj/effect/alien/resin/special/pylon/pathogen_core/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
/*	if((attacking_xeno.a_intent == INTENT_HELP) && (attacking_xeno.hivenumber == linked_hive.hivenumber) && allowed_to_overmind(attacking_xeno))
		if(tgui_alert(attacking_xeno, "Do you seek to become the Mycelial Overmind?", "Become Overmind?", list("Yes", "No"), 5 SECONDS) == "Yes")
			if(last_overmind_key == attacking_xeno.key)
				make_overmind(attacking_xeno)
			else
				admin_request_overmind(attacking_xeno)
			return XENO_NO_DELAY_ACTION
*/
	if(!overmind_mob && attacking_xeno.a_intent != INTENT_HELP && attacking_xeno.can_destroy_special() && attacking_xeno.hivenumber == linked_hive.hivenumber)
		if(last_attempt + 6 SECONDS > world.time)
			to_chat(attacking_xeno, SPAN_WARNING("We have attempted to dissolve \the [src] too recently! Wait a bit!")) // no spammy
			return XENO_NO_DELAY_ACTION

		else if(warn)
			if((alert(attacking_xeno, "Are you sure that you want to dissolve the blight core?", , "Yes", "No") != "Yes"))
				return XENO_NO_DELAY_ACTION

			INVOKE_ASYNC(src, PROC_REF(dissolve), attacking_xeno)
			return XENO_NO_DELAY_ACTION

	if(linked_hive)
		var/current_health = health
		if(HIVE_ALLIED_TO_HIVE(attacking_xeno.hivenumber, linked_hive.hivenumber))
			return XENO_NO_DELAY_ACTION
		. = ..()

		if(last_attacked_message < world.time && current_health > health)
			xeno_message(SPAN_XENOANNOUNCE("The blight core is under attack!"), 2, linked_hive.hivenumber)
			last_attacked_message = world.time + next_attacked_message
	else
		. = ..()

/obj/effect/alien/resin/special/pylon/pathogen_core/Destroy()
	if(overmind_timer)
		deltimer(overmind_timer)
	overmind_timer = null

	if(linked_hive)
		visible_message(SPAN_XENOHIGHDANGER("The mycelial roof withers away as \the [src] dies!"), max_distance = WEED_RANGE_CORE)
		linked_hive.hive_location = null
		if(world.time < XENOMORPH_PRE_SETUP_CUTOFF)
			. = ..()
			return
		if(!blight_dissovling)
			linked_hive.hivecore_cooldown = TRUE
			INVOKE_ASYNC(src, PROC_REF(cooldownFinish),linked_hive) // start cooldown

	if(overmind_mob)
		unset_overmind()

	SSminimaps.remove_marker(src)
	. = ..()

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/dissolve(mob/living/carbon/xenomorph/dissolver)
	xeno_message(SPAN_XENOANNOUNCE("[dissolver] is dissolving \the [src]!"), 3, linked_hive.hivenumber)
	visible_message(SPAN_DANGER("[dissolver] starts dissolving \the [src]!"))
	last_attempt = world.time //spamcheck
	if(!do_after(dissolver, 5 SECONDS , INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(dissolver,SPAN_WARNING("You stop dissolving \the [src]."))
		visible_message(SPAN_WARNING("[dissolver] stops dissolving \the [src]."))
		last_attempt = world.time // update the spam check
		return XENO_NO_DELAY_ACTION
	blight_dissovling = TRUE
	give_action(dissolver, /datum/action/xeno_action/activable/create_core)
	qdel(src)

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/cooldownFinish(datum/hive_status/linked_hive)
	sleep(HIVECORE_COOLDOWN)
	if(linked_hive.hivecore_cooldown) // check if its true so we don't double set it.
		linked_hive.hivecore_cooldown = FALSE
		xeno_message(SPAN_XENOANNOUNCE("The weeds have recovered! A new blight core can be built!"), 3, linked_hive.hivenumber)
	else
		log_admin("Hivecore cooldown reset proc aborted due to hivecore cooldown var being set to false before the cooldown has finished!")
		// Tell admins that this condition is reached so they know what has happened if it fails somehow
		return

#undef PYLON_REPAIR_TIME
#undef PYLON_WEEDS_REGROWTH_TIME

/datum/action/xeno_action/activable/queen_heal/pathogen_mind
	name = "Heal Pathogen Creature (600)"
	cross_map_heal = TRUE
