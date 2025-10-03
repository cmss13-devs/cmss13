#define TIME_TO_TRANSFORM 1 SECONDS
/datum/caste_datum/pathogen/overmind
	caste_type = PATHOGEN_CREATURE_OVERMIND
	tier = 4

	plasma_max = XENO_PLASMA_TIER_10
	plasma_gain = XENO_PLASMA_GAIN_TIER_7

	max_health = XENO_HEALTH_LESSER_DRONE

	fire_immunity = FIRE_IMMUNITY_NO_IGNITE

	minimap_icon = "overmind"

	aura_strength = 0

	max_build_dist = 7
	heal_standing = 3

	evolves_to = list()
	deevolves_to = list()
	is_intelligent = TRUE
	evolution_allowed = FALSE

/mob/living/carbon/xenomorph/overmind
	caste_type = PATHOGEN_CREATURE_OVERMIND
	name = "Overmind"
	desc = "A glorious singular entity."

	icon_state = "overmind_eye"
	icon_xeno = 'icons/mob/pathogen/overmind.dmi'
	icon_xenonid = 'icons/mob/pathogen/overmind.dmi'
	status_flags = INCORPOREAL
	density = FALSE
	a_intent = INTENT_HELP
	tier = 4

	see_invisible = SEE_INVISIBLE_LIVING
	invisibility = INVISIBILITY_LEVEL_TWO
	sight = SEE_MOBS|SEE_TURFS|SEE_OBJS

	counts_for_slots = FALSE

	///The core of our hivemind
	var/datum/weakref/core
	///The minimum health we can have
	var/minimum_health = -300

	COOLDOWN_DECLARE(cooldown_hivemind_manifestation)

	base_actions = list(
		/datum/action/xeno_action/watch_xeno/overmind,
		/datum/action/xeno_action/onclick/return_to_core,
		/datum/action/xeno_action/onclick/change_form,
		/datum/action/xeno_action/onclick/set_xeno_lead,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/manage_hive,
		/datum/action/xeno_action/onclick/send_thoughts,
		/datum/action/xeno_action/onclick/emit_pheromones/overmind,
		/datum/action/xeno_action/activable/info_marker/queen,
		/datum/action/xeno_action/activable/queen_heal/pathogen_mind, //first macro
		/datum/action/xeno_action/activable/queen_give_plasma, //second macro
		/datum/action/xeno_action/activable/expand_weeds, //third macro
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/activable/secrete_resin/queen_macro, //fifth macro
		/datum/action/xeno_action/onclick/blight_wave/overmind,
	)

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	tackle_chance = 0

/mob/living/carbon/xenomorph/overmind/Initialize(mapload)
	var/obj/effect/alien/resin/overmind/new_core = new /obj/effect/alien/resin/overmind(loc, hivenumber)
	core = WEAKREF(new_core)
	. = ..()
	new_core.parent = WEAKREF(src)
	RegisterSignal(src, COMSIG_XENOMORPH_CORE_RETURN, PROC_REF(return_to_core))
	RegisterSignal(src, COMSIG_XENOMORPH_HIVEMIND_CHANGE_FORM, PROC_REF(change_form))
	set_stats_incorporeal()
	update_action_buttons()
	make_pathogen_speaker()
	set_resin_build_order(GLOB.resin_build_order_pathogen_overmind)
	extra_build_dist = IGNORE_BUILD_DISTANCE

/mob/living/carbon/xenomorph/overmind/proc/set_stats_incorporeal()
	if(pass_flags)
		pass_flags.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		pass_flags.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

	invisibility = INVISIBILITY_LEVEL_TWO
	aura_strength = 2
	speed = XENO_SPEED_RUNNER

/mob/living/carbon/xenomorph/overmind/proc/set_stats_manifest()
	if(pass_flags)
		pass_flags.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		pass_flags.flags_can_pass_all = PASS_MOB_THRU_XENO|PASS_AROUND|PASS_HIGH_OVER_ONLY

	aura_strength = 5
	speed = XENO_SPEED_QUEEN

/mob/living/carbon/xenomorph/overmind/updatehealth()
	if(on_fire)
		ExtinguishMob()
	health = maxHealth - getFireLoss() - getBruteLoss() //Xenos can only take brute and fire damage.
	if(health <= 0 && !(status_flags & INCORPOREAL))
		setBruteLoss(0)
		setFireLoss(-minimum_health)
		change_form()
	health = maxHealth - getFireLoss() - getBruteLoss()
	med_hud_set_health()
	if(!COOLDOWN_FINISHED(src, cooldown_hivemind_manifestation))
		return
	update_wounds()

