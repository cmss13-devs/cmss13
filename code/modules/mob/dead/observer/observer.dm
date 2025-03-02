/mob/dead
	var/voted_this_drop = 0
	can_block_movement = FALSE
	recalculate_move_delay = FALSE

/mob/dead/forceMove(atom/destination)
	var/turf/old_turf = get_turf(src)
	var/turf/new_turf = get_turf(destination)
	if (old_turf?.z != new_turf?.z)
		onTransitZ(old_turf?.z, new_turf?.z)
	var/oldloc = loc
	loc = destination
	Moved(oldloc, NONE, TRUE)

/mob/dead/abstract_move(atom/destination)
	var/turf/old_turf = get_turf(src)
	var/turf/new_turf = get_turf(destination)
	if (old_turf?.z != new_turf?.z)
		onTransitZ(old_turf?.z, new_turf?.z)
	return ..()

/mob/dead/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	density = FALSE
	blinded = FALSE
	anchored = TRUE //  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	plane = GHOST_PLANE
	layer = ABOVE_FLY_LAYER
	stat = DEAD
	mob_flags = KNOWS_TECHNOLOGY

	/// If the observer is an admin, are they excluded from the xeno queue?
	var/admin_larva_protection = TRUE // Enabled by default
	var/ghostvision = TRUE
	var/self_visibility = TRUE
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
	universal_speak = TRUE
	var/updatedir = TRUE //Do we have to update our dir as the ghost moves around?
	var/atom/movable/following = null
	var/datum/orbit_menu/orbit_menu
	/// The target mob that the ghost is observing.
	var/mob/observe_target_mob = null
	/// The target client that the ghost is observing.
	var/client/observe_target_client = null
	var/datum/health_scan/last_health_display
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/own_orbit_size = 0
	var/observer_actions = list(/datum/action/observer_action/join_xeno, /datum/action/observer_action/join_lesser_drone)
	var/datum/action/minimap/observer/minimap
	///The last message for this player with their larva queue information
	var/larva_queue_cached_message
	///Used to bypass time of death checks such as when being selected for larva
	var/bypass_time_of_death_checks = FALSE
	///Used to bypass time of death checks for a successful hug
	var/bypass_time_of_death_checks_hugger = FALSE

	alpha = 127

/mob/dead/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost.Settings"
	ghostvision = !ghostvision
	if(ghostvision)
		see_invisible = INVISIBILITY_OBSERVER
	else
		see_invisible = HIDE_INVISIBLE_OBSERVER
	to_chat(usr, SPAN_NOTICE("You [(ghostvision?"now":"no longer")] have ghost vision."))

/mob/dead/observer/Initialize(mapload, mob/body)
	. = ..()

	GLOB.observer_list += src

	// Ghosts don't move, they teleport via a special case in mob code
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_INHERENT)

	var/turf/spawn_turf
	if(ismob(body))
		spawn_turf = get_turf(body) //Where is the body located?
		attack_log = body.attack_log //preserve our attack logs by copying them to our ghost
		life_kills_total = body.life_kills_total //kills also copy over

		appearance = body.appearance
		underlays.Cut()
		base_transform = matrix(body.base_transform)
		body.alter_ghost(src)
		apply_transform(matrix())

		own_orbit_size = body.get_orbit_size()

		desc = initial(desc)

		alpha = 127
		invisibility = INVISIBILITY_OBSERVER
		plane = GHOST_PLANE
		layer = ABOVE_FLY_LAYER
		mouse_opacity = MOUSE_OPACITY_ICON // In case we were weed_food

		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
		see_invisible = INVISIBILITY_OBSERVER
		see_in_dark = 100

		mind = body.mind //we don't transfer the mind but we keep a reference to it.

	if(!own_orbit_size)
		own_orbit_size = 32

	if(!isturf(spawn_turf))
		spawn_turf = get_turf(SAFEPICK(GLOB.latejoin)) //Safety in case we cannot find the body's position
	if(spawn_turf)
		forceMove(spawn_turf)

	if(!name) //To prevent nameless ghosts
		name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	if(name == "Unknown")
		if(body)
			name = body.real_name
	change_real_name(src, name)

	//To prevent weirdly offset ghosts.
	if(ishuman(body))
		pixel_x = 0
		pixel_y = 0

	minimap = new
	minimap.give_to(src)

	for(var/path in subtypesof(/datum/action/observer_action))
		var/datum/action/observer_action/new_action = new path()
		new_action.give_to(src)

	if(SSticker.mode && SSticker.mode.flags_round_type & MODE_PREDATOR)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), src, "<span style='color: red;'>This is a <B>PREDATOR ROUND</B>! If you are whitelisted, you may Join the Hunt!</span>"), 2 SECONDS)

	verbs -= /mob/verb/pickup_item
	verbs -= /mob/verb/pull_item

