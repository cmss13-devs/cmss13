/datum/admins/proc/approve_overmind(mob/approver, mob/candidate)
	if(GLOB.overmind_cancel)
		return
	GLOB.overmind_cancel = TRUE

	var/datum/hive_status/pathogen/hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	if(!hive)
		message_admins("Pathogen Overmind assignment failed! (ERR-01)")
		return FALSE

	if(!hive.hive_structures[PATHOGEN_STRUCTURE_CORE])
		message_admins("Pathogen Overmind assignment failed! (ERR-02)")
		return FALSE

	var/obj/effect/alien/resin/special/pylon/pathogen_core/core = hive.hive_location
	if(!core || !istype(core))
		message_admins("Pathogen Overmind assignment failed! (ERR-03)")
		return FALSE

	if(core.overmind_mob)
		message_admins("Pathogen Overmind assignment failed! There is already an Overmind!")
		return FALSE

	log_game("[key_name_admin(approver)] has approved [key_name_admin(candidate)] to become the Pathogen Overmind!")
	message_admins("[key_name_admin(approver)] has approved [key_name_admin(candidate)] to become the Pathogen Overmind!")
	core.make_overmind(candidate)

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/allowed_to_overmind(mob/living/carbon/xenomorph/possible_overmind)
	if(overmind_mob)
		return FALSE
	if(jobban_isbanned(possible_overmind, XENO_CASTE_QUEEN))
		return FALSE
	if(!can_play_special_job(possible_overmind.client, XENO_CASTE_QUEEN))
		return FALSE
	return TRUE

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/admin_request_overmind(mob/living/carbon/xenomorph/possible_overmind)
	if(overmind_mob)
		return FALSE

	for(var/client/admin in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
			playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
	message_admins("[key_name(possible_overmind)] has requested to become the Pathogen Overmind! [CC_MARK(possible_overmind)] (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];overmind_approve=\ref[possible_overmind]'>APPROVE</A>) (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];overmind_deny=\ref[possible_overmind]'>DENY</A>) [ADMIN_JMP_USER(possible_overmind)]")
	return TRUE

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/make_overmind(mob/living/carbon/xenomorph/target_creature)
	if(!istype(target_creature) || target_creature.hivenumber != XENO_HIVE_PATHOGEN)
		return FALSE
	if(!target_creature.client)
		return FALSE
	if(overmind_mob)
		return FALSE

	// Moves the mob to the core
	overmind_mob = target_creature
	overmind_mob.forceMove(loc)
	overmind_mob.cannot_slash = TRUE
	overmind_mob.invisibility = 60

	overmind_stored_stuff["plasmagen"] = overmind_mob.plasma_gain
	overmind_stored_stuff["plasmamax"] = overmind_mob.plasma_max
	overmind_stored_stuff["maxhealth"] = overmind_mob.maxHealth
	overmind_stored_stuff["armor"] = overmind_mob.armor_deflection
	overmind_stored_stuff["aura"] = overmind_mob.aura_strength

	overmind_mob.plasma_gain = 6
	overmind_mob.plasma_max = 1400
	overmind_mob.maxHealth = 1400
	overmind_mob.armor_deflection = 45
	overmind_mob.aura_strength = 6

	ADD_TRAIT(overmind_mob, TRAIT_IMMOBILIZED, OVERMIND_TRAIT)
	ADD_TRAIT(overmind_mob, TRAIT_PATHOGEN_OVERMIND, OVERMIND_TRAIT)
	ADD_TRAIT(overmind_mob, TRAIT_UNDENSE, OVERMIND_TRAIT)
	overmind_mob.set_body_position(STANDING_UP)
	overmind_mob.set_resting(FALSE)

	overmind_mob.change_real_name(overmind_mob, "Overmind ([overmind_mob.full_designation])")
	overmind_mob.hive.set_living_xeno_queen(overmind_mob)
	linked_hive.add_hive_leader(overmind_mob)
	overmind_mob.lock_evolve = TRUE

	if(!overmind_strengthened)
		overmind_timer = addtimer(CALLBACK(src, PROC_REF(strengthen_overmind)), 600 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

	// Remove their abilities
	for(var/datum/action/xeno_action/action in overmind_mob.actions)
		action.remove_from(overmind_mob)

	var/list/abilities_to_give = overmind_abilities.Copy()

	if(!overmind_strengthened)
		abilities_to_give -= overmind_abilities_strong

	for(var/path in abilities_to_give)
		give_action(overmind_mob, path)

	overmind_mob.set_resin_build_order(GLOB.resin_build_order_pathogen_overmind)
	overmind_mob.extra_build_dist = IGNORE_BUILD_DISTANCE

	for(var/mob/living/carbon/xenomorph/X in GLOB.living_xeno_list)
		if(X.hivenumber == XENO_HIVE_PATHOGEN)
			to_chat(X, SPAN_PATHOGEN_ANNOUNCE("[overmind_mob.full_designation] has become the Overmind!"))

	return TRUE

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/strengthen_overmind()
	overmind_strengthened = TRUE
	if(overmind_mob)
		to_chat(overmind_mob, SPAN_PATHOGEN_ANNOUNCE("Your blight core has grown stronger! New abilities are now possible."))
		to_chat(overmind_mob, SPAN_PATHOGEN_QUEEN("Along with your new powers, your heal can now be used at incredible distances."))

		var/datum/action/xeno_action/activable/queen_heal/pathogen_mind/heal = get_action(overmind_mob, /datum/action/xeno_action/activable/queen_heal/pathogen_mind)
		heal.cross_map_heal = TRUE

		for(var/path in overmind_abilities_strong)
			give_action(overmind_mob, path)
	return TRUE

/obj/effect/alien/resin/special/pylon/pathogen_core/proc/unset_overmind()
	if(!overmind_mob)
		return FALSE

	// Returns their abilities
	for(var/datum/action/xeno_action/action in overmind_mob.actions)
		action.remove_from(overmind_mob)
	overmind_mob.add_abilities()

	// Removes the mob from the core

	if(overmind_timer)
		deltimer(overmind_timer)
	overmind_timer = null

	REMOVE_TRAIT(overmind_mob, TRAIT_IMMOBILIZED, OVERMIND_TRAIT)
	REMOVE_TRAIT(overmind_mob, TRAIT_PATHOGEN_OVERMIND, OVERMIND_TRAIT)
	REMOVE_TRAIT(overmind_mob, TRAIT_UNDENSE, OVERMIND_TRAIT)

	overmind_mob.generate_name()
	overmind_mob.plasma_gain = overmind_stored_stuff["plasmagen"]
	overmind_mob.plasma_max = overmind_stored_stuff["plasmamax"]
	overmind_mob.maxHealth = overmind_stored_stuff["maxhealth"]
	overmind_mob.armor_deflection = overmind_stored_stuff["armor"]
	overmind_mob.aura_strength = overmind_stored_stuff["aura"]
	overmind_stored_stuff["name"] = null
	overmind_stored_stuff["plasmagen"] = null
	overmind_stored_stuff["plasmamax"] = null
	overmind_stored_stuff["maxhealth"] = null
	overmind_stored_stuff["armor"] = null
	overmind_stored_stuff["aura"] = null

	overmind_mob.cannot_slash = FALSE
	overmind_mob.invisibility = initial(overmind_mob.invisibility)
	overmind_mob.hive.set_living_xeno_queen(null)
	linked_hive.remove_hive_leader(overmind_mob)

	for(var/mob/living/carbon/xenomorph/X in GLOB.living_xeno_list)
		if(X.hivenumber == XENO_HIVE_PATHOGEN)
			to_chat(X, SPAN_PATHOGEN_ANNOUNCE("[overmind_mob.full_designation] is no longer the Overmind!"))

	var/list/cocoons = linked_hive.hive_structures[PATHOGEN_STRUCTURE_COCOON]
	for(var/obj/effect/alien/resin/special/popper_cocoon/cocoon in cocoons)
		cocoon.death()

	overmind_mob.set_resin_build_order(overmind_mob.caste.resin_build_order)
	overmind_mob.extra_build_dist = initial(overmind_mob.extra_build_dist)

	last_overmind_key = overmind_mob.key
	overmind_mob.lock_evolve = FALSE
	overmind_mob = null


	return TRUE


/datum/action/xeno_action/onclick/exit_overmind
	name = "Exit Overmind"
	action_icon_state = "agility_off"
	plasma_cost = 0
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/onclick/exit_overmind/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/creature = owner
	var/datum/hive_status/pathogen/hive = creature.hive

	var/obj/effect/alien/resin/special/pylon/pathogen_core/core = hive.hive_location

	var/choice = tgui_alert(creature, "Do you want to step down from Overmind?", "Leave Overmind", list("Yes", "No"))

	if(choice != "Yes")
		return FALSE

	if(core.overmind_mob != creature)
		return FALSE

	core.unset_overmind()

	return ..()
