/datum/mark_menu_ui
	var/name = "Mark Menu"
	var/data_initialized = FALSE //for the UI interaction

/datum/mark_menu_ui/proc/open_mark_menu(mob/user)
	var/mob/living/carbon/xenomorph/X = user
	if(!X.client)
		return

	if(!X.check_state(TRUE))
		return

	if(!data_initialized)
		update_all_data()

	tgui_interact(X)

/datum/mark_menu_ui/proc/update_all_data(send_update = TRUE)
	data_initialized = TRUE
	if(send_update)
		SStgui.update_uis(src)

/datum/mark_menu_ui/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/choose_mark),
	)

/datum/mark_menu_ui/ui_static_data(mob/user)
	var/mob/living/carbon/xenomorph/X = user
	if(!istype(X))
		return

	. = list()

	var/list/mark_meanings = list()
	for(var/type in GLOB.resin_mark_meanings)
		var/list/entry = list()
		var/datum/xeno_mark_define/RC = GLOB.resin_mark_meanings[type]

		entry["name"] = RC.name
		entry["desc"] = RC.desc
		entry["id"] = "[type]"
		entry["image"] = RC.icon_state

		mark_meanings += list(entry)

	.["mark_meanings"] = mark_meanings

/datum/mark_menu_ui/ui_data(mob/user)
	var/mob/living/carbon/xenomorph/X = user

	if(!istype(X))
		return

	. = list()
	.["selected_mark"] = X.selected_mark
	.["tracked_mark"] = X.tracked_marker
	.["is_leader"] = X.hive_pos
	.["user_nicknumber"] = X.nicknumber

	var/list/mark_list_infos = list()
	for(var/type in X.hive.resin_marks)
		var/list/entry = list()
		var/obj/effect/alien/resin/marker/RM = type
		var/mark_owner = null
		var/mark_owner_name = null
		for(var/mob/living/carbon/xenomorph/XX in X.hive.totalXenos)
			if(XX.nicknumber == RM.createdby)
				mark_owner = XX.nicknumber
				mark_owner_name = XX.name
		RM.weak_reference = WEAKREF(RM)

		entry["owner"] = mark_owner
		entry["owner_name"] = mark_owner_name
		entry["name"] = RM.mark_meaning.name
		entry["desc"] = RM.mark_meaning.desc
		entry["area"] = get_area_name(RM)
		entry["id"] = RM.weak_reference.reference
		entry["image"] = RM.mark_meaning.icon_state
		entry["time"] = RM.createdTime
		entry["watching"] = RM.xenos_tracking

		mark_list_infos += list(entry)

	.["mark_list_infos"] = mark_list_infos
	.["tracked_mark"] = null
	if(X.tracked_marker)
		var/datum/weakref/weak_reference = WEAKREF(X.tracked_marker)
		if(weak_reference) // WEAKREF also tested QDELETED
			.["tracked_mark"] = weak_reference.reference

