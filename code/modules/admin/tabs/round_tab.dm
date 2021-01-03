/client/proc/adjust_predator_round()
	set name = "Adjust Predator Round"
	set desc = "Adjust the number of predators present in a predator round."
	set category = "Server.Round"

	if(admin_holder)
		if(!SSticker || !SSticker.mode)
			to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
			return

		var/value = input(src,"How many additional predators can join? Decreasing the value is not recommended. Current predator count: [SSticker.mode.pred_current_num]","Input:", SSticker.mode.pred_additional_max) as num|null

		if(value < SSticker.mode.pred_current_num)
			to_chat(src, SPAN_NOTICE("Aborting. Number cannot be lower than the current pred count. (current: [SSticker.mode.pred_current_num], attempted: [value])"))
			return

		if(value)
			SSticker.mode.pred_additional_max = abs(value)
			message_staff("[key_name_admin(usr)] adjusted the additional pred amount to [abs(value)].")

/datum/admins/proc/force_predator_round()
	set name = "Force Predator Round"
	set desc = "Force a predator round for the round type. Only works on maps that support Predator spawns."
	set category = "Server.Round"

	if(!SSticker || SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(usr, SPAN_DANGER("The game hasn't started yet!"))
		return

	if(alert("Are you sure you want to force a predator round?",, "Yes", "No") == "No")
		return

	var/datum/game_mode/predator_round = SSticker.mode

	if(!(predator_round.flags_round_type & MODE_PREDATOR))
		var/datum/job/PJ = RoleAuthority.roles_for_mode[JOB_PREDATOR]
		if(istype(PJ))
			PJ.set_spawn_positions(marines_assigned)
		predator_round.flags_round_type |= MODE_PREDATOR
		to_chat(usr, "The Hunt is now enabled.")
	else
		to_chat(usr, "The Hunt is already in progress.")
		return

	message_staff("[key_name_admin(usr)] admin-forced a predator round.")
	return

/client/proc/free_slot()
	set name = "Free Job Slots"
	set category = "Server.Round"

	if(!admin_holder)
		return

	var/roles[] = new
	var/i
	var/datum/job/J
	for(i in RoleAuthority.roles_for_mode) //All the roles in the game.
		J = RoleAuthority.roles_for_mode[i]
		if(J.total_positions > 0 && J.current_positions > 0)
			roles += i

	to_chat(usr, SPAN_BOLDNOTICE("There is not a single taken job slot."))
	var/role = input("This list contains all roles that have at least one slot taken.\nPlease select role slot to free.", "Free role slot")  as null|anything in roles
	if(!role)
		return
	RoleAuthority.free_role_admin(RoleAuthority.roles_for_mode[role], TRUE, src)

/client/proc/modify_slot()
	set name = "Adjust Job Slots"
	set category = "Server.Round"

	if(!admin_holder)
		return

	var/roles[] = new
	var/i
	var/datum/job/J
	var/datum/job/K
	for (i in RoleAuthority.roles_for_mode) //All the roles in the game.
		K = RoleAuthority.roles_for_mode[i]
		if(K.allow_additional)
			roles += i
	var/role = input("Please select role slot to modify", "Modify amount of slots")  as null|anything in roles
	if(!role)
		return
	J = RoleAuthority.roles_for_mode[role]
	var/tpos = J.spawn_positions
	var/num = input("How many slots role [J.title] should have?\nCurrently taken slots: [J.current_positions]\nTotal amount of slots opened this round: [J.total_positions_so_far]","Number:", tpos) as num|null
	if(!num)
		return
	if(!RoleAuthority.modify_role(J, num))
		to_chat(usr, SPAN_BOLDNOTICE("Can't set job slots to be less than amount of log-ins or you are setting amount of slots less than minimal. Free slots first."))
	message_staff("[key_name(usr)] adjusted job slots of [J.title] to be [num].")

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
	message_staff("[key_name(usr)] has made the round end early.")
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
	if (SSticker.current_state != GAME_STATE_PREGAME)
		SSticker.delay_end = !SSticker.delay_end
		message_staff("[SPAN_NOTICE("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")]")
		for(var/client/C in GLOB.admins)
			to_chat(C, {"<hr>
			[SPAN_CENTERBOLD("Staff-Only Alert: <EM>[usr.key]</EM> [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"]")]
			<hr>"})
		return

	going = !(going)
	if (!going)
		to_world("<hr>")
		to_world("<span class='centerbold'>The game start has been delayed.</span>")
		to_world("<hr>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<hr>")
		to_world("<span class='centerbold'>The game will start soon!</span>")
		to_world("<hr>")
		log_admin("[key_name(usr)] removed the delay.")

/datum/admins/proc/startnow()
	set name = "Start Round"
	set desc = "Start the round RIGHT NOW"
	set category = "Server.Round"

	if (!SSticker)
		alert("Unable to start the game as it is not set up.")
		return
	if (alert("Are you sure you want to start the round early?",,"Yes","No") != "Yes")
		return
	if (SSticker.current_state == GAME_STATE_PREGAME)
		SSticker.current_state = GAME_STATE_SETTING_UP
		message_staff(SPAN_BLUE("[usr.key] has started the game."))

		return TRUE
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")
		return FALSE