/mob/dead/observer/proc/set_lighting_alpha_from_pref(client/ghost_client)
	var/vision_level = ghost_client?.prefs?.ghost_vision_pref
	switch(vision_level)
		if(GHOST_VISION_LEVEL_NO_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		if(GHOST_VISION_LEVEL_MID_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
		if(GHOST_VISION_LEVEL_HIGH_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if(GHOST_VISION_LEVEL_FULL_NVG)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	update_sight()

/// Removes all signals and data related to the observe target and resets observer's HUD/eye
/mob/dead/observer/proc/clean_observe_target()
	SIGNAL_HANDLER

	UnregisterSignal(observe_target_mob, COMSIG_PARENT_QDELETING)
	UnregisterSignal(observe_target_mob, COMSIG_MOB_GHOSTIZE)
	UnregisterSignal(observe_target_mob, COMSIG_MOB_NEW_MIND)
	UnregisterSignal(observe_target_mob, COMSIG_MOB_LOGIN)

	if(observe_target_client)
		UnregisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_ADD)
		UnregisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_REMOVE)

	if(observe_target_mob?.observers)
		observe_target_mob.observers -= src
		UNSETEMPTY(observe_target_mob.observers)

	observe_target_mob = null
	observe_target_client = null

	client.eye = src
	hud_used.show_hud(hud_used.hud_version, src)
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)

/// When the observer moves we disconnect from the observe target if we aren't on the same turf
/mob/dead/observer/proc/observer_move_react()
	SIGNAL_HANDLER

	if(loc == get_turf(observe_target_mob))
		return
	clean_observe_target()

/// When the observer target gets a screen, our observer gets a screen minus some game screens we don't want the observer to touch
/mob/dead/observer/proc/observe_target_screen_add(observe_target_mob_client, screen_add)
	SIGNAL_HANDLER

	var/static/list/excluded_types = typecacheof(list(
		/atom/movable/screen/fullscreen,
		/atom/movable/screen/click_catcher,
		/atom/movable/screen/escape_menu,
		/atom/movable/screen/buildmode,
		/obj/effect/detector_blip,
	))

	if(!client)
		return

	// `screen_add` can sometimes be a list, so it's safest to just handle everything as one.
	var/list/stuff_to_add = (islist(screen_add) ? screen_add : list(screen_add))

	for(var/item in stuff_to_add)
		// Ignore anything that's in `excluded_types`.
		if(is_type_in_typecache(item, excluded_types))
			continue

		client.add_to_screen(screen_add)

/// When the observer target loses a screen, our observer loses it as well
/mob/dead/observer/proc/observe_target_screen_remove(observe_target_mob_client, screen_remove)
	SIGNAL_HANDLER

	if(!client)
		return

	client.remove_from_screen(screen_remove)

/// When the observe target ghosts our observer disconnect from their screen updates
/mob/dead/observer/proc/observe_target_ghosting(mob/observer_target_mob)
	SIGNAL_HANDLER

	if(observe_target_client) //Should never not have one if ghostizing but maaaybe?
		UnregisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_ADD)
		UnregisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_REMOVE)

/// When the observe target gets a new mind our observer connects to the new client's screens
/mob/dead/observer/proc/observe_target_new_mind(mob/living/new_character, client/new_client)
	SIGNAL_HANDLER

	if(observe_target_client != new_client)
		observe_target_client = new_client

	// Override the signal from any previous targets.
	RegisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_ADD, PROC_REF(observe_target_screen_add), TRUE)
	RegisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_REMOVE, PROC_REF(observe_target_screen_remove), TRUE)

/// When the observe target logs in our observer connect to the new client
/mob/dead/observer/proc/observe_target_login(mob/living/new_character)
	SIGNAL_HANDLER

	if(observe_target_client != new_character.client)
		observe_target_client = new_character.client

	// Override the signal from any previous targets.
	RegisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_ADD, PROC_REF(observe_target_screen_add), TRUE)
	RegisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_REMOVE, PROC_REF(observe_target_screen_remove), TRUE)

///makes the ghost see the target hud and sets the eye at the target.
/mob/dead/observer/proc/do_observe(atom/movable/target)
	if(!client || !target || !istype(target))
		return

	ManualFollow(target)
	reset_perspective()

	if(!iscarbon(target) || !client.prefs?.auto_observe)
		return
	var/mob/living/carbon/carbon_target = target
	if(!carbon_target.hud_used)
		return

	client.clear_screen()
	client.eye = carbon_target
	observe_target_mob = carbon_target

	carbon_target.auto_observed(src)

	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(observer_move_react))
	RegisterSignal(observe_target_mob, COMSIG_PARENT_QDELETING, PROC_REF(clean_observe_target))
	RegisterSignal(observe_target_mob, COMSIG_MOB_GHOSTIZE, PROC_REF(observe_target_ghosting))
	RegisterSignal(observe_target_mob, COMSIG_MOB_NEW_MIND, PROC_REF(observe_target_new_mind))
	RegisterSignal(observe_target_mob, COMSIG_MOB_LOGIN, PROC_REF(observe_target_login))

	if(observe_target_mob.client)
		observe_target_client = observe_target_mob.client
		RegisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_ADD, PROC_REF(observe_target_screen_add))
		RegisterSignal(observe_target_client, COMSIG_CLIENT_SCREEN_REMOVE, PROC_REF(observe_target_screen_remove))

/mob/dead/observer/reset_perspective(atom/A)
	if(observe_target_mob)
		clean_observe_target()
	. = ..()

	if(!.)
		return

	if(!hud_used)
		return

	client.clear_screen()
	hud_used.show_hud(hud_used.hud_version)