/datum/behavior_delegate/pathogen_base/overmind/on_life()
	var/mob/living/carbon/xenomorph/overmind/overmind = bound_xeno
	if(!COOLDOWN_FINISHED(overmind, cooldown_hivemind_manifestation))
		return
	if(!(bound_xeno.status_flags & INCORPOREAL))
		if(!(locate(/obj/effect/alien/weeds) in get_turf(bound_xeno)))
			bound_xeno.adjustBruteLoss(20)

/mob/living/carbon/xenomorph/overmind/Destroy()
	var/obj/effect/alien/resin/overmind/hive_core = get_core()
	if(hive_core)
		qdel(hive_core)
	return ..()

/mob/living/carbon/xenomorph/overmind/death()
	var/obj/effect/alien/resin/overmind/hive_core = get_core()
	if(!QDELETED(hive_core))
		qdel(hive_core)
	return ..()

/mob/living/carbon/xenomorph/overmind/gib()
	return_to_core()

/mob/living/carbon/xenomorph/overmind/set_resting()
	return

/mob/living/carbon/xenomorph/overmind/generate_name()
	if(!nicknumber)
		generate_and_set_nicknumber()

	if(hive)
		color = hive.color

	var/name_client_prefix = ""
	var/name_client_postfix = ""
	if(client)
		name_client_prefix = "[(client.xeno_prefix||client.xeno_postfix) ? client.xeno_prefix : "XX"]-"
		name_client_postfix = client.xeno_postfix ? ("-"+client.xeno_postfix) : ""
		age_xeno()
	full_designation = "[name_client_prefix][nicknumber][name_client_postfix]"

	name = "Overmind ([full_designation])"

	//Update linked data so they show up properly
	change_real_name(src, name)
	//Update the hive status UI
	if(hive)
		var/datum/hive_status/hive_status = hive
		hive_status.hive_ui.update_xeno_info()

/mob/living/carbon/xenomorph/overmind/proc/change_form()
	if(status_flags & INCORPOREAL && health != maxHealth)
		to_chat(src, SPAN_XENOWARNING("You do not have the strength to manifest yet!"))
		return
	if(!COOLDOWN_FINISHED(src, cooldown_hivemind_manifestation))
		return
	COOLDOWN_START(src, cooldown_hivemind_manifestation, TIME_TO_TRANSFORM)
	invisibility = 0
	flick(status_flags & INCORPOREAL ? "overmind_appear" : "overmind_disappear", src)
	setDir(SOUTH)
	addtimer(CALLBACK(src, PROC_REF(do_change_form)), TIME_TO_TRANSFORM)

///Finish the form changing of the hivemind and give the needed stats
/mob/living/carbon/xenomorph/overmind/proc/do_change_form()
	if(status_flags & INCORPOREAL)
		status_flags = NONE
		set_stats_manifest()
		density = TRUE
		update_wounds()
		update_icons()
		update_action_buttons()
		return
	status_flags = initial(status_flags)
	set_stats_incorporeal()
	density = FALSE
	setDir(SOUTH)
	update_wounds()
	update_icons()
	update_action_buttons()
	handle_weeds_adjacent_removed()

/mob/living/carbon/xenomorph/overmind/fire_act(burn_level)
	return_to_core()
	to_chat(src, SPAN_XENOBOLDNOTICE("We were on top of fire, we got moved to our core."))

/mob/living/carbon/xenomorph/overmind/proc/turf_weed_only(mob/self, turf/crossing_turf)
	SIGNAL_HANDLER

	if(!crossing_turf)
		return FALSE

	if(istype(crossing_turf, /turf/closed/wall))
		var/turf/closed/wall/crossing_wall = crossing_turf
		if(crossing_wall.turf_flags & TURF_HULL)
			return FALSE

	var/obj/effect/alien/weeds/nearby_weeds = locate() in crossing_turf
	if(nearby_weeds && HIVE_ALLIED_TO_HIVE(nearby_weeds.hivenumber, hivenumber))
		if(!(nearby_weeds.hivenumber == XENO_HIVE_PATHOGEN))
			nearby_weeds.update_icon() //randomizes the icon of the turf when crossed over*/
		return TRUE

	return FALSE

