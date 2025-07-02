/datum/admins/proc/topic_teleports(href)
	switch(href)
		if("jump_to_area")
			var/area/choice = tgui_input_list(owner, "Pick an area to jump to:", "Jump", return_sorted_areas())
			if(QDELETED(choice))
				return

			owner.jump_to_area(choice)

		if("jump_to_turf")
			var/turf/choice = tgui_input_list(owner, "Pick a turf to jump to:", "Jump", GLOB.turfs)
			if(QDELETED(choice))
				return

			owner.jump_to_turf(choice)

		if("jump_to_mob")
			var/mob/choice = tgui_input_list(owner, "Pick a mob to jump to:", "Jump", GLOB.mob_list)
			if(QDELETED(choice))
				return

			owner.jumptomob(choice)

		if("jump_to_coord")
			var/targ_x = tgui_input_number(owner, "Jump to x from 0 to [world.maxx].", "Jump to X", 0, world.maxx, 0)
			if(!targ_x || targ_x < 0)
				return
			var/targ_y = tgui_input_number(owner, "Jump to y from 0 to [world.maxy].", "Jump to Y", 0, world.maxy, 0)
			if(!targ_y || targ_y < 0)
				return
			var/targ_z = tgui_input_number(owner, "Jump to z from 0 to [world.maxz].", "Jump to Z", 0, world.maxz, 0)
			if(!targ_z || targ_z < 0)
				return

			owner.jumptocoord(targ_x, targ_y, targ_z)

		if("jump_to_offset_coord")
			var/targ_x = tgui_input_real_number(owner, "Jump to X coordinate.")
			if(!targ_x)
				return
			var/targ_y = tgui_input_real_number(owner, "Jump to Y coordinate.")
			if(!targ_y)
				return

			owner.jumptooffsetcoord(targ_x, targ_y)

		if("jump_to_obj")
			var/list/obj/targets = list()
			for(var/obj/O in world)
				targets += O
			var/obj/choice = tgui_input_list(owner, "Pick an object to jump to:", "Jump", targets)
			if(QDELETED(choice))
				return

			owner.jump_to_object(choice)

		if("jump_to_key")
			owner.jumptokey()

		if("get_mob")
			var/mob/choice = tgui_input_list(owner, "Pick a mob to teleport here:","Get Mob", GLOB.mob_list)
			if(QDELETED(choice))
				return

			owner.Getmob(choice)

		if("get_key")
			owner.Getkey()

		if("teleport_mob_to_area")
			var/mob/choice = tgui_input_list(owner, "Pick a mob to an area:","Teleport Mob", sortmobs())
			if(QDELETED(choice))
				return

			owner.sendmob(choice)

		if("teleport_mobs_in_range")
			var/collect_range = tgui_input_number(owner, "Enter range from 0 to 7 tiles. All alive /living mobs within selected range will be marked for teleportation.", "Mass-teleportation", 0, 7, 0)
			if(collect_range < 0 || collect_range > 7)
				to_chat(owner, SPAN_ALERT("Incorrect range. Aborting."))
				return
			var/list/targets = list()
			for(var/mob/living/M in range(collect_range, owner.mob))
				if(M.stat != DEAD)
					targets.Add(M)
			if(length(targets) < 1)
				to_chat(owner, SPAN_ALERT("No alive /living mobs found. Aborting."))
				return
			if(alert(owner, "[length(targets)] mobs were marked for teleportation. Pressing \"TELEPORT\" will teleport them to your location at the moment of pressing button.", "Confirmation", "Teleport", "Cancel") == "Cancel")
				return
			for(var/mob/M in targets)
				if(!M)
					continue
				M.on_mob_jump()
				M.forceMove(get_turf(owner.mob))

			message_admins(WRAP_STAFF_LOG(owner.mob, "mass-teleported [length(targets)] mobs in [collect_range] tiles range to themselves in [get_area(owner.mob)] ([owner.mob.x],[owner.mob.y],[owner.mob.z])."), owner.mob.x, owner.mob.y, owner.mob.z)

		if("teleport_mobs_by_faction")
			var/faction = tgui_input_list(owner, "Choose between humanoids and xenomorphs.", "Mobs Choice", list("Humanoids", "Xenomorphs"))
			if(faction == "Humanoids")
				faction = null
				faction = tgui_input_list(owner, "Select faction you want to teleport to your location. Mobs in Thunderdome/CentComm areas won't be included.", "Faction Choice", FACTION_LIST_HUMANOID)
				if(!faction)
					to_chat(owner, SPAN_ALERT("Faction choice error. Aborting."))
					return
				var/list/targets = GLOB.alive_human_list.Copy()
				for(var/mob/living/carbon/human/H in targets)
					var/area/AR = get_area(H)
					if(H.faction != faction || AR.statistic_exempt)
						targets.Remove(H)
				if(length(targets) < 1)
					to_chat(owner, SPAN_ALERT("No alive /human mobs of [faction] faction were found. Aborting."))
					return
				if(alert(owner, "[length(targets)] humanoids of [faction] faction were marked for teleportation. Pressing \"TELEPORT\" will teleport them to your location at the moment of pressing button.", "Confirmation", "Teleport", "Cancel") == "Cancel")
					return

				for(var/mob/M in targets)
					if(!M)
						continue
					M.on_mob_jump()
					M.forceMove(get_turf(owner.mob))

				message_admins(WRAP_STAFF_LOG(owner.mob, "mass-teleported [length(targets)] human mobs of [faction] faction to themselves in [get_area(owner.mob)] ([owner.mob.x],[owner.mob.y],[owner.mob.z])."), owner.mob.x, owner.mob.y, owner.mob.z)

			else if(faction == "Xenomorphs")
				faction = null
				var/list/hives = list()
				var/datum/hive_status/hive
				for(var/hivenumber in GLOB.hive_datum)
					hive = GLOB.hive_datum[hivenumber]
					hives += list("[hive.name]" = hive.hivenumber)

				faction = tgui_input_list(owner, "Select hive you want to teleport to your location. Mobs in Thunderdome/CentComm areas won't be included.", "Hive Choice", hives)
				if(!faction)
					to_chat(owner, SPAN_ALERT("Hive choice error. Aborting."))
					return
				var/datum/hive_status/Hive = GLOB.hive_datum[hives[faction]]
				var/list/targets = Hive.totalXenos
				for(var/mob/living/carbon/xenomorph/X in targets)
					var/area/AR = get_area(X)
					if(X.stat == DEAD || AR.statistic_exempt)
						targets.Remove(X)
				if(length(targets) < 1)
					to_chat(owner, SPAN_ALERT("No alive xenomorphs of [faction] Hive were found. Aborting."))
					return
				if(alert(owner, "[length(targets)] xenomorphs of [faction] Hive were marked for teleportation. Pressing \"TELEPORT\" will teleport them to your location at the moment of pressing button.", "Confirmation", "Teleport", "Cancel") == "Cancel")
					return

				for(var/mob/M in targets)
					if(!M)
						continue
					M.on_mob_jump()
					M.forceMove(get_turf(owner.mob))

				message_admins(WRAP_STAFF_LOG(owner.mob, "mass-teleported [length(targets)] xenomorph mobs of [faction] Hive to themselves in [get_area(owner.mob)] ([owner.mob.x],[owner.mob.y],[owner.mob.z])."), owner.mob.x, owner.mob.y, owner.mob.z)

			else
				to_chat(owner, SPAN_ALERT("Mobs choice error. Aborting."))
				return

		if("teleport_corpses")
			if(length(GLOB.dead_mob_list) < 0)
				to_chat(owner, SPAN_ALERT("No corpses found. Aborting."))
				return

			if(alert(owner, "[length(GLOB.dead_mob_list)] corpses are marked for teleportation. Pressing \"TELEPORT\" will teleport them to your location at the moment of pressing button.", "Confirmation", "Teleport", "Cancel") == "Cancel")
				return
			for(var/mob/M in GLOB.dead_mob_list)
				if(!M)
					continue
				M.on_mob_jump()
				M.forceMove(get_turf(owner.mob))
			message_admins(WRAP_STAFF_LOG(owner.mob, "mass-teleported [length(GLOB.dead_mob_list)] corpses to themselves in [get_area(owner.mob)] ([owner.mob.x],[owner.mob.y],[owner.mob.z])."), owner.mob.x, owner.mob.y, owner.mob.z)

		if("teleport_items_by_type")
			var/item = input(owner,"What item?", "Item Fetcher","") as text|null
			if(!item)
				return

			var/list/types = typesof(/obj)
			var/list/matches = new()

			//Figure out which object they might be trying to fetch
			for(var/path in types)
				if(findtext("[path]", item))
					matches += path

			if(length(matches)==0)
				return

			var/chosen
			if(length(matches)==1)
				chosen = matches[1]
			else
				//If we have multiple options, let them select which one they meant
				chosen = tgui_input_list(usr, "Select an object type", "Find Object", matches)

			if(!chosen)
				return

			//Find all items in the world
			var/list/targets = list()
			for(var/obj/item/M in world)
				if(istype(M, chosen))
					targets += M

			if(length(targets) < 1)
				to_chat(owner, SPAN_ALERT("No items of type [chosen] were found. Aborting."))
				return

			if(alert(owner, "[length(targets)] items are marked for teleportation. Pressing \"TELEPORT\" will teleport them to your location at the moment of pressing button.", "Confirmation", "Teleport", "Cancel") == "Cancel")
				return

			//Fetch the items
			for(var/obj/item/M in targets)
				if(!M)
					continue
				M.forceMove(get_turf(owner.mob))

			message_admins(WRAP_STAFF_LOG(owner.mob, "mass-teleported [length(targets)] items of type [chosen] to themselves in [get_area(owner.mob)] ([owner.mob.x],[owner.mob.y],[owner.mob.z])."), owner.mob.x, owner.mob.y, owner.mob.z)
