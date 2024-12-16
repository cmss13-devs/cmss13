/datum/squad
	var/active_at = null

/datum/squad/New()
	roles_cap[JOB_SQUAD_ENGI] = 6
	roles_cap[JOB_SQUAD_MEDIC] = 8
	. = ..()

/datum/squad/marine/bravo
	active_at = 40

/datum/squad/marine/charlie
	active_at = 60

/datum/squad/marine/delta
	active_at = 20
