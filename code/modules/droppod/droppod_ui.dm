#define TAB_POD 0
#define TAB_BAY 1
#define TAB_DROPOFF 2

GLOBAL_LIST_INIT(droppod_tab_indexes, list(
	"TAB_POD" = TAB_POD,
	"TAB_BAY" = TAB_BAY,
	"TAB_DROPOFF" = TAB_DROPOFF
))

#define LAUNCH_ALL 0
#define LAUNCH_RANDOM 1

GLOBAL_LIST_INIT(droppod_launch_options, list(
	"LAUNCH_ALL" = LAUNCH_ALL,
	"LAUNCH_RANDOM" = LAUNCH_RANDOM
))

#define TARGET_MODE_NONE 0
#define TARGET_MODE_LAUNCH 1
#define TARGET_MODE_DROPOFF 2

GLOBAL_LIST_INIT(droppod_target_mode, list(
	"TARGET_MODE_NONE" = TARGET_MODE_NONE,
	"TARGET_MODE_LAUNCH" = TARGET_MODE_LAUNCH,
	"TARGET_MODE_DROPOFF" = TARGET_MODE_DROPOFF
))


/client/proc/enable_podlauncher() //Creates a verb for admins to open up the ui
	set name = "Config/Launch Supplypod"
	set desc = "Configure and launch a supplypod full of whatever your heart desires!"
	set category = "Admin.Events"
	new /datum/admin_podlauncher(usr)//create the datum

/datum/admin_podlauncher
	var/static/list/ignored_atoms = typecacheof(list(null, /mob/dead, /obj/effect/landmark, /obj/effect/particle_effect/sparks, /obj/effect/warning))

	var/client/holder
	var/area/admin/droppod/loading/bay
	var/obj/structure/droppod/container/temp_pod
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background
	var/map_name
	var/list/cam_plane_masters

	var/list/ordered_area = list()
	var/list/launch_list = list()

	var/launch_clone = FALSE
	var/launch_random_item = FALSE
	var/launch_choice = LAUNCH_ALL
	var/custom_dropoff = FALSE

	var/target_mode = TARGET_MODE_NONE

	var/tab_index = TAB_BAY

	var/turf/old_location

/datum/admin_podlauncher/New(user)
	if(user)
		setup(user)

/datum/admin_podlauncher/proc/setup(user)
	if(isclient(user))
		holder = user
	else
		var/mob/M = user
		holder = M.client
	var/area/pod_storage_area = locate(/area/admin/droppod/holding) in GLOB.sorted_areas
	temp_pod = new(pick(get_area_turfs(pod_storage_area))) //Create a new temp_pod in the podStorage area on centcom (so users are free to look at it and change other variables if needed)
	init_map()
	refresh_bay()
	tgui_interact(holder.mob)

/datum/admin_podlauncher/proc/refresh_bay()
	bay = locate(/area/admin/droppod/loading) in GLOB.sorted_areas
	if(!bay)
		if(holder)
			to_chat(holder, SPAN_WARNING("There's no /area/admin/droppod/loading. You can make one yourself, but yell at the mappers to fix this."))
		CRASH("No /area/admin/droppod/loading has been mapped into the admin z-level!")
	ordered_area = list()
	for(var/turf/T in bay)
		ordered_area += T
	pre_launch()
	refresh_view()

/datum/admin_podlauncher/proc/pre_launch() //Creates a list of acceptable items,
	var/list/acceptableTurfs = list()
	for (var/t in ordered_area) //Go through the orderedArea list
		var/turf/unchecked_turf = t
		if (length(typecache_filter_list_reverse(unchecked_turf.contents, ignored_atoms)) != 0) //if there is something in this turf that isn't in the blacklist, we consider this turf "acceptable" and add it to the acceptableTurfs list
			acceptableTurfs.Add(unchecked_turf) //Because orderedArea was an ordered linear list, acceptableTurfs will be as well.

	launch_list = list() //Anything in launch_list will go into the supplypod when it is launched
	if (length(acceptableTurfs) && !custom_dropoff) //We dont fill the supplypod if acceptableTurfs is empty, if the pod is going in reverse (effectReverse=true), or if the pod is acitng like a missile (effectMissile=true)
		switch(launch_choice)
			if(LAUNCH_ALL) //If we are launching all the turfs at once
				for (var/t in acceptableTurfs)
					var/turf/accepted_turf = t
					launch_list |= typecache_filter_list_reverse(accepted_turf.contents, ignored_atoms) //We filter any blacklisted atoms and add the rest to the launch_list
			if(LAUNCH_RANDOM) //If we are launching randomly
				var/turf/acceptable_turf = pick_n_take(acceptableTurfs)
				launch_list |= typecache_filter_list_reverse(acceptable_turf.contents, ignored_atoms) //filter a random turf from the acceptableTurfs list and add it to the launch_list

