/mob/dead
	var/voted_this_drop = 0
	recalculate_move_delay = FALSE

/mob/dead/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	density = 0
	canmove = TRUE 
	blinded = 0
	anchored = 1	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	layer = ABOVE_FLY_LAYER
	m_intent = MOVE_INTENT_WALK
	stat = DEAD
	var/adminlarva = 0
	var/can_reenter_corpse
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghost - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/list/HUD_toggled = list(
							"Medical HUD" = FALSE,
							"Security HUD" = FALSE,
							"Squad HUD" = FALSE,
							"Xeno Status HUD" = FALSE
							)
	universal_speak = 1
	var/atom/movable/following = null

/mob/dead/observer/New(mob/body)
	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	verbs += /mob/dead/observer/proc/dead_tele

	var/turf/T
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost

		if(isHumanSynthStrict(body))
			var/mob/living/carbon/human/H = body
			icon = 'icons/mob/humans/species/r_human.dmi'
			icon_state = "anglo_example"
			overlays += H.overlays
		else if(isYautja(body))
			icon = 'icons/mob/humans/species/r_predator.dmi'
			icon_state = "yautja_example"
			overlays += body.overlays
		else if(ismonkey(body))
			icon = 'icons/mob/humans/species/monkeys/monkey.dmi'
			icon_state = "monkey1"
			overlays += body.overlays
		else
			icon = body.icon
			icon_state = body.icon_state

		alpha = 127

		gender = body.gender
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
				else
					name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	if(!T)	T = pick(latejoin)			//Safety in case we cannot find the body's position
	loc = T

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	change_real_name(src, name)

	..()
	if(ticker && ticker.mode && ticker.mode.flags_round_type & MODE_PREDATOR)
		spawn(20)
			to_chat(src, "<span style='color: red;'>This is a <B>PREDATOR ROUND</B>! If you are whitelisted, you may Join the Hunt!</span>")
			return

/mob/dead/observer/Login()
	..()
	client.move_delay = MINIMAL_MOVEMENT_INTERVAL

/mob/dead/observer/Dispose()
	following = null
	return ..()

/mob/dead/observer/MouseDrop(atom/A)
	if(!usr || !A)
		return
	if(isobserver(usr) && usr.client && isliving(A))
		var/mob/living/M = A
		usr.client.cmd_admin_ghostchange(M, src)
	else return ..()


/mob/dead/observer/Topic(href, href_list)
	if(href_list["reentercorpse"])
		if(istype(usr, /mob/dead/observer))
			var/mob/dead/observer/A = usr
			A.reenter_corpse()
	if(href_list["track"])
		var/mob/target = locate(href_list["track"]) in mob_list
		if(target)
			ManualFollow(target)
	if(href_list[XENO_OVERWATCH_TARGET_HREF])
		var/mob/target = locate(href_list[XENO_OVERWATCH_TARGET_HREF]) in living_xeno_list
		if(target)
			ManualFollow(target)
	if(href_list["jumptocoord"])
		if(istype(usr, /mob/dead/observer))
			var/mob/dead/observer/A = usr
			var/x = text2num(href_list["X"])
			var/y = text2num(href_list["Y"])
			var/z = text2num(href_list["Z"])
			if(x && y && z)
				A.JumpToCoord(x, y, z)


/mob/dead/BlockedPassDirs(atom/movable/mover, target_dir)
	return NO_BLOCKED_MOVEMENT
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/dead/observer/Life()
	..()
	if(!loc) return
	if(!client) return 0

	return 1

