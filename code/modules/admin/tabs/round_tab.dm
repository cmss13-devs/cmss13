/client/proc/adjust_predator_round()
	set name = "Adjust Predator Round"
	set desc = "Adjust the number of predators present in a predator round."
	set category = "Server.Round"

	if(admin_holder)
		if(!SSticker || !SSticker.mode)
			to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
			return

		var/value = tgui_input_number(src,"How many additional predators can join? Decreasing the value is not recommended. Current predator count: [SSticker.mode.pred_current_num]","Input:", 0, (SSticker.mode.pred_additional_max - SSticker.mode.pred_current_num))

		if(value < SSticker.mode.pred_current_num)
			to_chat(src, SPAN_NOTICE("Aborting. Number cannot be lower than the current pred count. (current: [SSticker.mode.pred_current_num], attempted: [value])"))
			return

		if(value)
			SSticker.mode.pred_additional_max = abs(value)
			message_admins("[key_name_admin(usr)] adjusted the additional pred amount to [abs(value)].")

/datum/admins/proc/force_predator_round()
	set name = "Toggle Predator Round"
	set desc = "Force-toggle a predator round for the round type. Only works on maps that support Predator spawns."
	set category = "Server.Round"

	// note: This is a proof of concept. ideally, scenario parameters should all be changeable in the same UI, rather than writing snowflake code everywhere like this
	if(!SSticker || SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		var/enabled = FALSE
		if(SSnightmare.get_scenario_value("predator_round"))
			enabled = TRUE
		var/ret = alert("Nightmare Scenario has the upcoming round being a [(enabled ? "PREDATOR" : "NORMAL")] round. Do you want to toggle this?", "Toggle Predator Round", "Yes", "No")
		if(ret == "Yes")
			SSnightmare.set_scenario_value("predator_round", !enabled)
		return

	var/datum/game_mode/predator_round = SSticker.mode
	if(alert("Are you sure you want to force-toggle a predator round? Predators currently: [(predator_round.flags_round_type & MODE_PREDATOR) ? "Enabled" : "Disabled"]",, "Yes", "No") != "Yes")
		return

	if(!(predator_round.flags_round_type & MODE_PREDATOR))
		var/datum/job/PJ = GLOB.RoleAuthority.roles_for_mode[JOB_PREDATOR]
		if(istype(PJ) && !PJ.spawn_positions)
			PJ.set_spawn_positions(GLOB.players_preassigned)
		predator_round.flags_round_type |= MODE_PREDATOR
	else
		predator_round.flags_round_type &= ~MODE_PREDATOR

	message_admins("[key_name_admin(usr)] has [(predator_round.flags_round_type & MODE_PREDATOR) ? "allowed predators to spawn" : "prevented predators from spawning"].")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_PREDATOR_ROUND_TOGGLED)

/client/proc/free_slot()
	set name = "Free Job Slots"
	set category = "Server.Round"

	if(!admin_holder)
		return

	var/roles[] = new
	var/i
	var/datum/job/J
	for(i in GLOB.RoleAuthority.roles_for_mode) //All the roles in the game.
		J = GLOB.RoleAuthority.roles_for_mode[i]
		if(J.total_positions > 0 && J.current_positions > 0)
			roles += i

	to_chat(usr, SPAN_BOLDNOTICE("There is not a single taken job slot."))
	var/role = input("This list contains all roles that have at least one slot taken.\nPlease select role slot to free.", "Free role slot")  as null|anything in roles
	if(!role)
		return
	GLOB.RoleAuthority.free_role_admin(GLOB.RoleAuthority.roles_for_mode[role], TRUE, src)

/client/proc/modify_slot()
	set name = "Adjust Job Slots"
	set category = "Server.Round"

	if(!admin_holder)
		return

	var/roles[] = new
	var/datum/job/J

	var/active_role_names = GLOB.gamemode_roles[GLOB.master_mode]
	if(!active_role_names)
		active_role_names = GLOB.ROLES_DISTRESS_SIGNAL

	for(var/role_name as anything in active_role_names)
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role_name]
		if(!job)
			continue
		roles += role_name

	var/role = input("Please select role slot to modify", "Modify amount of slots")  as null|anything in roles
	if(!role)
		return
	J = GLOB.RoleAuthority.roles_by_name[role]
	var/tpos = J.spawn_positions
	var/num = tgui_input_number(src, "How many slots role [J.title] should have?\nCurrently taken slots: [J.current_positions]\nTotal amount of slots opened this round: [J.total_positions_so_far]","Number:", tpos)
	if(isnull(num))
		return
	if(!GLOB.RoleAuthority.modify_role(J, num))
		to_chat(usr, SPAN_BOLDNOTICE("Can't set job slots to be less than amount of log-ins or you are setting amount of slots less than minimal. Free slots first."))
	message_admins("[key_name(usr)] adjusted job slots of [J.title] to be [num].")

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Server.Round"
	if(admin_holder)
		admin_holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")
	return