/datum/admin_podlauncher/proc/launch(turf/target_turf) //Game time started
	if (isnull(target_turf))
		return
	var/obj/structure/droppod/container/toLaunch = DuplicateObject(temp_pod) //Duplicate the temp_pod (which we have been varediting or configuring with the UI) and store the result
	toLaunch.dropoff_point = temp_pod.dropoff_point
	if(launch_random_item)
		var/atom/movable/launch_candidate = pick_n_take(launch_list)
		if(!isnull(launch_candidate))
			if(launch_clone)
				launch_candidate = DuplicateObject(launch_candidate)
			launch_candidate.forceMove(toLaunch) //Duplicate a single atom/movable from launchList and forceMove it into the supplypod
	else
		for (var/launch_candidate in launch_list)
			if (isnull(launch_candidate))
				continue
			var/atom/movable/movable_to_launch = launch_candidate
			if(launch_clone)
				movable_to_launch = DuplicateObject(movable_to_launch)
			movable_to_launch.forceMove(toLaunch) //Duplicate each atom/movable in launchList and forceMove them into the supplypod

	toLaunch.launch(target_turf)

/datum/admin_podlauncher/proc/init_map()
	if(map_name)
		holder.clear_map(map_name)

	map_name = "admin_supplypod_bay_[REF(src)]_map"
	// Initialize map objects
	cam_screen = new
	cam_screen.icon = null
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = TRUE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_screen.appearance_flags |= TILE_BOUND

	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = TRUE
	cam_background.appearance_flags |= TILE_BOUND

	cam_plane_masters = list()
	for(var/plane in subtypesof(/atom/movable/screen/plane_master) - /atom/movable/screen/plane_master/blackness)
		var/atom/movable/screen/plane_master/instance = new plane()
		add_plane(instance)

	refresh_view()
	holder.register_map_obj(cam_screen)
	holder.register_map_obj(cam_background)
	for(var/plane_id in cam_plane_masters)
		holder.register_map_obj(cam_plane_masters[plane_id])

/datum/admin_podlauncher/proc/add_plane(atom/movable/screen/plane_master/instance)
	instance.assigned_map = map_name
	instance.appearance_flags |= TILE_BOUND
	instance.del_on_map_removal = FALSE
	if(instance.blend_mode_override)
		instance.blend_mode = instance.blend_mode_override
	instance.screen_loc = "[map_name]:CENTER"
	cam_plane_masters["[instance.plane]"] = instance

/datum/admin_podlauncher/proc/refresh_view()
	switch(tab_index)
		if (TAB_POD)
			setup_view_pod()
		if (TAB_BAY)
			setup_view_bay()
		else
			setup_view_dropoff()

/datum/admin_podlauncher/proc/setup_view_pod()
	setup_view(RANGE_TURFS(2, temp_pod))

/datum/admin_podlauncher/proc/setup_view_bay()
	var/list/visible_turfs = list()
	for(var/turf/bay_turf in bay)
		visible_turfs += bay_turf
	setup_view(visible_turfs)

/datum/admin_podlauncher/proc/setup_view_dropoff()
	var/turf/drop = temp_pod.dropoff_point
	setup_view(RANGE_TURFS(3, drop))

/datum/admin_podlauncher/proc/setup_view(list/visible_turfs)
	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

/datum/admin_podlauncher/proc/set_target_mode(mode)
	if(mode == target_mode)
		return

	switch(mode)
		if(TARGET_MODE_DROPOFF)
			RegisterSignal(holder, COMSIG_CLIENT_RESET_VIEW, PROC_REF(mouse_dropoff), TRUE)
			RegisterSignal(holder, COMSIG_CLIENT_PRE_CLICK, PROC_REF(select_dropoff_target), TRUE)
		if(TARGET_MODE_LAUNCH)
			RegisterSignal(holder, COMSIG_CLIENT_RESET_VIEW, PROC_REF(mouse_launch), TRUE)
			RegisterSignal(holder, COMSIG_CLIENT_PRE_CLICK, PROC_REF(select_launch_target), TRUE)
		else
			UnregisterSignal(holder, list(
				COMSIG_CLIENT_RESET_VIEW,
				COMSIG_CLIENT_PRE_CLICK
			))
	holder.mob.reset_view()
	target_mode = mode

