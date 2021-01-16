#define MOVE_INTENT_WALK 1
#define MOVE_INTENT_RUN 2

/mob/dead
	var/voted_this_drop = 0
	can_block_movement = FALSE
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
	var/m_intent = MOVE_INTENT_WALK
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
	alpha = 127

/mob/dead/observer/New(mob/body)
	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	add_verb(src, /mob/dead/observer/proc/dead_tele)
	GLOB.observer_list += src

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
			icon = get_icon_from_source(CONFIG_GET(string/species_hunter))
			icon_state = "yautja_example"
			overlays += body.overlays
		else if(ismonkey(body))
			icon = 'icons/mob/humans/species/monkeys/monkey.dmi'
			icon_state = "monkey1"
			overlays += body.overlays
		else
			icon = body.icon
			icon_state = body.icon_state

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

	if(!T)	T = get_turf(pick(GLOB.latejoin))			//Safety in case we cannot find the body's position
	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	change_real_name(src, name)

	..()
	if(SSticker.mode && SSticker.mode.flags_round_type & MODE_PREDATOR)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, src, "<span style='color: red;'>This is a <B>PREDATOR ROUND</B>! If you are whitelisted, you may Join the Hunt!</span>"), 2 SECONDS)

/mob/dead/observer/Login()
	..()
	client.move_delay = MINIMAL_MOVEMENT_INTERVAL

/mob/dead/observer/Destroy()
	GLOB.observer_list -= src
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
	. = ..()
	if(.)
		return
	if(href_list["reentercorpse"])
		if(istype(usr, /mob/dead/observer))
			var/mob/dead/observer/A = usr
			A.reenter_corpse()
	if(href_list["track"])
		var/mob/target = locate(href_list["track"]) in GLOB.mob_list
		if(target)
			ManualFollow(target)
	if(href_list[XENO_OVERWATCH_TARGET_HREF])
		var/mob/target = locate(href_list[XENO_OVERWATCH_TARGET_HREF]) in GLOB.living_xeno_list
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

/mob/dead/observer/proc/set_huds_from_prefs()
	if(!client || !client.prefs)
		return

	var/datum/mob_hud/H
	HUD_toggled = client.prefs.observer_huds
	for(var/i in HUD_toggled)
		if(HUD_toggled[i])
			switch(i)
				if("Medical HUD")
					H = huds[MOB_HUD_MEDICAL_OBSERVER]
					H.add_hud_to(src)
				if("Security HUD")
					H = huds[MOB_HUD_SECURITY_ADVANCED]
					H.add_hud_to(src)
				if("Squad HUD")
					H = huds[MOB_HUD_SQUAD_OBSERVER]
					H.add_hud_to(src)
				if("Xeno Status HUD")
					H = huds[MOB_HUD_XENO_STATUS]
					H.add_hud_to(src)
				if("Faction UPP HUD")
					H = huds[MOB_HUD_FACTION_UPP]
					H.add_hud_to(src)
				if("Faction W-Y HUD")
					H = huds[MOB_HUD_FACTION_WY]
					H.add_hud_to(src)
				if("Faction RESS HUD")
					H = huds[MOB_HUD_FACTION_RESS]
					H.add_hud_to(src)
				if("Faction CLF HUD")
					H = huds[MOB_HUD_FACTION_CLF]
					H.add_hud_to(src)


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
	SStgui.on_transfer(src, ghost)
	if(is_admin_level(z))
		ghost.timeofdeath = 0 // Bypass respawn limit if you die on the admin zlevel

	ghost.key = key
	ghost.mind = mind

	if(ghost.mind)
		ghost.mind.current = ghost

	if(!can_reenter_corpse)
		away_timer = 300 //They'll never come back, so we can max out the timer right away.
		if(round_statistics)
			round_statistics.update_panel_data()
		track_death_calculations() //This needs to be done before mind is nullified
		if(ghost.mind)
			ghost.mind.original = ghost
	else if(ghost.mind && ghost.mind.player_entity) //Use else here because track_death_calculations() already calls this.
		ghost.mind.player_entity.update_panel_data(round_statistics)
		ghost.mind.original = src

	mind = null

	if(ghost.client)
		ghost.client.init_verbs()
		ghost.client.change_view(world_view_size) //reset view range to default
		ghost.client.pixel_x = 0 //recenters our view
		ghost.client.pixel_y = 0
		if(ghost.client.soundOutput)
			ghost.client.soundOutput.update_ambience()
			ghost.client.soundOutput.status_flags = 0 //Clear all effects that would affect a living mob
			ghost.client.soundOutput.apply_status()

		if(ghost.client.player_data)
			ghost.client.player_data.load_timestat_data()

	ghost.set_huds_from_prefs()

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
		if(ghost && !is_admin_level(z))
			ghost.timeofdeath = world.time

