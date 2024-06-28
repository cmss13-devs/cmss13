/datum/faction_task
	var/name = "INSERT"
	var/desc = "INSERT"
	var/list/announce_desc = list("complete" = "Good job, sector taken, ", "failed" = "Sector control failed")
	var/state = OBJECTIVE_INACTIVE

	var/score = 0

	var/game_ender = FALSE
	var/rand_total_time = FALSE
	var/total_time = 0
	COOLDOWN_DECLARE(remaining_time)

	var/task_type
	var/task_color
	var/datum/faction/faction_owner

/datum/faction_task/New(datum/faction/faction_to_set)
	. = ..()

	if(rand_total_time)
		total_time += rand(-total_time, total_time) / 2

	faction_owner = faction_to_set
	SSfactions.add_task(src)
	activate()

/datum/faction_task/Destroy()
	SSfactions.stop_processing_task(src)
	SSfactions.remove_task(src)
	return ..()

/datum/faction_task/proc/activate()
	if(total_time)
		COOLDOWN_START(src, total_time, total_time)
	SSfactions.start_processing_task(src)

/datum/faction_task/proc/deactivate()
	SSfactions.stop_processing_task(src)

/datum/faction_task/proc/check_completion()
	return

/datum/faction_task/proc/complete(end_state)
	state = end_state

	if(state & OBJECTIVE_COMPLETE)
		faction_owner.faction_victory_points += score
	announce_faction()

/datum/faction_task/proc/announce_faction()
	faction_announcement(state & OBJECTIVE_COMPLETE ? announce_desc["complete"] : announce_desc["failed"], name, null, faction_owner)

/datum/faction_task/proc/get_completion_status()
	if(state & OBJECTIVE_IN_PROGRESS)
		return "<span class='objectivebig'>In Progress!</span>"
	else if(state & OBJECTIVE_FAILED)
		return "<span class='objectivefail'>Failed!</span>"
	else if(state & OBJECTIVE_COMPLETE)
		return "<span class='objectivesuccess'>Succeeded!</span>"
	return "<span class='objectivebig'>Awaiting</span>"

/datum/faction_task/proc/get_readable_progress()
	var/dat = "<b>[name]:</b> "
	return dat + get_completion_status() + "<br>"

////////////////////////////////////////////////////////////////////////////////////////
/obj/structure/prop/sector_center
	name = FACTION_TASKS_SECTOR_CONTROL
	desc = "To seize this object is to take victory in one hand"
	icon = 'icons/obj/structures/sector_control.dmi'
	icon_state = "tower"
	breakable = FALSE
	indestructible = TRUE
	unacidable = TRUE
	unslashable = TRUE
	density = TRUE

	var/capture_progress = 0
	var/req_capture_progress = 100
	var/zone_range = 8
	var/home_sector = FALSE

	var/sector_id = "0"
	var/list/sector_connections = list()

	faction_to_get = null

	var/datum/faction_task/sector_control/owner

	var/list/connected_task = list()
	var/list/bordered_sectors = list()
	var/list/linked_turfs = list()

	var/obj/effect/decal/fog //fog
	var/datum/shape/rectangle/range_bounds

/obj/structure/prop/sector_center/Initialize()
	. = ..()
	name = "Sector [pick(operation_prefixes)]-[pick(operation_postfixes)]"
	owner = new(faction, src)
	range_bounds = RECT(loc.x, loc.y, zone_range * 2, zone_range * 2)
	update_icon()
	if(home_sector)
		capture_progress = req_capture_progress

	fog = new(owner)

	for(var/turf/turf in range(round(zone_range*COVERAGE_MULT), loc))
		LAZYADD(turf.linked_sectors, src)
		linked_turfs += turf

	START_PROCESSING(SSslowobj, src)

/obj/structure/prop/sector_center/Destroy()
	. = ..()
	for(var/turf/turf as anything in linked_turfs)
		LAZYREMOVE(turf.linked_sectors, src)
	range_bounds = null
	STOP_PROCESSING(SSslowobj, src)

/obj/structure/prop/sector_center/get_examine_text(mob/user)
	. = ..()
	. += "Capture progress [capture_progress/req_capture_progress*100]% ([capture_progress]/[req_capture_progress]),"
	if(faction)
		. += " by faction [faction],"
	. += "<br>Zone radius [zone_range] m.<br>"

