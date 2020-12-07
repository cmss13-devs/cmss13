/datum/mind
	var/key
	var/ckey
	var/name				//replaces mob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any meaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle minds.
	var/mob/dead/observer/ghost_mob = null // If we're in a ghost, a reference to it
	var/active = FALSE
	var/roundstart_picked = FALSE

	var/memory
	var/datum/objective_memory_storage/objective_memory = new() //a list of objectives you have knowledge about

	var/datum/entity/player_entity/player_entity = null

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account

/datum/mind/New(var/key, var/ckey)
	src.key = key
	src.ckey = ckey
	player_entity = setup_player_entity(ckey)

/datum/mind/proc/transfer_to(mob/living/new_character, var/force = FALSE)
	if(QDELETED(new_character))
		msg_admin_niche("[key]/[ckey] has tried to transfer to deleted [new_character].")
		return

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
	original = new_character
	new_character.mind = src	//and link our new body to ourself

	if(active || force)
		new_character.key = key		//now transfer the key to link the client to our new body
		SSround_recording.recorder.update_key(new_character)
		if(new_character.client)
			new_character.client.change_view(world_view_size) //reset view range to default.
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

	show_browser(recipient, output, "[current.real_name]'s Memory", "memory")

//this is an objective that the player has just completed
//and we want to store the objective clues generated based on it -spookydonut
/datum/mind/proc/store_objective(var/datum/cm_objective/O)
	if(objective_memory)
		objective_memory.store_objective(O)

/datum/mind/proc/view_objective_memories(mob/recipient)
	if(objective_memory)
		if(ismob(current))
			objective_memory.view_objective_memories(recipient, current.real_name)
		else
			objective_memory.view_objective_memories(recipient, null)

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))	
		return

	else if (href_list["memory_edit"])
		var/new_memo = copytext(sanitize(input("Write new memory", "Memory", memory) as null|message),1,MAX_MESSAGE_LEN)
		if (isnull(new_memo)) return
		memory = new_memo

	else if (href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.drop_inv_item_on_ground(W)

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
		if(SSticker) SSticker.minds += mind
		else world.log << "## DEBUG: mind_initialize(): No ticker ready yet! Please inform Carn"
		. = 1 //successfully created a new mind
	if(!mind.name)	mind.name = real_name
	mind.current = src