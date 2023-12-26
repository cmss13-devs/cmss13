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
		if("add_req_points")
			add_req_points()
		if("check_req_heat")
			check_req_heat()
		if("medal")
			owner.award_medal()
		if("jelly")
			owner.award_jelly()
		if("nuke")
			owner.give_nuke()
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
			message_admins("[key_name_admin(usr)] triggered a communications blackout.")
		if("destructible_terrain")
			if(tgui_alert(usr, "Are you sure you want to toggle all ground-level terrain destructible?", "Confirmation", list("Yes", "No"), 20 SECONDS) != "Yes")
				return
			toggle_destructible_terrain()
			message_admins("[key_name_admin(usr)] toggled destructible terrain.")
		if("blackout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_admins("[key_name_admin(usr)] broke all lights")
			lightsout(0,0)
		if("whiteout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			for(var/obj/structure/machinery/light/L in GLOB.machines)
				L.fix()
			message_admins("[key_name_admin(usr)] fixed all lights")
		if("power")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_admins("[key_name_admin(usr)] powered all SMESs and APCs")
			power_restore()
		if("unpower")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_admins("[key_name_admin(usr)] unpowered all SMESs and APCs")
			power_failure()
		if("quickpower")
			if(alert(usr, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") != "Yes")
				return
			message_admins("[key_name_admin(usr)] powered all SMESs")
			power_restore_quick()
		if("powereverything")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_admins("[key_name_admin(usr)] powered all SMESs and APCs everywhere")
			power_restore_everything()
		if("powershipreactors")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
				return
			message_admins("[key_name_admin(usr)] powered all ship reactors")
			power_restore_ship_reactors()
		if("change_clearance")
			var/list/clearance_levels = list(0,1,2,3,4,5)
			var/level = tgui_input_list(usr, "Select new clearance level:","Current level: [GLOB.chemical_data.clearance_level]", clearance_levels)
			if(!level)
				return
			message_admins("[key_name_admin(usr)] changed research clearance level to [level].")
			GLOB.chemical_data.clearance_level = level
		if("give_research_credits")
			var/amount = tgui_input_real_number(usr, "How many credits to add?")
			if(amount != 0) //can add negative numbers too!
				message_admins("[key_name_admin(usr)] added [amount] research credits.")
				GLOB.chemical_data.update_credits(amount)

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

	var/strip_the_humans = FALSE
	var/strip_weapons = FALSE
	if(href_list["equip_with"] == "no_weapons")
		strip_weapons = TRUE

	if(href_list["equip_with"] == "no_equipment")
		strip_the_humans = TRUE

	if(humans_to_spawn)
		var/list/turfs = list()
		if(isnull(range_to_spawn_on))
			range_to_spawn_on = 0

		var/turf/spawn_turf
		if(range_to_spawn_on)
			for(spawn_turf in range(initial_turf, range_to_spawn_on))
				if(!spawn_turf || istype(spawn_turf, /turf/closed))
					continue
				turfs += spawn_turf
		else
			turfs = list(initial_turf)

		if(!length(turfs))
			return

		var/list/humans = list()
		var/mob/living/carbon/human/spawned_human
		for(var/i = 0 to humans_to_spawn-1)
			spawn_turf = pick(turfs)
			spawned_human = new(spawn_turf)

			if(!spawned_human.hud_used)
				spawned_human.create_hud()

			if(free_the_humans)
				owner.free_for_ghosts(spawned_human)

			arm_equipment(spawned_human, job_name, TRUE, FALSE)

			humans += spawned_human

			if(strip_the_humans)
				for(var/obj/item/current_item in spawned_human)
					//no more deletion of ID cards
					if(istype(current_item, /obj/item/card/id/))
						continue
					qdel(current_item)
				continue

			if(strip_weapons)
				var/obj/item_storage
				for(var/obj/item/current_item in spawned_human.GetAllContents(3))
					if(istype(current_item, /obj/item/ammo_magazine))

						item_storage = current_item.loc
						qdel(current_item)

						if(istype(item_storage, /obj/item/storage))
							item_storage.update_icon()

						continue

					if(istype(current_item, /obj/item/weapon))
						qdel(current_item)
						continue

					if(istype(current_item, /obj/item/explosive))
						qdel(current_item)

				for(var/obj/item/hand_item in spawned_human.hands)
					if(istype(hand_item, /obj/item/weapon))
						qdel(hand_item)
						continue

					if(istype(hand_item, /obj/item/explosive))
						qdel(hand_item)



		if (offer_as_ert)
			var/datum/emergency_call/custom/em_call = new()
			var/name = input(usr, "Please name your ERT", "ERT Name", "Admin spawned humans")
			em_call.name = name
			em_call.mob_max = humans.len
			em_call.players_to_offer = humans
			em_call.owner = owner
			var/quiet_launch = TRUE
			var/ql_prompt = tgui_alert(usr, "Would you like to broadcast the beacon launch? This will reveal the distress beacon to all players.", "Announce distress beacon?", list("Yes", "No"), 20 SECONDS)
			if(ql_prompt == "Yes")
				quiet_launch = FALSE

			var/announce_receipt = FALSE
			var/ar_prompt = tgui_alert(usr, "Would you like to announce the beacon received message? This will reveal the distress beacon to all players.", "Announce beacon received?", list("Yes", "No"), 20 SECONDS)
			if(ar_prompt == "Yes")
				announce_receipt = TRUE
			log_debug("ERT DEBUG (CUSTOM SET): [quiet_launch] - [announce_receipt]")
			em_call.activate(quiet_launch, announce_receipt)

		message_admins("[key_name_admin(usr)] created [humans_to_spawn] humans as [job_name] at [get_area(initial_spot)]")

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

		var/turf/spawn_turf
		if(range_to_spawn_on)
			for(spawn_turf in range(initial_turf, range_to_spawn_on))
				if(!spawn_turf || istype(spawn_turf, /turf/closed))
					continue
				turfs += spawn_turf
		else
			turfs = list(initial_turf)

		if(!length(turfs))
			return

		var/caste_type = GLOB.RoleAuthority.get_caste_by_text(xeno_caste)

		var/list/xenos = list()
		var/mob/living/carbon/xenomorph/X
		for(var/i = 0 to xenos_to_spawn - 1)
			spawn_turf = pick(turfs)
			X = new caste_type(spawn_turf, null, xeno_hive)

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

			var/launch_broadcast = tgui_alert(usr, "Would you like to broadcast the beacon launch? This will reveal the distress beacon to all players.", "Announce distress beacon?", list("Yes", "No"), 20 SECONDS)
			if(launch_broadcast == "Yes")
				launch_broadcast = TRUE
			else
				launch_broadcast = FALSE

			var/announce_receipt = tgui_alert(usr, "Would you like to announce the beacon received message? This will reveal the distress beacon to all players.", "Announce beacon received?", list("Yes", "No"), 20 SECONDS)
			if(announce_receipt == "Yes")
				announce_receipt = TRUE
			else
				announce_receipt = FALSE

			em_call.activate(launch_broadcast, announce_receipt)

		message_admins("[key_name_admin(usr)] created [xenos_to_spawn] xenos as [xeno_caste] at [get_area(initial_spot)]")

