//GLOBAL DEFINES//

#define HIVE_STARTING_BUFFPOINTS 0
#define HIVE_MAX_BUFFPOINTS 10
#define BUFF_POINTS_NAME "Royal resin"

//LOCAL DEFINES//

#define HIVEBUFF_TIER_MINOR "Minor"
#define HIVEBUFF_TIER_MAJOR "Major"

/**
 *
 *	HIVE BUFFS - XENOMORPH ENDGAME
 *	Contains all the class definitons and code for applying hivebuffs to xeno hives.
 *	Each buff consists of a /datum/hivebuff
 *	And associated on_engage and on_cease procs to handle behaviour of activating and ending the buffs
 *	Buffs are divided into 2 tiers, minor and major.
 *
 */
/datum/hivebuff
	/// Timer id for cooldown duration
	var/_timer_id_cooldown = TIMER_ID_NULL
	/// The hive that this buff is applied to.
	var/datum/hive_status/hive
	///Name of the buff, short and to the point
	var/name = "Hivebuff"
	/// Description of what the buff does.
	var/desc = "Base hivebuff"
	/// Path to .dmi with hivebuff radial icons
	var/hivebuff_radial_dmi = 'icons/ui_icons/hivebuff_radial.dmi'
	/// Image to display on radial menu
	var/radial_icon = "health"
	/// Round time before the buff becomes available to purchase
	var/roundtime_to_enable = 0 HOURS

	/// Flavour message to announce to the hive on buff application. Narrated to all players in the hive.
	var/engage_flavourmessage
	/// Flavour message to announce to the hive on buff expiry. Narrated to all players in the hive.
	var/cease_flavourmessage

	/// Minor or Major buff. Governs announcements made and importance.
	var/tier = HIVEBUFF_TIER_MINOR
	/// Number of pylons required to buy the buff
	var/number_of_required_pylons = 1
	///If this buff can be used with others
	var/is_combineable = TRUE
	///If this buff can be used more than once a round.
	var/is_reusable = TRUE
	/// Time that the buff is active for if it is a timed buff.
	var/duration
	/// Time that the buff is on cooldown after ending
	var/cooldown_duration
	/// Cost of the buff
	var/cost = 1

	/// Message to send to the user and queen if we fail for any reason during on_engage()
	var/engage_failure_message

	/// Flavour message to give to the marines on buff engage
	var/marine_flavourmessage

	/// Apply the buff effect to new xenomorphs who spawn or evolve.
	var/apply_on_new_xeno = TRUE

	/// Special fail message
	var/special_fail_message = ""

	/// Ask the buyer where to put the buff
	var/must_select_pylon = FALSE

	/// _on_cease timer id
	var/cease_timer_id

/datum/hivebuff/New(datum/hive_status/xenohive)
	. = ..()
	if(!xenohive || !istype(xenohive))
		stack_trace("Hivebuff created without correct hive_status passed.")
		return FALSE
	hive = xenohive

	if(!engage_flavourmessage)
		engage_flavourmessage = "The Queen has purchased [name]."
	if(!cease_flavourmessage)
		cease_flavourmessage = "The [name] has expired."

	return TRUE

/datum/hivebuff/Destroy(force, ...)
	LAZYREMOVE(hive.active_hivebuffs, src)
	LAZYREMOVE(hive.used_hivebuffs, src)
	LAZYREMOVE(hive.cooldown_hivebuffs, src)
	hive = null
	return ..()

