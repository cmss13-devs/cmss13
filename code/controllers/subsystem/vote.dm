SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	init_order = SS_INIT_VOTE
	priority = SS_PRIORITY_VOTE

	flags = SS_KEEP_TIMING|SS_NO_INIT

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	/**
	  * Callback to calculate how many votes to add/remove
	  * Pass the number of current round votes and carryover
	  */
	var/datum/callback/vote_adjustment_callback = null

	/// Callback that runs when the vote ends
	var/datum/callback/on_vote_end = null
	/// Adjustments applied to the current round's votes
	var/list/adjustments = list()
	/// Current round votes
	var/list/choices = list()
	/// Votes from previous rounds
	var/list/carryover = list()
	var/list/voted = list()
	var/list/voting = list()

	// mapvotes carryover
	var/list/datum/entity/map_vote/votes

/datum/controller/subsystem/vote/fire()
	if(mode)
		time_remaining = floor((started_time + CONFIG_GET(number/vote_period) - world.time)/10)

		if(time_remaining < 0)
			result()
			reset()

/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	if(vote_adjustment_callback)
		QDEL_NULL(vote_adjustment_callback)
	if(on_vote_end)
		on_vote_end.Invoke()
		QDEL_NULL(on_vote_end)
	adjustments.Cut()
	choices.Cut()
	carryover.Cut()
	voted.Cut()
	voting.Cut()
	remove_action_buttons()

	UnregisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN)

	for(var/c in GLOB.player_list)
		update_static_data(c)
	SStgui.update_uis(src)

