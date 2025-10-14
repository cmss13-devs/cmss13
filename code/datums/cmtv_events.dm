/datum/cmtv_event
	/// What's the name of this event
	var/name

	/// Which signal we should be listening for
	var/listener

	/// Which argument position contains where we're gonna observe for a bit. Ignores the first argument, SSdcs
	var/spectate_arg_position = 1

	/// How long we're gonna be forcefully observing this for
	var/observation_timer = 20 SECONDS

/datum/cmtv_event/proc/handle_global_event()
	SScmtv.temporary_spectate_turf(args[spectate_arg_position + 1], observation_timer)

/datum/cmtv_event/orbital_bombardment
	name = "Orbital Bombardment"
	listener = COMSIG_GLOB_ORBITAL_BOMBARDMENT
	observation_timer = 30 SECONDS

/datum/cmtv_event/queen_death
	name = "Queen Death"
	listener = COMSIG_GLOB_QUEEN_DEATH

/datum/cmtv_event/dropship_impact
	name = "Dropship Impact"
	listener = COMSIG_GLOB_DROPSHIP_IMPACT
	observation_timer = 40 SECONDS

/datum/cmtv_event/dropship_locked
	name = "Dropship Locked"
	listener = COMSIG_GLOB_DROPSHIP_LOCKED

/datum/cmtv_event/firemission_imbound
	name = "Firemission Imbound"
	listener = COMSIG_GLOB_FIREMISSION_IMBOUND
