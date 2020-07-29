/*
Events are triggered through the round with some delay between each one and 20 minutes from roundstart.

The rolling system works currently on tickets (needs to be reworked):
	Each event has x tickets every time,
	These get added to a lottery,
	One is picked and wins.

Event subsystems checks if all prequisitions are fulfilled before adding an event to the current lottery,
	Checked by check_prerequisite() and returns TRUE if the event is valid, FALSE if not.

Once an event has won the lottery,
	activate() is called, for the event to do its thing.
*/

/datum/round_event
	var/name = "default"
	var/tickets = 1
	var/number = 0

/datum/round_event/proc/check_prerequisite()
	if(!RoleAuthority)
		return FALSE

	// Check that MPs exist
	var/datum/job/MP = RoleAuthority.roles_for_mode[JOB_POLICE]
	if(istype(MP) && MP.current_positions > 0)
		return TRUE

	var/datum/job/MW = RoleAuthority.roles_for_mode[JOB_WARDEN]
	if(istype(MW) && MW.current_positions > 0)
		return TRUE

	var/datum/job/CMP = RoleAuthority.roles_for_mode[JOB_CHIEF_POLICE]
	if(istype(CMP) && CMP.current_positions > 0)
		return TRUE

	return FALSE

/datum/round_event/proc/activate()
	return