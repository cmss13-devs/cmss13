#define RANDOM_EVENT_ADMIN_INTERVENTION_TIME (10 SECONDS)

#define INFINITE_EVENT_OCURRENCES -1

///this datum is used by the events controller to dictate how it selects events
/datum/round_event_control
	///The human-readable name of the event
	var/name
	///The typepath of the event datum /datum/round_event
	var/typepath
	/**
	  *The weight this event has in the random-selection process.
	  *Higher weights are more likely to be picked.
	  *10 is the default weight. 20 is twice more likely; 5 is half as likely as this default.
	  *0 here does NOT disable the event, it just makes it extremely unlikely
	  */
	var/weight = 10

	///The earliest world.time that an event can start (round-duration in deciseconds) default: 20 mins
	var/earliest_start = 20 MINUTES
	///The minimum amount of alive, non-AFK human players on server required to start the event.
	var/min_players = 0

	///How many times this event has occurred
	var/occurrences = 0
	//The maximum number of times this event can occur (naturally), it can still be forced.By setting this to 0 you can effectively disable an event.
	var/max_occurrences = 20

	//should we let the ghosts and admins know this event is firing? Disable on events that fire a lot
	var/alert_observers = TRUE

	//Event won't happen in these gamemodes
	var/list/gamemode_blacklist = list()
	//Event will happen ONLY in these gamemodes if not empty
	var/list/gamemode_whitelist = list()

	///admin cancellation
	var/triggering

/// Checks if the event can be spawned. Used by event controller. Admin-created events override this.
/datum/round_event_control/proc/can_spawn_event(players_amt, gamemode)
	if(occurrences >= max_occurrences && max_occurrences != INFINITE_EVENT_OCURRENCES)
		return FALSE
	if(earliest_start >= world.time-SSticker.round_start_time)
		return FALSE
	if(players_amt < min_players)
		return FALSE
	if(length(gamemode_blacklist) && (gamemode in gamemode_blacklist))
		return FALSE
	if(length(gamemode_whitelist) && !(gamemode in gamemode_whitelist))
		return FALSE
	return TRUE

/datum/round_event_control/proc/pre_run_event()
	if(!ispath(typepath, /datum/round_event))
		return EVENT_CANT_RUN

	triggering = TRUE
	if(alert_observers)
		message_admins("Random Event triggering in [DisplayTimeText(RANDOM_EVENT_ADMIN_INTERVENTION_TIME)]: [name]. (<a href='?src=[REF(src)];cancel=1'>CANCEL</a>)")
		sleep(RANDOM_EVENT_ADMIN_INTERVENTION_TIME)
		var/gamemode = SSticker.mode.config_tag
		var/players_amt = get_active_player_count(alive_check = TRUE, afk_check = TRUE)
		if(!can_spawn_event(players_amt, gamemode))
			message_admins("Second pre-condition check for [name] failed, skipping...")
			return EVENT_INTERRUPTED

	if(!triggering)
		return EVENT_CANCELLED //admin cancelled
	triggering = FALSE
	return EVENT_READY

/datum/round_event_control/Topic(href, href_list)
	..()
	if(href_list["cancel"])
		if(!triggering)
			to_chat(usr, SPAN_ADMIN("You are too late to cancel that event"))
			return
		triggering = FALSE
		message_admins("[key_name_admin(usr)] cancelled event [name].")
		log_admin("[key_name(usr)] cancelled event [name].")

/*
Runs the event
* Arguments:
* - random: shows if the event was triggered randomly, or by on purpose by an admin or an item
* - announce_chance_override: if the value is not null, overrides the announcement chance when an admin calls an event
*/
/datum/round_event_control/proc/run_event(random = FALSE, announce_chance_override = null, admin_forced = FALSE)
	/*
	* We clear our signals first so we dont cancel a wanted event by accident,
	* the majority of time the admin will probably want to cancel a single midround spawned random events
	* and not multiple events called by others admins
	* * In the worst case scenario we can still recall a event which we cancelled by accident, which is much better then to have a unwanted event
	*/
	UnregisterSignal(SSdcs, COMSIG_GLOB_RANDOM_EVENT)
	var/datum/round_event/E = new typepath(TRUE, src)
	E.current_players = get_active_player_count(alive_check = TRUE, afk_check = TRUE)
	occurrences++

	if(announce_chance_override != null)
		E.announce_chance = announce_chance_override

	testing("[time2text(world.time, "hh:mm:ss")] [E.type]")
	triggering = TRUE

	if(!triggering)
		RegisterSignal(SSdcs, COMSIG_GLOB_RANDOM_EVENT, PROC_REF(stop_random_event))
		E.cancel_event = TRUE
		return E

	triggering = FALSE
	if(random)
		log_game("Random Event triggering: [name] ([typepath])")

	return E

