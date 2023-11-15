/**
 * # Autofire Subsystem
 *
 * Maintains a timer-like system to handle autofiring. Much of this code is modeled
 * after or adapted from TGMC's runechat subsytem.
 *
 * Note that this has the same structure for storing and queueing shooter component as the timer subsystem does
 * for handling timers: the bucket_list is a list of autofire component, each of which are the head
 * of a linked list. Any given index in bucket_list could be null, representing an empty bucket.
 *
 * Doesn't support any event scheduled for more than 100 ticks in the future, as it has no secondary queue by design
 */
SUBSYSTEM_DEF(automatedfire)
	name = "Automated fire"
	flags = SS_TICKER | SS_NO_INIT
	wait = 1
	priority = SS_PRIORITY_AUTOFIRE

	/// world.time of the first entry in the bucket list, effectively the 'start time' of the current buckets
	var/head_offset = 0
	/// Index of the first non-empty bucket
	var/practical_offset = 1
	///How many buckets for every frame of world.fps
	var/bucket_resolution = 0
	/// How many shooter are in the buckets
	var/shooter_count = 0
	/// List of buckets, each bucket holds every shooter that has to shoot this byond tick
	var/list/bucket_list = list()
	/// Reference to the next shooter before we clean shooter.next
	var/datum/component/automatedfire/next_shooter

/datum/controller/subsystem/automatedfire/PreInit()
	bucket_list.len = AUTOFIRE_BUCKET_LEN
	head_offset = world.time
	bucket_resolution = world.tick_lag

/datum/controller/subsystem/automatedfire/stat_entry(msg = "ActShooters: [shooter_count]")
	return ..()

/datum/controller/subsystem/automatedfire/fire(resumed = FALSE)
	// Check for when we need to loop the buckets, this occurs when
	// the head_offset is approaching AUTOFIRE_BUCKET_LEN ticks in the past
	if (practical_offset > AUTOFIRE_BUCKET_LEN)
		head_offset += TICKS2DS(AUTOFIRE_BUCKET_LEN)
		practical_offset = 1
		resumed = FALSE

	// Check for when we have to reset buckets, typically from auto-reset
	if ((length(bucket_list) != AUTOFIRE_BUCKET_LEN) || (world.tick_lag != bucket_resolution))
		reset_buckets()
		bucket_list = src.bucket_list
		resumed = FALSE

	// Store a reference to the 'working' shooter so that we can resume if the MC
	// has us stop mid-way through processing
	var/static/datum/component/automatedfire/shooter
	if (!resumed)
		shooter = null

	// Iterate through each bucket starting from the practical offset
	while (practical_offset <= AUTOFIRE_BUCKET_LEN && head_offset + ((practical_offset - 1) * world.tick_lag) <= world.time)
		if(!shooter)
			shooter = bucket_list[practical_offset]
			bucket_list[practical_offset] = null

		while (shooter)
			next_shooter = shooter.next
			INVOKE_ASYNC(shooter, TYPE_PROC_REF(/datum/component/automatedfire, process_shot))

			SSautomatedfire.shooter_count--
			shooter = next_shooter
			if (MC_TICK_CHECK)
				return

		// Move to the next bucket
		practical_offset++

/datum/controller/subsystem/automatedfire/Recover()
	bucket_list |= SSautomatedfire.bucket_list

///In the event of a change of world.tick_lag, we refresh the size of the bucket and the bucket resolution
/datum/controller/subsystem/automatedfire/proc/reset_buckets()
	bucket_list.len = AUTOFIRE_BUCKET_LEN
	head_offset = world.time
	bucket_resolution = world.tick_lag
