/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using minds properly:

	-	Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing mind of the old mob should be transfered to the new mob like so:

			mind.transfer_to(new_mob)

	-	You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transfering the mind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

	-	When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.

			new_mob.key = key

		The Login proc will handle making a new mob for that mobtype (including setting up stuff like mind.name). Simple!
		However if you want that mind to have any special properties like being a traitor etc you will have to do that
		yourself.

*/

/datum/mind
	var/key
	var/ckey
	var/name				//replaces mob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any meaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle minds.
	var/mob/dead/observer/ghost_mob = null // If we're in a ghost, a reference to it
	var/active = 0

	var/memory
	var/list/objective_memory = list() //a list of objectives you have knowledge about

	var/assigned_role = ""
	var/special_role = ""

	var/role_alt_title
	var/role_comm_title

	var/list/datum/objective/objectives = list()
	var/list/datum/objective/special_verbs = list()

	var/datum/entity/player_entity/player_entity = null

	var/faction = FACTION_NEUTRAL			//associated faction
	var/datum/changeling/changeling		//changeling holder

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account

/datum/mind/New(var/key, var/ckey)
	src.key = key
	src.ckey = ckey
	player_entity = setup_player_entity(ckey)

/datum/mind/proc/transfer_to(mob/living/new_character, var/force = FALSE)
	if(current)	
		current.mind = null	//remove ourself from our old body's mind variable
		nanomanager.user_transferred(current, new_character) // transfer active NanoUI instances to new user

	if(key)
		if(new_character.key != key)
			new_character.ghostize(TRUE)
	else
		key = new_character.key

	if(new_character.mind) 
		new_character.mind.current = null //remove any mind currently in our new body's mind variable

	current = new_character		//link ourself to our new body
	new_character.mind = src	//and link our new body to ourself

	if(active || force)
		new_character.key = key		//now transfer the key to link the client to our new body
		if(new_character.client)
			new_character.client.change_view(world.view) //reset view range to default.
			new_character.client.pixel_x = 0
			new_character.client.pixel_y = 0
			if(usr && usr.open_uis)
				for(var/datum/nanoui/ui in usr.open_uis)
					if(ui.allowed_user_stat == -1)
						ui.close()
						continue
			player_entity = setup_player_entity(ckey)

	new_character.refresh_huds(current)					//inherit the HUDs from the old body


/datum/mind/proc/store_memory(new_text)
	memory += "[new_text]<BR>"

/datum/mind/proc/show_memory(mob/recipient)
	var/output = memory

	if(objectives.len>0)
		output += "<HR><B>Objectives:</B>"

		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			output += "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++

	show_browser(recipient, output, "[current.real_name]'s Memory", "memory")

//this is an objective that the player has just completed
//and we want to store the objective clues generated based on it -spookydonut
/datum/mind/proc/store_objective(var/datum/cm_objective/O)
	for(var/datum/cm_objective/R in O.enables_objectives)
		if(!(R in objective_memory) && R.is_active())
			objective_memory += R

/datum/mind/proc/view_objective_memories(mob/recipient)
	var/output
	
	// Do we have DEFCON?
	if(objectives_controller)
		output += "<b>DEFCON [defcon_controller.current_defcon_level]:</b> [defcon_controller.check_defcon_percentage()]%"
		
		output += "<br>"
		output += "<hr>"
		output += "<br>"
			
		for(var/datum/cm_objective/O in objective_memory)
			if(!O)
				continue
			if(!O.is_prerequisites_completed() || !O.is_active())
				continue
			if(O.display_flags & OBJ_DISPLAY_HIDDEN)
				continue
			if(O.is_complete())
				continue
			output += "[O.get_clue()]<BR>"

		output += "<br>"
		output += "<hr>"
		output += "<br>"

		// Item and body retrieval %, power, etc.
		output += objectives_controller.get_objectives_progress()
	var/window_name = "objective clues"
	if(ismob(current))
		window_name = "[current.real_name]'s objective clues"

	show_browser(recipient, output, window_name, "objectivesmemory")