/mob/proc/ghostize(var/can_reenter_corpse = TRUE)
	if(isaghost(src) || !key)
		return

	var/mob/dead/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
	ghost.can_reenter_corpse = can_reenter_corpse
	ghost.timeofdeath = timeofdeath //BS12 EDIT
	ghost.key = key
	ghost.mind = mind

	if(!can_reenter_corpse)
		away_timer = 300 //They'll never come back, so we can max out the timer right away.
		if(round_statistics)
			round_statistics.update_panel_data()
		track_death_calculations() //This needs to be done before mind is nullified
	else if(ghost.mind && ghost.mind.player_entity) //Use else here because track_death_calculations() already calls this.
		ghost.mind.player_entity.update_panel_data(round_statistics)

	mind = null

	if(ghost.client)
		ghost.client.change_view(world.view) //reset view range to default
		ghost.client.pixel_x = 0 //recenters our view
		ghost.client.pixel_y = 0
		if(ghost.client.soundOutput)
			ghost.client.soundOutput.update_ambience()
			ghost.client.soundOutput.status_flags = 0 //Clear all effects that would affect a living mob
			ghost.client.soundOutput.apply_status()
		
		if(ghost.client.prefs)
			var/datum/mob_hud/H
			ghost.HUD_toggled = ghost.client.prefs.observer_huds
			for(var/i in ghost.HUD_toggled)
				if(ghost.HUD_toggled[i])
					switch(i)
						if("Medical HUD")
							H = huds[MOB_HUD_MEDICAL_OBSERVER]
							H.add_hud_to(ghost)
						if("Security HUD")
							H = huds[MOB_HUD_SECURITY_ADVANCED]
							H.add_hud_to(ghost)
						if("Squad HUD")
							H = huds[MOB_HUD_SQUAD]
							H.add_hud_to(ghost)
						if("Xeno Status HUD")
							H = huds[MOB_HUD_XENO_STATUS]
							H.add_hud_to(ghost)

	return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD)
		if(mind && mind.player_entity)
			mind.player_entity.update_panel_data(round_statistics)
		ghostize(TRUE)
	else
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to return to your body. You can't change your mind so choose wisely!)","Are you sure you want to ghost?","Ghost","Stay in body")
		if(response != "Ghost")	return	//didn't want to ghost after-all
		AdjustSleeping(2) // Sleep so you will be properly recognized as ghosted
		var/turf/location = get_turf(src)
		if(location) //to avoid runtime when a mob ends up in nullspace
			msg_admin_niche("[key_name_admin(usr)] has ghosted. (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
		log_game("[key_name_admin(usr)] has ghosted.")
		var/mob/dead/observer/ghost = ghostize(FALSE) //FALSE parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		if(ghost)
			ghost.timeofdeath = world.time

/mob/dead/observer/Move(NewLoc, direct)
	following = null
	dir = direct
	var/area/last_area = get_area(loc)
	if(NewLoc)
		for(var/obj/effect/step_trigger/S in NewLoc)
			S.Crossed(src)

	loc = get_turf(src) //Get out of closets and such as a ghost
	if((direct & NORTH) && y < world.maxy)
		y += m_intent //Let's take advantage of the intents being 1 & 2 respectively
	else if((direct & SOUTH) && y > 1)
		y -= m_intent
	if((direct & EAST) && x < world.maxx)
		x += m_intent
	else if((direct & WEST) && x > 1)
		x -= m_intent

	var/turf/new_turf = locate(x, y, z)
	if(!new_turf)
		return

	var/area/new_area = new_turf.loc
	
	if((new_area != last_area) && new_area)
		new_area.Entered(src)
		if(last_area)
			last_area.Exited(src)

	for(var/obj/effect/step_trigger/S in new_turf)	//<-- this is dumb
		S.Crossed(src)

/mob/dead/observer/examine(mob/user)
	to_chat(user, desc)

/mob/dead/observer/can_use_hands()
	return 0

/mob/dead/observer/Stat()
	if (!..())
		return 0

	stat("Time:","[worldtime2text()]")
	stat("DEFCON Level:","[defcon_controller.current_defcon_level]")

	if(EvacuationAuthority)
		var/eta_status = EvacuationAuthority.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)
	return 1

/mob/dead/observer/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"

	if(!client)	
		return

	if(!mind || !mind.current || mind.current.disposed || !can_reenter_corpse)
		to_chat(src, "<span style='color: red;'>You have no body.</span>")
		return

	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(src, "<span style='color: red;'>Another consciousness is in your body...It is resisting you.</span>")
		return

	mind.transfer_to(mind.current, TRUE)
	qdel(src)
	return TRUE

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"
	if(!istype(usr, /mob/dead/observer))
		to_chat(src, "<span style='color: red;'>Not when you're not dead!</span>")
		return
	var/A
	A = input("Area to jump to", "BOOYEA", A) as null|anything in ghostteleportlocs
	var/area/thearea = ghostteleportlocs[A]
	if(!thearea)	return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(src, "<span style='color: red;'>No area available.</span>")

	usr.loc = pick(L)
	following = null