/datum/admin_podlauncher/proc/select_launch_target(client/C, atom/target, list/mods)
	SIGNAL_HANDLER

	var/left_click = mods["left"]

	if(!left_click || istype(target,/atom/movable/screen))
		return

	pre_launch()
	target = get_turf(target)
	launch(target)

	message_admins("[key_name_admin(C)] launched a droppod", target.x, target.y, target.z)
	return COMPONENT_INTERRUPT_CLICK

/datum/admin_podlauncher/proc/mouse_launch(client/C)
	SIGNAL_HANDLER
	C.mouse_pointer_icon = 'icons/effects/mouse_pointer/supplypod_target.dmi' //Icon for when mouse is released

/datum/admin_podlauncher/proc/select_dropoff_target(client/C, atom/target, list/mods)
	SIGNAL_HANDLER
	var/left_click = mods["left"]

	if(!left_click || istype(target,/atom/movable/screen))
		return

	custom_dropoff = TRUE
	temp_pod.dropoff_point = get_turf(target)
	if(holder)
		to_chat(holder, SPAN_NOTICE("You have selected [temp_pod.dropoff_point] as your dropoff location."))
	SStgui.update_uis(src)
	return COMPONENT_INTERRUPT_CLICK

/datum/admin_podlauncher/proc/mouse_dropoff(client/C)
	SIGNAL_HANDLER
	C.mouse_pointer_icon = 'icons/effects/mouse_pointer/supplypod_pickturf.dmi' //Icon for when mouse is released

/datum/admin_podlauncher/ui_static_data(mob/user)
	. = list()
	.["glob_tab_indexes"] = GLOB.droppod_tab_indexes
	.["glob_launch_options"] = GLOB.droppod_launch_options
	.["glob_target_mode"] = GLOB.droppod_target_mode

/datum/admin_podlauncher/ui_data(mob/user)
	. = list()
	.["launch_clone"] = launch_clone
	.["launch_random_item"] = launch_random_item
	.["launch_choice"] = launch_choice
	.["custom_dropoff"] = custom_dropoff
	.["target_mode"] = target_mode

	if(old_location)
		var/area/A = get_area(old_location)
		.["old_area"] = A?.name

	.["explosion_power"] = temp_pod.land_exp_power
	.["explosion_falloff"] = temp_pod.land_exp_falloff
	.["gib_on_land"] = temp_pod.gib_on_land
	.["stealth"] = temp_pod.stealth
	.["land_damage"] = temp_pod.land_damage

	.["should_recall"] = temp_pod.should_recall
	.["delays"] = list(
		"drop_time" = temp_pod.drop_time,
		"dropping_time" = temp_pod.dropping_time,
		"open_time" = temp_pod.open_time,
		"return_time" = temp_pod.return_time
	)
	.["reverse_delays"] = temp_pod.reverse_delays

	.["max_mob_size"] = temp_pod.max_mob_size
	.["max_hold_items"] = temp_pod.max_hold_items
	.["can_be_opened"] = temp_pod.can_be_opened
	.["map_ref"] = map_name

/datum/admin_podlauncher/proc/load_data(list/d)
	launch_clone = d["launch_clone"]
	launch_random_item = d["launch_random_item"]
	launch_choice = d["launch_choice"]

	temp_pod.land_exp_power = d["explosion_power"]
	temp_pod.land_exp_falloff = d["explosion_falloff"]
	temp_pod.gib_on_land = d["gib_on_land"]
	temp_pod.stealth = d["stealth"]
	temp_pod.land_damage = d["land_damage"]

	temp_pod.should_recall = d["should_recall"]
	var/list/delays = d["delays"]

	temp_pod.drop_time = delays["drop_time"]
	temp_pod.dropping_time = delays["dropping_time"]
	temp_pod.open_time = delays["open_time"]
	temp_pod.return_time = delays["return_time"]

	temp_pod.reverse_delays = d["reverse_delays"]

	temp_pod.max_mob_size = d["max_mob_size"]
	temp_pod.max_hold_items = d["max_hold_items"]
	temp_pod.can_be_opened = d["can_be_opened"]


