SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 0.4 SECONDS
	init_order = SS_INIT_STATPANELS
	init_stage = INITSTAGE_EARLY
	priority = SS_PRIORITY_STATPANEL
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/list/global_data
	var/list/mc_data

	///how many subsystem fires between most tab updates
	var/default_wait = 10
	///how many subsystem fires between updates of the status tab
	var/status_wait = 5
	///how many subsystem fires between updates of the MC tab
	var/mc_wait = 3
	///how many full runs this subsystem has completed. used for variable rate refreshes.
	var/num_fires = 0


/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		num_fires++
		var/datum/map_config/cached
		if(SSmapping.next_map_configs)
			cached = SSmapping.next_map_configs[GROUND_MAP]
		global_data = list(
			"Map: [SSmapping.configs?[GROUND_MAP]?.map_name || "Loading..."]",
			cached ? "Next Map: [cached?.map_name]" : null,
// "Round ID: [GLOB.round_id ? GLOB.round_id : "NULL"]", // this is commented because we don't have it and we should have it instead of using debug DB - be the hero of today
//   "Round Time: [ROUND_TIME]",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			"Round Time: [duration2text()]",
			"Operation Time: [worldtime2text()]",
		)

		src.currentrun = GLOB.clients.Copy()
		mc_data = null

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--

		if(!target.stat_panel.is_ready())
			continue

		if(target.stat_tab == "Status" && num_fires % status_wait == 0)
			set_status_tab(target)
		if(!CLIENT_IS_STAFF(target))
			target.stat_panel.send_message("remove_admin_tabs")
		else
			target.stat_panel.send_message("update_split_admin_tabs", !!(target.prefs.toggles_admin & SPLIT_ADMIN_TABS))

			if(!("Tickets" in target.panel_tabs))
				target.stat_panel.send_message("add_admin_tabs", target.admin_holder.href_token)

			if(!("MC" in target.panel_tabs) && target.admin_holder.rights & R_DEBUG)
				target.stat_panel.send_message("add_debug_tabs", target.admin_holder.href_token)

			if(target.stat_tab == "MC" && ((num_fires % mc_wait == 0))) // || target?.prefs.read_preference(/datum/preference/toggle/fast_mc_refresh)))
				set_MC_tab(target)

			if(target.stat_tab == "Tickets" && num_fires % default_wait == 0)
				set_tickets_tab(target)

			if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
				target.stat_panel.send_message("remove_sdql2")

			else if(length(GLOB.sdql2_queries) && (target.stat_tab == "SDQL2" || !("SDQL2" in target.panel_tabs)) && (num_fires % default_wait == 0))
				set_SDQL2_tab(target)

		if(target.mob)
			var/mob/target_mob = target.mob

			/*
			// Handle the action panels of the stat panel
			var/update_actions = FALSE
			// We're on a spell tab, update the tab so we can see cooldowns progressing and such
			if(target.stat_tab in target.spell_tabs)
				update_actions = TRUE
			// We're not on a spell tab per se, but we have cooldown actions, and we've yet to
			// set up our spell tabs at all
			if(!length(target.spell_tabs) && locate(/datum/action/cooldown) in target_mob.actions)
				update_actions = TRUE

			if(update_actions && num_fires % default_wait == 0)
				set_action_tabs(target, target_mob)
			*/

			// Handle the examined turf of the stat panel, if it's been long enough, or if we've generated new images for it
			var/turf/listed_turf = target_mob?.listed_turf
			if(listed_turf && num_fires % default_wait == 0)
				if(target.stat_tab == listed_turf.name || !(listed_turf.name in target.panel_tabs))
					set_turf_examine_tab(target, target_mob)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/statpanels/proc/set_status_tab(client/target)
	if(!global_data)//statbrowser hasnt fired yet and we were called from immediate_send_stat_data()
		return

	target.stat_panel.send_message("update_stat", list(
		"global_data" = global_data,
		//"ping_str" = "Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)",
		"other_str" = target.mob?.get_status_tab_items(),
	))

	return

/datum/controller/subsystem/statpanels/proc/set_MC_tab(client/target)
	var/turf/eye_turf = get_turf(target.eye)
	var/coord_entry = COORD(eye_turf)
	if(!mc_data)
		generate_mc_data()
	target.stat_panel.send_message("update_mc", list(mc_data = mc_data, coord_entry = coord_entry))

/datum/controller/subsystem/statpanels/proc/set_tickets_tab(client/target)
	var/list/ahelp_tickets = GLOB.ahelp_tickets.stat_entry()
	target.stat_panel.send_message("update_tickets", ahelp_tickets)