/// returns the component for the listener
/datum/round_event_control/proc/stop_random_event()
	SIGNAL_HANDLER
	return CANCEL_RANDOM_EVENT

//Special admins setup
/datum/round_event_control/proc/admin_setup()
	return

/datum/round_event	//NOTE: Times are measured in master controller ticks!
	var/processing = TRUE
	var/datum/round_event_control/control

	var/startWhen = 0 //When in the lifetime to call start().
	var/announce_when = 0 //When in the lifetime to call announce(). If you don't want it to announce use announce_chance, below.
	var/announce_chance = 100 // Probability of announcing, used in prob(), 0 to 100, default 100. Used in ion storms currently.
	var/endWhen = 0 //When in the lifetime the event should end.

	var/activeFor = 0 //How long the event has existed. You don't need to change this.
	var/current_players = 0 //Amount of of alive, non-AFK human players on server at the time of event start

	/// Whether a admin wants this event to be cancelled
	var/cancel_event = FALSE

//Called first before processing.
//Allows you to setup your event, such as randomly
//setting the startWhen and or announce_when variables.
//Only called once.
//EDIT: if there's anything you want to override within the new() call, it will not be overridden by the time this proc is called.
//It will only have been overridden by the time we get to announce() start() tick() or end() (anything but setup basically).
//This is really only for setting defaults which can be overridden later when New() finishes.
/datum/round_event/proc/setup()
	return

//Called when the tick is equal to the startWhen variable.
//Allows you to start before announcing or vice versa.
//Only called once.
/datum/round_event/proc/start()
	return

//Called when the tick is equal to the announce_when variable.
//Allows you to announce before starting or vice versa.
//Only called once.
/datum/round_event/proc/announce(fake)
	return

//Called on or after the tick counter is equal to startWhen.
//You can include code related to your event or add your own
//time stamped events.
//Called more than once.
/datum/round_event/proc/tick()
	return

//Called on or after the tick is equal or more than endWhen
//You can include code related to the event ending.
//Do not place spawn() in here, instead use tick() to check for
//the activeFor variable.
//For example: if(activeFor == myOwnVariable + 30) doStuff()
//Only called once.
/datum/round_event/proc/end()
	return

//Do not override this proc, instead use the appropiate procs.
//This proc will handle the calls to the appropiate procs.
/datum/round_event/process()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!processing)
		return

	if(SEND_GLOBAL_SIGNAL(COMSIG_GLOB_RANDOM_EVENT, src) & CANCEL_RANDOM_EVENT)
		processing = FALSE
		kill()
		return

	if(activeFor == startWhen)
		processing = FALSE
		start()
		processing = TRUE

	if(activeFor == announce_when && prob(announce_chance))
		processing = FALSE
		announce(FALSE)
		processing = TRUE

	if(startWhen < activeFor && activeFor < endWhen)
		processing = FALSE
		tick()
		processing = TRUE

	if(activeFor == endWhen)
		processing = FALSE
		end()
		processing = TRUE

	// Everything is done, let's clean up.
	if(activeFor >= endWhen && activeFor >= announce_when && activeFor >= startWhen)
		processing = FALSE
		kill()

	activeFor++


//Garbage collects the event by removing it from the global events list,
//which should be the only place it's referenced.
//Called when start(), announce() and end() has all been called.
/datum/round_event/proc/kill()
	SSevents.running -= src

//Sets up the event then adds the event to the the list of running events
/datum/round_event/New(my_processing = TRUE)
	setup()
	processing = my_processing
	SSevents.running += src
	return ..()

#undef RANDOM_EVENT_ADMIN_INTERVENTION_TIME