/mob/dead/observer/Login()
	..() // This calls signals which might have resulted in our client getting deleted

	if(!client)
		return

	if(client.check_whitelist_status(WHITELIST_PREDATOR))
		RegisterSignal(SSdcs, COMSIG_GLOB_PREDATOR_ROUND_TOGGLED, PROC_REF(toggle_predator_action))
		toggle_predator_action()

	client.move_delay = MINIMAL_MOVEMENT_INTERVAL

	if(observe_target_mob)
		clean_observe_target()

	set_huds_from_prefs()

/mob/dead/observer/Destroy(force)
	GLOB.observer_list -= src
	QDEL_NULL(orbit_menu)
	QDEL_NULL(last_health_display)
	QDEL_NULL(minimap)
	following = null
	observe_target_mob = null
	observe_target_client = null
	return ..()

/mob/dead/observer/MouseDrop(atom/A)
	if(!usr || !A)
		return
	if(isobserver(usr) && usr.client && isliving(A))
		var/mob/living/M = A
		usr.client.cmd_admin_ghostchange(M, src)
	else
		return ..()


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
		if(!target)
			return
		do_observe(target)

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
	if(href_list["joinresponseteam"])
		JoinResponseTeam()
	if(href_list["claim_freed"])
		handle_joining_as_freed_mob(locate(href_list["claim_freed"]))
	if(href_list["join_xeno"])
		join_as_alien()
	if(href_list[NOTIFY_USCM_TACMAP])
		GLOB.uscm_tacmap_status.tgui_interact(src)
	if(href_list[NOTIFY_XENO_TACMAP])
		GLOB.xeno_tacmap_status.tgui_interact(src)

/mob/dead/observer/proc/set_huds_from_prefs()
	if(!client || !client.prefs)
		return

	var/datum/mob_hud/the_hud
	HUD_toggled = client.prefs.observer_huds
	for(var/i in HUD_toggled)
		if(HUD_toggled[i])
			switch(i)
				if("Medical HUD")
					the_hud = GLOB.huds[MOB_HUD_MEDICAL_OBSERVER]
					the_hud.add_hud_to(src, src)
				if("Security HUD")
					the_hud= GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
					the_hud.add_hud_to(src, src)
				if("Squad HUD")
					the_hud= GLOB.huds[MOB_HUD_FACTION_OBSERVER]
					the_hud.add_hud_to(src, src)
				if("Xeno Status HUD")
					the_hud= GLOB.huds[MOB_HUD_XENO_STATUS]
					the_hud.add_hud_to(src, src)
				if("Faction UPP HUD")
					the_hud= GLOB.huds[MOB_HUD_FACTION_UPP]
					the_hud.add_hud_to(src, src)
				if("Faction Wey-Yu HUD")
					the_hud= GLOB.huds[MOB_HUD_FACTION_WY]
					the_hud.add_hud_to(src, src)
				if("Faction TWE HUD")
					the_hud= GLOB.huds[MOB_HUD_FACTION_TWE]
					the_hud.add_hud_to(src, src)
				if("Faction CLF HUD")
					the_hud= GLOB.huds[MOB_HUD_FACTION_CLF]
					the_hud.add_hud_to(src, src)
				if(HUD_MENTOR_SIGHT)
					the_hud= GLOB.huds[MOB_HUD_NEW_PLAYER]
					the_hud.add_hud_to(src, src)

	see_invisible = INVISIBILITY_OBSERVER

	if(client.prefs.toggles_ghost & GHOST_HEALTH_SCAN)
		add_verb(src, /mob/dead/observer/proc/scan_health)
	else
		remove_verb(src, /mob/dead/observer/proc/scan_health)


/mob/dead/BlockedPassDirs(atom/movable/mover, target_dir)
	return NO_BLOCKED_MOVEMENT
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/dead/observer/Life(delta_time)
	..()
	if(!loc)
		return
	if(!client)
		return 0

	return TRUE

/mob/dead/observer/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud/ghost(src)

