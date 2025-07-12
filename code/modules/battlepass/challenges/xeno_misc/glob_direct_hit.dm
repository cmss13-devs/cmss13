/datum/battlepass_challenge/glob_hits
	name = "Direct Glob Hits"
	desc = "Land AMOUNT direct acid glob hits as a Boiler."
	challenge_category = CHALLENGE_XENO
	completion_xp = 6
	pick_weight = 6
	var/minimum = 1 as num
	var/maximum = 4 as num
	var/requirement = 0 as num
	var/filled = 0 as num

/datum/battlepass_challenge/glob_hits/New(client/owning_client)
	. = ..()
	if(!.)
		return .

	requirement = rand(minimum, maximum)
	regenerate_desc()

/datum/battlepass_challenge/glob_hits/regenerate_desc()
	desc = "Land [requirement] direct acid glob hit\s as a Boiler."

/datum/battlepass_challenge/glob_hits/on_client_login_mob(datum/source, mob/logged_in_mob)
	. = ..()
	if(!completed)
		RegisterSignal(logged_in_mob, COMSIG_FIRER_PROJECTILE_DIRECT_HIT, PROC_REF(on_sigtrigger))

/datum/battlepass_challenge/glob_hits/unhook_signals(mob/source)
	UnregisterSignal(source, COMSIG_FIRER_PROJECTILE_DIRECT_HIT)

/datum/battlepass_challenge/glob_hits/check_challenge_completed()
	return (filled >= requirement)

/datum/battlepass_challenge/glob_hits/get_completion_percent()
	return (filled / requirement)

/datum/battlepass_challenge/glob_hits/get_completion_numerator()
	return filled

/datum/battlepass_challenge/glob_hits/get_completion_denominator()
	return requirement

/datum/battlepass_challenge/glob_hits/serialize()
	. = ..()
	.["requirement"] = requirement
	.["filled"] = filled

/datum/battlepass_challenge/glob_hits/deserialize(list/save_list)
	. = ..()
	requirement = save_list["requirement"]
	filled = save_list["filled"]

/// When the xeno plants a resin node
/datum/battlepass_challenge/glob_hits/proc/on_sigtrigger(datum/source, obj/projectile/hit_projectile)
	SIGNAL_HANDLER
	if(!istype(hit_projectile.ammo, /datum/ammo/xeno/boiler_gas))
		return

	filled++
	on_possible_challenge_completed()


