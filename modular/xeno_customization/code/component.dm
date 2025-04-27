/datum/component/xeno_customization
	dupe_mode = COMPONENT_DUPE_ALLOWED
	/// The thing to show
	var/datum/xeno_customization_option/option
	/// What is actually showed
	var/image/to_show
	/// List of players who are ready/already see customization
	var/list/mob/seeables = list()
	/// Holds xeno's icon for full body customization
	var/icon/original_icon
	/// Holds xeno's image for showing full body customization
	var/image/original_image

/datum/component/xeno_customization/Initialize(datum/xeno_customization_option/option)
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/xenomorph/xeno = parent

	src.option = option
	to_show = image(option.icon_path, parent)
	if(option.full_body_customization)
		original_icon = xeno.icon
		original_image = image(xeno.icon, xeno)
	update_customization_icons(xeno, xeno.icon_state)
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(on_new_player_login))
	for(var/mob/player in GLOB.player_list)
		add_to_player_view(player)

/datum/component/xeno_customization/RegisterWithParent()
	RegisterSignal(parent, COMSIG_XENO_UPDATE_ICONS, PROC_REF(update_customization_icons))
	RegisterSignal(parent, COMSIG_ALTER_GHOST, PROC_REF(on_ghost))

/datum/component/xeno_customization/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_XENO_UPDATE_ICONS)
	UnregisterSignal(parent, COMSIG_ALTER_GHOST)

/datum/component/xeno_customization/Destroy(force, silent)
	remove_from_everyone_view(full_remove = TRUE)
	qdel(to_show)
	if(option.full_body_customization)
		var/mob/living/carbon/xenomorph/xeno = parent
		xeno.icon = original_icon
		qdel(original_image)
		original_icon = null
	. = ..()

/datum/component/xeno_customization/proc/on_ghost(mob/user, mob/dead/observer/ghost)
	SIGNAL_HANDLER

	if(!option.full_body_customization)
		return
	ghost.icon = to_show.icon

/datum/component/xeno_customization/proc/on_new_player_login(subsystem, mob/user)
	SIGNAL_HANDLER

	add_to_player_view(user)

/datum/component/xeno_customization/proc/add_to_player_view(mob/user)
	SIGNAL_HANDLER

	if(!user.client)
		return
	if(!(user in seeables))
		seeables += user
		RegisterSignal(user, COMSIG_XENO_CUSTOMIZATION_VISIBILITY, PROC_REF(add_to_player_view))
		RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(on_viewer_destroy))
	if(!check_visibility_pref(user))
		remove_from_player_view(user)
		return
	user.client.images |= to_show
	if(option.full_body_customization)
		user.client.images -= original_image

/datum/component/xeno_customization/proc/remove_from_player_view(mob/user, full_remove = FALSE)
	SIGNAL_HANDLER

	if(!user.client)
		return
	user.client.images -= to_show
	if(option.full_body_customization && !full_remove)
		user.client.images += original_image

/datum/component/xeno_customization/proc/remove_from_everyone_view(full_remove = FALSE)
	for(var/mob/player in seeables)
		remove_from_player_view(player, full_remove)

/datum/component/xeno_customization/proc/on_viewer_destroy(mob/user)
	SIGNAL_HANDLER

	seeables -= user
	UnregisterSignal(user, COMSIG_XENO_CUSTOMIZATION_VISIBILITY)
	UnregisterSignal(user, COMSIG_PARENT_QDELETING)

/datum/component/xeno_customization/proc/check_visibility_pref(mob/user)
	switch(user.client.prefs.xeno_customization_visibility)
		if(XENO_CUSTOMIZATION_SHOW_ALL)
			if(option.customization_type == XENO_CUSTOMIZATION_NON_LORE_FRIENDLY && !(isxeno(user) || isobserver(user)))
				return FALSE
			return TRUE
		if(XENO_CUSTOMIZATION_SHOW_NONE)
			return FALSE
		if(XENO_CUSTOMIZATION_SHOW_LORE_FRIENDLY)
			if(option.customization_type == XENO_CUSTOMIZATION_NON_LORE_FRIENDLY)
				return FALSE
			return TRUE
	return TRUE

/datum/component/xeno_customization/proc/update_customization_icons(mob/living/carbon/xenomorph/xeno, icon_state)
	SIGNAL_HANDLER

	to_show.layer = xeno.layer

	if(option.full_body_customization)
		xeno.icon = null
		to_show.icon_state = icon_state
		original_image.icon_state = icon_state
		if(!(icon_state in icon_states(option.icon_path)))
			xeno.icon = original_icon
		return

	var/list/split = splittext(icon_state, " ")
	var/xeno_state = split[length(split)]
	if(xeno_state == "Down" && split[length(split) - 1] == "Knocked")
		xeno_state = "Knocked Down"
	to_show.icon_state = xeno_state
