/datum/escape_menu/proc/show_admin_buttons()
	if(!check_client_rights(client, R_MOD, FALSE))
		return

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Return",
			/* offset = */ 0,
			CALLBACK(src, PROC_REF(home_main_page)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Chem Panel",
			/* offset = */ 2,
			CALLBACK(src, PROC_REF(home_chem)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Event Panel",
			/* offset = */ 3,
			CALLBACK(src, PROC_REF(home_event)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Game Panel",
			/* offset = */ 4,
			CALLBACK(src, PROC_REF(home_game)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Medals Panel",
			/* offset = */ 5,
			CALLBACK(src, PROC_REF(home_medal)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Tacmaps Panel",
			/* offset = */ 6,
			CALLBACK(src, PROC_REF(home_tacmaps)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Teleport Panel",
			/* offset = */ 7,
			CALLBACK(src, PROC_REF(home_teleport)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Inview Panel",
			/* offset = */ 8,
			CALLBACK(src, PROC_REF(home_inview)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Unban Panel",
			/* offset = */ 9,
			CALLBACK(src, PROC_REF(home_unban)),
		)
	)

	page_holder.give_screen_object(
		new /atom/movable/screen/escape_menu/home_button(
			null,
			src,
			"Shuttle Manipulator",
			/* offset = */ 10,
			CALLBACK(src, PROC_REF(home_shuttle)),
		)
	)


/datum/escape_menu/proc/home_chem()
	if(!client?.admin_holder.check_for_rights(R_MOD))
		return

	client?.admin_holder.chempanel()

/datum/escape_menu/proc/home_event()
	if(!client?.admin_holder.check_for_rights(R_ADMIN))
		return

	client?.admin_holder.event_panel()

/datum/escape_menu/proc/home_game()
	if(!client?.admin_holder.check_for_rights(R_SPAWN))
		return

	client?.admin_holder.Game()

/datum/escape_menu/proc/home_medal()
	if(!client?.admin_holder.check_for_rights(R_MOD))
		return

	GLOB.medals_panel.tgui_interact(client?.mob)

/datum/escape_menu/proc/home_tacmaps()
	if(!client?.admin_holder.check_for_rights(R_ADMIN|R_MOD))
		return

	GLOB.tacmap_admin_panel.tgui_interact(client?.mob)

/datum/escape_menu/proc/home_teleport()
	if(!client?.admin_holder.check_for_rights(R_MOD))
		return

	client?.admin_holder.teleport_panel()

/datum/escape_menu/proc/home_inview()
	if(!client?.admin_holder.check_for_rights(R_MOD))
		return

	client?.admin_holder.in_view_panel()

/datum/escape_menu/proc/home_unban()
	if(!client?.admin_holder.check_for_rights(R_BAN))
		return

	client?.admin_holder.unbanpanel()

/datum/escape_menu/proc/home_shuttle()
	if(!client?.admin_holder.check_for_rights(R_ADMIN|R_DEBUG|R_HOST))
		return

	SSshuttle.tgui_interact(client?.mob)