/mob/dead/observer/verb/follow()
	set category = "Ghost"
	set name = "Follow"

	var/list/choices = list("Mobs Within Screen", "Humans", "Xenomorphs", "Predators", "Synthetics", "ERT Members", "Survivors", "Any Mobs", "Mobs by Factions", "Xenos by Hives", "Vehicles")
	var/input = input("Please, select a category:", "Follow", null, null) as null|anything in choices
	var/atom/movable/target
	var/list/targets = list()
	switch(input)
		if("Mobs Within Screen")
			ManualFollow(target)
		if("Humans")
			targets = gethumans()
		if("Xenomorphs")
			targets = getxenos()
		if("Predators")
			targets = getpreds()
		if("Synthetics")
			targets = getsynths()
		if("ERT Members")
			targets = getertmembers()
		if("Survivors")
			targets = getsurvivors()
		if("Any Mobs")
			targets = getmobs()
		if("Vehicles")
			targets = all_multi_vehicles.Copy()

		if("Mobs by Factions")
			choices = FACTION_LIST_HUMANOID
			input = input("Please, select a Faction:", "Follow", null, null) as null|anything in choices
			targets = gethumans()
			for(var/mob/M in targets)
				if(M.faction != choices[input])
					targets.Remove(M)

		if("Xenos by Hives")
			choices = list("Regular Hive" = XENO_HIVE_NORMAL, "Corrupted Hive" = XENO_HIVE_CORRUPTED, "Alpha Hive" = XENO_HIVE_ALPHA, "Beta Hive" = XENO_HIVE_BETA, "Zeta Hive" = XENO_HIVE_ZETA)
			input = input("Please, select a Hive:", "Follow", null, null) as null|anything in choices
			targets = getxenos()
			for(var/mob/living/carbon/Xenomorph/X in targets)
				if(X.hivenumber != choices[input])
					targets.Remove(X)


	if(!LAZYLEN(targets))
		to_chat(usr, SPAN_WARNING("There aren't any targets in [input] category to follow."))
		return
	input = input("Please select a target among [input] to follow", "Follow", null, null) as null|anything in targets
	target = input

	ManualFollow(target)
	return

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(var/atom/movable/target)
	if(target && target != src)
		if(following && following == target)
			return
		following = target
		to_chat(src, SPAN_NOTICE(" Now following [target]"))
		spawn(0)
			while(target && following == target && client)
				var/turf/T = get_turf(target)
				if(!T)
					break
				// To stop the ghost flickering.
				if(loc != T)
					loc = T
				sleep(15)

/mob/dead/observer/proc/JumpToCoord(var/tx, var/ty, var/tz)
	if(!tx || !ty || !tz)
		return
	following = null
	spawn(0)
		// To stop the ghost flickering.
		x = tx
		y = ty
		z = tz
		sleep(15)

/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/dead/observer)) //Make sure they're an observer!


		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		dest += getmobs() //Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.loc = T
				following = null
			else
				to_chat(A, "<span style='color: red;'>This mob is not located in the game world.</span>")

/mob/dead/observer/memory()
	set hidden = 1
	to_chat(src, "<span style='color: red;'>You are dead! You have no mind to store memory!</span>")

/mob/dead/observer/add_memory()
	set hidden = 1
	to_chat(src, "<span style='color: red;'>You are dead! You have no mind to store memory!</span>")

/mob/dead/observer/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/dead/observer)) return

	// Shamelessly copied from the Gas Analyzers
	if (!( istype(loc, /turf) ))
		return

	var/turf/T = loc

	var/pressure = T.return_pressure()
	var/env_temperature = T.return_temperature()
	var/env_gas = T.return_gas()

	to_chat(src, SPAN_INFO("<B>Results:</B>"))
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(src, "<span style='color: blue;'>Pressure: [round(pressure,0.1)] kPa</span>")
	else
		to_chat(src, "<span style='color: red;'>Pressure: [round(pressure,0.1)] kPa</span>")

	to_chat(src, "<span style='color: blue;'>Gas type: [env_gas]</span>")
	to_chat(src, "<span style='color: blue;'>Temperature: [round(env_temperature-T0C,0.1)]&deg;C</span>")


/mob/dead/observer/verb/toggle_zoom()
	set name = "Toggle Zoom"
	set category = "Ghost"

	if(client)
		if(client.view != world.view)
			client.change_view(world.view)
		else
			client.change_view(14)