/mob/proc/ghostize(can_reenter_corpse = TRUE, aghosted = FALSE)
	if(isaghost(src) || !key)
		return
	if(aghosted)
		src.aghosted = TRUE

	SEND_SIGNAL(src, COMSIG_MOB_GHOSTIZE)

	var/mob/dead/observer/ghost = new(loc, src) //Transfer safety to observer spawning proc.
	ghost.can_reenter_corpse = can_reenter_corpse
	ghost.timeofdeath = timeofdeath //BS12 EDIT

	// Carryover langchat settings since we kept the icon
	ghost.langchat_height = langchat_height
	ghost.icon_size = icon_size
	ghost.langchat_image = null
	ghost.langchat_make_image()

	SStgui.on_transfer(src, ghost)
	if(should_block_game_interaction(src)) // Gibbed humans ghostize the brain in their head which itself is z 0
		ghost.timeofdeath = 1 // Bypass respawn limit if you die on the admin zlevel

	ghost.key = key
	ghost.mind = mind

	if(ghost.mind)
		ghost.mind.current = ghost

	if(!can_reenter_corpse)
		away_timer = 300 //They'll never come back, so we can max out the timer right away.
		if(GLOB.round_statistics)
			GLOB.round_statistics.update_panel_data()
		track_death_calculations() //This needs to be done before mind is nullified
		if(ghost.mind)
			ghost.mind.original = ghost
	else if(ghost.mind && ghost.mind.player_entity) //Use else here because track_death_calculations() already calls this.
		ghost.mind.player_entity.update_panel_data(GLOB.round_statistics)
		ghost.mind.original = src

	mind = null

	// Larva queue: We use the larger of their existing queue time or the new timeofdeath except for facehuggers or lesser drone
	var/exempt_tod = isfacehugger(src) || islesserdrone(src) || should_block_game_interaction(src, include_hunting_grounds=TRUE)
	var/new_tod = exempt_tod ? 1 : ghost.timeofdeath

	// if they died as facehugger or lesser drone, bypass typical TOD checks
	ghost.bypass_time_of_death_checks = (isfacehugger(src) || islesserdrone(src))

	if(ghost.client)
		ghost.client.init_verbs()
		ghost.client.change_view(GLOB.world_view_size) //reset view range to default
		ghost.client.pixel_x = 0 //recenters our view
		ghost.client.pixel_y = 0
		ghost.set_lighting_alpha_from_pref(ghost.client)
		if(ghost.client.soundOutput)
			ghost.client.soundOutput.update_ambience()
			ghost.client.soundOutput.status_flags = 0 //Clear all effects that would affect a living mob
			ghost.client.soundOutput.apply_status()

		if(ghost.client.player_data)
			ghost.client.player_data.load_timestat_data()

	if(ghost.client?.player_details)
		ghost.client.player_details.larva_queue_time = max(ghost.client.player_details.larva_queue_time, new_tod)
	else if(persistent_ckey)
		var/datum/player_details/details = GLOB.player_details[persistent_ckey]
		if(details)
			details.larva_queue_time = max(details.larva_queue_time, new_tod)

	ghost.set_huds_from_prefs()

	return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	do_ghost()

/mob/living/proc/do_ghost()
	if(stat == DEAD)
		if(mind && mind.player_entity)
			mind.player_entity.update_panel_data(GLOB.round_statistics)
		ghostize(TRUE)
	else
		var/list/options = list("Ghost", "Stay in body")
		if(check_other_rights(client, R_MOD, FALSE))
			options = list("Aghost") + options
		var/text_prompt = "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to return to your body. You can't change your mind so choose wisely!)"
		var/is_nested = (buckled && istype(buckled, /obj/structure/bed/nest)) ? TRUE : FALSE
		var/obj/structure/bed/nest/nest = FALSE
		if(is_nested)
			text_prompt += "\nSince you're nested, you will get a chance to reenter your body if freed."
			nest = buckled
		var/response = tgui_alert(src, text_prompt, "Are you sure you want to ghost?", options)
		if(response == "Aghost")
			client.admin_ghost()
			return
		if(response != "Ghost")
			return //didn't want to ghost after-all
		AdjustSleeping(2) // Sleep so you will be properly recognized as ghosted
		var/turf/location = get_turf(src)
		if(location) //to avoid runtime when a mob ends up in nullspace
			msg_admin_niche("[key_name_admin(client)] has ghosted. [ADMIN_JMP(location)]")
		log_game("[key_name_admin(client)] has ghosted.")
		var/mob/dead/observer/ghost = ghostize((is_nested && nest && !QDELETED(nest))) //FALSE parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		SEND_SIGNAL(src, COMSIG_LIVING_GHOSTED, ghost)
		if(ghost && !should_block_game_interaction(src, include_hunting_grounds=TRUE))
			ghost.timeofdeath = world.time

			// Larva queue: We use the larger of their existing queue time or the new timeofdeath except for facehuggers or lesser drone
			var/new_tod = (isfacehugger(src) || islesserdrone(src)) ? 1 : ghost.timeofdeath

			// if they died as facehugger or lesser drone, bypass typical TOD checks
			ghost.bypass_time_of_death_checks = (isfacehugger(src) || islesserdrone(src))

			if(ghost.client)
				ghost.client.player_details.larva_queue_time = max(ghost.client.player_details.larva_queue_time, new_tod)
			else if(persistent_ckey)
				var/datum/player_details/details = GLOB.player_details[persistent_ckey]
				if(details)
					details.larva_queue_time = max(details.larva_queue_time, new_tod)

		if(is_nested && nest && !QDELETED(nest))
			ghost.can_reenter_corpse = FALSE
			nest.ghost_of_buckled_mob = ghost