/obj/structure/prop/sector_center/process()
	var/turf/turf = get_turf(src)
	if(!istype(turf))
		return

	if(!range_bounds)
		range_bounds = RECT(turf.x, turf.y, zone_range * 2, zone_range * 2)

	var/list/candidates = SSquadtree.players_in_range(range_bounds, turf.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)

	var/total_ammount = 0
	var/list/sorted_in_range = list()
	for(var/atom in candidates)
		var/mob/living/carbon/carbon = atom
		if(carbon.faction)
			if(!length(sorted_in_range[carbon.faction.faction_name]))
				sorted_in_range[carbon.faction.faction_name] = list()
			total_ammount++
			sorted_in_range[carbon.faction.faction_name] += carbon

	var/datum/faction/potential_faction
	var/potential_number = 0
	var/faction_mobs_number = 0
	for(var/faction_to_get in sorted_in_range)
		faction_mobs_number = length(sorted_in_range[faction_to_get])
		if(potential_number < faction_mobs_number)
			potential_faction = GLOB.faction_datum[faction_to_get]
			potential_number = faction_mobs_number

	var/have_task = FALSE
	if(potential_faction && length(get_faction_tasks(potential_faction)))
		have_task = TRUE

	var/overhelming = potential_number * 2 - total_ammount
	var/overhelming_to_add = potential_number * 2 - total_ammount
	if(!have_task)
		overhelming_to_add = 1

	if(!length(candidates) && capture_progress != req_capture_progress)
		capture_progress--

	else if(capture_progress != req_capture_progress)
		if(faction != potential_faction)
			if(overhelming)
				if(capture_progress > 1)
					capture_progress -= overhelming_to_add
				else if(capture_progress < 1 && !faction)
					get_sector(potential_faction)
					capture_progress = 1
			else
				capture_progress--
		else
			if(overhelming)
				capture_progress += overhelming_to_add
			else
				capture_progress--
	else
		if(faction != potential_faction)
			if(overhelming)
				capture_progress -= overhelming_to_add

	if(capture_progress == req_capture_progress && faction)
		faction.faction_victory_points += home_sector ? 5 : 1
	capture_progress = Clamp(capture_progress, 0, req_capture_progress)
	if(!capture_progress && faction)
		get_sector(null)

/obj/structure/prop/sector_center/proc/get_sector(datum/faction/check_faction)
	if(!check_faction)
		faction_announcement("[name] lost!", FACTION_TASKS_SECTOR_CONTROL, null, faction)
		faction = null
//		fog.faction = null
		return
	var/announce_text = "[name] new controlled by [check_faction]"
	if(home_sector)
		var/datum/faction/initial_faction = GLOB.faction_datum[faction_to_get]
		if(initial_faction == faction)
			faction_announcement("[name] new controlled by [check_faction], home sector occupied, now for us that big problem!", FACTION_TASKS_SECTOR_CONTROL, null, faction)
			faction_announcement("[name] new controlled by [check_faction], home sector returned back, now your enemy don't can do anything!", FACTION_TASKS_SECTOR_CONTROL, null, initial_faction)
			initial_faction.latejoin_enabled = FALSE
		else if(initial_faction == check_faction)
			faction_announcement("[name] new controlled by [check_faction], home sector occupied, enemy now can comeback!", FACTION_TASKS_SECTOR_CONTROL, null, faction)
			faction_announcement("[name] new controlled by [check_faction], home sector returned back, rise and destory our enemies!", FACTION_TASKS_SECTOR_CONTROL, null, initial_faction)
			initial_faction.latejoin_enabled = TRUE
		else
			faction_announcement(announce_text, FACTION_TASKS_SECTOR_CONTROL, null, faction)
			faction_announcement(announce_text, FACTION_TASKS_SECTOR_CONTROL, null, check_faction)
	else
		faction_announcement(announce_text, FACTION_TASKS_SECTOR_CONTROL, null, faction)
		faction_announcement(announce_text, FACTION_TASKS_SECTOR_CONTROL, null, check_faction)
	faction = check_faction
//	fog.faction = faction

/obj/structure/prop/sector_center/proc/captured(datum/faction/check_faction)
	if(faction == check_faction && capture_progress == req_capture_progress)
		return TRUE
	return FALSE

/obj/structure/prop/sector_center/proc/get_faction_tasks(datum/faction/check_faction)
	var/list/tasks_list = list()
	var/list/potential_tasks = connected_task[check_faction.faction_name]
	for(var/datum/faction_task/task in potential_tasks)
		if(task.faction_owner == check_faction)
			tasks_list += task
	return tasks_list

