/*****************************
*
*	HIVE BUFFS	- XENOMORPH ENDGAME
*	Contains all the class definitons and code for applying hivebuffs to xeno hives.
*	Each buff consists of a /datum/hivebuff
*	And associated on_engage and on_cease procs to handle behaviour of activating and ending the buffs
*	Buffs are divided into 2 tiers, minor and major.
*
*****************************/

#define HIVEBUFF_TIER_MINOR 1
#define HIVEBUFF_TIER_MAJOR 2

GLOBAL_LIST_INIT(all_hivebuffs, list(/datum/hivebuff/extra_larva))

/datum/hivebuff
	/// Timer id to call on_cease() if neccessary to end the effects.
	var/_timer_id
	///Name of the buff, short and to the point
	var/name = "Hivebuff"
	/// Description of what the buff does.
	var/desc = "Base hivebuff"

	/// Flavour message to announce to the hive on buff application. Narrated to all players in the hive.
	var/engage_flavourmessage = "The qween has purchased a buff UwU!"
	/// Flavour message to announce to the hive on buff expiry. Narrated to all players in the hive.
	var/cease_flavourmessage = "Oh noes! =>.<= our buff has expired!!"

	/// Minor or Major buff.
	var/tier = HIVEBUFF_TIER_MINOR
	/// The hive that this buff is applied to.
	var/datum/hive_status/hive


	///If this buff can be used with others
	var/unique = TRUE
	///If this buff can be used more than once a round.
	var/reusable = FALSE
	///Cooldown before the buff can be used again.
	var/cooldown
	/// Time that the buff is active for if it is a timed buff.
	var/duration
	/// Cost of the buff
	var/price


/datum/hivebuff/New(datum/hive_status/xenohive)
	. = ..()
	if(!istype(xenohive))
		stack_trace("Hivebuff created without correct hive_status passed.")
		return FALSE
	hive = xenohive

	return TRUE

/datum/hivebuff/Destroy(force, ...)
	hive = null
	. = ..()

///Wrapper for on_engage(), handles adding buff to the active_hivebuffs and used_hivebuffs for the hive.
/datum/hivebuff/proc/_on_engage()
	if(!on_engage())
		return FALSE
	hive.active_hivebuffs += src
	hive.used_hivebuffs += name


	announce_buff_engage()

	if(!duration)
		on_cease()
	else
		_timer_id = addtimer(CALLBACK(src, PROC_REF(_on_cease)), duration)
	return TRUE

/// Behaviour for the buff goes in here. Return TRUE if your buff succeeds, FALSE if your buff fails.
/datum/hivebuff/proc/on_engage()
	return

/// Wrapper for on_cease(), calls qdel(src) after on_cease() behaviour.
/datum/hivebuff/proc/_on_cease()
	if(cease_flavourmessage)
		announce_buff_cease()
	on_cease()
	qdel(src)

/// Any effects which need to be ended, called when a buff expires.
/datum/hivebuff/proc/on_cease()
	return

/datum/hivebuff/proc/announce_buff_engage()
	if(!engage_flavourmessage)
		return
	if(tier > HIVEBUFF_TIER_MINOR)
		xeno_announcement(engage_flavourmessage, hive.hivenumber, "Buff Purchased")
	for(var/mob/xenomorph as anything in hive.totalXenos)
		if(!xenomorph.client)
			return
		xenomorph.play_screen_text(engage_flavourmessage, override_color = "#4e0044")
		if(tier <= HIVEBUFF_TIER_MINOR)
			to_chat(xenomorph, SPAN_XENO(engage_flavourmessage))

/datum/hivebuff/proc/announce_buff_cease()
	for(var/mob/living/xenomorph as anything in hive.totalXenos)
		if(!xenomorph.client)
			return
		xenomorph.play_screen_text(cease_flavourmessage, override_color = "#4e0044")
		to_chat(xenomorph, SPAN_XENO(cease_flavourmessage))



////////////////////////////////
//		BUFFS
////////////////////////////////

/datum/hivebuff/extra_larva
	name = "Surge of Larva"
	desc = "Provides 5 larva instantly to the hive."

	engage_flavourmessage = "The queen has purchased 5 extra larva to join the hive!"

	reusable = FALSE

/datum/hivebuff/extra_larva/on_engage()
	hive.stored_larva += 5
	return TRUE

/datum/hivebuff/extra_life
	name = "Boon of Plenty"
	desc = "Increases all xenomorph health by 10% for 10 seconds"
	tier = HIVEBUFF_TIER_MAJOR

	engage_flavourmessage = "The queen has imbued us with greater fortitude."
	duration = 20 SECONDS


/datum/hivebuff/extra_life/on_engage()
	for(var/mob/living/carbon/xenomorph/xeno as anything in hive.totalXenos)
		xeno.maxHealth *= 1.1
	return TRUE

/datum/hivebuff/extra_life/on_cease()
	for(var/mob/living/carbon/xenomorph/xeno as anything in hive.totalXenos)
		xeno.maxHealth = initial(xeno.caste.max_health)
	return TRUE