///Wrapper for on_engage(), handles checking if the buff can be actually purchased as well as adding buff to the active_hivebuffs and used_hivebuffs for the hive.
/datum/hivebuff/proc/_on_engage(mob/living/carbon/xenomorph/purchasing_mob, obj/effect/alien/resin/special/pylon/purchased_pylon)
	if(!_roundtime_check())
		to_chat(purchasing_mob, SPAN_XENONOTICE("Our hive is not mature enough yet to purchase this!"))
		return

	if(!_check_num_required_pylons())
		to_chat(purchasing_mob, SPAN_XENONOTICE("Our hive does not have the required number of available pylons! We require [number_of_required_pylons]"))
		return FALSE

	if(!_check_danger())
		to_chat(purchasing_mob, SPAN_XENONOTICE("There is not enough danger to warrant hive buffs."))
		return FALSE

	if(!_check_can_afford_buff())
		to_chat(purchasing_mob, SPAN_XENONOTICE("Our hive cannot afford [name]! [hive.buff_points] / [cost] points."))
		return FALSE

	if(!_check_pass_active())
		to_chat(purchasing_mob, SPAN_XENONOTICE("Our hive can't benefit from [name] yet!"))
		return FALSE

	if(!_check_pass_reusable())
		to_chat(purchasing_mob, SPAN_XENONOTICE("Our hive has already used [name] and cannot use it again!"))
		return FALSE

	var/datum/hivebuff/cooldown_buff = locate(type) in hive.cooldown_hivebuffs
	if(cooldown_buff)
		to_chat(purchasing_mob, SPAN_XENONOTICE("Our hive has already used [name] recently! Wait [DisplayTimeText(timeleft(cooldown_buff._timer_id_cooldown))]."))
		return FALSE

	if(!_check_pass_combineable())
		var/active_buffs = ""
		for(var/buff in hive.active_hivebuffs)
			active_buffs += buff + " "
		active_buffs = trim_right(active_buffs)
		to_chat(purchasing_mob, SPAN_XENONOTICE("[name] cannot be used with other active buffs! Wait for those to end first. Active buffs: [active_buffs]"))
		return FALSE

	if(!handle_special_checks())
		to_chat(purchasing_mob, SPAN_XENONOTICE(special_fail_message))
		return FALSE

	log_admin("[key_name(purchasing_mob)] of [hive.hivenumber] is attempting to purchase a hive buff: [name].")

	if(!_seek_queen_approval(purchasing_mob))
		return FALSE

	// _seek_queen_approval() includes a 20 second timeout so we check that everything still exists that we need.
	if(QDELETED(purchasing_mob) && !purchasing_mob.check_state())
		return FALSE

	// Actually process the buff and apply effects - If the buff succeeds engage_message will return TRUE, if it fails there should be an engage_failure_message set.
	if(!on_engage(purchased_pylon))
		if(engage_failure_message && istext(engage_failure_message))
			to_chat(purchasing_mob, SPAN_XENONOTICE(engage_failure_message))
			to_chat(hive.living_xeno_queen, SPAN_XENONOTICE(engage_failure_message))
			return
		else
			stack_trace("[purchasing_mob] attempted to purchase a hive buff: [name] and failed to engage and returned an invalid failure message or no failure message.")
			return

	// All checks have passed.

	// Purchase and deduct funds only after we're sure the buff has engaged
	if(!_purchase_and_deduct(purchasing_mob))
		return

	for(var/mob/living/carbon/xenomorph/xeno in hive.totalXenos)
		apply_buff_effects(xeno)

	if(apply_on_new_xeno)
		RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(_handle_xenomorph_new))

	var/involved = purchasing_mob == hive.living_xeno_queen ? "[key_name_admin(purchasing_mob)]" : "[key_name_admin(purchasing_mob)] and [key_name_admin(hive.living_xeno_queen)]"
	message_admins("[involved] of [hive.hivenumber] has purchased a hive buff: [name].")

	// Add to the relevant hive lists.
	LAZYADD(hive.used_hivebuffs, src)
	LAZYADD(hive.active_hivebuffs, src)

	// Announce to our hive that we've completed.
	_announce_buff_engage()

	// If we need a timer to call _on_cease() we add it here and store the id, used for deleting the timer if we Destroy().
	// If we have no duration to the buff then we call _on_cease() immediately.
	if(duration)
		cease_timer_id = addtimer(CALLBACK(src, PROC_REF(_on_cease)), duration, TIMER_STOPPABLE|TIMER_DELETE_ME)
	else
		_on_cease()
	return TRUE

/// Behaviour for the buff goes in here.
/// IMPORTANT: If you buff has any kind of conditions which can fail. Set an engage_failure_message and return FALSE.
/// If your buff succeeds you must return TRUE
/datum/hivebuff/proc/on_engage(obj/effect/alien/resin/special/pylon/purchased_pylon)
	return TRUE

/// Wrapper for on_cease()
/datum/hivebuff/proc/_on_cease()
	if(cease_timer_id)
		deltimer(cease_timer_id)

	_announce_buff_cease()
	on_cease()
	LAZYREMOVE(hive.active_hivebuffs, src)
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)

	for(var/mob/living/carbon/xenomorph/xeno in hive.totalXenos)
		remove_buff_effects(xeno)

	if(cooldown_duration)
		LAZYADD(hive.cooldown_hivebuffs, src)
		_timer_id_cooldown = addtimer(CALLBACK(src, PROC_REF(_on_cooldown_end)), cooldown_duration, TIMER_STOPPABLE|TIMER_DELETE_ME)