/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"

	if (see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/dead/observer/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	var/dat = data_core.get_manifest()

	show_browser(src, dat, "Crew Manifest", "manifest", "size=375x420")

/mob/dead/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of the hive."
	set category = "Ghost"

	hive_datum[XENO_HIVE_NORMAL].hive_ui.open_hive_status(src)

/mob/dead/verb/join_as_alien()
	set category = "Ghost"
	set name = "Join as Xeno"
	set desc = "Select an alive but logged-out Xenomorph to rejoin the game."

	if (!client)
		return

	if(!ticker || ticker.current_state < GAME_STATE_PLAYING || !ticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(ticker.mode.check_xeno_late_join(src))
		ticker.mode.attempt_to_join_as_xeno(src)

/mob/dead/verb/join_as_zombie() //Adapted from join as hellhoud
	set category = "Ghost"
	set name = "Join as Zombie"
	set desc = "Select an alive but logged-out Zombie to rejoin the game."

	if (!client)
		return

	if(!ticker || ticker.current_state < GAME_STATE_PLAYING || !ticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	var/list/zombie_list = list()

	for(var/mob/living/carbon/human/A in living_mob_list)
		if(iszombie(A) && !A.client && A.regenZ)
			var/player_in_decap_head
			//when decapitated the human mob is clientless,
			//we must check whether the player is still manning the brain in the decap'd head,
			//so their body isn't stolen by another player.
			var/obj/limb/head/h = A.get_limb("head")
			if(h && (h.status & LIMB_DESTROYED))
				for (var/obj/item/limb/head/HD in item_list)
					if(HD.brainmob)
						if(HD.brainmob.real_name == A.real_name)
							if(HD.brainmob.client)
								player_in_decap_head = TRUE
								break
			if(!player_in_decap_head)
				zombie_list += A.real_name


	if(zombie_list.len == 0)
		to_chat(src, "<span style='color: green;'>There are no available zombies or all empty zombies have been fed the cure.</span>")
		return

	var/choice = input("Pick a Zombie:") as null|anything in zombie_list
	if(!choice || choice == "Cancel")
		return

	if(!client)
		return

	for(var/mob/living/carbon/human/Z in living_mob_list)
		if(choice == Z.real_name)
			if(Z.disposed) //should never occur,just to be sure.
				return
			if(!Z.regenZ)
				to_chat(src, SPAN_WARNING("That zombie has been cured!"))
				return
			if(Z.client)
				to_chat(src, SPAN_WARNING("That player is still connected."))
				return

			var/obj/limb/head/h = Z.get_limb("head")
			if(h && (h.status & LIMB_DESTROYED))
				for (var/obj/item/limb/head/HD in item_list)
					if(HD.brainmob)
						if(HD.brainmob.real_name == Z.real_name)
							if(HD.brainmob.client)
								to_chat(src, SPAN_WARNING("That player is still connected!"))
								return

			var/mob/ghostmob = client.mob

			Z.ghostize(0) //Make sure previous owner does not get a free respawn.
			Z.ckey = usr.ckey
			if(Z.client) //so players don't keep their ghost zoom view.
				Z.client.change_view(world.view)

			msg_admin_niche("[key_name(usr)] has joined as a [Z].")

			if(isobserver(ghostmob) )
				qdel(ghostmob)
			return





/mob/dead/verb/join_as_hellhound()
	set category = "Ghost"
	set name = "Join as Hellhound"
	set desc = "Select an alive and available Hellhound. THIS COMES WITH STRICT RULES. READ THEM OR GET BANNED."

	var/mob/L = src

	if(ticker.current_state < GAME_STATE_PLAYING)
		to_chat(usr, SPAN_WARNING("The game hasn't started yet!"))
		return

	if (!usr.stat) // Make sure we're an observer
		// to_chat(usr, "!usr.stat")
		return

	if (usr != src)
		// to_chat(usr, "usr != src")
		return 0 // Something is terribly wrong

	if(jobban_isbanned(usr,"Alien")) // User is jobbanned
		to_chat(usr, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a Hellhound."))
		return

	var/list/hellhound_list = list()

	for(var/mob/living/carbon/hellhound/A in living_mob_list)
		if(istype(A) && !A.client)
			hellhound_list += A.real_name

	if(hellhound_list.len == 0)
		to_chat(usr, "<span style='color: red;'>There aren't any available Hellhounds.</span>")
		return

	var/choice = input("Pick a Hellhound:") as null|anything in hellhound_list
	if (isnull(choice) || choice == "Cancel")
		return

	for(var/mob/living/carbon/hellhound/X in living_mob_list)
		if(choice == X.real_name)
			L = X
			break

	if(!L || L.disposed)
		to_chat(usr, "<span style='color: red;'>Not a valid mob!</span>")
		return

	if(!istype(L, /mob/living/carbon/hellhound))
		to_chat(usr, "<span style='color: red;'>That's not a Hellhound.</span>")
		return

	if(L.stat == DEAD)  // DEAD
		to_chat(usr, "<span style='color: red;'>It's dead.</span>")
		return

	if(L.client) // Larva player is still online
		to_chat(usr, "<span style='color: red;'>That player is still connected.</span>")
		return

	if (alert(usr, "Everything checks out. Are you sure you want to transfer yourself into this hellhound?", "Confirmation", "Yes", "No") == "Yes")

		if(L.client || L.stat == DEAD) // Do it again, just in case
			to_chat(usr, "<span style='color: red;'>Oops. That mob can no longer be controlled. Sorry.</span>")
			return

		var/mob/ghostmob = usr.client.mob
		msg_admin_niche("[key_name(usr)] has joined as a [L].")
		L.ckey = usr.ckey
		if(L.client) L.client.change_view(world.view)

		if( isobserver(ghostmob) )
			qdel(ghostmob)
		spawn(15)
			to_chat(L, "<span style='font-weight: bold; color: red;'>Attention!! You are playing as a hellhound. You can get server banned if you are shitty so listen up!</span>")
			to_chat(L, "<span style='color: red;'>You MUST listen to and obey the Predator's commands at all times. Die if they demand it. Not following them is unthinkable to a hellhound.</span>")
			to_chat(L, "<span style='color: red;'>You are not here to go hog wild rambo. You're here to be part of something rare, a Predator hunt.</span>")
			to_chat(L, "<span style='color: red;'>The Predator players must follow a strict code of role-play and you are expected to as well.</span>")
			to_chat(L, "<span style='color: red;'>The Predators cannot understand your speech. They can only give you orders and expect you to follow them. They have a camera that allows them to see you remotely, so you are excellent for scouting missions.</span>")
			to_chat(L, "<span style='color: red;'>Hellhounds are fiercely protective of their masters and will never leave their side if under attack.</span>")
			to_chat(L, "<span style='color: red;'>Note that ANY Predator can give you orders. If they conflict, follow the latest one. If they dislike your performance they can ask for another ghost and everyone will mock you. So do a good job!</span>")
	return

/mob/dead/verb/join_as_yautja()
	set category = "Ghost"
	set name = "Join the Hunt"
	set desc = "If you are whitelisted, and it is the right type of round, join in."

	if (!client)
		return

	if(!ticker || ticker.current_state < GAME_STATE_PLAYING || !ticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(ticker.mode.check_predator_late_join(src))
		ticker.mode.attempt_to_join_as_predator(src)

/mob/dead/verb/drop_vote()
	set category = "Ghost"
	set name = "Spectator Vote"
	set desc = "If it's on Hunter Games gamemode, vote on who gets a supply drop!"

	if(!ticker || ticker.current_state < GAME_STATE_PLAYING || !ticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(!istype(ticker.mode,/datum/game_mode/huntergames))
		to_chat(src, SPAN_INFO("Wrong game mode. You have to be observing a Hunter Games round."))
		return

	if(!waiting_for_drop_votes)
		to_chat(src, SPAN_INFO("There's no drop vote currently in progress. Wait for a supply drop to be announced!"))
		return

	if(voted_this_drop)
		to_chat(src, SPAN_INFO("You voted for this one already. Only one please!"))
		return

	var/list/mobs = living_mob_list
	var/target = null

	for(var/mob/living/M in mobs)
		if(!istype(M,/mob/living/carbon/human) || M.stat || isYautja(M)) mobs -= M


	target = input("Please, select a contestant!", "Cake Time", null, null) as null|anything in mobs

	if (!target)//Make sure we actually have a target
		return
	else
		to_chat(src, SPAN_INFO("Your vote for [target] has been counted!"))
		ticker.mode:supply_votes += target
		voted_this_drop = 1
		spawn(200)
			voted_this_drop = 0
		return

/mob/dead/observer/verb/go_dnr()
	set category = "Ghost"
	set name = "Go DNR"
	set desc = "Prevent your character from being revived."

	if(alert("Do you want to go DNR?", "Choose to go DNR", "Yes", "No") == "Yes")
		can_reenter_corpse = FALSE

/mob/dead/observer/verb/edit_characters()
	set category = "Ghost"
	set name = "Edit Characters"
	set desc = "Edit your characters in your preferences."

	client.prefs.ShowChoices(src)

/mob/dead/observer/verb/view_stats()
	set category = "Ghost"
	set name = "View Statistics"
	set desc = "View global and player statistics tied to the game."

	if(client && client.player_entity)
		client.player_entity.show_statistics(src, round_statistics)

/mob/dead/observer/verb/view_kill_feed()
	set category = "Ghost"
	set name = "View Kill Feed"
	set desc = "View global kill statistics tied to the game."

	if(round_statistics)
		round_statistics.show_kill_feed(src)

/mob/dead/observer/verb/toggle_fast_ghost_move()
	set category = "Ghost"
	set name = "Toggle Observer Speed"
	set desc = "Switch between fast and regular ghost movement"

	m_intent ^= MOVE_INTENT_RUN | MOVE_INTENT_WALK //The one already active is turned off, the other is turned on
	to_chat(src, SPAN_NOTICE("Observer movement changed"))

/mob/dead/observer/Topic(href, href_list)
	..()
	if(href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