/datum/controller/subsystem/vote/proc/get_result()
	var/greatest_votes = 0
	var/total_votes = 0
	var/list/choices_adjusted = list()

	// First read in the total amount of votes
	for(var/option in choices)
		var/current_votes = choices[option]
		total_votes += current_votes

	// Then go through all the vote choices again to perform adjustments and checks
	for(var/option in choices)
		var/current_votes = choices[option]
		var/carryover = src.carryover[option]
		current_votes += carryover
		if(vote_adjustment_callback)
			adjustments[option] = vote_adjustment_callback.Invoke(current_votes, carryover, total_votes)
			current_votes += adjustments[option]
		choices_adjusted[option] = current_votes

		if(current_votes > greatest_votes)
			greatest_votes = current_votes
	if(!CONFIG_GET(flag/default_no_vote) && length(choices))
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if(!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(length(non_voters) > 0)
			if(mode == "restart")
				choices["Continue Playing"] += length(non_voters)
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
	. = list()
/*
	if(greatest_votes)
		for(var/option in choices_adjusted)
			if(choices_adjusted[option] == greatest_votes)
				. += option
*/
//RUCM START
	for(var/option in choices_adjusted)
		if(choices_adjusted[option] == greatest_votes)
			. += option
//RUCM END
	return .


/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(length(winners) > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>[capitalize(mode)] Vote</b>"
		for(var/i = 1 to length(choices))
			var/choice = choices[i]
			var/votes = choices[choice]
			if(!votes)
				votes = 0
			var/adjustment = adjustments[choice]
			var/carryover = src.carryover[choice]
			var/votes_actual = votes + adjustment + carryover

			var/msg = "<br><b>[choice]:</b> [votes_actual]"
			if(votes)
				msg += " ("
				if(votes)
					msg += "[votes] new vote[votes > 1 ? "s" : ""]; "
				if(adjustment)
					msg += "[abs(adjustment)] vote[abs(adjustment) > 1 ? "s" : ""] [adjustment < 0 ? "removed" : "added"] for adjustment; "
				// Remove the trailing "; "
				msg = copytext(msg, 1, length(msg)-1)
				msg += ")"
			text += msg
		if(mode != "custom")
			if(length(winners) > 1)
				text = "<br><b>Vote Tied Between:</b>"
				for(var/option in winners)
					text += "<br>[FOURSPACES][option]"
			. = pick(winners)
			text += "<br><b>Vote Result: [.]</b>"
		else
			text += "<br><b>Did not vote:</b> [length(GLOB.clients) - length(voted)]"
	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	remove_action_buttons()
	to_chat(world, "<br><font color='purple'>[text]</font>")
	return .


/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = FALSE
	if(.)
		switch(mode)
			if("gamemode")
				SSticker.save_mode(.)
				GLOB.master_mode = .
				to_chat(world, SPAN_BOLDNOTICE("Notice: The Gamemode for next round has been set to [.]"))
			if("restart")
				if(. == "Restart Round")
					restart = TRUE
			if("groundmap")
				var/datum/map_config/VM = config.maplist[GROUND_MAP][.]
				SSmapping.changemap(VM, GROUND_MAP)
				for(var/datum/entity/map_vote/in_vote in votes)
					var/map = in_vote.map_name
					if(!isnull(choices[map]))
						var/total_votes = choices[map] + adjustments[map] + carryover[map]
						in_vote.total_votes = (. == map) ? 0 : total_votes
						in_vote.save()
			if("shipmap")
				var/datum/map_config/VM = config.maplist[SHIP_MAP][.]
				SSmapping.changemap(VM, SHIP_MAP)
	if(restart)
		var/active_admins = 0
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_client_rights(C, R_SERVER, FALSE))
				active_admins = TRUE
				break
		if(!active_admins)
			world.Reboot()
		else
			to_chat(world, "<span style='boltnotice'>Notice:Restart vote will not restart the server automatically because there are active admins on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +SERVER, so it has been canceled. If you wish, you may restart the server.")

	return .


/datum/controller/subsystem/vote/proc/handle_client_joining(dcs, client/C)
	SIGNAL_HANDLER

	var/datum/action/innate/vote/V = give_action(C.mob, /datum/action/innate/vote)
	if(question)
		V.set_name("Vote: [question]")
	C.player_details.player_actions += V

/datum/controller/subsystem/vote/proc/submit_vote(vote)
	if(mode)
		if(CONFIG_GET(flag/no_dead_vote) && usr.stat == DEAD && !check_rights(R_ADMIN))
			return FALSE
		if(!(usr.ckey in voted))
			if(vote in choices)
				voted += usr.ckey
				choices[vote]++
				update_static_data(usr)
				return vote
	return FALSE


/datum/controller/subsystem/vote/proc/carry_over_callback(list/datum/entity/map_vote/votes)
	src.votes = votes
	for(var/i in choices)
		var/found = FALSE
		var/datum/entity/map_vote/vote
		for(var/datum/entity/map_vote/in_vote in votes)
			if(in_vote.map_name == i)
				found = TRUE
				vote = in_vote
				break

		if(!found)
			vote = SSentity_manager.select(/datum/entity/map_vote)
			vote.map_name = i
			vote.total_votes = 0
			vote.save()

		carryover[i] += vote.total_votes

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, datum/callback/on_end, send_clients_vote = FALSE)
	var/vote_sound = 'sound/ambience/alarm4.ogg'
	var/vote_sound_vol = 5
	var/randomize_entries = FALSE

	if(!mode)
		var/admin = FALSE
		var/ckey = ckey(initiator_key)
		if(initiator_key == "SERVER")
			admin = TRUE
		else
			for(var/i in GLOB.admins)
				var/client/C = i
				if(C.ckey == ckey)
					admin = TRUE
					break

		if(!admin && vote_type == "restart")
			for(var/client/C as anything in GLOB.admins)
				if(!C.is_afk() && check_client_rights(C, R_SERVER, FALSE))
					to_chat(usr, SPAN_WARNING("You cannot make a restart vote while there are active admins online."))
					return FALSE

		if(started_time)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, SPAN_WARNING("There is already a vote in progress! Please wait for it to finish."))
				return FALSE

			if(next_allowed_time > world.time && !admin)
				to_chat(usr, SPAN_WARNING("A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!"))
				return FALSE

		reset()
		switch(vote_type)
			if("restart")
				question = "Restart vote"
				choices.Add("Restart Round", "Continue Playing")
			if("gamemode")
				question = "Gamemode vote"
				randomize_entries = TRUE
				for(var/mode_type in config.gamemode_cache)
					var/datum/game_mode/cur_mode = mode_type
					if(initial(cur_mode.config_tag))