/mob/dead/observer/Move(atom/newloc, direct)
	following = null
	var/area/last_area = get_area(loc)
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own

	if(newloc)
		abstract_move(newloc)
	else
		abstract_move(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

	var/turf/new_turf = locate(x, y, z)
	if(!new_turf)
		return

	var/area/new_area = new_turf.loc

	if((new_area != last_area) && new_area)
		new_area.Entered(src)
		if(last_area)
			last_area.Exited(src)

	for(var/obj/effect/step_trigger/S in new_turf) //<-- this is dumb
		S.Crossed(src)

	// CRUTCH because ghost don't respect normal movement rules
	SEND_SIGNAL(new_turf, COMSIG_TURF_ENTERED, src)
	SEND_SIGNAL(src, COMSIG_GHOST_MOVED, new_turf)

/mob/dead/observer/get_examine_text(mob/user)
	return list(desc)

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

	if(mind.original.key && copytext(mind.original.key,1,2)!="@") //makes sure we don't accidentally kick any clients
		to_chat(src, "<span style='color: red;'>Another consciousness is in your body...It is resisting you.</span>")
		return

	mind.transfer_to(mind.original, TRUE)
	qdel(src)
	return TRUE

/mob/dead/observer/verb/enter_tech_tree()
	set category = "Ghost"
	set name = "Teleport to Techtree"

	var/list/trees = list()

	for(var/T in SStechtree.trees)
		trees += list("[T]" = SStechtree.trees[T])

	var/value = SStechtree.trees[1]

	if(length(trees) > 1)
		value = tgui_input_list(src, "Choose which tree to enter", "Enter Tree", trees)

	if(!value)
		return

	var/datum/techtree/tree = trees[value]

	forceMove(tree.entrance)

/mob/dead/observer/verb/teleport_z_up()
	set category = "Ghost.Movement"
	set name = "Move Up"
	set desc = "Move up a z level"

	var/turf/above = SSmapping.get_turf_above(get_turf(src))

	if(above)
		usr.forceMove(above)

/mob/dead/observer/verb/teleport_z_down()
	set category = "Ghost.Movement"
	set name = "Move Down"
	set desc = "Move down a z level"

	var/turf/below = SSmapping.get_turf_below(get_turf(src))

	if(below)
		usr.forceMove(below)

/mob/dead/observer/verb/dead_teleport_area()
	set category = "Ghost"
	set name = "Teleport to Area"
	set desc= "Teleport to a location"

	if(!istype(usr, /mob/dead/observer))
		to_chat(src, "<span style='color: red;'>Not when you're not dead!</span>")
		return

	var/area/thearea = tgui_input_list(usr, "Area to jump to", "BOOYEA", return_sorted_areas())
	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!LAZYLEN(L))
		to_chat(src, "<span style='color: red;'>No area available.</span>")
		return

	usr.forceMove(pick(L))
	following = null

/mob/dead/observer/proc/scan_health(mob/living/target in GLOB.living_mob_list)
	set name = "Scan Health"

	if(!istype(target))
		return

	if(check_client_rights(client, R_MOD, FALSE))
		view_health_scan(target)
		return

	if(!mind.original)
		view_health_scan(target)
		return

	if(!ishuman(mind.original))
		view_health_scan(target)
		return

	var/mob/living/carbon/human/original_human = mind.original

	if((original_human.stat == DEAD && !original_human.check_tod() || !original_human.is_revivable()) || !can_reenter_corpse)
		view_health_scan(target)
		return

	to_chat(src, SPAN_NOTICE("You must be permanently unrevivable or unable to reenter your body to use the scan health verb."))

/mob/dead/observer/proc/view_health_scan(mob/living/target)
	if (!last_health_display)
		last_health_display = new(target)
	else
		last_health_display.target_mob = target
	last_health_display.look_at(src, DETAIL_LEVEL_FULL, bypass_checks = TRUE)

/mob/dead/observer/verb/follow_local(mob/target in GLOB.mob_list)
	set category = "Ghost.Follow"
	set name = "Follow Local Mob"
	set desc = "Follow on-screen mob"

	do_observe(target)

/mob/dead/observer/verb/follow()
	set category = "Ghost.Follow"
	set name = "Follow"

	if(!orbit_menu)
		orbit_menu = new(src)
	orbit_menu.tgui_interact(src)

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if(!istype(target))
		return

	var/orbitsize = target.get_orbit_size()
	orbitsize -= (orbitsize / world.icon_size) * (world.icon_size * 0.25)

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36

	orbit(target, orbitsize, FALSE, 20, rot_seg)

/mob/dead/observer/get_orbit_size()
	return own_orbit_size

/mob/dead/observer/orbit()
	setDir(SOUTH)//reset dir so the right directional sprites show up //might tweak this for xenos, stan_albatross orbitshit
	return ..()


/mob/dead/observer/stop_orbit(datum/component/orbiter/orbits)
	. = ..()
	pixel_y = -2
	animate(src, pixel_y = 0, time = 10, loop = -1)

/mob/dead/observer/proc/JumpToCoord(tx, ty, tz)
	if(!tx || !ty || !tz)
		return
	following = null
	forceMove(locate(tx, ty, tz))

/mob/dead/observer/verb/dead_teleport_mob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Teleport to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/dead/observer)) //Make sure they're an observer!


		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null    //Chosen target.

		dest += getmobs() //Fill list, prompt user with list
		target = tgui_input_list(usr, "Please, select a player!", "Jump to Mob", dest)

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src  //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T)) //Make sure the turf exists, then move the source to that destination.
				A.forceMove(T)
				following = null
			else
				to_chat(A, "<span style='color: red;'>This mob is not located in the game world.</span>")

/mob/dead/observer/memory()
	set hidden = TRUE
	to_chat(src, "<span style='color: red;'>You are dead! You have no mind to store memory!</span>")

/mob/dead/observer/add_memory()
	set hidden = TRUE
	to_chat(src, "<span style='color: red;'>You are dead! You have no mind to store memory!</span>")

