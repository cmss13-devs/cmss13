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
		if("add_upp_req_points")
			add_upp_req_points()
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

		if("xenothumbs")
			var/grant = tgui_alert(owner, "Do you wish to grant or revoke Xenomorph firearms permits?", "Give or Take", list("Grant", "Revoke", "Cancel"))
			if(grant == "Cancel")
				return

			var/list/mob/living/carbon/xenomorph/permit_recipients = list()
			var/list/datum/hive_status/permit_hives = list()
			switch(tgui_alert(owner, "Do you wish to do this for one Xeno or an entire hive?", "Recipients", list("Xeno", "Hive", "All Xenos")))
				if("Xeno")
					permit_recipients += tgui_input_list(usr, "Select recipient Xenomorph:", "Armed Xenomorph", GLOB.living_xeno_list)
					if(isnull(permit_recipients[1])) //Cancel button.
						return
				if("Hive")
					permit_hives += GLOB.hive_datum[tgui_input_list(usr, "Select recipient hive:", "Armed Hive", GLOB.hive_datum)]
					if(isnull(permit_hives[1])) //Cancel button.
						return
					permit_recipients = permit_hives[1].totalXenos.Copy()
				if("All Xenos")
					permit_recipients = GLOB.living_xeno_list.Copy()
					for(var/hive in GLOB.hive_datum)
						permit_hives += GLOB.hive_datum[hive]

			var/list/handled_xenos = list()

			for(var/mob/living/carbon/xenomorph/xeno as anything in permit_recipients)
				if(QDELETED(xeno) || xeno.stat == DEAD) //Xenos might die before the admin picks them.
					to_chat(usr, SPAN_HIGHDANGER("[xeno] died before their firearms permit could be issued!"))
					continue
				if(HAS_TRAIT(xeno, TRAIT_OPPOSABLE_THUMBS))
					if(grant == "Revoke")
						REMOVE_TRAIT(xeno, TRAIT_OPPOSABLE_THUMBS, TRAIT_SOURCE_HIVE)
						to_chat(xeno, SPAN_XENOANNOUNCE("We forget how thumbs work. We feel a terrible sense of loss."))
						handled_xenos += xeno
				else if(grant == "Grant")
					ADD_TRAIT(xeno, TRAIT_OPPOSABLE_THUMBS, TRAIT_SOURCE_HIVE)
					to_chat(xeno, SPAN_XENOANNOUNCE("We suddenly comprehend the magic of opposable thumbs along with surprising kinesthetic intelligence. We could do... <b><i>so much</b></i> with this knowledge."))
					handled_xenos += xeno

			for(var/datum/hive_status/permit_hive as anything in permit_hives)
				//Give or remove the trait from newly-born xenos in this hive.
				if(grant == "Grant")
					LAZYADD(permit_hive.hive_inherant_traits, TRAIT_OPPOSABLE_THUMBS)
				else
					LAZYREMOVE(permit_hive.hive_inherant_traits, TRAIT_OPPOSABLE_THUMBS)

			if(!length(handled_xenos) && !length(permit_hives))
				return

			if(grant == "Grant")
				message_admins("[usr] granted 2nd Amendment rights to [length(handled_xenos) > 1 ? "[length(handled_xenos)] xenos" : "[length(handled_xenos) == 1 ? "[handled_xenos[1]]" : "no xenos"]"]\
					[length(permit_hives) > 1 ? " in all hives, and to any new xenos. Quite possibly we will all regret this." : "[length(permit_hives) == 1 ? " in [permit_hives[1]], and to any new xenos in that hive." : "."]"]")
			else
				message_admins("[usr] revoked 2nd Amendment rights from [length(handled_xenos) > 1 ? "[length(handled_xenos)] xenos" : "[length(handled_xenos) == 1 ? "[handled_xenos[1]]" : "no xenos"]"]\
					[length(permit_hives) > 1 ? " in all hives, and from any new xenos." : "[length(permit_hives) == 1 ? " in [permit_hives[1]], and from any new xenos in that hive." : "."]"]")


		if("xenocards")
			var/grant = tgui_alert(owner, "Do you wish to grant or revoke Xenomorph card playing abilities?", "Give or Take", list("Grant", "Revoke", "Cancel"))
			if(grant == "Cancel")
				return

			var/list/mob/living/carbon/xenomorph/permit_recipients = list()
			var/list/datum/hive_status/permit_hives = list()
			switch(tgui_alert(owner, "Do you wish to do this for one Xeno or an entire hive?", "Recipients", list("Xeno", "Hive", "All Xenos")))
				if("Xeno")
					permit_recipients += tgui_input_list(usr, "Select recipient Xenomorph:", "Ace Xenomorph", GLOB.living_xeno_list)
					if(isnull(permit_recipients[1])) //Cancel button.
						return
				if("Hive")
					permit_hives += GLOB.hive_datum[tgui_input_list(usr, "Select recipient hive:", "Ace Hive", GLOB.hive_datum)]
					if(isnull(permit_hives[1])) //Cancel button.
						return
					permit_recipients = permit_hives[1].totalXenos.Copy()
				if("All Xenos")
					permit_recipients = GLOB.living_xeno_list.Copy()
					for(var/hive in GLOB.hive_datum)
						permit_hives += GLOB.hive_datum[hive]

			var/list/handled_xenos = list()

			for(var/mob/living/carbon/xenomorph/xeno as anything in permit_recipients)
				if(QDELETED(xeno) || xeno.stat == DEAD) //Xenos might die before the admin picks them.
					to_chat(usr, SPAN_HIGHDANGER("[xeno] died before they could get a royal flush!"))
					continue
				if(HAS_TRAIT(xeno, TRAIT_CARDPLAYING_THUMBS))
					if(grant == "Revoke")
						REMOVE_TRAIT(xeno, TRAIT_CARDPLAYING_THUMBS, TRAIT_SOURCE_HIVE)
						to_chat(xeno, SPAN_XENOANNOUNCE("We forget how cards work. We feel a terrible sense of loss."))
						handled_xenos += xeno
				else if(grant == "Grant")
					ADD_TRAIT(xeno, TRAIT_CARDPLAYING_THUMBS, TRAIT_SOURCE_HIVE)
					to_chat(xeno, SPAN_XENOANNOUNCE("We suddenly comprehend the magic of playing cards along with a little kinesthetic intelligence. We could do... <b><i>very little</b></i> with this knowledge."))
					handled_xenos += xeno

			for(var/datum/hive_status/permit_hive as anything in permit_hives)
				//Give or remove the trait from newly-born xenos in this hive.
				if(grant == "Grant")
					LAZYADD(permit_hive.hive_inherant_traits, TRAIT_CARDPLAYING_THUMBS)
				else
					LAZYREMOVE(permit_hive.hive_inherant_traits, TRAIT_CARDPLAYING_THUMBS)

			if(!length(handled_xenos) && !length(permit_hives))
				return

			if(grant == "Grant")
				message_admins("[usr] granted card playing rights to [length(handled_xenos) > 1 ? "[length(handled_xenos)] xenos" : "[length(handled_xenos) == 1 ? "[handled_xenos[1]]" : "no xenos"]"]\
					[length(permit_hives) > 1 ? " in all hives, and to any new xenos. Quite possibly we will all enjoy this." : "[length(permit_hives) == 1 ? " in [permit_hives[1]], and to any new xenos in that hive." : "."]"]")
			else
				message_admins("[usr] revoked card playing rights from [length(handled_xenos) > 1 ? "[length(handled_xenos)] xenos" : "[length(handled_xenos) == 1 ? "[handled_xenos[1]]" : "no xenos"]"]\
					[length(permit_hives) > 1 ? " in all hives, and from any new xenos." : "[length(permit_hives) == 1 ? " in [permit_hives[1]], and from any new xenos in that hive." : "."]"]")

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

	var/humans_to_spawn = clamp(text2num(href_list["object_count"]), 1, 100)
	var/range_to_spawn_on = clamp(text2num(href_list["object_range"]), 0, 10)

	var/free_the_humans = FALSE
	var/offer_as_ert = FALSE
	var/play_as = FALSE

	if(href_list["spawn_as"] == "freed")
		free_the_humans = TRUE

	else if(href_list["spawn_as"] == "ert")
		offer_as_ert = TRUE

	else if(href_list["spawn_as"] == "play")
		play_as = TRUE
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
			for(spawn_turf in range(range_to_spawn_on, initial_turf))
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

		if(play_as)
			spawned_human.ckey = owner.ckey

		if (offer_as_ert)
			var/datum/emergency_call/custom/em_call = new()
			var/name = input(usr, "Please name your ERT", "ERT Name", "Admin spawned humans")
			em_call.name = name
			em_call.mob_max = length(humans)
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

	var/xenos_to_spawn = clamp(text2num(href_list["object_count"]), 1, 100)
	var/range_to_spawn_on = clamp(text2num(href_list["object_range"]), 0, 10)

	var/free_the_xenos = FALSE
	var/offer_as_ert = FALSE
	var/play_as = FALSE

	if(href_list["spawn_as"] == "freed")
		free_the_xenos = TRUE

	else if(href_list["spawn_as"] == "ert")
		offer_as_ert = TRUE

	else if(href_list["spawn_as"] == "play")
		play_as = TRUE

	if(xenos_to_spawn)
		var/list/turfs = list()
		if(isnull(range_to_spawn_on))
			range_to_spawn_on = 0

		var/turf/spawn_turf
		if(range_to_spawn_on)
			for(spawn_turf in range(range_to_spawn_on, initial_turf))
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

		if(play_as)
			X.ckey = owner.ckey

		if(offer_as_ert)
			var/datum/emergency_call/custom/em_call = new()
			var/name = input(usr, "Please name your ERT", "ERT Name", "Admin spawned xenos")
			em_call.name = name
			em_call.mob_max = length(xenos)
			em_call.players_to_offer = xenos
			em_call.owner = owner

			var/quiet_launch = TRUE
			var/ql_prompt = tgui_alert(usr, "Would you like to broadcast the beacon launch? This will reveal the distress beacon to all players.", "Announce distress beacon?", list("Yes", "No"), 20 SECONDS)
			if(ql_prompt == "Yes")
				quiet_launch = FALSE

			var/announce_receipt = FALSE
			var/ar_prompt = tgui_alert(usr, "Would you like to announce the beacon received message? This will reveal the distress beacon to all players.", "Announce beacon received?", list("Yes", "No"), 20 SECONDS)
			if(ar_prompt == "Yes")
				announce_receipt = TRUE

			em_call.activate(quiet_launch, announce_receipt)

		message_admins("[key_name_admin(usr)] created [xenos_to_spawn] xenos as [xeno_caste] at [get_area(initial_spot)]")