/// Handler for the end of a cooldown
/datum/hivebuff/proc/_on_cooldown_end()
	LAZYREMOVE(hive.cooldown_hivebuffs, src)
	_timer_id_cooldown = TIMER_ID_NULL

/// Checks the number of pylons required and if the hive posesses them
/datum/hivebuff/proc/_check_num_required_pylons()
	return number_of_required_pylons >= hive.active_endgame_pylons

/datum/hivebuff/proc/_roundtime_check()
	if(ROUND_TIME > roundtime_to_enable)
		return TRUE
	return FALSE

/datum/hivebuff/proc/_check_danger()
	var/groundside_humans = 0
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue

		var/turf/turf = get_turf(current_human)
		if(is_ground_level(turf?.z))
			groundside_humans++
			if(groundside_humans >= 12)
				return TRUE

	return FALSE

/// Checks if the hive can afford to purchase the buff returns TRUE if they can purchase and FALSE if not.
/datum/hivebuff/proc/_check_can_afford_buff()
	if(hive.buff_points < cost)
		return FALSE

	return TRUE

/// Checks if this buff is already active in the hive. Returns TRUE if passed FALSE if not.
/datum/hivebuff/proc/_check_pass_active()
	// Prevent the same lineage of buff (e.g. no minor and major health allowed)
	for(var/datum/hivebuff/buff as anything in hive.active_hivebuffs)
		if(istype(src, buff.type))
			return FALSE
		if(istype(buff, type))
			return FALSE

	return TRUE

/// Checks if the buff is combineable if other buffs are already in use. Return TRUE if passed FALSE if not.
/datum/hivebuff/proc/_check_pass_combineable()
	if(is_combineable)
		return TRUE
	for(var/datum/hivebuff/active_hivebuff in hive.active_hivebuffs)
		if(!active_hivebuff.is_combineable)
			return FALSE
	return TRUE

/// Checks if the buff is reusable and if it's already been used. Returns TRUE if passed, FALSE if not.
/datum/hivebuff/proc/_check_pass_reusable()
	if(is_reusable)
		return TRUE

	for(var/datum/hivebuff/buff as anything in hive.used_hivebuffs)
		if(type == buff.type)
			return FALSE

	return TRUE

/// Deducts points from the hive buff points equal to the cost of the buff
/datum/hivebuff/proc/_purchase_and_deduct(mob/purchasing_mob)
	if(!_check_can_afford_buff())
		to_chat(purchasing_mob, SPAN_XENONOTICE("Something went wrong, try again."))
		return FALSE

	hive.buff_points -= cost
	hive.check_if_hit_larva_from_pylon_limit()
	return TRUE

/datum/hivebuff/proc/_seek_queen_approval(mob/living/purchasing_mob)
	if(!hive.living_xeno_queen)
		return FALSE

	var/mob/living/queen = hive.living_xeno_queen
	var/queen_response = tgui_alert(queen, "You are trying to Purchase [name] at a cost of [cost] [BUFF_POINTS_NAME]. Our hive has [hive.buff_points] [BUFF_POINTS_NAME]. Are you sure you want to purchase it? Description: [desc]", "Approve Hive Buff", list("Yes", "No"), 20 SECONDS)

	return queen_response == "Yes"

/// Any effects which need to be ended or ceased gracefully, called when a buff expires.
/datum/hivebuff/proc/on_cease()
	return

/datum/hivebuff/proc/_announce_buff_engage()
	if(engage_flavourmessage)
		xeno_announcement(SPAN_XENOANNOUNCE(engage_flavourmessage), hive.hivenumber, XENO_GENERAL_ANNOUNCE)

	if(marine_flavourmessage)
		marine_announcement(marine_flavourmessage, COMMAND_ANNOUNCE, 'sound/AI/bioscan.ogg')

/datum/hivebuff/proc/_announce_buff_cease()
	if(!duration)
		return

	for(var/mob/living/xenomorph as anything in hive.totalXenos)
		if(!xenomorph.client)
			continue
		xenomorph.play_screen_text(cease_flavourmessage, override_color = "#740064")
		to_chat(xenomorph, SPAN_XENO(cease_flavourmessage))

///Signal handler for new xenomorphs joining the hive
/datum/hivebuff/proc/_handle_xenomorph_new(datum/source, mob/living/carbon/xenomorph/new_xeno)
	SIGNAL_HANDLER
	if(!apply_on_new_xeno)
		return

	if(!(src in hive.active_hivebuffs))
		return
	// If we're the same hive as the buff
	if(new_xeno.hive == hive)
		apply_buff_effects(new_xeno)

