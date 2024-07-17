/mob/new_player
	var/datum/queued_player/que_data

SUBSYSTEM_DEF(queue)
	name = "Queue"
	wait = 5 SECONDS
	init_order = -101
	priority = SS_PRIORITY_ADMIN
	flags = SS_BACKGROUND

	var/list/datum/queued_tier/prioritized = list()
	var/list/queued = list()
	var/hard_popcap = FALSE

/datum/controller/subsystem/queue/Initialize()
	hard_popcap = CONFIG_GET(number/hard_popcap) //TODO MAKE CALCULATION OF MAX PLAYERS AND SOME LAG DETECT FEATURES TO GOOD
	if(!hard_popcap)
		can_fire = FALSE
	else
		can_fire = TRUE
	prioritized.len = 5
	for(var/i = 1 to 5)
		var/datum/queued_tier/tier = new()
		tier.priority = i
		prioritized[i] = tier
	return SS_INIT_SUCCESS

/datum/controller/subsystem/queue/stat_entry(msg)
	msg = "RС:[length(REAL_CLIENTS)]|QC:[length(GLOB.que_clients)]|QA:[length(GLOB.que_admins)]|QD:[length(GLOB.que_donaters)]|PCP:[(length(GLOB.clients)/max(hard_popcap, 1))*100]%"
	return ..()

/datum/controller/subsystem/queue/fire(resumed = FALSE)
	for(var/datum/queued_tier/priority in prioritized)
		priority.handle_queue()

/datum/controller/subsystem/queue/proc/queue_player(mob/new_player/new_player)
	GLOB.que_clients |= new_player.client
	var/datum/queued_player/info = new()

	var/donater = new_player.client.player_data.donator_info.patreon_function_available("queue")
	if(new_player.client.admin_holder)
		GLOB.que_admins |= new_player.client
		info.priority = 1
	else if(donater)
		GLOB.que_donaters |= new_player.client
		info.priority = donater
	else
		info.priority = 5

	var/potential_position = 1

	var/datum/queued_tier/priority
	for(var/i = 1 to info.priority)
		priority = prioritized[i]
		potential_position += length(priority.queued_players)
	priority.queued_players += info

	info.position = potential_position
	info.time_join = world.time
	info.new_player = new_player

	queued[info.position] = info
	return info

/datum/queued_tier
	var/priority = 0
	var/list/datum/queued_player/queued_players = list()

/datum/queued_tier/proc/handle_queue()
	for(var/datum/queued_player/queued_player in queued_players)
		queued_player.handle_position()

/datum/queued_player
	var/priority = 0
	var/position = 0
	var/time_join = 0
	var/mob/new_player/new_player

/datum/queued_player/proc/handle_position()
	var/potential_position = 0
	var/datum/queued_tier/priority
	for(var/i = 1 to priority)
		priority = SSqueue.prioritized[i]
		if(priority.priority < priority)
			potential_position += length(priority.queued_players)
		else if(priority.priority == priority)
			potential_position += priority.queued_players.Find(src)
	position = potential_position
	new_player.queue_player_panel(TRUE)
	if(REAL_CLIENTS < SSqueue.hard_popcap && position == 1)
		exit_queue()

/datum/queued_player/proc/exit_queue()
	GLOB.last_time_qued = world.time
	new_player.exit_queue()
	SSqueue.prioritized[priority].queued_players -= src
	SSqueue.queued -= src
	qdel(src)

/datum/queued_player/Destroy()
	GLOB.que_clients -= new_player.client
	if(priority < 2)
		GLOB.que_admins -= new_player.client
	else if(priority < 5)
		GLOB.que_donaters -= new_player.client

	position = null
	time_join = null
	new_player = null
	return ..()