/datum/mind/proc/edit_memory()
	if(!ticker || !ticker.mode)
		alert("Not before round-start!", "Alert")
		return

	var/out = "Mind currently owned by key: [key] [active?"(synced)":"(not synced)"]<br>"
	out += "Assigned role: [assigned_role]. <a href='?src=\ref[src];role_edit=1'>Edit</a><br>"
	out += "Factions and special roles:<br>"

	var/list/sections = list(
		"implant",
		"traitor",
	)
	var/text = ""
	var/mob/living/carbon/human/H = current
	if (istype(current, /mob/living/carbon/human))
		/** Impanted**/
		if(istype(current, /mob/living/carbon/human))
			if(H.is_loyalty_implanted(H))
				text = "Loyalty Implant:<a href='?src=\ref[src];implant=remove'>Remove</a>|<b>Implanted</b></br>"
			else
				text = "Loyalty Implant:<b>No Implant</b>|<a href='?src=\ref[src];implant=add'>Implant him!</a></br>"
		else
			text = "Loyalty Implant: Don't implant that monkey!</br>"
		sections["implant"] = text

	/** TRAITOR ***/
	text = "traitor"
	if (ticker.mode.config_tag=="traitor")
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if(istype(current, /mob/living/carbon/human))
		if (H.is_loyalty_implanted(H))
			text +="traitor|<b>LOYAL EMPLOYEE</b>"
		else
			if (src in ticker.mode.traitors)
				text += "<b>TRAITOR</b>|<a href='?src=\ref[src];traitor=clear'>Employee</a>"
				if (objectives.len==0)
					text += "<br>Objectives are empty! <a href='?src=\ref[src];traitor=autoobjectives'>Randomize</a>!"
			else
				text += "<a href='?src=\ref[src];traitor=traitor'>traitor</a>|<b>Employee</b>"
	sections["traitor"] = text

	out += "<br>"

	out += "<b>Memory:</b><br>"
	out += memory
	out += "<br><a href='?src=\ref[src];memory_edit=1'>Edit memory</a><br>"
	out += "Objectives:<br>"
	if (objectives.len == 0)
		out += "EMPTY<br>"
	else
		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			out += "<B>[obj_count]</B>: [objective.explanation_text] <a href='?src=\ref[src];obj_edit=\ref[objective]'>Edit</a> <a href='?src=\ref[src];obj_delete=\ref[objective]'>Delete</a> <a href='?src=\ref[src];obj_completed=\ref[objective]'><font color=[objective.completed ? "green" : "red"]>Toggle Completion</font></a><br>"
			obj_count++
	out += "<a href='?src=\ref[src];obj_add=1'>Add objective</a><br><br>"

	out += "<a href='?src=\ref[src];obj_announce=1'>Announce objectives</a><br><br>"

	show_browser(usr, out, "<B>[name]</B>[(current&&(current.real_name!=name))?" (as [current.real_name])":""]", "edit_memory[src]")

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))	return

	if (href_list["role_edit"])
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in joblist
		if (!new_role) return
		assigned_role = new_role
		if(ishuman(current))
			var/mob/living/carbon/human/H = current
			if(H.mind)
				for(var/datum/job/J in get_all_jobs())
					if(J.title == new_role)
						H.set_skills(J.get_skills()) //give new role's job_knowledge to us.
						H.mind.special_role = J.special_role
						H.mind.role_alt_title = J.get_alternative_title(src)
						H.mind.role_comm_title = J.get_comm_title()
						break

	else if (href_list["memory_edit"])
		var/new_memo = copytext(sanitize(input("Write new memory", "Memory", memory) as null|message),1,MAX_MESSAGE_LEN)
		if (isnull(new_memo)) return
		memory = new_memo

	else if (href_list["obj_edit"] || href_list["obj_add"])
		var/datum/objective/objective
		var/objective_pos
		var/def_value

		if (href_list["obj_edit"])
			objective = locate(href_list["obj_edit"])
			if (!objective) return
			objective_pos = objectives.Find(objective)

			//Text strings are easy to manipulate. Revised for simplicity.
			var/temp_obj_type = "[objective.type]"//Convert path into a text string.
			def_value = copytext(temp_obj_type, 19)//Convert last part of path into an objective keyword.
			if(!def_value)//If it's a custom objective, it will be an empty string.
				def_value = "custom"

		var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null|anything in list("assassinate", "debrain", "protect", "prevent", "harm", "brig", "hijack", "escape", "survive", "steal", "download", "nuclear", "capture", "absorb", "custom")
		if (!new_obj_type) return

		var/datum/objective/new_objective = null

		switch (new_obj_type)
			if ("assassinate","protect","debrain", "harm", "brig")
				//To determine what to name the objective in explanation text.
				var/objective_type_capital = uppertext(copytext(new_obj_type, 1,2))//Capitalize first letter.
				var/objective_type_text = copytext(new_obj_type, 2)//Leave the rest of the text.
				var/objective_type = "[objective_type_capital][objective_type_text]"//Add them together into a text string.

				var/list/possible_targets = list("Free objective")
				for(var/datum/mind/possible_target in ticker.minds)
					if ((possible_target != src) && istype(possible_target.current, /mob/living/carbon/human))
						possible_targets += possible_target.current

				var/mob/def_target = null
				var/objective_list[] = list(/datum/objective/assassinate, /datum/objective/protect, /datum/objective/debrain)
				if (objective&&(objective.type in objective_list) && objective:target)
					def_target = objective:target.current

				var/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
				if (!new_target) return

				var/objective_path = text2path("/datum/objective/[new_obj_type]")
				if (new_target == "Free objective")
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = null
					new_objective.explanation_text = "Free objective"
				else
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = new_target:mind
					//Will display as special role if the target is set as MODE. Ninjas/commandos/nuke ops.
					new_objective.explanation_text = "[objective_type] [new_target:real_name], the [new_target:mind:assigned_role=="MODE" ? (new_target:mind:special_role) : (new_target:mind:assigned_role)]."

			if ("survive")
				new_objective = new /datum/objective/survive
				new_objective.owner = src

			if ("steal")
				if (!istype(objective, /datum/objective/steal))
					new_objective = new /datum/objective/steal
					new_objective.owner = src
				else
					new_objective = objective
				var/datum/objective/steal/steal = new_objective
				if (!steal.select_target())
					return

			if("download","capture")
				var/def_num
				if(objective&&objective.type==text2path("/datum/objective/[new_obj_type]"))
					def_num = objective.target_amount

				var/target_number = input("Input target number:", "Objective", def_num) as num|null
				if (isnull(target_number))//Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
					return

				switch(new_obj_type)
					if("download")
						new_objective = new /datum/objective/download
						new_objective.explanation_text = "Download [target_number] research levels."
					if("capture")
						new_objective = new /datum/objective/capture
						new_objective.explanation_text = "Accumulate [target_number] capture points."
				new_objective.owner = src
				new_objective.target_amount = target_number

			if ("custom")
				var/expl = stripped_input(usr, "Custom objective:", "Objective", objective ? objective.explanation_text : "",MAX_MESSAGE_LEN)
				if (!expl) return
				new_objective = new /datum/objective
				new_objective.owner = src
				new_objective.explanation_text = expl

		if (!new_objective) return

		if (objective)
			objectives -= objective
			objectives.Insert(objective_pos, new_objective)
		else
			objectives += new_objective

	else if (href_list["obj_delete"])
		var/datum/objective/objective = locate(href_list["obj_delete"])
		if(!istype(objective))	return
		objectives -= objective

	else if(href_list["obj_completed"])
		var/datum/objective/objective = locate(href_list["obj_completed"])
		if(!istype(objective))	return
		objective.completed = !objective.completed

	else if (href_list["traitor"])
		switch(href_list["traitor"])
			if("clear")
				if(src in ticker.mode.traitors)
					ticker.mode.traitors -= src
					special_role = null
					current.hud_set_special_role()
					to_chat(current, SPAN_WARNING("<FONT size = 3><B>You have been brainwashed! You are no longer a traitor!</B></FONT>"))
					log_admin("[key_name_admin(usr)] has de-traitor'ed [current].")

			if("traitor")
				if(!(src in ticker.mode.traitors))
					ticker.mode.traitors += src
					special_role = "traitor"
					current.hud_set_special_role()
					to_chat(current, "<B>\red You are a traitor!</B>")
					log_admin("[key_name_admin(usr)] has traitor'ed [current].")
					show_objectives()

	else if (href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.drop_inv_item_on_ground(W)

	else if (href_list["obj_announce"])
		var/obj_count = 1
		to_chat(current, SPAN_NOTICE(" Your current objectives:"))
		for(var/datum/objective/objective in objectives)
			to_chat(current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

	edit_memory()

/datum/mind/proc/make_Traitor()
	if(!(src in ticker.mode.traitors))
		ticker.mode.traitors += src
		special_role = "traitor"

/datum/mind/proc/setup_human_stats()
	if(!player_entity)
		player_entity = setup_player_entity(ckey)
		if(!player_entity)
			return
	return player_entity.setup_human_stats()

/datum/mind/proc/setup_xeno_stats()
	if(!player_entity)
		player_entity = setup_player_entity(ckey)
		if(!player_entity)
			return
	return player_entity.setup_xeno_stats()

/datum/mind/proc/wipe_entity()
	player_entity = null

//Initialisation procs
/mob/proc/mind_initialize()
	if(mind) mind.key = key
	else
		mind = new /datum/mind(key, ckey)
		mind.original = src
		if(ticker) ticker.minds += mind
		else world.log << "## DEBUG: mind_initialize(): No ticker ready yet! Please inform Carn"
		. = 1 //successfully created a new mind
	if(!mind.name)	mind.name = real_name
	mind.current = src
		

//HUMAN
/mob/living/carbon/human/mind_initialize()
	if(..()) //new mind created
		//if we find an ID with assignment, we give the new mind the info linked to that job.
		if(wear_id)
			var/obj/item/card/id/I = wear_id.GetID()
			if(I && I.assignment)
				for(var/datum/job/J in get_all_jobs())
					if(J.title == I.rank)
						mind.assigned_role = J.title
						set_skills(J.get_skills())
						mind.special_role = J.special_role
						mind.role_alt_title = J.get_alternative_title(src)
						mind.role_comm_title = J.get_comm_title()
						break
	//if not, we give the mind default job_knowledge and assigned_role
	if(!mind.assigned_role)
		mind.assigned_role = JOB_SQUAD_MARINE //default

//XENO
/mob/living/carbon/Xenomorph/mind_initialize()
	..()
	mind.assigned_role = "MODE"
	mind.special_role = "Xenomorph"

//AI
/mob/living/silicon/ai/mind_initialize()
	..()
	mind.assigned_role = "AI"

//BORG
/mob/living/silicon/robot/mind_initialize()
	..()
	mind.assigned_role = "Cyborg"

//Animals
/mob/living/simple_animal/mind_initialize()
	..()
	mind.assigned_role = "Animal"

/mob/living/simple_animal/corgi/mind_initialize()
	..()
	mind.assigned_role = "Corgi"

/mob/living/simple_animal/shade/mind_initialize()
	..()
	mind.assigned_role = "Shade"

/mob/living/simple_animal/construct/builder/mind_initialize()
	..()
	mind.assigned_role = "Artificer"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/wraith/mind_initialize()
	..()
	mind.assigned_role = "Wraith"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/armoured/mind_initialize()
	..()
	mind.assigned_role = "Juggernaut"
	mind.special_role = "Cultist"