///The actual effects of the buff to apply
/datum/hivebuff/proc/apply_buff_effects(mob/living/carbon/xenomorph/xeno)
	return

/// Reverse the effects here, should be the opposite of apply_effects()
/datum/hivebuff/proc/remove_buff_effects(mob/living/carbon/xenomorph/xeno)
	return

/datum/hivebuff/proc/handle_special_checks()
	return TRUE


// BUFFS //

/datum/hivebuff/extra_larva
	name = "Surge of Larva"
	desc = "Provides 5 larva instantly to the hive."
	radial_icon = "larba"

	engage_flavourmessage = "The Queen has purchased 5 extra larva to join the hive!"
	cost = 5
	number_of_required_pylons = 1
	is_reusable = FALSE

/datum/hivebuff/extra_larva/on_engage(obj/effect/alien/resin/special/pylon/purchased_pylon)
	hive.stored_larva += 5
	return TRUE

/datum/hivebuff/evo_buff
	name = "Boon of Evolution"
	desc = "Doubles evolution speed for 5 minutes."
	tier = HIVEBUFF_TIER_MINOR
	engage_flavourmessage = "The Queen has blessed us with faster evolution."
	duration = 5 MINUTES
	number_of_required_pylons = 1
	var/value_before_buff

/datum/hivebuff/evo_buff/on_engage(obj/effect/alien/resin/special/pylon/purchased_pylon)
	value_before_buff = SSxevolution.get_evolution_boost_power(hive.hivenumber)
	hive.override_evilution(value_before_buff * 2, TRUE)

	return TRUE

/datum/hivebuff/evo_buff/on_cease()
	hive.override_evilution(value_before_buff, FALSE)

/datum/hivebuff/evo_buff/major
	name = "Major Boon of Evolution"
	desc = "Doubles evolution speed for 10 minutes and allows evolution progress without an ovipositor."
	tier = HIVEBUFF_TIER_MAJOR

	engage_flavourmessage = "The Queen has blessed us with faster evolution."
	duration = 10 MINUTES
	cost = 2
	number_of_required_pylons = 2
	radial_icon = "health_m"

/datum/hivebuff/evo_buff/major/on_engage(obj/effect/alien/resin/special/pylon/purchased_pylon)
	hive.allow_no_queen_evo = TRUE

	return ..()

/datum/hivebuff/evo_buff/major/on_cease()
	. = ..()
	hive.allow_no_queen_evo = FALSE

/datum/hivebuff/game_ender_caste
	name = "His Grace"
	desc = "A huge behemoth of a Xenomorph which can tear its way through defences and flesh alike. Requires open space around the hive core to spawn."
	tier = HIVEBUFF_TIER_MAJOR
	radial_icon = "king"

	is_reusable = TRUE
	cost = 0
	special_fail_message = "Only one hatchery may exist at a time."
	cooldown_duration = 15 MINUTES // This buff ceases instantly so we need to incorporation the spawning time too
	number_of_required_pylons = 2

/datum/hivebuff/game_ender_caste/New()
	roundtime_to_enable = GLOB.king_acquisition_time

	return ..()

/datum/hivebuff/game_ender_caste/handle_special_checks()
	if(locate(/mob/living/carbon/xenomorph/king) in hive.totalXenos)
		special_fail_message = "Only one King may exist at a time."
		return FALSE

	if(!hive.hive_location)
		special_fail_message = "You must first construct a hive core."
		return FALSE

	return !hive.has_hatchery

/datum/hivebuff/game_ender_caste/on_engage(obj/effect/alien/resin/special/pylon/purchased_pylon)
	var/turf/spawn_turf
	for(var/turf/potential_turf in orange(5, hive.hive_location))
		var/failed = FALSE
		for(var/x_offset in -1 to 1)
			for(var/y_offset in -1 to 1)
				var/turf/turf_to_check = locate(potential_turf.x + x_offset, potential_turf.y + y_offset, potential_turf.z)
				if(turf_to_check.density)
					failed = TRUE
					break
				if(!turf_to_check.is_weedable())
					failed = TRUE
					break
				var/area/target_area = get_area(turf_to_check)
				if(target_area.flags_area & AREA_NOTUNNEL)
					failed = TRUE
					break
				for(var/obj/structure/struct in turf_to_check)
					if(struct.density)
						failed = TRUE
						break
				for(var/obj/effect/alien/resin/special in turf_to_check)
					failed = TRUE
					break
		if(!failed)
			spawn_turf = potential_turf
			break

	if(!spawn_turf)
		engage_failure_message = "Unable to find a viable spawn point for the King."
		return FALSE

	for(var/obj/effect/alien/resin/special/pylon/pylon as anything in hive.active_endgame_pylons)
		pylon.protection_level = TURF_PROTECTION_OB
		pylon.update_icon()

	new /obj/effect/alien/resin/king_cocoon(spawn_turf, hive.hivenumber)

	return TRUE

