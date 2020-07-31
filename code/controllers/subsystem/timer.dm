#define BUCKET_LEN (round(10*(60/world.tick_lag), 1)) //how many ticks should we keep in the bucket. (1 minutes worth)
#define BUCKET_POS(timer) (round((timer.time_to_run - SStimer.head_offset) / world.tick_lag) + 1)
#define TIMER_ID_MAX (2**24) //max float with integer precision

var/datum/subsystem/timer/SStimer

/datum/subsystem/timer
	name          = "Timer"
	wait          = SS_INIT_TIMER
	flags         = SS_NO_INIT | SS_TICKER
	display_order = SS_DISPLAY_TIMER

	var/list/datum/timed_event/processing = list()
	var/list/hashes = list()

	var/head_offset = 0 //world.time of the first entry in the the bucket.
	var/practical_offset = 0 //index of the first non-empty item in the bucket.
	var/bucket_resolution = 0 //world.tick_lag the bucket was designed for
	var/bucket_count = 0 //how many timers are in the buckets

	var/list/bucket_list = list() //list of buckets, each bucket holds every timer that has to run that byond tick.

	var/list/timer_id_dict = list() //list of all active timers assoicated to their timer id (for easy lookup)

	var/list/clienttime_timers = list() //timers that run on "client time"

	var/log_bad_timers = FALSE

	var/list/bad_timerlist = list()

	var/last_invoke_tick = 0
	var/static/last_invoke_warning = 0
	var/static/bucket_auto_reset = TRUE

	var/static/times_flushed = 0
	var/static/times_crashed = 0

/datum/subsystem/timer/New()
	NEW_SS_GLOBAL(SStimer)


/datum/subsystem/timer/stat_entry()
	..("B:[bucket_count] P:[length(processing)] H:[length(hashes)] C:[length(clienttime_timers)][times_crashed ? " F:[times_crashed]" : ""]")


/datum/subsystem/timer/fire(resumed = FALSE)
	var/lit = last_invoke_tick
	var/last_check = world.time - TIMER_HANGS_WARNING
	var/list/bucket_list = src.bucket_list
	var/static/list/spent = list()

	if(!bucket_count)
		last_invoke_tick = world.time

	if(lit && lit < last_check && last_invoke_warning < last_check)
		last_invoke_warning = world.time
		var/msg = "No regular timers processed in the last [TIMER_HANGS_WARNING] ticks[bucket_auto_reset ? ", resetting buckets" : ""]!"
		times_crashed++
		message_admins(msg)
		WARNING(msg)
		if(bucket_auto_reset)
			bucket_resolution = 0

		//world << "Timer bucket reset. world.time: [world.time], head_offset: [head_offset], practical_offset: [practical_offset], times_flushed: [times_flushed], length(spent): [length(spent)]"
		for (var/i in 1 to bucket_list.len)
			var/datum/timed_event/bucket_head = bucket_list[i]
			if (!bucket_head)
				continue

			//world << "Active timers at index [i]:"

			var/datum/timed_event/bucket_node = bucket_head
			var/anti_loop_check = 1000
			do
				//world << "[get_timer_debug_string(bucket_node)]"
				bucket_node = bucket_node.next
				anti_loop_check--
			while(bucket_node && bucket_node != bucket_head && anti_loop_check)
		//world << "Active timers in the processing queue:"
		//for(var/I in processing)
		//	world << "[get_timer_debug_string(I)]"

	while(length(clienttime_timers))
		var/datum/timed_event/ctime_timer = clienttime_timers[clienttime_timers.len]
		if (ctime_timer.time_to_run <= REALTIMEOFDAY)
			--clienttime_timers.len
			var/datum/callback/callBack = ctime_timer.callBack
			ctime_timer.spent = TRUE
			callBack.InvokeAsync()
			qdel(ctime_timer)
		else
			break	//None of the rest are ready to run
		if (MC_TICK_CHECK)
			return

	var/static/datum/timed_event/timer
	var/static/datum/timed_event/head

	if (practical_offset > BUCKET_LEN || (!resumed  && length(bucket_list) != BUCKET_LEN || world.tick_lag != bucket_resolution))
		shift_buckets()
		bucket_list = src.bucket_list
		resumed = FALSE

	if (!resumed)
		timer = null
		head = null

	while (practical_offset <= BUCKET_LEN && head_offset + (practical_offset*world.tick_lag) <= world.time && !MC_TICK_CHECK)
		if (!timer || !head || timer == head)
			head = bucket_list[practical_offset]
			if (!head)
				practical_offset++
				if (MC_TICK_CHECK)
					break
				continue
			timer = head
		do
			var/datum/callback/callBack = timer.callBack
			if (!callBack)
				log_debug("Invalid timer: [timer] timer.time_to_run=[timer.time_to_run]||timer=[timer]||world.time=[world.time]||head_offset=[head_offset]||practical_offset=[practical_offset]||timer.spent=[timer.spent]")
				var/datum/timed_event/bad_timer = timer
				timer = timer.next
				if (timer == bad_timer)
					timer = null
				if(log_bad_timers)
					bad_timerlist += bad_timer
					bad_timer.cleanup_timer()
				else
					qdel(bad_timer)
				continue
				
			if (!timer.spent)
				spent += timer
				timer.spent = TRUE
				callBack.InvokeAsync()
				last_invoke_tick = world.time

			timer = timer.next

			if (MC_TICK_CHECK)
				return
		while (timer && timer != head)
		timer = null
		bucket_list[practical_offset++] = null
		if (MC_TICK_CHECK)
			return

	times_flushed++

	bucket_count -= length(spent)

	for (var/spent_timer in spent)
		qdel(spent_timer)

	spent.len = 0