/obj/structure/prop/sector_center/base
	req_capture_progress = 600
	zone_range = 16
	home_sector = TRUE

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/sector_control
	name = FACTION_TASKS_SECTOR_CONTROL
	desc = "You need to control ###SECTOR### sector as long as can"
	announce_desc = list("complete" = "Good job, sector taken", "failed" = "Sector control failed")

	task_type = FACTION_TASKS_SECTOR_CONTROL
	task_color = "#1616a0"

	var/obj/structure/prop/sector_center/sector_center
	var/datum/faction_task/sector_control/grooped_task

/datum/faction_task/sector_control/New(datum/faction/faction_to_set, obj/structure/prop/sector_center/sector)
	. = ..()
	sector_center = sector
	desc = replacetext(desc, "###SECTOR###", sector.name)
	sector_center.connected_task += src

/datum/faction_task/sector_control/process()
	sector_center.process()

/datum/faction_task/sector_control/announce_faction()
	faction_announcement("[sector_center] [state & OBJECTIVE_COMPLETE ? announce_desc["complete"] : announce_desc["failed"]]", name, null, faction_owner)

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/sector_control/protect
	name = FACTION_TASKS_SECTOR_PROTECT
	desc = "Defend ###SECTOR### sector"
	announce_desc = list("complete" = "Good job, sector taken", "failed" = "Sector control failed")

	score = 1500

	total_time = 0

/datum/faction_task/sector_control/protect/process()
	return

/datum/faction_task/sector_control/protect/check_completion()
	if(!sector_center.captured(faction_owner))
		complete(OBJECTIVE_FAILED)
	else if(COOLDOWN_FINISHED(src, remaining_time))
		complete(OBJECTIVE_COMPLETE)

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/sector_control/occupy
	name = FACTION_TASKS_SECTOR_OCCUPY
	desc = "Capture ###SECTOR### sector"
	announce_desc = list("complete" = "Good job, sector taken", "failed" = "Sector control failed")

	score = 2250

	total_time = 15 MINUTES

/datum/faction_task/sector_control/occupy/New(datum/faction/faction_to_set, obj/structure/prop/sector_center/sector)
	. = ..()
	if(sector.faction)
		grooped_task = new /datum/faction_task/sector_control/protect(sector.faction, sector)
		SSfactions.active_tasks += grooped_task

/datum/faction_task/sector_control/occupy/check_completion()
	if(!sector_center.captured(faction_owner) || COOLDOWN_FINISHED(src, remaining_time))
		complete(OBJECTIVE_FAILED)
		grooped_task.complete(OBJECTIVE_COMPLETE)
	else if(sector_center.captured(faction_owner))
		complete(OBJECTIVE_COMPLETE)
		grooped_task.complete(OBJECTIVE_FAILED)

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/sector_control/occupy/hold
	name = FACTION_TASKS_SECTOR_HOLD
	desc = "Dig in and hold ###SECTOR### sector"
	announce_desc = list("complete" = "Good job, sector taken", "failed" = "Sector control failed")

	total_time = 30 MINUTES

/datum/faction_task/sector_control/occupy/hold/process()
	if(sector_center.captured(faction_owner))
		score++

/datum/faction_task/sector_control/occupy/hold/check_completion()
	if(COOLDOWN_FINISHED(src, remaining_time))
		if(score)
			complete(OBJECTIVE_COMPLETE)
		else
			complete(OBJECTIVE_FAILED)

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/dominate
	name = FACTION_TASKS_DOMINATE
	desc = "Destroy all enemy forces and capture all strategic points"
	announce_desc = list("complete" = "All enemy forces destroyed!", "failed" = "Enemy overhelmed and destroyed our forces")

	task_type = "Game Ender"
	task_color = "#b23131"

/datum/faction_task/dominate/check_completion()
	faction_owner.faction_victory_points -= score
	faction_owner.homes_sector_occupation = TRUE
	score = 0

	var/list/faction_stats = list("dead_enemy_factions" = 0, "total_friendly_factions" = 0)
	for(var/faction_name in SSticker.mode.factions_pool)
		var/datum/faction/faction = GLOB.faction_datum[SSticker.mode.factions_pool[faction_name]]
		if(faction_owner.relations_datum.allies[faction.faction_name])
			faction_stats["total_friendly_factions"]++

		else if(!length(faction.totalMobs))
			faction_stats["dead_enemy_factions"]++
			score += length(faction.totalDeadMobs)

	faction_owner.faction_victory_points += score

	if(faction_stats["dead_enemy_factions"] >= length(SSticker.mode.factions_pool) - length(faction_stats["total_friendly_factions"]))
		complete(OBJECTIVE_COMPLETE)