/mob/dead/observer/Move(NewLoc, direct)
	following = null
	setDir(direct)
	var/area/last_area = get_area(loc)
	if(NewLoc)
		for(var/obj/effect/step_trigger/S in NewLoc)
			S.Crossed(src)

	forceMove(get_turf(src) )//Get out of closets and such as a ghost
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

/mob/dead/observer/verb/reenter_corpse()
	set category = "Ghost.Body"
	set name = "Re-enter Corpse"

	if(!client)
		return

	if(!mind || !mind.original || QDELETED(mind.original) || !can_reenter_corpse)
		to_chat(src, "<span style='color: red;'>You have no body.</span>")
		return

	if(mind.original.key && copytext(mind.original.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(src, "<span style='color: red;'>Another consciousness is in your body...It is resisting you.</span>")
		return

	mind.transfer_to(mind.original, TRUE)
	SStgui.on_transfer(src, mind.current)
	qdel(src)
	return TRUE

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"

	if(!istype(usr, /mob/dead/observer))
		to_chat(src, "<span style='color: red;'>Not when you're not dead!</span>")
		return

	var/area/thearea = tgui_input_list(usr, "Area to jump to", "BOOYEA", GLOB.sorted_areas)
	if(!thearea)	return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(src, "<span style='color: red;'>No area available.</span>")
		return

	usr.loc = pick(L)
	following = null

/mob/dead/observer/verb/follow_local(var/mob/target)
	set category = "Ghost.Follow"
	set name = "Follow Local Mob"
	set desc = "Follow on-screen mob"

	ManualFollow(target)
	return

/mob/dead/observer/verb/follow()
	set category = "Ghost.Follow"
	set name = "Follow"

	var/list/choices = list("Humans", "Xenomorphs", "Holograms", "Predators", "Synthetics", "ERT Members", "Survivors", "Any Mobs", "Mobs by Faction", "Xenos by Hive", "Vehicles")
	var/input = tgui_input_list(usr, "Please, select a category:", "Follow", choices)
	if(!input)
		return
	var/atom/movable/target
	var/list/targets = list()
	switch(input)
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
			targets = get_multi_vehicles()

		if("Holograms")
			targets = get_holograms()

		if("Mobs by Faction")
			choices = FACTION_LIST_HUMANOID
			input = tgui_input_list(usr, "Please, select a Faction:", "Follow", choices)

			targets = gethumans()
			for(var/name in targets)
				var/mob/living/carbon/human/M = targets[name]
				if(!istype(M) || M.faction != input)
					targets.Remove(name)

		if("Xenos by Hive")
			var/hives = list()

			for(var/datum/hive_status/hive in GLOB.hive_datum)
				hives += list("[hive.name]" = hive.hivenumber)

			input = tgui_input_list(usr, "Please, select a Hive:", "Follow", hives)
			if(!input)
				return

			targets = getxenos()
			for(var/name in targets)
				var/mob/living/carbon/Xenomorph/X = targets[name]
				if(!istype(X) || X.hivenumber != hives[input])
					targets.Remove(name)

	if(!LAZYLEN(targets))
		to_chat(usr, SPAN_WARNING("There aren't any targets in [input] category to follow."))
		return
	input = tgui_input_list(usr, "Please select a target among [input] to follow", "Follow", targets)
	target = targets[input]

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
					forceMove(T)
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
		target = tgui_input_list(usr, "Please, select a player!", "Jump to Mob", dest)

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.forceMove(T)
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
	set category = "Ghost.Settings"

	if(client)
		if(client.view != world_view_size)
			client.change_view(world_view_size)
		else
			client.change_view(14)


/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost.Settings"

	if (see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/dead/observer/verb/toggle_self_visibility()
	set name = "Toggle Self Visibility"
	set category = "Ghost.Settings"

	if (alpha)
		alpha = 0
	else
		alpha = initial(alpha)

/mob/dead/observer/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "Ghost.View"

	var/dat = GLOB.data_core.get_manifest()

	show_browser(src, dat, "Crew Manifest", "manifest", "size=450x750")

/mob/dead/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of the hive."
	set category = "Ghost.View"

	var/list/hives = list()
	var/datum/hive_status/last_hive_checked

	for(var/datum/hive_status/hive in GLOB.hive_datum)
		if(hive.totalXenos.len > 0)
			hives += list("[hive.name]" = hive.hivenumber)
			last_hive_checked = hive

	if(!hives.len)
		to_chat(src, SPAN_ALERT("There seem to be no living hives at the moment"))
		return
	else if(hives.len == 1) // Only one hive, don't need an input menu for that
		last_hive_checked.hive_ui.open_hive_status(src)
	else
		faction = tgui_input_list(src, "Select which hive status menu to open up", "Hive Choice", hives)
		if(!faction)
			to_chat(src, SPAN_ALERT("Hive choice error. Aborting."))
			return

		GLOB.hive_datum[hives[faction]].hive_ui.open_hive_status(src)

/mob/dead/verb/join_as_alien()
	set category = "Ghost.Join"
	set name = "Join as Xeno"
	set desc = "Select an alive but logged-out Xenomorph to rejoin the game."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_xeno_late_join(src))
		SSticker.mode.attempt_to_join_as_xeno(src)

/mob/dead/verb/join_as_zombie() //Adapted from join as hellhoud
	set category = "Ghost.Join"
	set name = "Join as Zombie"
	set desc = "Select an alive but logged-out Zombie to rejoin the game."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	var/list/zombie_list = list()

	for(var/mob/living/carbon/human/A in GLOB.zombie_list)
		if(!A.client && A.stat != DEAD) // Only living zombies
			zombie_list += list(A.real_name = A)


	if(zombie_list.len == 0)
		to_chat(src, SPAN_DANGER("There are no available zombies."))
		return

	var/choice = tgui_input_list(usr, "Pick a Zombie:", "Join as Zombie", zombie_list)
	if(!choice)
		return

	if(!client)
		return

	var/mob/living/carbon/human/Z = zombie_list[choice]

	if(!Z || !mind)
		return

	if(QDELETED(Z)) //should never occur,just to be sure.
		return

	if(Z.stat == DEAD)
		to_chat(src, SPAN_WARNING("This zombie is dead!"))
		return

	if(Z.client)
		to_chat(src, SPAN_WARNING("That player is still connected."))
		return

	mind.transfer_to(Z, TRUE)
	msg_admin_niche("[key_name(usr)] has joined as a [Z].")


/mob/dead/verb/join_as_freed_mob()
	set category = "Ghost.Join"
	set name = "Join as Freed Mob"
	set desc = "Select a freed mob by staff."

	var/mob/M = src
	if(!M.stat || !M.mind)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	var/choice = tgui_input_list(usr, "Pick a Freed Mob:", "Join as Freed Mob", GLOB.freed_mob_list)
	if(!choice || choice == "Cancel")
		return

	var/mob/living/L = choice
	if(!istype(L))
		return

	if(QDELETED(L) || L.client)
		GLOB.freed_mob_list -= L
		to_chat(src, SPAN_WARNING("Something went wrong."))
		return

	GLOB.freed_mob_list -= L
	M.mind.transfer_to(L, TRUE)

/mob/dead/verb/join_as_hellhound()
	set category = "Ghost.Join"
	set name = "Join as Hellhound"
	set desc = "Select an alive and available Hellhound. THIS COMES WITH STRICT RULES. READ THEM OR GET BANNED."

	var/mob/L = src

	if(SSticker.current_state < GAME_STATE_PLAYING)
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

	for(var/mob/living/carbon/hellhound/A in GLOB.hellhound_list)
		if(istype(A) && !A.client)
			hellhound_list += A.real_name

	if(hellhound_list.len == 0)
		to_chat(usr, "<span style='color: red;'>There aren't any available Hellhounds.</span>")
		return

	var/choice = tgui_input_list(usr, "Pick a Hellhound:", "Join as Hellhound", hellhound_list)
	if (isnull(choice) || choice == "Cancel")
		return

	for(var/mob/living/carbon/hellhound/X in GLOB.hellhound_list)
		if(choice == X.real_name)
			L = X
			break

	if(!L || QDELETED(L))
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
		if(L.client) L.client.change_view(world_view_size)

		if( isobserver(ghostmob) )
			qdel(ghostmob)

/mob/dead/verb/join_as_yautja()
	set category = "Ghost.Join"
	set name = "Join the Hunt"
	set desc = "If you are whitelisted, and it is the right type of round, join in."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_predator_late_join(src))
		SSticker.mode.attempt_to_join_as_predator(src)

/mob/dead/verb/drop_vote()
	set category = "Ghost"
	set name = "Spectator Vote"
	set desc = "If it's on Hunter Games gamemode, vote on who gets a supply drop!"

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(!istype(SSticker.mode,/datum/game_mode/huntergames))
		to_chat(src, SPAN_INFO("Wrong game mode. You have to be observing a Hunter Games round."))
		return

	if(!waiting_for_drop_votes)
		to_chat(src, SPAN_INFO("There's no drop vote currently in progress. Wait for a supply drop to be announced!"))
		return

	if(voted_this_drop)
		to_chat(src, SPAN_INFO("You voted for this one already. Only one please!"))
		return

	var/list/mobs = GLOB.alive_mob_list
	var/target = null

	for(var/mob/living/M in mobs)
		if(!istype(M,/mob/living/carbon/human) || M.stat || isYautja(M)) mobs -= M


	target = tgui_input_list(usr, "Please, select a contestant!", "Cake Time", mobs)

	if (!target)//Make sure we actually have a target
		return
	else
		to_chat(src, SPAN_INFO("Your vote for [target] has been counted!"))
		SSticker.mode:supply_votes += target
		voted_this_drop = 1
		addtimer(VARSET_CALLBACK(src, voted_this_drop, FALSE), 20 SECONDS)

/mob/dead/observer/verb/go_dnr()
	set category = "Ghost.Body"
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
	set category = "Ghost.View"
	set name = "View Playtimes"
	set desc = "View your playtimes."

	if(client && client.player_entity)
		client.player_data.ui_interact(src)

/mob/dead/observer/verb/view_kill_feed()
	set category = "Ghost.View"
	set name = "View Kill Feed"
	set desc = "View global kill statistics tied to the game."

	if(round_statistics)
		round_statistics.show_kill_feed(src)

/mob/dead/observer/verb/toggle_fast_ghost_move()
	set category = "Ghost.Settings"
	set name = "Toggle Observer Speed"
	set desc = "Switch between fast and regular ghost movement"

	m_intent ^= MOVE_INTENT_RUN | MOVE_INTENT_WALK //The one already active is turned off, the other is turned on
	to_chat(src, SPAN_NOTICE("Observer movement changed"))

/mob/dead/observer/Topic(href, href_list)
	..()
	if(href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)

/mob/dead/observer/get_status_tab_items()
	. = ..()
	. += ""
	. += "Game Mode: [GLOB.master_mode]"

	if(SSticker.HasRoundStarted())
		return

	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		. += "Time To Start: [round(time_remaining)]s"
	else if(time_remaining == -10)
		. += "Time To Start: DELAYED"
	else
		. += "Time To Start: SOON"

	. += "Players: [SSticker.totalPlayers]"
	if(client.admin_holder)
		. += "Players Ready: [SSticker.totalPlayersReady]"
	. += "DEFCON Level: [defcon_controller.current_defcon_level]"

	if(EvacuationAuthority)
		var/eta_status = EvacuationAuthority.get_status_panel_eta()
		if(eta_status)
			. += eta_status

#undef MOVE_INTENT_WALK
#undef MOVE_INTENT_RUN