/datum/subsystem/timer/proc/get_timer_debug_string(datum/timed_event/TE)
	. = "Timer: [TE]"
	. += "Prev: [TE.prev ? TE.prev : "NULL"], Next: [TE.next ? TE.next : "NULL"]"
	if(TE.spent)
		. += ", SPENT"
	if(!TE)
		. += ", QDELETED"

/datum/subsystem/timer/proc/shift_buckets()
	var/list/bucket_list = src.bucket_list
	var/list/all_timers = list()
	//collect the timers currently in the bucket
	for (var/bucket_head in bucket_list)
		if (!bucket_head)
			continue
		var/datum/timed_event/bucket_node = bucket_head
		do
			all_timers += bucket_node
			bucket_node = bucket_node.next
		while(bucket_node && bucket_node != bucket_head)

	bucket_list.len = 0
	bucket_list.len = BUCKET_LEN

	practical_offset = 1
	bucket_count = 0
	head_offset = world.time
	bucket_resolution = world.tick_lag

	all_timers += processing
	if (!all_timers.len)
		return

	sortTim(all_timers, /proc/cmp_timer)

	var/datum/timed_event/head = all_timers[1]

	if (head.time_to_run < head_offset)
		head_offset = head.time_to_run

	var/list/timers_to_remove = list()

	for (var/thing in all_timers)
		var/datum/timed_event/timer = thing
		if (!timer)
			timers_to_remove += timer
			continue

		var/bucket_pos = BUCKET_POS(timer)
		if (bucket_pos > BUCKET_LEN)
			break

		timers_to_remove += timer //remove it from the big list once we are done
		if (!timer.callBack || timer.spent)
			continue
		bucket_count++
		var/datum/timed_event/bucket_head = bucket_list[bucket_pos]
		if (!bucket_head)
			bucket_list[bucket_pos] = timer
			timer.next = null
			timer.prev = null
			continue

		if (!bucket_head.prev)
			bucket_head.prev = bucket_head
		timer.next = bucket_head
		timer.prev = bucket_head.prev
		timer.next.prev = timer
		timer.prev.next = timer

	processing = (all_timers - timers_to_remove)


/datum/subsystem/timer/Recover()
	processing |= SStimer.processing
	hashes |= SStimer.hashes
	timer_id_dict |= SStimer.timer_id_dict
	bucket_list |= SStimer.bucket_list

/datum/timed_event
	var/id
	var/datum/callback/callBack
	var/time_to_run
	var/hash
	var/list/flags
	var/spent = FALSE //set to true right before running.
	var/name //for easy debugging.

	// Circular doublely linked list
	var/datum/timed_event/next
	var/datum/timed_event/prev

	var/static/nextid = 1

/datum/timed_event/New(datum/callback/callBack, time_to_run, flags, hash)
	id = TIMER_ID_NULL
	src.callBack = callBack
	src.time_to_run = time_to_run
	src.flags = flags
	src.hash = hash

	if (flags & TIMER_UNIQUE)
		SStimer.hashes[hash] = src
	if (flags & TIMER_STOPPABLE)
		do
			if (nextid >= TIMER_ID_MAX)
				nextid = 1
			id = nextid++
		while(SStimer.timer_id_dict["timerid" + num2text(id, 8)])
		SStimer.timer_id_dict["timerid" + num2text(id, 8)] = src

	name = "Timer: " + num2text(id, 8) + ", TTR: [time_to_run], Flags: [jointext(bitfield2list(flags, list("TIMER_UNIQUE", "TIMER_OVERRIDE_UNIQUE", "TIMER_NO_WAIT_UNIQUE", "TIMER_CLIENT_TIME", "TIMER_STOPPABLE")), ", ")], callBack: \ref[callBack], callBack.object: [callBack.object]\ref[callBack.object]([getcallingtype()]), callBack.delegate:[callBack.delegate]([callBack.arguments ? callBack.arguments.Join(", ") : ""])"

	if (callBack.object != GLOBAL_PROC)
		LAZYADD(callBack.object.active_timers, src)

	if (flags & TIMER_CLIENT_TIME)
		//sorted insert
		var/list/ctts = SStimer.clienttime_timers
		var/cttl = length(ctts)
		if(cttl)
			var/datum/timed_event/Last = ctts[cttl]
			if(Last.time_to_run >= time_to_run)
				ctts += src
			else if(cttl > 1)
				for(var/I in cttl to 1)
					var/datum/timed_event/E = ctts[I]
					if(E.time_to_run <= time_to_run)
						ctts.Insert(src, I)
						break
		else
			ctts += src
		return

	//get the list of buckets
	var/list/bucket_list = SStimer.bucket_list
	//calculate our place in the bucket list
	var/bucket_pos = BUCKET_POS(src)
	//we are too far aways from needing to run to be in the bucket list, shift_buckets() will handle us.
	if (bucket_pos > bucket_list.len)
		SStimer.processing += src
		return
	//get the bucket for our tick
	var/datum/timed_event/bucket_head = bucket_list[bucket_pos]
	SStimer.bucket_count++
	//empty bucket, we will just add ourselves
	if (!bucket_head)
		bucket_list[bucket_pos] = src
		if (bucket_pos < SStimer.practical_offset)
			SStimer.practical_offset = bucket_pos
		return
	//other wise, lets do a simplified linked list add.
	if (!bucket_head.prev)
		bucket_head.prev = bucket_head
	next = bucket_head
	prev = bucket_head.prev
	next.prev = src
	prev.next = src