/mob/living/carbon/xenomorph/overmind/proc/handle_weeds_adjacent_removed()
	if(turf_weed_only(src, get_turf(src)))
		return TRUE
	return_to_core()
	to_chat(src, SPAN_XENOBOLDNOTICE("We had no weeds nearby, we got moved to our core."))
	return FALSE

/mob/living/carbon/xenomorph/overmind/proc/return_to_core()
	if(!(status_flags & INCORPOREAL) && COOLDOWN_FINISHED(src, cooldown_hivemind_manifestation))
		do_change_form()
	forceMove(get_turf(get_core()))

///Start the teleportation process to send the hivemind manifestation to the selected turf
/mob/living/carbon/xenomorph/overmind/proc/start_teleport(turf/T)
	if(!istype(T, /turf/open))
		balloon_alert(src, "can't teleport into a wall")
		return
	COOLDOWN_START(src, cooldown_hivemind_manifestation, TIME_TO_TRANSFORM * 2)
	flick("overmind_disappear", src)
	setDir(SOUTH)
	addtimer(CALLBACK(src, PROC_REF(end_teleport), T), TIME_TO_TRANSFORM)

///Finish the teleportation process to send the hivemind manifestation to the selected turf
/mob/living/carbon/xenomorph/overmind/proc/end_teleport(turf/T)
	if(!turf_weed_only(src, T))
		balloon_alert(src, "no weeds in destination")
		return FALSE
	forceMove(T)
	flick("overmind_appear", src)
	setDir(SOUTH)
	return TRUE

/mob/living/carbon/xenomorph/overmind/proc/setBruteLoss(amount)
	bruteloss = amount
/mob/living/carbon/xenomorph/overmind/proc/setFireLoss(amount)
	fireloss = amount

/mob/living/carbon/xenomorph/overmind/Move(atom/newloc, direction, glide_size_override)
	if(!COOLDOWN_FINISHED(src, cooldown_hivemind_manifestation))
		return
	if(!turf_weed_only(src, newloc))
		return FALSE
	if(!(status_flags & INCORPOREAL))
		return ..()

	abstract_move(newloc)

/mob/living/carbon/xenomorph/overmind/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!COOLDOWN_FINISHED(src, cooldown_hivemind_manifestation))
		return
	if(href_list["hivemind_jump"])
		var/mob/living/carbon/xenomorph/xeno = locate(href_list["hivemind_jump"])
		if(!istype(xeno))
			return
		jump(xeno)

/// Jump hivemind's camera to the passed xeno, if they are on/near weeds
/mob/living/carbon/xenomorph/overmind/proc/jump(mob/living/carbon/xenomorph/xeno)
	var/turf/target_turf = get_turf(xeno)
	if(!turf_weed_only(src, target_turf))
		balloon_alert(src, "no nearby weeds")
		return FALSE
	if(!(status_flags & INCORPOREAL))
		start_teleport(target_turf)
		return TRUE
	abstract_move(target_turf)
	return TRUE

/// handles hivemind updating with their respective weedtype
/mob/living/carbon/xenomorph/overmind/update_icons()
	. = ..()
	if(status_flags & INCORPOREAL)
		icon_state = "overmind_eye"
		return
	icon_state = "overmind_manifested"

/mob/living/carbon/xenomorph/overmind/Click(atom/target, list/mods)
	if(mods[CTRL_CLICK])
		if(!COOLDOWN_FINISHED(src, cooldown_hivemind_manifestation))
			return
		var/turf/target_turf = get_turf(target)
		if(!turf_weed_only(src, target_turf))
			return
		if(!(status_flags & INCORPOREAL))
			start_teleport(target_turf)
			return
		setDir(SOUTH)
		abstract_move(target_turf)
	else
		..()

/mob/living/carbon/xenomorph/overmind/a_intent_change()
	return //Unable to change intent, forced help intent

/// Hiveminds specifically have no status hud element
/mob/living/carbon/xenomorph/overmind/med_hud_set_status()
	return

/mob/living/carbon/xenomorph/overmind/update_progression()
	return

/// Getter proc for the weakref'd core
/mob/living/carbon/xenomorph/overmind/proc/get_core()
	return core?.resolve()

