
#define EVACUATION_TYPE_NONE 0
#define EVACUATION_TYPE_ADDITIVE 1
#define EVACUATION_TYPE_MULTIPLICATIVE 2

#define HIJACK_ANNOUNCE "ARES Emergency Procedures"
#define XENO_HIJACK_ANNOUNCE "You sense something unusual..."

#define EVACUATION_STATUS_NOT_INITIATED 0
#define EVACUATION_STATUS_INITIATED 1

#define HIJACK_OBJECTIVES_NOT_STARTED 0
#define HIJACK_OBJECTIVES_STARTED 1
#define HIJACK_OBJECTIVES_COMPLETE 2

SUBSYSTEM_DEF(hijack)
	name   = "Hijack"
	wait   = 2 SECONDS
	flags  = SS_NO_INIT | SS_KEEP_TIMING
	priority   = SS_PRIORITY_HIJACK

	///Required progress to evacuate safely via lifeboats
	var/required_progress = 100

	///Current progress towards evacuating safely via lifeboats
	var/current_progress = 0

	///The estimated time left to get to the safe evacuation point
	var/estimated_time_left = 0

	///Areas that are marked as having progress, assoc list that is progress_area = boolean, the boolean indicating if it was progressing or not on the last fire()
	var/list/progress_areas = list()

	///The areas that need cycled through currently
	var/list/current_run = list()

	///The progress of the current run that needs to be added at the end of the current run
	var/current_run_progress_additive = 0

	///Holds what the current_run_progress_additive should be multiplied by at the end of the current run
	var/current_run_progress_multiplicative = 1

	///Holds the progress change from last run
	var/last_run_progress_change = 0

	///Holds the next % point progress should be announced, increments on itself
	var/announce_checkpoint = 25

	///What stage of evacuation we are currently on
	var/evac_status = EVACUATION_STATUS_NOT_INITIATED

	///What stage of hijack are we currently on
	var/hijack_status = HIJACK_OBJECTIVES_NOT_STARTED

	///Whether or not evacuation has been disabled by admins
	var/evac_admin_denied = FALSE

	///Whether or not self destruct has been disabled by admins
	//var/evac_self_destruct_denied = FALSE // Re-enable for SD stuff - Morrow