/*
						cur_mode = new mode_type
						var/vote_cycle_met = !initial(cur_mode.vote_cycle) || (text2num(SSperf_logging?.round?.id) % initial(cur_mode.vote_cycle) == 0)
						var/min_players_met = length(GLOB.clients) >= cur_mode.required_players
						if(initial(cur_mode.votable) && vote_cycle_met && min_players_met)
*/
//RUCM START
						var/vote_cycle_met = !initial(cur_mode.vote_cycle) || (text2num(SSperf_logging?.round?.id) % initial(cur_mode.vote_cycle) == 0)
						var/population_met = (!initial(cur_mode.population_min) || initial(cur_mode.population_min) < length(GLOB.clients)) && (!initial(cur_mode.population_max) || initial(cur_mode.population_max) > length(GLOB.clients))
						if(initial(cur_mode.votable) && vote_cycle_met && population_met)
//RUCM END
							choices += initial(cur_mode.config_tag)
/*
						qdel(cur_mode)
*/
			if("groundmap")
				question = "Ground map vote"
				vote_sound = 'sound/voice/start_your_voting.ogg'
				vote_sound_vol = 15
				randomize_entries = TRUE
				var/list/maps = list()
				for(var/i in config.maplist[GROUND_MAP])
					var/datum/map_config/VM = config.maplist[GROUND_MAP][i]
					if(VM.map_file == SSmapping.configs[GROUND_MAP].map_file)
						continue
					if(!VM.voteweight)
						continue
					if(!(GLOB.master_mode in VM.gamemodes))
						continue
					if(text2num(SSperf_logging?.round?.id) % VM.vote_cycle != 0)
						continue
					if(VM.config_max_users || VM.config_min_users)
						var/players = length(GLOB.clients)
						if(VM.config_max_users && players > VM.config_max_users)
							continue
						if(VM.config_min_users && players < VM.config_min_users)
							continue
					maps += i

				choices.Add(maps)
				if(!length(choices))
					if(on_end)
						on_end.Invoke()
					return FALSE
				SSentity_manager.filter_then(/datum/entity/map_vote, null, CALLBACK(src, PROC_REF(carry_over_callback)))

				if(CONFIG_GET(flag/allow_vote_adjustment_callback))
					vote_adjustment_callback = CALLBACK(src, PROC_REF(map_vote_adjustment))
			if("shipmap")
				question = "Ship map vote"
				randomize_entries = TRUE
				var/list/maps = list()
				for(var/i in config.maplist[SHIP_MAP])
					var/datum/map_config/VM = config.maplist[SHIP_MAP][i]
					if(!VM.voteweight)
						continue
					if(VM.config_max_users || VM.config_min_users)
						var/players = length(GLOB.clients)
						if(players > VM.config_max_users)
							continue
						if(players < VM.config_min_users)
							continue
					maps += i
				choices.Add(maps)
				if(length(choices) < 2)
					if(on_end)
						on_end.Invoke()
					return FALSE
			if("custom")
				question = input(usr, "What is the vote for?")
				if(!question)
					return FALSE
				for(var/i = 1 to 10)
					var/option = capitalize(input(usr, "Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)

				if(tgui_input_list(usr, "Do you want to randomize the vote option order?", "Randomize", list("Yes", "No")) == "Yes")
					randomize_entries = TRUE

			else
				if(on_end)
					on_end.Invoke()
				return FALSE

		if(randomize_entries)
			choices = shuffle(choices)

		for(var/i in choices)
			choices[i] = 0

		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		on_vote_end = on_end
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "custom")
			text += "<br>[question]"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		SEND_SOUND(world, sound(vote_sound, channel = SOUND_CHANNEL_VOX, volume = vote_sound_vol))
		to_chat(world, SPAN_CENTERBOLD("<br><br><font color='purple'><b>[text]</b><br>Type <b>vote</b> or click <a href='byond://?src=[REF(src)]'>here</a> to place your votes.<br>You have [DisplayTimeText(vp)] to vote.</font><br><br>"))
		time_remaining = floor(vp/10)
		for(var/c in GLOB.clients)
			var/client/C = c
			var/datum/action/innate/vote/V = give_action(C.mob, /datum/action/innate/vote)
			if(question)
				V.set_name("Vote: [question]")
			C.player_details.player_actions += V
			if(send_clients_vote)
				C.mob.vote()

		RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_client_joining))
		SStgui.update_uis(src)
		return TRUE
	return FALSE