/datum/controller/subsystem/statpanels/proc/set_turf_examine_tab(client/target, mob/target_mob)
	var/list/overrides = list()
	for(var/image/target_image as anything in target.images)
		if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
			continue
		overrides += target_image.loc

	var/list/atoms_to_display = list(target_mob.listed_turf)
	for(var/atom/movable/turf_content as anything in target_mob.listed_turf)
		if(issurface(turf_content))
			for(var/obj/item/item in turf_content.contents)
				atoms_to_display += item
		if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
			continue
		if(turf_content.invisibility > target_mob.see_invisible)
			continue
		if(turf_content in overrides)
			continue
		//if(turf_content.IsObscured()) // requires click under flags to work
		// continue
		atoms_to_display += turf_content

	/// Set the atoms we're meant to display
	var/datum/object_window_info/obj_window = target.obj_window
	obj_window.atoms_to_show = atoms_to_display
	START_PROCESSING(SSobj_tab_items, obj_window)
	refresh_client_obj_view(target)

/datum/controller/subsystem/statpanels/proc/refresh_client_obj_view(client/refresh)
	var/list/turf_items = return_object_images(refresh)
	if(!length(turf_items) || !refresh.mob?.listed_turf)
		return
	refresh.stat_panel.send_message("update_listedturf", turf_items)

#define OBJ_IMAGE_LOADING "statpanels obj loading temporary"
/// Returns all our ready object tab images
/// Returns a list in the form list(list(object_name, object_ref, loaded_image), ...)
/datum/controller/subsystem/statpanels/proc/return_object_images(client/load_from)
	// You might be inclined to think that this is a waste of cpu time, since we
	// A: Double iterate over atoms in the build case, or
	// B: Generate these lists over and over in the refresh case
	// It's really not very hot. The hot portion of this code is genuinely mostly in the image generation
	// So it's ok to pay a performance cost for cleanliness here

	// No turf? go away
	if(!load_from.mob?.listed_turf)
		return list()
	var/datum/object_window_info/obj_window = load_from.obj_window
	var/list/already_seen = obj_window.atoms_to_images
	var/list/to_make = obj_window.atoms_to_imagify
	var/list/turf_items = list()
	for(var/atom/turf_item as anything in obj_window.atoms_to_show)
		// First, we fill up the list of refs to display
		// If we already have one, just use that
		var/existing_image = already_seen[turf_item]
		if(existing_image == OBJ_IMAGE_LOADING)
			continue
		// We already have it. Success!
		if(existing_image)
			turf_items[++turf_items.len] = list("[turf_item.name]", REF(turf_item), existing_image)
			continue
		// Now, we're gonna queue image generation out of those refs
		to_make += turf_item
		already_seen[turf_item] = OBJ_IMAGE_LOADING
		obj_window.RegisterSignal(turf_item, COMSIG_PARENT_QDELETING, /datum/object_window_info/proc/viewing_atom_deleted) // we reset cache if anything in it gets deleted
	return turf_items

#undef OBJ_IMAGE_LOADING

/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	mc_data = list(
		list("CPU:", world.cpu),
		list("Instances:", "[num2text(world.contents.len, 10)]"),
		list("World Time:", "[world.time]"),
		list("Globals:", GLOB.stat_entry(), "\ref[GLOB]"),
		list("[config]:", config.stat_entry(), "\ref[config]"),
// list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)"),
		list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)"),
		list("Master Controller:", Master.stat_entry(), "\ref[Master]"),
		list("Failsafe Controller:", Failsafe.stat_entry(), "\ref[Failsafe]"),
		list("","")
	)
	for(var/datum/controller/subsystem/sub_system as anything in Master.subsystems)
		mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), text_ref(sub_system))

/// Sets the current tab to the SDQL tab
/datum/controller/subsystem/statpanels/proc/set_SDQL2_tab(client/target)
	var/list/sdql2_initial = list()
	//sdql2_initial[length(sdql2_initial)++] = list("", "Access Global SDQL2 List", REF(GLOB.sdql2_vv_statobj))
	var/list/sdql2_querydata = list()
	//for(var/datum/sdql2_query/query as anything in GLOB.sdql2_queries)
		//sdql2_querydata = query.generate_stat()

	sdql2_initial += sdql2_querydata
	target.stat_panel.send_message("update_sdql2", sdql2_initial)

///immediately update the active statpanel tab of the target client
/datum/controller/subsystem/statpanels/proc/immediate_send_stat_data(client/target)
	if(!target.stat_panel.is_ready())
		return FALSE

	if(target.stat_tab == "Status")
		set_status_tab(target)
		return TRUE

	var/mob/target_mob = target.mob

	// Handle actions

	/*
	var/update_actions = FALSE
	if(target.stat_tab in target.spell_tabs)
		update_actions = TRUE

	if(!length(target.spell_tabs) && locate(/datum/action/cooldown) in target_mob.actions)
		update_actions = TRUE

	if(update_actions)
		set_action_tabs(target, target_mob)
		return TRUE
	*/

	// Handle turfs

	if(target_mob?.listed_turf)
		if(!target_mob.TurfAdjacent(target_mob.listed_turf))
			target_mob.set_listed_turf(null)

		else if(target.stat_tab == target_mob?.listed_turf.name || !(target_mob?.listed_turf.name in target.panel_tabs))
			set_turf_examine_tab(target, target_mob)
			return TRUE

	if(!target.admin_holder)
		return FALSE

	if(target.stat_tab == "MC")
		set_MC_tab(target)
		return TRUE

	if(target.stat_tab == "Tickets")
		set_tickets_tab(target)
		return TRUE

	if(!length(GLOB.sdql2_queries) && ("SDQL2" in target.panel_tabs))
		target.stat_panel.send_message("remove_sdql2")

	else if(length(GLOB.sdql2_queries) && target.stat_tab == "SDQL2")
		set_SDQL2_tab(target)

