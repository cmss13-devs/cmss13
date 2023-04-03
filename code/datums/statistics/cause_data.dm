
/datum/cause_data
	var/datum/weakref/weak_mob
	var/ckey
	var/role
	var/faction
	var/cause_name
	var/datum/weakref/weak_cause

/datum/cause_data/proc/resolve_mob()
	if(!weak_mob)
		return null
	return weak_mob.resolve()

/datum/cause_data/proc/resolve_cause()
	if(!weak_cause)
		return null
	return weak_cause.resolve()

/proc/create_cause_data(new_cause, mob/M = null, obj/C = null)
	if(!new_cause)
		return null
	var/datum/cause_data/new_data = new()
	new_data.cause_name = new_cause
	if(C)
		new_data.weak_cause = WEAKREF(C)
	if(istype(M))
		new_data.weak_mob = WEAKREF(M)
		if(M.mind)
			new_data.ckey = M.mind.ckey
		new_data.role = M.get_role_name()
		new_data.faction = M.faction
	return new_data
