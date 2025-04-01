/datum/tech
	var/name = "tech"
	var/desc = "placeholder description"

	var/icon = 'icons/effects/techtree/tech.dmi'
	var/icon_state = "unknown"

	var/flags = NO_FLAGS
	var/tech_flags = NO_FLAGS

	var/required_points = 0
	var/datum/tier/tier = /datum/tier/one

	var/unlocked = FALSE

	var/datum/techtree/holder

	// Variables for the physical node in the tree
	var/obj/effect/node

	var/background_icon = "background"
	var/background_icon_locked = "marine"

	var/announce_name = "ALMAYER SPECIAL ASSETS AUTHORIZED"
	var/announce_message

	var/is_tier_changer = FALSE

/datum/tech/proc/can_unlock(mob/M)
	SHOULD_CALL_PARENT(TRUE)

	if(!holder.has_access(M, TREE_ACCESS_MODIFY))
		to_chat(M, SPAN_WARNING("You lack the necessary permission required to use this tree"))
		return

	if(!check_tier_level(M))
		return

	if(!(type in holder.all_techs[tier.type]))
		to_chat(M, SPAN_WARNING("You cannot purchase this node!"))
		return

	if(!holder.can_use_points(required_points))
		to_chat(M, SPAN_WARNING("Not enough points to purchase this node."))
		return

	return TRUE

/datum/tech/proc/check_tier_level(mob/M)
	if(holder.tier.tier < tier.tier)
		if(M)
			to_chat(M, SPAN_WARNING("This tier level has not been unlocked yet!"))
		return FALSE

	var/datum/tier/t_target = holder.tree_tiers[tier.type]
	if(t_target.max_techs != INFINITE_TECHS && LAZYLEN(holder.unlocked_techs[tier.type]) >= t_target.max_techs)
		if(M)
			to_chat(M, SPAN_WARNING("You can't purchase any more techs of this tier!"))
		return FALSE

	return TRUE


/** Called when a tech is unlocked. Usually, benefits can be applied here
* however, the purchase can still be cancelled by returning FALSE
*
* If you sleep in this proc, you must call can_unlock after the sleep ends to make sure you can still purchase the tech in question
**/
/datum/tech/proc/on_unlock(mob/user)
	SHOULD_CALL_PARENT(TRUE)

	unlocked = TRUE
	to_chat(user, SPAN_HELPFUL("You have purchased the '[name]' tech node."))
	log_admin("[key_name_admin(user)] has bought '[name]' via tech points.")
	if(!is_tier_changer)
		var/log_details = announce_message
		if(!log_details)
			log_details = name
		var/current_points = holder.points
		log_ares_tech(user.real_name, is_tier_changer, announce_name, log_details, required_points, current_points)
	holder.spend_points(required_points)
	update_icon(node)

	if(!(tech_flags & TECH_FLAG_NO_ANNOUNCE) && announce_message && announce_name)
		marine_announcement(announce_message, announce_name, 'sound/misc/notice2.ogg', logging = ARES_LOG_NONE)

	return TRUE

/datum/tech/ui_status(mob/user, datum/ui_state/state)
	return holder.ui_status(user, state)

/datum/tech/ui_data(mob/user)
	. = list(
		"total_points" = holder.points,
		"valid_tier" = check_tier_level(),
		"can_afford" = holder.can_use_points(required_points),
		"unlocked" = tech_flags & TECH_FLAG_MULTIUSE? FALSE: unlocked,
		"cost" = required_points
	)

/datum/tech/ui_static_data(mob/user)
	. = list(
		"theme" = holder.ui_theme,
		"name" = name,
		"desc" = desc,
	)

	if(tech_flags & TECH_FLAG_MULTIUSE)
		.["stats"] += list(list(
			"content" = "Repurchasable",
			"color" = "grey",
			"icon" = "cart-plus",
			"tooltip" = "Can be purchased multiple times."
		))

/datum/tech/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TechNode", name)
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/tech/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("purchase")
			holder.purchase_node(usr, src)
			. = TRUE

/datum/tech/proc/on_tree_insertion(datum/techtree/tree)
	holder = tree
	background_icon = tree.background_icon
	background_icon_locked = tree.background_icon_locked

/datum/tech/proc/update_icon(obj/effect/node)
	node.overlays.Cut()
	if(!icon_state)
		node.icon = 'icons/effects/techtree/tech.dmi'
		node.icon_state = null
		return

	node.icon = 'icons/effects/techtree/tech.dmi'
	node.icon_state = "[background_icon]"

	node.overlays += get_tier_overlay()
	node.overlays += image(icon, node, icon_state)

	var/background_icons = 'icons/effects/techtree/tech_64.dmi'
	node.overlays += image(background_icons, node, "background[unlocked? "" : "_locked"]", pixel_x = -16, pixel_y = -16)
	node.overlays += image(background_icons, node, "[background_icon_locked][unlocked? "" : "_locked"]", pixel_x = -16, pixel_y = -16)


/datum/tech/proc/get_tier_overlay()
	var/background_icons = 'icons/effects/techtree/tech_64.dmi'
	var/image/I = image(background_icons, node, "+lines", pixel_x = -16, pixel_y = -16)
	I.color = tier.color

	return I