/client/proc/check_round_status()
	set name = "Round Status"
	set category = "Server.Round"
	if(admin_holder)
		admin_holder.check_round_status()
		log_admin("[key_name(usr)] checked round status.")
	return

/datum/admins/proc/end_round()
	set name = "End Round"
	set desc = "Immediately ends the round, be very careful"
	set category = "Server.Round"

	if(!check_rights(R_SERVER) || !SSticker.mode)
		return

	if(alert("Are you sure you want to end the round?",,"Yes","No") != "Yes")
		return
	// trying to end the round before it even starts. bruh
	if(!SSticker.mode)
		return

	SSticker.mode.round_finished = MODE_INFESTATION_DRAW_DEATH
	message_admins("[key_name(usr)] has made the round end early.")
	for(var/client/C in GLOB.admins)
		to_chat(C, {"
		<hr>
		[SPAN_CENTERBOLD("Staff-Only Alert: <EM>[usr.key]</EM> has made the round end early")]
		<hr>
		"})
	return

/datum/admins/proc/delay()
	set name = "Delay Round Start/End"
	set desc = "Delay the game start/end"
	set category = "Server.Round"

	if(!check_rights(R_SERVER))
		return
	if(SSticker.current_state != GAME_STATE_PREGAME)
		if(SSticker.delay_end)
			if(tgui_alert(usr, "Round end delay is already enabled, are you sure you want to disable it?", "Confirmation", list("Yes", "No"), 30 SECONDS) != "Yes")
				return
		SSticker.delay_end = !SSticker.delay_end
		message_admins("[SPAN_NOTICE("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")]")
		for(var/client/C in GLOB.admins)
			to_chat(C, {"<hr>
			[SPAN_CENTERBOLD("Staff-Only Alert: <EM>[usr.key]</EM> [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"]")]
			<hr>"})
		return
	else
		SSticker.delay_start = !SSticker.delay_start
		message_admins("[SPAN_NOTICE("[key_name(usr)] [SSticker.delay_start ? "delayed the round start" : "has made the round start normally"].")]")
		to_chat(world, SPAN_CENTERBOLD("The game start has been [SSticker.delay_start ? "delayed" : "continued"]."))
		return

/datum/admins/proc/startnow()
	set name = "Start Round"
	set desc = "Start the round RIGHT NOW"
	set category = "Server.Round"
	var/response = tgui_alert(usr, "Are you sure you want to start the round early?", "Force Start Round", list("Yes", "Bypass Checks", "No"), 30 SECONDS)
	if (response != "Yes" && response != "Bypass Checks")
		return FALSE
	SSticker.bypass_checks = response == "Bypass Checks"
	if (SSticker.current_state == GAME_STATE_STARTUP)
		message_admins("Game is setting up and will launch as soon as it is ready.")
		message_admins(SPAN_ADMINNOTICE("[usr.key] has started the process to start the game when loading is finished."))
		while (SSticker.current_state == GAME_STATE_STARTUP)
			sleep(50) // it patiently waits for the game to be ready here before moving on.
	if (SSticker.current_state == GAME_STATE_PREGAME)
		SSticker.bypass_checks = TRUE
		SSticker.request_start()
		message_admins(SPAN_BLUE("[usr.key] has started the game."))

		return TRUE
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")
		return FALSE

/client/proc/toggle_cdn()
	set name = "Toggle CDN"
	set category = "Server"
	var/static/admin_disabled_cdn_transport = null
	if(alert(usr, "Are you sure you want to toggle CDN asset transport?", "Confirm", "Yes", "No") != "Yes")
		return

	var/current_transport = CONFIG_GET(string/asset_transport)
	if(!current_transport || current_transport == "simple")
		if(admin_disabled_cdn_transport)
			CONFIG_SET(string/asset_transport, admin_disabled_cdn_transport)
			admin_disabled_cdn_transport = null
			SSassets.OnConfigLoad()
			message_admins("[key_name_admin(usr)] re-enabled the CDN asset transport")
			log_admin("[key_name(usr)] re-enabled the CDN asset transport")
			return

		to_chat(usr, SPAN_ADMINNOTICE("The CDN is not enabled!"))
		if(alert(usr, "CDN asset transport is not enabled! If you're having issues with assets, you can also try disabling filename mutations.", "CDN asset transport is not enabled!", "Try disabling filename mutations", "Nevermind") == "Try disabling filename mutations")
			SSassets.transport.dont_mutate_filenames = !SSassets.transport.dont_mutate_filenames
			message_admins("[key_name_admin(usr)] [(SSassets.transport.dont_mutate_filenames ? "disabled" : "re-enabled")] asset filename transforms.")
			log_admin("[key_name(usr)] [(SSassets.transport.dont_mutate_filenames ? "disabled" : "re-enabled")] asset filename transforms.")
		return

	admin_disabled_cdn_transport = current_transport
	CONFIG_SET(string/asset_transport, "simple")
	SSassets.OnConfigLoad()
	SSassets.transport.dont_mutate_filenames = TRUE
	message_admins("[key_name_admin(usr)] disabled CDN asset transport")
	log_admin("[key_name(usr)] disabled CDN asset transport")
