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
	///Name of the buff, short and to the point
	var/name = "Hivebuff"
	/// Description of what the buff does.
	var/desc = "Base hivebuff"

	/// Flavour message to announce to the hive on buff application. Narrated to all players.
	var/flavourmessage = ""

	///Cost of the buff
	var/price
	/// Minor or Major buff.
	var/tier = HIVEBUFF_TIER_MINOR
	/// The hive that this buff is applied to.
	var/datum/hive_status/hive
	/// Time that the buff is active for if it is a timed buff.
	var/duration
	/// Holder for the timer to call on_cease() if neccessary to end the effects.
	var/timer
	///If this buff can be used with others
	var/unique
	///If this buff can be used more than once a round.
	var/reusable
	///Cooldown before the buff can be used again.
	var/cooldown


/datum/hivebuff/New(datum/hive_status/xenohive)
	. = ..()
	if(!istype(xenohive))
		stack_trace("Hivebuff created without correct hive_status passed.")
		return FALSE
	hive = xenohive

	return TRUE

/datum/hivebuff/Destroy(force, ...)
	hive = null
	timer = null
	. = ..()

/// Entry point into the buff here when a buff is selected and set up this is the first proc to call.
/// Call parent after applying your buffs
/datum/hivebuff/proc/on_engage()
	SHOULD_CALL_PARENT(TRUE)
	hive.active_hivebuffs += src
	hive.used_hivebuffs += name
	if(!timer)
		on_cease()
	return TRUE

/// Any effects which need to be ended, called when a buff expires.
/datum/hivebuff/proc/on_cease()
	if(!reusable)
		hive.used_hivebuffs += name
	qdel(src)

////////////////////////////////
//		BUFFS
////////////////////////////////

/datum/hivebuff/extra_larva
	name = "Surge of Larva"
	desc = "Provides 5 larva instantly to the hive."

	flavourmessage = "The queen has purchased 5 extra larva to join the hive!"

	reusable = FALSE

/datum/hivebuff/extra_larva/on_engage()
	hive.stored_larva += 5
	. = ..()