/datum/faction_task/dominate/complete(end_state)
	. = ..()
	if(state == OBJECTIVE_COMPLETE)
		SSticker.mode.round_finished = SSticker.mode.faction_round_end_state[faction_owner.faction_name]
		SSticker.mode.faction_won = faction_owner

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/hold
	name = FACTION_TASKS_HOLD_TIME
	desc = "Hold positions until enemy reserves are depleted"
	announce_desc = list("complete" = "You survived, await main army, we already there!", "failed" = "This is cvaudrant lost, you failed your one small job, idiots!")

	rand_total_time = TRUE
	total_time = 2 HOURS

	task_type = "Game Ender"
	task_color = "#b23131"

/datum/faction_task/hold/process()
	faction_owner.faction_victory_points++

/datum/faction_task/hold/check_completion()
	if(!length(faction_owner.totalDeadMobs))
		complete(OBJECTIVE_FAILED)
	else if(COOLDOWN_FINISHED(src, remaining_time))
		complete(OBJECTIVE_COMPLETE)

/datum/faction_task/hold/complete(end_state)
	. = ..()
	if(state == OBJECTIVE_COMPLETE)
		SSticker.mode.round_finished = SSticker.mode.faction_round_end_state[faction_owner.faction_name]
		SSticker.mode.faction_won = faction_owner

/datum/faction_task/hold/get_completion_status()
	if(state & OBJECTIVE_IN_PROGRESS)
		return "<span class='objectivebig'>Remaining time: [COOLDOWN_TIMELEFT(src, remaining_time)]</span>"
	else if(state & OBJECTIVE_FAILED)
		return "<span class='objectivefail'>Failed! Everyone's dead!</span>"
	else if(state & OBJECTIVE_COMPLETE)
		return "<span class='objectivesuccess'>Succeeded! Time's up!</span>"
	return "<span class='objectivebig'>Awaiting</span>"

////////////////////////////////////////////////////////////////////////////////////////
/datum/faction_task/destroy
	name = FACTION_TASKS_DESTROY
	desc = "Destroy a target"
	announce_desc = list("complete" = "Good job, sector taken, ", "failed" = "Sector control failed")

	score = 700

	total_time = 25 MINUTES

	task_type = "Objectives"
	task_color = "#1eb641"

	var/datum/faction/destroyed_faction

/datum/faction_task/destroy/New(datum/faction/faction_to_set, obj/target)
	. = ..()
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(object_destroyed), override = TRUE)

/datum/faction_task/destroy/proc/object_destroyed(obj/target, datum/faction/faction)
	SIGNAL_HANDLER
	destroyed_faction = faction

/datum/faction_task/destroy/check_completion()
	if(COOLDOWN_FINISHED(src, remaining_time))
		complete(OBJECTIVE_FAILED)

	else if(destroyed_faction)
		if(destroyed_faction != faction_owner)
			complete(OBJECTIVE_FAILED)
		else
			complete(OBJECTIVE_COMPLETE)

/*
#define FACTION_TASKS_KILL				"Kill Task"
#define FACTION_TASKS_PROTECT			"Protect Task"
*/
#define TASK_STATUS_LIST list(OBJECTIVE_COMPLETE = "complete", OBJECTIVE_FAILED = "failed", OBJECTIVE_IN_PROGRESS = "in progress", OBJECTIVE_ACTIVE = "active", OBJECTIVE_INACTIVE = "inactive")
#define TGUI_TASK_COLORS list("#b23131" = "red", "#1eb641" = "green", "#1616a0" = "blue")

/datum/faction_task_ui
	var/datum/faction/faction

/datum/faction_task_ui/New(datum/faction/faction_to_set)
	faction = faction_to_set

/datum/faction_task_ui/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FactionTask", "[faction] Tasks")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/faction_task_ui/ui_data(mob/user)
	. = list()
	var/list/task_payload = list()
	for(var/datum/faction_task/task in SSfactions.active_tasks)
		if(task.faction_owner != faction)
			continue
		task_payload += list(
			"name" = task.name,
			"desc" = task.desc,
			"status" = TASK_STATUS_LIST[task.state],
			"status_desc" = task.get_completion_status(),
			"type" = task.task_type,
			"color" = TGUI_TASK_COLORS[task.task_color]
		)
	.["tasks"] = task_payload
	.["points"] = faction.faction_victory_points
	.["req_points"] = 10000

/datum/faction_task_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/faction_task_ui/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