// =================
// hivemind core
/obj/effect/alien/resin/overmind
	name = "overmind core"
	desc = "A very weird, pulsating node. This looks almost alive."
	var/max_health = 600
	health = 600
	icon = 'icons/mob/pathogen/overmind_core.dmi'
	icon_state = "overmind_white"

	///The cooldown of the alert hivemind gets when a hostile is near it's core
	COOLDOWN_DECLARE(cooldown_overmind_proxy_alert)
	hivenumber = XENO_HIVE_PATHOGEN

	///The weakref to the parent hivemind mob that we're attached to
	var/datum/weakref/parent

/obj/effect/alien/resin/overmind/Initialize(mapload)
	. = ..()
	new /obj/effect/alien/weeds/node/pylon/pathogen_core(loc)
	set_light(7, 5, LIGHT_COLOR_YELLOW)

	for(var/turfs in RANGE_TURFS(OVERMIND_DETECTION_RANGE, src))
		RegisterSignal(turfs, COMSIG_TURF_ENTERED, PROC_REF(overmind_proxy_alert))

/obj/effect/alien/resin/overmind/Destroy()
	var/mob/living/carbon/xenomorph/overmind/our_parent = get_parent()
	if(isnull(our_parent))
		return ..()
	playsound(our_parent, 'sound/pathogen_creatures/pathogen_help.ogg', 30, TRUE)
	to_chat(our_parent, SPAN_XENOHIGHDANGER("Your core has been destroyed!"))
	xeno_message("A sudden tremor ripples through the hive... \the [our_parent] has been slain!", "xenoannounce", 5, our_parent.hivenumber)
	our_parent.ghostize()
	if(!QDELETED(our_parent))
		qdel(our_parent)
	return ..()

//hivemind cores

/obj/effect/alien/resin/overmind/attack_alien(mob/living/carbon/xenomorph/xeno_attacker)
	if(HIVE_ALLIED_TO_HIVE(hivenumber, xeno_attacker.hivenumber))
		xeno_attacker.visible_message(SPAN_DANGER("[xeno_attacker] nudges its head against [src]."), \
		SPAN_XENODANGER("You nudge your head against [src]."))
		return
	..()

/obj/effect/alien/resin/overmind/healthcheck()
	. = ..()
	var/mob/living/carbon/xenomorph/overmind/our_parent = get_parent()
	if(isnull(our_parent))
		return
	var/health_percent = round((max_health / health) * 100)
	switch(health_percent)
		if(-INFINITY to 25)
			to_chat(our_parent, SPAN_XENOHIGHDANGER("Your core is under attack, and dangerous low on health!"))
		if(26 to 75)
			to_chat(our_parent, SPAN_XENOHIGHDANGER("Your core is under attack, and low on health!"))
		if(76 to INFINITY)
			to_chat(our_parent, SPAN_XENOHIGHDANGER("Your core is under attack!"))

/**
 * Proc checks if we should alert the hivemind, and if it can, it does so.
 * datum/source - the atom (in this case it should be a turf) sending the crossed signal
 * atom/movable/hostile - the atom that triggered the crossed signal, in this case we're looking for a mob
 */
/obj/effect/alien/resin/overmind/proc/overmind_proxy_alert(datum/source, atom/movable/hostile)
	SIGNAL_HANDLER
	if(!COOLDOWN_FINISHED(src, cooldown_overmind_proxy_alert)) //Proxy alert triggered too recently; abort
		return

	if(!isliving(hostile))
		return

	var/mob/living/living_triggerer = hostile
	if(living_triggerer.stat == DEAD) //We don't care about the dead
		return

	if(isxeno(hostile))
		var/mob/living/carbon/xenomorph/X = hostile
		if(X.hivenumber == hivenumber) //Trigger proxy alert only for hostile xenos
			return

	xeno_announcement("Our [src.name] has detected a nearby hostile, [hostile], at [get_area(hostile)] (X: [hostile.x], Y: [hostile.y]).", XENO_HIVE_PATHOGEN, PATHOGEN_ANNOUNCE)
	SEND_SOUND(get_parent(), 'sound/pathogen_creatures/pathogen_help.ogg')
	COOLDOWN_START(src, cooldown_overmind_proxy_alert, OVERMIND_DETECTION_COOLDOWN) //set the cooldown.

/// Getter for the parent of this hive core
/obj/effect/alien/resin/overmind/proc/get_parent()
	return parent?.resolve()

#undef TIME_TO_TRANSFORM
