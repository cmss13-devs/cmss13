SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

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
		time_remaining = round((started_time + CONFIG_GET(number/vote_period) - world.time)/10)

		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				C << browse(null, "window=vote")
			reset()
		else
			var/datum/browser/client_popup
			for(var/client/C in voting)
				client_popup = new(C, "vote", "Voting Panel")
				client_popup.set_window_options("can_close=0")
				client_popup.set_content(interface(C))
				client_popup.open(FALSE)


/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	if(vote_adjustment_callback)
		QDEL_NULL(vote_adjustment_callback)
	adjustments.Cut()
	choices.Cut()
	carryover.Cut()
	voted.Cut()
	voting.Cut()
	remove_action_buttons()


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
	if(greatest_votes)
		for(var/option in choices_adjusted)
			if(choices_adjusted[option] == greatest_votes)
				. += option
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
			if(!C.is_afk() && check_rights(R_SERVER))
				active_admins = TRUE
				break
		if(!active_admins)
			world.Reboot("Restart vote successful.")
		else
			to_chat(world, "<span style='boltnotice'>Notice:Restart vote will not restart the server automatically because there are active admins on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +SERVER, so it has been canceled. If you wish, you may restart the server.")

	return .


/datum/controller/subsystem/vote/proc/submit_vote(vote)
	if(mode)
		if(CONFIG_GET(flag/no_dead_vote) && usr.stat == DEAD && !check_rights(R_ADMIN))
			return FALSE
		if(!(usr.ckey in voted))
			if(vote && 1 <= vote && vote <= length(choices))
				voted += usr.ckey
				choices[choices[vote]]++
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

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key)
	if(!mode)
		if(started_time)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, "<span class='warning'>There is already a vote in progress! please wait for it to finish.</span>")
				return FALSE

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

			if(next_allowed_time > world.time && !admin)
				to_chat(usr, "<span class='warning'>A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!</span>")
				return FALSE

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round", "Continue Playing")
			if("gamemode")
				choices.Add(config.votable_modes)
			if("groundmap")
				var/list/maps = list()
				for(var/i in config.maplist[GROUND_MAP])
					var/datum/map_config/VM = config.maplist[GROUND_MAP][i]
					if(VM.map_file == SSmapping.configs[GROUND_MAP].map_file)
						continue
					if(!VM.voteweight)
						continue
					if(VM.config_max_users || VM.config_min_users)
						var/players = length(GLOB.clients)
						if(VM.config_max_users && players > VM.config_max_users)
							continue
						if(VM.config_min_users && players < VM.config_min_users)
							continue
					maps += i

				choices.Add(maps)
				if(length(choices) < 2)
					return FALSE
				SSentity_manager.filter_then(/datum/entity/map_vote, null, CALLBACK(src, .proc/carry_over_callback))

				vote_adjustment_callback = CALLBACK(src, .proc/map_vote_adjustment)
			if("shipmap")
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
					return FALSE
			if("custom")
				question = stripped_input(usr, "What is the vote for?")
				if(!question)
					return FALSE
				for(var/i = 1 to 10)
					var/option = capitalize(stripped_input(usr, "Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return FALSE
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "custom")
			text += "<br>[question]"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		//SEND_SOUND(world, sound('sound/ambience/alarm4.ogg', channel = CHANNEL_NOTIFY))
		to_chat(world, "<br><font color='purple'><b>[text]</b><br>Type <b>vote</b> or click <a href='?src=[REF(src)]'>here</a> to place your votes.<br>You have [DisplayTimeText(vp)] to vote.</font>")
		time_remaining = round(vp/10)
		for(var/c in GLOB.clients)
			var/client/C = c
			var/datum/action/innate/vote/V = new
			if(question)
				V.name = "Vote: [question]"
			C.player_details.player_actions += V
			V.give_action(C.mob)
		return TRUE
	return FALSE


/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = FALSE
	if(check_rights(R_ADMIN))
		admin = TRUE
	voting |= C

	if(mode)
		if(question)
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
		. += "Time Left: [time_remaining] s<hr><ul>"
		for(var/i = 1 to length(choices))
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			. += "<li><a href='?_src_=vote;vote=[i]'>[choices[i]]</a> ([votes] votes)</li>"
		. += "</ul><hr>"
		if(admin)
			. += "(<a href='?_src_=vote;vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"

		var/avr = CONFIG_GET(flag/allow_vote_restart)
		if(avr || admin)
			. += "<a href='?_src_=vote;vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		if(admin)
			. += "[FOURSPACES](<a href='?_src_=vote;vote=toggle_restart'>[avr ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"

		var/avm = CONFIG_GET(flag/allow_vote_mode)
		if(avm || admin)
			. += "<a href='?_src_=vote;vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"

		if(admin)
			. += "[FOURSPACES](<a href='?_src_=vote;vote=toggle_gamemode'>[avm ? "Allowed" : "Disallowed"]</a>)"

		. += "</li><hr>"

		if(admin)
			. += "<li><a href='?_src_=vote;vote=groundmap'>Ground Map Vote</a></li>"
			. += "<li><a href='?_src_=vote;vote=shipmap'>Ship Map Vote</a></li>"
			. += "<li><a href='?_src_=vote;vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='?_src_=vote;vote=close'>Close</a>"
	return .


///datum/controller/subsystem/vote/can_interact(mob/user) // can_interact refactor TODO:
//	return TRUE

/* VOTE ADJUSTMENT PROCS */
/datum/controller/subsystem/vote/proc/map_vote_adjustment(current_votes, carry_over, total_votes)
	// Get 10% of the total map votes and remove them from the pool
	var/total_vote_adjustment = round(total_votes * 0.1)

	// Do not remove more votes than were made for the map
	return -(min(current_votes, total_vote_adjustment))
/* END VOTE ADJUSTMENT PROCS */


/datum/controller/subsystem/vote/Topic(href, list/href_list, hsrc)
	. = ..()
	if(.)
		return

	if(!usr?.client)
		return

	switch(href_list["vote"])
		if("close")
			voting -= usr.client
			DIRECT_OUTPUT(usr, browse(null, "window=vote"))
			return
		if("cancel")
			if(check_rights(R_ADMIN) && alert(usr, "Are you sure you want to cancel the vote?", "Cancel Vote", "Yes", "No") == "Yes")
				reset()
				to_chat(world, "<b><font color='purple'>The vote has been cancelled.</font></b>")
		if("toggle_restart")
			if(check_rights(R_ADMIN))
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("toggle_gamemode")
			if(check_rights(R_ADMIN))
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || check_rights(R_ADMIN))
				initiate_vote("restart", usr.key)
		if("gamemode")
			if(CONFIG_GET(flag/allow_vote_mode) || check_rights(R_ADMIN))
				initiate_vote("gamemode", usr.key)
		if("custom")
			if(check_rights(R_ADMIN))
				initiate_vote("custom", usr.key)
		if("groundmap")
			if(check_rights(R_ADMIN))
				initiate_vote("groundmap", usr.key)
		if("shipmap")
			if(check_rights(R_ADMIN))
				initiate_vote("shipmap", usr.key)
		else
			submit_vote(round(text2num(href_list["vote"])))
	usr.vote()


/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	var/datum/browser/popup = new(src, "vote", "Voting Panel")
	popup.set_window_options("can_close=0")
	popup.set_content(SSvote.interface(client))
	popup.open(FALSE)

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_REMOVE_VOTE_BUTTON)

/datum/action/innate/vote
	name = "Vote!"
	action_icon_state = "vote"

/datum/action/innate/vote/give_action(mob/M)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_REMOVE_VOTE_BUTTON, .proc/remove_vote_action)

/datum/action/innate/vote/proc/remove_vote_action(datum/source)
	SIGNAL_HANDLER

	if(remove_from_client())
		remove_action(owner)
	qdel(src)

/datum/action/innate/vote/action_activate()
	owner.vote()
	remove_vote_action()

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
