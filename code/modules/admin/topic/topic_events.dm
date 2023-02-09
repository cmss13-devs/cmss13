/datum/admins/proc/topic_events(href)
	switch(href)
		if("securitylevel")
			owner.change_security_level()
		if("distress")
			admin_force_distress()
		if("selfdestruct")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			admin_force_selfdestruct()
		if("evacuation_start")
			if(alert(usr, "Are you sure you want to trigger an evacuation?", "Confirmation", "Yes", "No") != "Yes")
				return
			admin_force_evacuation()
		if("evacuation_cancel")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			admin_cancel_evacuation()
		if("disable_shuttle_console")
			disable_shuttle_console()
		if("add_req_points")
			add_req_points()
		if("medal")
			owner.award_medal()
		if("jelly")
			owner.award_jelly()
		if("pmcguns")
			owner.toggle_gun_restrictions()
		if("monkify")
			owner.turn_everyone_into_primitives()
		if("comms_blackout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			var/answer = alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No")
			if(answer == "Yes")
				communications_blackout(0)
			else
				communications_blackout(1)
			message_staff("[key_name_admin(usr)] triggered a communications blackout.")
		if("destructible_terrain")
			if(tgui_alert(usr, "Are you sure you want to toggle all ground-level terrain destructible?", "Confirmation", list("Yes", "No"), 20 SECONDS) != "Yes")
				return
			toggle_destructible_terrain()
			message_staff("[key_name_admin(usr)] toggled destructible terrain.")
		if("blackout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_staff("[key_name_admin(usr)] broke all lights")
			lightsout(0,0)
		if("whiteout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			for(var/obj/structure/machinery/light/L in machines)
				L.fix()
			message_staff("[key_name_admin(usr)] fixed all lights")
		if("power")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_staff("[key_name_admin(usr)] powered all SMESs and APCs")
			power_restore()
		if("unpower")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_staff("[key_name_admin(usr)] unpowered all SMESs and APCs")
			power_failure()
		if("quickpower")
			if(alert(usr, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") != "Yes")
				return
			message_staff("[key_name_admin(usr)] powered all SMESs")
			power_restore_quick()
		if("powereverything")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_staff("[key_name_admin(usr)] powered all SMESs and APCs everywhere")
			power_restore_everything()
		if("powershipreactors")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_staff("[key_name_admin(usr)] powered all ship reactors")
			power_restore_ship_reactors()
		if("change_clearance")
			var/list/clearance_levels = list(0,1,2,3,4,5)
			var/level = tgui_input_list(usr, "Select new clearance level:","Current level: [chemical_data.clearance_level]", clearance_levels)
			if(!level)
				return
			message_staff("[key_name_admin(usr)] changed research clearance level to [level].")
			chemical_data.clearance_level = level
		if("give_research_credits")
			var/amount = tgui_input_real_number(usr, "How many credits to add?")
			if(amount != 0) //can add negative numbers too!
				message_staff("[key_name_admin(usr)] added [amount] research credits.")
				chemical_data.update_credits(amount)

/datum/admins/proc/create_humans_list(href_list)
	if(SSticker?.current_state < GAME_STATE_PLAYING)
		alert("Please wait until the game has started before spawning humans")
		return

	var/atom/initial_spot = usr.loc
	var/turf/initial_turf = get_turf(initial_spot)

	var/job_name
	if (istext(href_list["create_humans_list"]))
		job_name = href_list["create_humans_list"]
	else
		alert("Select fewer paths, (max 1)")
		return

	var/humans_to_spawn = dd_range(1, 100, text2num(href_list["object_count"]))
	var/range_to_spawn_on = dd_range(0, 10, text2num(href_list["object_range"]))

	var/free_the_humans = FALSE
	var/offer_as_ert = FALSE
	if(href_list["spawn_as"] == "freed")
		free_the_humans = TRUE

	else if(href_list["spawn_as"] == "ert")
		offer_as_ert = TRUE

	if(humans_to_spawn)
		var/list/turfs = list()
		if(isnull(range_to_spawn_on))
			range_to_spawn_on = 0

		if(range_to_spawn_on)
			for(var/turf/T in range(initial_turf, range_to_spawn_on))
				if(!T || istype(T, /turf/closed))
					continue
				turfs += T
		else
			turfs = list(initial_turf)

		if(!length(turfs))
			return

		var/list/humans = list()
		var/mob/living/carbon/human/H
		for(var/i = 0 to humans_to_spawn-1)
			var/turf/to_spawn_at = pick(turfs)
			H = new(to_spawn_at)

			if(!H.hud_used)
				H.create_hud()

			arm_equipment(H, job_name, TRUE, FALSE)

			if(free_the_humans)
				owner.free_for_ghosts(H)

			humans += H

		if (offer_as_ert)
			var/datum/emergency_call/custom/em_call = new()
			var/name = input(usr, "Please name your ERT", "ERT Name", "Admin spawned humans")
			em_call.name = name
			em_call.mob_max = humans.len
			em_call.players_to_offer = humans
			em_call.owner = owner

			em_call.activate(announce = FALSE)

		message_staff("[key_name_admin(usr)] created [humans_to_spawn] humans as [job_name] at [get_area(initial_spot)]")

/datum/admins/proc/create_xenos_list(href_list)
	if(SSticker?.current_state < GAME_STATE_PLAYING)
		alert("Please wait until the game has started before spawning xenos")
		return

	var/atom/initial_spot = usr.loc
	var/turf/initial_turf = get_turf(initial_spot)

	var/xeno_hive
	if (istext(href_list["create_hive_list"]))
		xeno_hive = href_list["create_hive_list"]
	else
		alert("Select fewer hive paths, (max 1)")
		return

	var/xeno_caste
	if (istext(href_list["create_xenos_list"]))
		xeno_caste = href_list["create_xenos_list"]
	else
		alert("Select fewer xeno paths, (max 1)")
		return

	var/xenos_to_spawn = dd_range(1, 100, text2num(href_list["object_count"]))
	var/range_to_spawn_on = dd_range(0, 10, text2num(href_list["object_range"]))

	var/free_the_xenos = FALSE
	var/offer_as_ert = FALSE
	if(href_list["spawn_as"] == "freed")
		free_the_xenos = TRUE

	else if(href_list["spawn_as"] == "ert")
		offer_as_ert = TRUE

	if(xenos_to_spawn)
		var/list/turfs = list()
		if(isnull(range_to_spawn_on))
			range_to_spawn_on = 0

		if(range_to_spawn_on)
			for(var/turf/T in range(initial_turf, range_to_spawn_on))
				if(!T || istype(T, /turf/closed))
					continue
				turfs += T
		else
			turfs = list(initial_turf)

		if(!length(turfs))
			return

		var/caste_type = RoleAuthority.get_caste_by_text(xeno_caste)

		var/list/xenos = list()
		var/mob/living/carbon/xenomorph/X
		for(var/i = 0 to xenos_to_spawn - 1)
			var/turf/to_spawn_at = pick(turfs)
			X = new caste_type(to_spawn_at, null, xeno_hive)

			if(!X.hud_used)
				X.create_hud()

			if(free_the_xenos)
				owner.free_for_ghosts(X)

			xenos += X

		if (offer_as_ert)
			var/datum/emergency_call/custom/em_call = new()
			var/name = input(usr, "Please name your ERT", "ERT Name", "Admin spawned xenos")
			em_call.name = name
			em_call.mob_max = xenos.len
			em_call.players_to_offer = xenos
			em_call.owner = owner

			em_call.activate(announce = FALSE)

		message_staff("[key_name_admin(usr)] created [xenos_to_spawn] xenos as [xeno_caste] at [get_area(initial_spot)]")