/datum/mark_menu_ui/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MarkMenu", "Mark Menu")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/mark_menu_ui/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/mark_menu_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/mark_menu_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/X = usr

	if(!istype(X))
		return

	switch(action)
		if("choose_mark")
			var/selected_type = text2path(params["type"])
			if(!ispath(selected_type, /datum/xeno_mark_define)) // Hacky fix
				return
			var/datum/xeno_mark_define/x = new selected_type
			var/datum/action/xeno_action/activable/info_marker/Xenos_mark_info_action
			to_chat(X, SPAN_NOTICE("You will now declare '<b>[x.name]</b>!' when marking resin."))
			//update the button's overlay with new choice
			for(var/datum/action/xeno_action/XA in X.actions)
				if(istype(XA, /datum/action/xeno_action/activable/info_marker))
					Xenos_mark_info_action = XA
					Xenos_mark_info_action.update_button_icon(x)
					break
			X.selected_mark = selected_type
			. = TRUE

		if("watch")
			var/obj/effect/alien/resin/marker/mark_to_watch = locate(params["type"])
			if(!mark_to_watch)
				return
			to_chat(X, SPAN_XENONOTICE("You psychically observe the [mark_to_watch.mark_meaning.name] resin mark in [get_area_name(mark_to_watch)]."))
			X.overwatch(mark_to_watch) //this is so scuffed, sorry if this causes errors
			update_all_data()
			. = TRUE

		if("track")
			var/obj/effect/alien/resin/marker/mark_to_track = locate(params["type"])
			if(!mark_to_track)
				return
			X.start_tracking_resin_mark(mark_to_track)
			update_all_data()
			. = TRUE
		if("destroy")
			var/obj/effect/alien/resin/marker/mark_to_destroy = locate(params["type"])
			if(!mark_to_destroy)
				return
			if(mark_to_destroy.createdby == X.nicknumber)
				to_chat(X, SPAN_XENONOTICE("You psychically command the [mark_to_destroy.mark_meaning.name] resin mark to be destroyed."))
				qdel(mark_to_destroy)
				update_all_data()
				. = TRUE
				return
			else if(isqueen(X))
				var/mob/living/carbon/xenomorph/mark_to_destroy_owner
				to_chat(X, SPAN_XENONOTICE("You psychically command the [mark_to_destroy.mark_meaning.name] resin mark to be destroyed."))
				for(var/mob/living/carbon/xenomorph/XX in X.hive.totalXenos)
					if(XX.nicknumber == mark_to_destroy.createdby)
						mark_to_destroy_owner = XX
				to_chat(mark_to_destroy_owner, SPAN_XENONOTICE("Your [mark_to_destroy.mark_meaning.name] resin mark was commanded to be destroyed by [X.name]."))
				qdel(mark_to_destroy)
				update_all_data()
				. = TRUE
				return
			to_chat(X, SPAN_XENONOTICE("You lack the permissions to do this."))
			return
		if("force")
			var/obj/effect/alien/resin/marker/mark_to_force = locate(params["type"])
			if(!mark_to_force)
				return
			if(!isqueen(X))
				to_chat(X, SPAN_XENONOTICE("You lack the permissions to do this."))
				return
			var/FunkTownOhyea = "Force all to track"
			var/list/possible_xenos = list()
			possible_xenos |= FunkTownOhyea
			for(var/mob/living/carbon/xenomorph/T in GLOB.living_xeno_list)
				if (T != X && !should_block_game_interaction(T) && X.hivenumber == T.hivenumber)
					possible_xenos += T

			var/mob/living/carbon/xenomorph/selected_xeno = tgui_input_list(X, "Target", "Watch which xenomorph?", possible_xenos, theme="hive_status")

			if(selected_xeno == FunkTownOhyea)
				for(var/mob/living/carbon/xenomorph/forced_xeno in X.hive.totalXenos)
					forced_xeno.stop_tracking_resin_mark(FALSE, TRUE)
					to_chat(forced_xeno, SPAN_XENOANNOUNCE("Hive! Your queen commands: [mark_to_force.mark_meaning.desc] in [get_area_name(mark_to_force)]. (<a href='byond://?src=\ref[X];overwatch=1;target=\ref[mark_to_force]'>Watch</a>) (<a href='byond://?src=\ref[X];track=1;target=\ref[mark_to_force]'>Track</a>)"))
					forced_xeno.start_tracking_resin_mark(mark_to_force)
					forced_xeno.hud_used.locate_marker.overlays.Cut()
					flick("marker_alert", forced_xeno.hud_used.locate_marker)
					. = TRUE
				update_all_data()
				return
			if (!selected_xeno || QDELETED(selected_xeno) || selected_xeno.stat == DEAD || should_block_game_interaction(selected_xeno) || !X.check_state(1))
				return
			else
				selected_xeno.stop_tracking_resin_mark(FALSE, TRUE)
				to_chat(selected_xeno, SPAN_XENOBOLDNOTICE("Your queen commands you to follow: [mark_to_force.mark_meaning.desc] in [get_area_name(mark_to_force)]. (<a href='byond://?src=\ref[X];overwatch=1;target=\ref[mark_to_force]'>Watch</a>) (<a href='byond://?src=\ref[X];track=1;target=\ref[mark_to_force]'>Track</a>)"))
				selected_xeno.start_tracking_resin_mark(mark_to_force)
				update_all_data()
				. = TRUE