/datum/hivebuff/fire
	name = "Boon of Fire Resistance"
	desc = "Makes all xenomorphs immune to fire for 5 minutes."
	tier = HIVEBUFF_TIER_MINOR

	engage_flavourmessage = "The Queen has imbued us with flame-resistant chitin."
	duration = 5 MINUTES
	number_of_required_pylons = 1
	radial_icon = "shield"

/datum/hivebuff/fire/apply_buff_effects(mob/living/carbon/xenomorph/xeno)
	if(!xeno.caste)
		return

	if(!(xeno.caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE))
		RegisterSignal(xeno, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))

	if(xeno.caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(xeno, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED), PROC_REF(flamer_crossed_immune))
		

/datum/hivebuff/fire/remove_buff_effects(mob/living/carbon/xenomorph/xeno)
	if(!(xeno.caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE))
		UnregisterSignal(xeno, COMSIG_LIVING_PREIGNITION)
	if(xeno.caste.fire_immunity == FIRE_IMMUNITY_NONE)
		UnregisterSignal(xeno, list(
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED
			))

/datum/hivebuff/fire/proc/flamer_crossed_immune(mob/living/living, datum/reagent/reagent)
	SIGNAL_HANDLER

	if(reagent.fire_penetrating)
		return

	. |= COMPONENT_NO_IGNITE


/datum/hivebuff/fire/proc/fire_immune(mob/living/living)
	SIGNAL_HANDLER

	if(living.fire_reagent?.fire_penetrating && !HAS_TRAIT(living, TRAIT_ABILITY_BURROWED))
		return

	return COMPONENT_CANCEL_IGNITION

/datum/hivebuff/adaptability
	name = "Boon of Adaptability"
	desc = "Allows each xenomorph to change to a different caste of the same tier."
	tier = HIVEBUFF_TIER_MAJOR

	engage_flavourmessage = "The Queen has blessed us with adaptability."
	duration = 0
	cost = 2
	number_of_required_pylons = 2
	radial_icon = "shield_m"

/datum/hivebuff/adaptability/apply_buff_effects(mob/living/carbon/xenomorph/xeno)
	if(xeno.caste.tier > 3)
		return

	if(get_action(xeno, /datum/action/xeno_action/onclick/transmute))
		return
	
	add_verb(xeno, /mob/living/carbon/xenomorph/proc/transmute_verb)
	var/datum/action/xeno_action/onclick/transmute/transmute_action = new()
	transmute_action.give_to(xeno)

/datum/hivebuff/attack
	name = "Boon of Aggression"
	desc = "Increases all xenomorph damage by 5 for 5 minutes"
	tier = HIVEBUFF_TIER_MINOR

	engage_flavourmessage = "The Queen has imbued us with sharp claws."
	duration = 5 MINUTES
	number_of_required_pylons = 1
	radial_icon = "slash"

/datum/hivebuff/attack/apply_buff_effects(mob/living/carbon/xenomorph/xeno)
	xeno.damage_modifier += XENO_DAMAGE_MOD_VERY_SMALL
	xeno.recalculate_damage()

/datum/hivebuff/attack/remove_buff_effects(mob/living/carbon/xenomorph/xeno)
	xeno.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	xeno.recalculate_damage()

/datum/hivebuff/attack/major
	name = "Major Boon of Aggression"
	desc = "Increases all xenomorph damage by 10 for 10 minutes"
	tier = HIVEBUFF_TIER_MAJOR

	engage_flavourmessage = "The Queen has imbued us with razor-sharp claws."
	duration = 10 MINUTES
	number_of_required_pylons = 2
	cost = 2
	radial_icon = "slash_m"

/datum/hivebuff/attack/major/apply_buff_effects(mob/living/carbon/xenomorph/xeno)
	xeno.damage_modifier += XENO_DAMAGE_MOD_SMALL
	xeno.recalculate_damage()

/datum/hivebuff/attack/major/remove_buff_effects(mob/living/carbon/xenomorph/xeno)
	xeno.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	xeno.recalculate_damage()