/// Stat panel window declaration
/client/var/datum/tgui_window/stat_panel

/// Datum that holds and tracks info about a client's object window
/// Really only exists because I want to be able to do logic with signals
/// And need a safe place to do the registration
/datum/object_window_info
	/// list of atoms to show to our client via the object tab, at least currently
	var/list/atoms_to_show = list()
	/// list of atom -> image string for objects we have had in the right click tab
	/// this is our caching
	var/list/atoms_to_images = list()
	/// list of atoms to turn into images for the object tab
	var/list/atoms_to_imagify = list()
	/// Our owner client
	var/client/parent
	/// Are we currently tracking a turf?
	var/actively_tracking = FALSE

/datum/object_window_info/New(client/parent)
	. = ..()
	src.parent = parent

/datum/object_window_info/Destroy(force, ...)
	atoms_to_show = null
	atoms_to_images = null
	atoms_to_imagify = null
	parent.obj_window = null
	parent = null
	STOP_PROCESSING(SSobj_tab_items, src)
	return ..()

/// Takes a client, attempts to generate object images for it
/// We will update the client with any improvements we make when we're done
/datum/object_window_info/process(delta_time)
	// Cache the datum access for sonic speed
	var/list/to_make = atoms_to_imagify
	var/list/newly_seen = atoms_to_images
	var/index = 0
	for(index in 1 to length(to_make))
		var/atom/thing = to_make[index]

		var/generated_string
		/* We're cheap and won't render all overlays. It's expensive and updates with onmob changes!
		if(ismob(thing) || length(thing.overlays) > 2)
			generated_string = costly_icon2html(thing, parent, sourceonly=TRUE)
		else
			generated_string = icon2html(thing, parent, sourceonly=TRUE)
		*/
		generated_string = icon2html(thing, parent, sourceonly=TRUE)

		newly_seen[thing] = generated_string
		if(TICK_CHECK)
			to_make.Cut(1, index + 1)
			index = 0
			break
	// If we've not cut yet, do it now
	if(index)
		to_make.Cut(1, index + 1)
	SSstatpanels.refresh_client_obj_view(parent)
	if(!length(to_make))
		return PROCESS_KILL

/datum/object_window_info/proc/start_turf_tracking()
	if(actively_tracking)
		stop_turf_tracking()
	var/static/list/connections = list(
		COMSIG_MOVABLE_MOVED = PROC_REF(on_mob_move),
		COMSIG_MOB_LOGOUT = PROC_REF(on_mob_logout),
	)
	AddComponent(/datum/component/connect_mob_behalf, parent, connections)
	actively_tracking = TRUE

/datum/object_window_info/proc/stop_turf_tracking()
	qdel(GetComponent(/datum/component/connect_mob_behalf))
	actively_tracking = FALSE

/datum/object_window_info/proc/on_mob_move(mob/source)
	SIGNAL_HANDLER
	var/turf/listed = source.listed_turf
	if(!listed || !source.TurfAdjacent(listed))
		source.set_listed_turf(null)

/datum/object_window_info/proc/on_mob_logout(mob/source)
	SIGNAL_HANDLER
	on_mob_move(parent.mob)

/// Clears any cached object window stuff
/// We use hard refs cause we'd need a signal for this anyway. Cleaner this way
/datum/object_window_info/proc/viewing_atom_deleted(atom/deleted)
	SIGNAL_HANDLER
	atoms_to_show -= deleted
	atoms_to_imagify -= deleted
	atoms_to_images -= deleted

/mob/proc/set_listed_turf(turf/new_turf)
	listed_turf = new_turf
	if(!client)
		return
	if(!client.obj_window)
		client.obj_window = new(client)
	if(listed_turf)
		client.stat_panel.send_message("create_listedturf", listed_turf.name)
		client.obj_window.start_turf_tracking()
	else
		client.stat_panel.send_message("remove_listedturf")
		client.obj_window.stop_turf_tracking()

/client/verb/open_statbrowser_options(current_fontsize as num|null)
	set name = "Open Statbrowser Options"
	set hidden = TRUE


	var/datum/statbrowser_options/SM = statbrowser_options
	if(!SM)
		SM = statbrowser_options = new(src, current_fontsize)
	SM.tgui_interact()
