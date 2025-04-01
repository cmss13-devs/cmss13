/obj/structure/techpod_vendor
	name = "ColMarTech Techpod Vendor"
	desc = "An automated gear rack hooked up to a tech gear storage."
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "intel_gear"
	anchored = TRUE
	wrenchable = FALSE
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

	//per faction access
	var/faction_requirement = FACTION_MARINE
	//set to TRUE to allow everyone to use it on distress beacon mode OR to limit to roles above on all other modes.
	var/access_settings_override = FALSE

/obj/structure/techpod_vendor/attack_hand(mob/user)
	var/area/a = get_area(src)
	//no idea why it was made just a structure, so this is gonna be here for now
	if(!a || a.requires_power && !a.unlimited_power && !a.power_equip)
		return

	if(!ishuman(user) || !get_access_permission(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/list/list_of_techs = list()

	/*
	for(var/i in GLOB.unlocked_droppod_techs)
		var/datum/tech/droppod/droppod_tech = i
		if(!droppod_tech.can_access(user))
			continue
		list_of_techs[droppod_tech.name] = droppod_tech
	*/

	if(!length(list_of_techs))
		to_chat(user, SPAN_WARNING("No tech gear is available at the moment!"))
		return

	var/user_input = tgui_input_list(user, "Choose a tech to retrieve an item from.", name, list_of_techs)
	if(!user_input)
		return

/obj/structure/techpod_vendor/proc/get_access_permission(mob/living/carbon/human/user)
	if(SSticker.mode == GAMEMODE_WHISKEY_OUTPOST || GLOB.master_mode == GAMEMODE_WHISKEY_OUTPOST) //all WO has lifted access restrictions
		return TRUE
	else if(SSticker.mode == "Distress Signal" || GLOB.master_mode == "Distress Signal")
		if(access_settings_override) //everyone allowed to grab stuff
			return TRUE
		else if(user.get_target_lock(faction_requirement)) //only it's faction group allowed
			return TRUE
	else
		if(access_settings_override)
			if(user.get_target_lock(faction_requirement)) //vica versa for extended and other modes, allowed by default, not allowed with override
				return TRUE
		else
			return TRUE

	return FALSE
