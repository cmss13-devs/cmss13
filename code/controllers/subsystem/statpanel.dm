SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 6
	init_order = SS_INIT_STATPANELS
	priority = SS_PRIORITY_STATPANEL
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/encoded_global_data
	var/mc_data_encoded
	var/list/cached_images = list()

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		var/datum/map_config/cached
		if(SSmapping.next_map_configs)
			cached = SSmapping.next_map_configs[GROUND_MAP]
//		var/round_time = world.time - SSticker.round_start_time
		var/list/global_data = list(
			"Map: [SSmapping.configs[GROUND_MAP]?.map_name || "Loading..."]",
			cached ? "Next Map: [cached?.map_name]" : null,
//			"Round ID: [GLOB.round_id ? GLOB.round_id : "NULL"]",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			"Round Time: [duration2text()]",
			"Operation Time: [worldtime2text()]",
		)

		encoded_global_data = url_encode(json_encode(global_data))
		src.currentrun = GLOB.clients.Copy()
		mc_data_encoded = null
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--
		if(!target.statbrowser_ready)
			continue
		if(target.stat_tab == "Status")
//			var/ping_str = url_encode("Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)")
			var/other_str = url_encode(json_encode(target.mob.get_status_tab_items()))
			target << output("[encoded_global_data];;[other_str]", "statbrowser:update")
		if(!CLIENT_IS_STAFF(target))
			target << output("", "statbrowser:remove_admin_tabs")
		else
			if(!("Admin" in target.panel_tabs) || !("Tickets" in target.panel_tabs))
				target << output("[url_encode(target.admin_holder.href_token)]", "statbrowser:add_admin_tabs")
			if(!("MC" in target.panel_tabs) && check_client_rights(target, R_DEBUG|R_HOST, FALSE))
				target << output("", "statbrowser:add_mc_tab")
			if(target.stat_tab == "MC")
				var/turf/eye_turf = get_turf(target.eye)
				var/coord_entry = url_encode(COORD(eye_turf))
				if(!mc_data_encoded)
					generate_mc_data()
				target << output("[mc_data_encoded];[coord_entry]", "statbrowser:update_mc")
			if(target.stat_tab == "Tickets")
				set_tickets_tab(target)
		if(target.mob)
			var/mob/M = target.mob
			if(M?.listed_turf)
				var/mob/target_mob = M
				if(!target_mob.TurfAdjacent(target_mob.listed_turf))
					target << output("", "statbrowser:remove_listedturf")
					target_mob.listed_turf = null
				else if(target.stat_tab == M?.listed_turf.name || !(M?.listed_turf.name in target.panel_tabs))
					var/list/overrides = list()
					var/list/turfitems = list()
					for(var/img in target.images)
						var/image/target_image = img
						if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
							continue
						overrides += target_image.loc
					for(var/tc in target_mob.listed_turf) //load items in surfaces
						if(issurface(tc))
							var/obj/structure/surface/S = tc
							for(var/obj/item/I in S.contents)
								turfitems[++turfitems.len] = list("[I.name]", REF(I), icon2html(I, target, sourceonly=TRUE))
							break //there shouldn't ever be multiple surfaces in one turf
					turfitems[++turfitems.len] = list("[target_mob.listed_turf]", REF(target_mob.listed_turf), icon2html(target_mob.listed_turf, target, sourceonly=TRUE))
					for(var/tc in target_mob.listed_turf)
						var/atom/movable/turf_content = tc
						if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
							continue
						if(turf_content.invisibility > target_mob.see_invisible)
							continue
						if(turf_content in overrides)
							continue
						//if(turf_content.IsObscured()) // requires click under flags to work
						//	continue
						if(length(turfitems) < 30) // only create images for the first 30 items on the turf, for performance reasons
							if(!(REF(turf_content) in cached_images))
								cached_images += REF(turf_content)
								turf_content.RegisterSignal(turf_content, COMSIG_PARENT_QDELETING, /atom/.proc/remove_from_cache_qdeleting) // we reset cache if anything in it gets deleted
								/* Uncomment below to re-enable generation of icons with overlays. THIS IS VERY PERFORMANCE INTENSIVE.
								if(ismob(turf_content) || length(turf_content.overlays) > 2)
									if(ishuman(turf_content))
										turf_content.RegisterSignal(turf_content, list(
											COMSIG_HUMAN_OVERLAY_APPLIED,
											COMSIG_HUMAN_OVERLAY_REMOVED,
										), /atom/.proc/remove_from_cache_updated_overlays)
									turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), costly_icon2html(turf_content, target, sourceonly = TRUE))
								else
									turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), icon2html(turf_content, target, sourceonly=TRUE))
								*/
								turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), icon2html(turf_content, target, sourceonly=TRUE))
							else
								turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
						else
							turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
					turfitems = url_encode(json_encode(turfitems))
					target << output("[turfitems];", "statbrowser:update_listedturf")
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/statpanels/proc/set_tickets_tab(client/target)
	var/list/ahelp_tickets = GLOB.ahelp_tickets.stat_entry()
	target << output("[url_encode(json_encode(ahelp_tickets))];", "statbrowser:update_tickets")

/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	var/list/mc_data = list(
		list("CPU:", world.cpu),
		list("Instances:", "[num2text(world.contents.len, 10)]"),
		list("World Time:", "[world.time]"),
		list("Globals:", GLOB.stat_entry(), "\ref[GLOB]"),
		list("[config]:", config.stat_entry(), "\ref[config]"),
//		list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)"),
		list("Master Controller:", Master.stat_entry(), "\ref[Master]"),
		list("Failsafe Controller:", Failsafe.stat_entry(), "\ref[Failsafe]"),
		list("","")
	)
	for(var/ss in Master.subsystems)
		var/datum/controller/subsystem/sub_system = ss
		mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")
	//mc_data[++mc_data.len] = list("Camera Net", "Cameras: [GLOB.cameranet.cameras.len] | Chunks: [GLOB.cameranet.chunks.len]", "\ref[GLOB.cameranet]")
	mc_data_encoded = url_encode(json_encode(mc_data))

/atom/proc/remove_from_cache_qdeleting()
	SIGNAL_HANDLER
	SSstatpanels.cached_images -= REF(src)

/atom/proc/remove_from_cache_updated_overlays()
	SIGNAL_HANDLER
	UnregisterSignal(src, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_HUMAN_OVERLAY_APPLIED,
		COMSIG_HUMAN_OVERLAY_REMOVED,
	))
	SSstatpanels.cached_images -= REF(src)

/// verbs that send information from the browser UI
/client/verb/set_tab(tab as text|null)
	set name = "Set Tab"
	set hidden = TRUE

	stat_tab = tab

/client/verb/send_tabs(tabs as text|null)
	set name = "Send Tabs"
	set hidden = TRUE

	panel_tabs |= tabs

/client/verb/remove_tabs(tabs as text|null)
	set name = "Remove Tabs"
	set hidden = TRUE

	panel_tabs -= tabs

/client/verb/reset_tabs()
	set name = "Reset Tabs"
	set hidden = TRUE

	panel_tabs = list()

/client/verb/panel_ready()
	set name = "Panel Ready"
	set hidden = TRUE

	statbrowser_ready = TRUE
	init_statbrowser()

/client/verb/open_statbrowser_options(current_fontsize as num|null)
	set name = "Open Statbrowser Options"
	set hidden = TRUE


	var/datum/statbrowser_options/SM = statbrowser_options
	if(!SM)
		SM = statbrowser_options = new(src, current_fontsize)
	SM.tgui_interact()