/mob/dead/observer/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/dead/observer))
		return

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
		// Check the current zoom level and toggle to the next level cyclically
		if (client.view == GLOB.world_view_size)
			client.change_view(14)
		else if (client.view == 14)
			client.change_view(28)
		else
			client.change_view(GLOB.world_view_size)


/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost.Settings"

	var/level_message
	switch(lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
			level_message = "half night vision"
			src?.client?.prefs?.ghost_vision_pref = GHOST_VISION_LEVEL_MID_NVG
		if(LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
			level_message = "three quarters night vision"
			src?.client?.prefs?.ghost_vision_pref = GHOST_VISION_LEVEL_HIGH_NVG
		if(LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
			level_message = "full night vision"
			src?.client?.prefs?.ghost_vision_pref = GHOST_VISION_LEVEL_FULL_NVG
		if(LIGHTING_PLANE_ALPHA_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			level_message = "no night vision"
			src?.client?.prefs?.ghost_vision_pref = GHOST_VISION_LEVEL_NO_NVG
	src.client.prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("Night Vision mode switched and saved to [level_message]."))
	sync_lighting_plane_alpha()

/mob/dead/observer/verb/toggle_self_visibility()
	set name = "Toggle Self Visibility"
	set category = "Ghost.Settings"
	self_visibility = !self_visibility
	if (self_visibility)
		alpha = initial(alpha)
	else
		alpha = 0
	to_chat(usr, SPAN_NOTICE("You are now [(self_visibility?"visible":"invisible")]."))

/mob/dead/observer/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "Ghost.View"
	GLOB.crew_manifest.open_ui(src)

/mob/dead/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of the hive."
	set category = "Ghost.View"

	var/list/hives = list()
	var/datum/hive_status/last_hive_checked

	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(length(hive.totalXenos) > 0)
			hives += list("[hive.name]" = hive.hivenumber)
			last_hive_checked = hive

	if(!length(hives))
		to_chat(src, SPAN_ALERT("There seem to be no living hives at the moment"))
		return
	else if(length(hives) == 1) // Only one hive, don't need an input menu for that
		last_hive_checked.hive_ui.open_hive_status(src)
	else
		faction = tgui_input_list(src, "Select which hive status menu to open up", "Hive Choice", hives, theme="hive_status")
		if(!faction)
			to_chat(src, SPAN_ALERT("Hive choice error. Aborting."))
			return

		GLOB.hive_datum[hives[faction]].hive_ui.open_hive_status(src)

/mob/dead/observer/verb/view_uscm_tacmap()
	set name = "View USCM Tacmap"
	set category = "Ghost.View"

	GLOB.uscm_tacmap_status.tgui_interact(src)

/mob/dead/observer/verb/view_xeno_tacmap()
	set name = "View Xeno Tacmap"
	set category = "Ghost.View"

	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(!hive || !length(hive.totalXenos))
		to_chat(src, SPAN_ALERT("There seems to be no living normal hive at the moment"))
		return

	GLOB.xeno_tacmap_status.tgui_interact(src)

/mob/dead/observer/verb/view_faxes()
	set name = "View Sent Faxes"
	set desc = "View faxes from this round"
	set category = "Ghost.View"

	var/list/options = list(
		"Weyland-Yutani", "High Command", "Provost", "Press",
		"Colonial Marshal Bureau", "Union of Progressive Peoples",
		"Three World Empire", "Colonial Liberation Front",
		"Other", "Cancel")
	var/answer = tgui_input_list(src, "Which kind of faxes would you like to see?", "Faxes", options)
	switch(answer)
		if("Weyland-Yutani")
			var/body = "<body>"

			for(var/text in GLOB.WYFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to Weyland-Yutani", "wyfaxviewer", "size=300x600")

		if("High Command")
			var/body = "<body>"

			for(var/text in GLOB.USCMFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to High Command", "uscmfaxviewer", "size=300x600")

		if("Provost")
			var/body = "<body>"

			for(var/text in GLOB.ProvostFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Provost Office", "provostfaxviewer", "size=300x600")

		if("Press")
			var/body = "<body>"

			for(var/text in GLOB.PressFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to Press organizations", "pressfaxviewer", "size=300x600")

		if("Colonial Marshal Bureau")
			var/body = "<body>"

			for(var/text in GLOB.CMBFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Colonial Marshal Bureau", "cmbfaxviewer", "size=300x600")

		if("Union of Progressive Peoples")
			var/body = "<body>"

			for(var/text in GLOB.UPPFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Union of Progressive Peoples", "uppfaxviewer", "size=300x600")

		if("Three World Empire")
			var/body = "<body>"

			for(var/text in GLOB.TWEFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Three World Empire", "twefaxviewer", "size=300x600")

		if("Colonial Liberation Front")
			var/body = "<body>"

			for(var/text in GLOB.CLFFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Colonial Liberation Front", "clffaxviewer", "size=300x600")

		if("Other")
			var/body = "<body>"

			for(var/text in GLOB.GeneralFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Inter-machine Faxes", "otherfaxviewer", "size=300x600")
		if("Cancel")
			return

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

/mob/dead/verb/join_as_facehugger()
	set category = "Ghost.Join"
	set name = "Join as a Facehugger"
	set desc = "Try joining as a Facehugger from a Carrier or Egg Morpher."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_xeno_late_join(src))
		SSticker.mode.attempt_to_join_as_facehugger(src)

/mob/dead/verb/join_as_lesser_drone()
	set category = "Ghost.Join"
	set name = "Join as a Lesser Drone"
	set desc = "Try joining as a Lesser Drone to support the hive."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_xeno_late_join(src))
		SSticker.mode.attempt_to_join_as_lesser_drone(src)

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
	if(length(GLOB.zombie_landmarks))
		zombie_list += list("Underground Zombie" = "Underground Zombie")
	for(var/mob/living/carbon/human/A in GLOB.zombie_list)
		if(!A.client && A.stat != DEAD) // Only living zombies
			zombie_list += list(A.real_name = A)

	if(!length(zombie_list))
		to_chat(src, SPAN_DANGER("There are no available zombies."))
		return

	var/choice = tgui_input_list(usr, "Pick a Zombie:", "Join as Zombie", zombie_list)
	if(!choice)
		return

	if(!client || !mind)
		return

	if(choice == "Underground Zombie")
		if(!length(GLOB.zombie_landmarks))
			to_chat(src, SPAN_WARNING("Sorry, the last underground zombie just got taken."))
			return
		var/obj/effect/landmark/zombie/spawn_point = pick(GLOB.zombie_landmarks)
		spawn_point.spawn_zombie(src)
		return

	var/mob/living/carbon/human/Z = zombie_list[choice]

	if(!Z || QDELETED(Z))
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

	var/list/mobs_by_role = list() // the list the mobs are assigned to first, for sorting purposes
	for(var/mob/freed_mob as anything in GLOB.freed_mob_list)
		var/role_name = freed_mob.get_role_name()
		if(!role_name)
			role_name = "No Role"
		LAZYINITLIST(mobs_by_role[role_name])
		mobs_by_role[role_name] += freed_mob

	var/list/freed_mob_choices = list() // the list we'll be choosing from
	for(var/role in mobs_by_role)
		for(var/freed_mob in mobs_by_role[role])
			freed_mob_choices["[freed_mob] ([role])"] = freed_mob
	if(!length(freed_mob_choices))
		to_chat(src, SPAN_WARNING("There are no Freed Mobs available."))
		return
	var/choice = tgui_input_list(usr, "Pick a Freed Mob:", "Join as Freed Mob", freed_mob_choices)
	if(!choice)
		return

	var/mob/living/L = freed_mob_choices[choice]

	handle_joining_as_freed_mob(L)

/mob/dead/proc/handle_joining_as_freed_mob(mob/living/freed_mob)
	if(!istype(freed_mob) || !(freed_mob in GLOB.freed_mob_list))
		return

	if(QDELETED(freed_mob) || freed_mob.client)
		GLOB.freed_mob_list -= freed_mob
		to_chat(src, SPAN_WARNING("Something went wrong."))
		return

	GLOB.freed_mob_list -= freed_mob
	mind.transfer_to(freed_mob, TRUE)

/mob/dead/verb/join_as_hellhound()
	set category = "Ghost.Join"
	set name = "Join as Hellhound"
	set desc = "Select an alive and available Hellhound. THIS COMES WITH STRICT RULES. READ THEM OR GET BANNED."

	var/mob/dead/current_mob = src
	if(!current_mob.stat || !current_mob.mind)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	var/list/hellhound_mob_list = list() // the list we'll be choosing from
	for(var/mob/living/carbon/xenomorph/hellhound/Hellhound as anything in GLOB.hellhound_list)
		if(Hellhound.client)
			continue
		if(Hellhound.aghosted)
			continue
		hellhound_mob_list[Hellhound.name] = Hellhound
	var/choice = tgui_input_list(usr, "Pick a Hellhound:", "Join as Hellhound", hellhound_mob_list)
	if(!choice)
		return

	var/mob/living/carbon/xenomorph/hellhound/Hellhound = hellhound_mob_list[choice]
	if(!Hellhound || !(Hellhound in GLOB.hellhound_list))
		return

	if(QDELETED(Hellhound) || Hellhound.client)
		to_chat(src, SPAN_WARNING("Something went wrong."))
		return

	if(Hellhound.stat == DEAD)
		to_chat(src, SPAN_WARNING("That Hellhound has died."))
		return

	current_mob.mind.transfer_to(Hellhound, TRUE)
	Hellhound.generate_name()

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

/mob/dead/verb/join_as_joe()
	set category = "Ghost.Join"
	set name = "Join as a Working Joe"
	set desc = "If you are whitelisted, you'll be able to join in."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_joe_late_join(src))
		SSticker.mode.attempt_to_join_as_joe(src)

/mob/dead/verb/join_as_responder()
	set category = "Ghost.Join"
	set name = "Join as a Fax Responder"
	set desc = "If you are whitelisted, you'll be able to join in."

	if (!client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(src, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_fax_responder_late_join(src))
		SSticker.mode.attempt_to_join_as_fax_responder(src)

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

	var/datum/game_mode/huntergames/mode = SSticker.mode

	if(!mode.waiting_for_drop_votes)
		to_chat(src, SPAN_INFO("There's no drop vote currently in progress. Wait for a supply drop to be announced!"))
		return

	if(voted_this_drop)
		to_chat(src, SPAN_INFO("You voted for this one already. Only one please!"))
		return

	var/list/mobs = GLOB.alive_mob_list
	var/target = null

	for(var/mob/living/M in mobs)
		if(!istype(M,/mob/living/carbon/human) || M.stat || isyautja(M))
			mobs -= M


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
		var/ref
		var/mob/living/carbon/human/H = mind.original
		if(istype(H))
			ref = WEAKREF(H)
		GLOB.data_core.manifest_modify(name, ref, null, null, "*Deceased*")


/mob/dead/observer/verb/view_kill_feed()
	set category = "Ghost.View"
	set name = "View Kill Feed"
	set desc = "View global kill statistics tied to the game."

	if(GLOB.round_statistics)
		GLOB.round_statistics.show_kill_feed(src)

/mob/dead/observer/get_status_tab_items()
	. = ..()
	. += ""
	. += "Game Mode: [GLOB.master_mode]"

	if(!SSticker.HasRoundStarted())
		var/time_remaining = SSticker.GetTimeLeft()
		if(time_remaining > 0)
			. += "Time To Start: [floor(time_remaining)]s[SSticker.delay_start ? " (DELAYED)" : ""]"
		else if(time_remaining == -10)
			. += "Time To Start: DELAYED"
		else
			. += "Time To Start: SOON"

		. += "Players: [SSticker.totalPlayers]"
		if(client.admin_holder)
			. += "Players Ready: [SSticker.totalPlayersReady]"

	. += ""

	if(SSticker.mode?.force_end_at)
		var/time_left = SSticker.mode.force_end_at - world.time
		if(time_left >= 0)
			. += "Hijack Time Left: [DisplayTimeText(time_left, 1)]"
		else
			. += "Hijack Over"

	if(SShijack)
		var/eta_status = SShijack.get_evac_eta()
		if(eta_status)
			. += "Evacuation Goal: [eta_status]"

		if(SShijack.sd_unlocked)
			. += "Self Destruct Goal: [SShijack.get_sd_eta()]"

	if(client.prefs?.be_special & BE_ALIEN_AFTER_DEATH)
		if(larva_queue_cached_message)
			. += larva_queue_cached_message
			. += ""

	if(timeofdeath)
		var/time_since_death = world.time - timeofdeath
		var/format = (time_since_death >= 1 HOURS ? "hh:mm:ss" : "mm:ss")

		. += "Time Since Death: [time2text(time_since_death, format)]"


/proc/message_ghosts(message)
	for(var/mob/dead/observer/O as anything in GLOB.observer_list)
		to_chat(O, message)

/// Format text and links to JuMP/FoLloW something
/mob/dead/observer/proc/format_jump(atom/target, jump_tag)
	if(ismob(target))
		if(!jump_tag)
			jump_tag = "FLW"
		return "(<a href='byond://?src=\ref[src];track=\ref[target]'>[jump_tag]</a>)"
	if(!jump_tag)
		jump_tag = "JMP"
	var/turf/turf = get_turf(target)
	return "(<a href='byond://?src=\ref[src];jumptocoord=1;X=[turf.x];Y=[turf.y];Z=[turf.z]'>[jump_tag]</a>)"

/mob/dead/observer/point_to(atom/A in view())
	if(!(client?.prefs?.toggles_chat & CHAT_DEAD))
		return FALSE
	if(A?.z != src.z || !A.mouse_opacity || get_dist(src, A) > client.view)
		return FALSE
	var/turf/turf = get_turf(A)
	if(recently_pointed_to > world.time)
		return FALSE
	point_to_atom(A, turf)
	return TRUE

/mob/dead/observer/point_to_atom(atom/A, turf/T)
	recently_pointed_to = world.time + 4 SECONDS
	new /obj/effect/overlay/temp/point/big/observer(T, src, A)
	for(var/mob/dead/observer/nearby_observer as anything in GLOB.observer_list)
		var/client/observer_client = nearby_observer.client
		// We check observer view range specifically to also show the message to zoomed out ghosts. Double check Z as get_dist goes thru levels.
		if((observer_client?.prefs?.toggles_chat & CHAT_DEAD) \
			&& src.z == nearby_observer.z && get_dist(src, nearby_observer) <= observer_client.view)
			to_chat(observer_client, SPAN_DEADSAY("<b>[src]</b> points to [A] [nearby_observer.format_jump(A)]"))
	return TRUE

/// This proc is called when a predator round is toggled by the admin verb, as well as when a ghost logs in
/mob/dead/observer/proc/toggle_predator_action()
	SIGNAL_HANDLER

	var/key_to_use = ckey || persistent_ckey

	if(!key_to_use)
		return

	if(!SSticker.mode)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(toggle_predator_action)))
		return

	if(SSticker.mode.flags_round_type & MODE_PREDATOR)
		if(locate(/datum/action/join_predator) in actions)
			return

		var/datum/action/join_predator/new_action = new()
		new_action.give_to(src)
		return

	var/datum/action/join_predator/old_action = locate() in actions
	if(old_action)
		qdel(old_action)