/datum/admin_podlauncher/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("load_preset")
			load_data(params["payload"])
			. = TRUE
		if("set_target_mode")
			var/new_mode = params["target_mode"]
			set_target_mode(new_mode)
			. = TRUE
		if("set_tab_index")
			var/new_index = params["tab_index"]
			tab_index = new_index
			refresh_view()
			. = TRUE
		if("refresh_view")
			init_map()
			refresh_view()
		if("clear_dropoff")
			temp_pod.dropoff_point = null
			custom_dropoff = FALSE
			. = TRUE
		if("goto_bay")
			var/mob/M = holder.mob
			if(get_area(M) != bay)
				old_location = M.loc
			var/turf/target_turf = pick(get_area_turfs(bay))
			M.forceMove(target_turf)
			message_admins("[key_name_admin(usr)] jumped to [bay].")
			. = TRUE
		if("goto_dropoff")
			var/mob/M = holder.mob //We teleport whatever mob the client is attached to at the point of clicking
			var/turf/current_location = get_turf(M)
			var/turf/dropoff_turf = temp_pod.dropoff_point
			if (current_location != dropoff_turf)
				old_location = current_location
			M.forceMove(dropoff_turf) //Perform the actual teleport
			message_admins("[key_name(usr)] jumped to [get_area(dropoff_turf)]")
			. = TRUE
		if("goto_prev_turf")
			var/mob/M = holder.mob
			if(!old_location)
				to_chat(M, SPAN_WARNING("Error! You don't have an old location to teleport back to!"))
				return
			M.forceMove(old_location)
			message_admins("[key_name_admin(usr)] jumped to [get_area(old_location)]")
			. = TRUE
		if("launch_clone")
			launch_clone = !!params["should_do"]
			. = TRUE
		if("launch_random_item")
			launch_random_item = !!params["should_do"]
			. = TRUE
		if("set_launch_option")
			var/option = params["launch_option"]
			if(!(option in GLOB.droppod_launch_options))
				return

			launch_choice = GLOB.droppod_launch_options[option]
			. = TRUE
		if("set_delays")
			if(params["drop_time"])
				temp_pod.drop_time = params["drop_time"]
			if(params["dropping_time"])
				temp_pod.dropping_time = params["dropping_time"]
			if(params["open_time"])
				temp_pod.open_time = params["open_time"]
			if(params["return_time"])
				temp_pod.return_time = params["return_time"]
			. = TRUE
		if("set_should_recall")
			temp_pod.should_recall = text2num(params["should_do"])
			. = TRUE
		if("set_reverse_delays")
			for(var/i in params)
				if(i in temp_pod.reverse_delays)
					temp_pod.reverse_delays[i] = params[i]
			. = TRUE
		if("set_explosive_parameters")
			if(!isnull(params["falloff"]))
				temp_pod.land_exp_falloff = max(text2num(params["falloff"]), 0)
			if(!isnull(params["power"]))
				temp_pod.land_exp_power = max(text2num(params["power"]), 0)
			. = TRUE
		if("set_gib_on_land")
			temp_pod.gib_on_land = !!params["should_do"]
			. = TRUE
		if("set_stealth")
			temp_pod.stealth = !!params["should_do"]
			. = TRUE
		if("set_damage")
			temp_pod.land_damage = max(text2num(params["damage"]), 0)
			. = TRUE
		if("set_max_hold_items")
			temp_pod.max_hold_items = max(text2num(params["max_hold_items"], 0))
			. = TRUE
		if("set_can_be_opened")
			temp_pod.can_be_opened = !!params["should_do"]
			. = TRUE
		if("refresh_bay")
			refresh_bay()
			. = TRUE
		if("clear_bay")
			if(tgui_alert(usr, "This will delete all objs and mobs in [bay]. Are you sure?",\
				"Confirmation", list("Yes", "No")) == "Yes")
				clear_bay()
				refresh_bay()
			. = TRUE

/datum/admin_podlauncher/proc/clear_bay()
	for (var/obj/O in bay.GetAllContents())
		qdel(O)
	for (var/mob/M in bay.GetAllContents())
		qdel(M)
	for (var/bayturf in bay)
		var/turf/turf_to_clear = bayturf
		turf_to_clear.ChangeTurf(/turf/open/floor/plating)

/datum/admin_podlauncher/ui_state(mob/user)
	return GLOB.admin_state

/datum/admin_podlauncher/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PodLauncher", "Admin Podlauncher")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/admin_podlauncher/ui_close(mob/user)
	set_target_mode(TARGET_MODE_NONE)
	QDEL_NULL(temp_pod)
	user.client?.clear_map(map_name)
	QDEL_NULL(cam_screen)
	QDEL_NULL(cam_background)
	QDEL_LIST_ASSOC_VAL(cam_plane_masters)
	qdel(src)