/datum/controller/subsystem/vote/proc/map_vote_adjustment(current_votes, carry_over, total_votes)
	// Get 10% of the total map votes and remove them from the pool
	var/total_vote_adjustment = floor(total_votes * CONFIG_GET(number/vote_adjustment_callback))

	// Do not remove more votes than were made for the map
	return -(min(current_votes, total_vote_adjustment))

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	SSvote.tgui_interact(src)

/datum/controller/subsystem/vote/Topic(href, href_list)
	. = ..()
	usr.vote()

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_REMOVE_VOTE_BUTTON)

/datum/action/innate/vote
	name = "Vote!"
	action_icon_state = "vote"

/datum/action/innate/vote/give_to(mob/M)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_REMOVE_VOTE_BUTTON, PROC_REF(remove_vote_action))

/datum/action/innate/vote/proc/remove_vote_action(datum/source)
	SIGNAL_HANDLER

	if(remove_from_client())
		remove_from(owner)
	qdel(src)

/datum/action/innate/vote/action_activate()
	. = ..()
	owner.vote()

/datum/action/innate/vote/proc/remove_from_client()
	if(!owner)
		return FALSE
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/P = GLOB.player_details[owner.ckey]
		if(P)
			P.player_actions -= src
	return TRUE

/datum/controller/subsystem/vote/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VoteMenu", "Vote Menu")
		ui.open()

/datum/controller/subsystem/vote/ui_state(mob/user)
	return GLOB.always_state

/datum/controller/subsystem/vote/ui_data(mob/user)
	. = list()
	.["is_admin"] = user.client.admin_holder?.rights & R_ADMIN // This can change if they deadmin.

	.["vote_in_progress"] = mode
	.["vote_choices"] = choices
	.["vote_title"] = question

	. += get_config_restrictions()

/datum/controller/subsystem/vote/proc/get_config_restrictions()
	. = list()

	.["can_restart_vote"] = CONFIG_GET(flag/allow_vote_restart)
	.["can_gamemode_vote"] = CONFIG_GET(flag/allow_vote_mode)

// possible_vote_types JSON TABLE FOR THE CLIENT MENU
// PARAMETERS
// name string display name
// icon string font awesome icon
// color string color, not in hex
// admin_only boolean controls whether an option is admin_only
// variable_required string The vote may not be activated (by non-admins) if a variable passed in data does not evaluate to true.
GLOBAL_LIST_INIT(possible_vote_types, list(
	"restart" = list(
		"name" = "Restart Vote",
		"color" = "red",
		"icon" = "power-off",
		"variable_required" = "can_restart_vote",
	),
	"gamemode" = list(
		"name" = "Gamemode Vote",
		"color" = "purple",
		"icon" = "dice-d6",
		"variable_required" = "can_gamemode_vote",
	),
	"shipmap" = list(
		"name" = "Shipmap Vote",
		"color" = "blue",
		"icon" = "plane",
		"admin_only" = TRUE,
	),
	"groundmap" = list(
		"name" = "Groundmap Vote",
		"color" = "blue",
		"icon" = "campground",
		"admin_only" = TRUE,
	),
	"custom" = list(
		"name" = "Custom Vote",
		"color" = "yellow",
		"icon" = "question",
		"admin_only" = TRUE,
	),
))

/datum/controller/subsystem/vote/ui_static_data(mob/user)
	. = list()
	.["possible_vote_types"] = GLOB.possible_vote_types
	.["vote_has_voted"] = (user.ckey in voted)

/datum/controller/subsystem/vote/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return


	if(!usr.client)
		return

	if(check_rights(R_ADMIN))
		switch(action)
			if("cancel")
				reset()
				to_chat(world, "<b><font color='purple'>The vote has been cancelled.</font></b>")
			if("toggle_restart")
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
			if("toggle_gamemode")
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))

	switch(action)
		if("initiate_vote")
			if(!params["vote_type"])
				return

			if(!(params["vote_type"] in GLOB.possible_vote_types))
				return

			if(!check_rights(R_MOD))
				var/list/vote_type = GLOB.possible_vote_types[params["vote_type"]]
				if(vote_type["admin_only"])
					return

				var/list/config_restrictions = get_config_restrictions()
				if(vote_type["variable_required"] && !config_restrictions[vote_type["variable_required"]])
					return

			initiate_vote(params["vote_type"], usr.key)
		if("vote")
			submit_vote(params["voted_for"])

	return TRUE