/datum/timed_event/Dispose()
	..()
	cleanup_timer()

	return GC_HINT_IWILLGC

// Clean up for storing a timer for logging and disposing
/datum/timed_event/proc/cleanup_timer()
	if (flags & TIMER_UNIQUE)
		SStimer.hashes -= hash

	if (callBack && callBack.object && callBack.object != GLOBAL_PROC && callBack.object.active_timers)
		callBack.object.active_timers -= src
		UNSETEMPTY(callBack.object.active_timers)

	callBack = null

	if (flags & TIMER_STOPPABLE)
		SStimer.timer_id_dict -= "timerid[id]"

	if (flags & TIMER_CLIENT_TIME)
		SStimer.clienttime_timers -= src
		return

	if (!spent)
		if (prev == next && next)
			if (next != src)
				next.prev = null
				prev.next = null
			else // We are the head and referencing ourself, so we just need to directly clear those refs
				next = null
				prev = null
		else
			if (prev)
				prev.next = next
			if (next)
				next.prev = prev

		var/bucketpos = BUCKET_POS(src)
		var/datum/timed_event/buckethead
		var/list/bucket_list = SStimer.bucket_list

		if (bucketpos > 0 && bucketpos <= length(bucket_list))
			buckethead = bucket_list[bucketpos]
			SStimer.bucket_count--
		else
			SStimer.processing -= src

		if (buckethead == src)
			bucket_list[bucketpos] = next
	else
		if (prev && prev.next == src)
			prev.next = next
		if (next && next.prev == src)
			next.prev = prev
	next = null
	prev = null

/datum/timed_event/proc/getcallingtype()
	. = "ERROR"
	if (callBack.object == GLOBAL_PROC)
		. = "GLOBAL PROC"
	else
		. = "[callBack.object.type]"

/proc/add_timer(datum/callback/callback, wait, flags)
	if (!callback)
		return

	wait = max(wait, 0)

	var/hash

	if (flags & TIMER_UNIQUE)
		var/list/hashlist
		if(flags & TIMER_NO_WAIT_UNIQUE)
			hashlist = list(callback.object, "(\ref[callback.object])", callback.delegate, flags & TIMER_CLIENT_TIME)
		else
			hashlist = list(callback.object, "(\ref[callback.object])", callback.delegate, wait, flags & TIMER_CLIENT_TIME)
		hashlist += callback.arguments
		hash = hashlist.Join("|||||||")
		var/datum/timed_event/hash_timer = SStimer.hashes[hash]
		if(hash_timer)
			if (hash_timer.spent) //it's pending deletion, pretend it doesn't exist.
				hash_timer.hash = null
				SStimer.hashes -= hash
			else
				if (flags & TIMER_OVERRIDE_UNIQUE)
					qdel(hash_timer)
				else
					if (hash_timer.flags & TIMER_STOPPABLE)
						. = hash_timer.id
					return

	var/time_to_run = world.time + wait
	if (flags & TIMER_CLIENT_TIME)
		time_to_run = REALTIMEOFDAY + wait

	var/datum/timed_event/timer = new(callback, time_to_run, flags, hash)
	if (flags & TIMER_STOPPABLE)
		return timer.id

/proc/delete_timer(id)
	if (!id)
		return FALSE
	if (id == TIMER_ID_NULL)
		CRASH("Tried to delete a null timerid. Use the TIMER_STOPPABLE flag.")
	if (!istext(id))
		if (istype(id, /datum/timed_event))
			qdel(id)
			return TRUE
	var/datum/timed_event/timer = SStimer.timer_id_dict["timerid[id]"]
	if (timer && !timer.spent)
		qdel(timer)
		return TRUE
	return FALSE


#undef BUCKET_LEN
#undef BUCKET_POS