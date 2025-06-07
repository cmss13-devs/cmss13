/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

/datum/caste_datum/pathogen
	minimum_evolve_time = 0

/datum/caste_datum/pathogen/get_minimap_icon()
	var/image/background = mutable_appearance('icons/mob/pathogen/neo_blips.dmi', minimap_background)

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/mob/pathogen/neo_blips.dmi', icon_state = iconstate)
	icon.appearance_flags = RESET_COLOR
	background.overlays += icon

	return background



/datum/admins/var/create_pathogen_creatures_html = null
/datum/admins/proc/create_pathogen_creatures(mob/user)
	if(!create_xenos_html)
		var/hive_types = XENO_HIVE_PATHOGEN
		var/xeno_types = jointext(ALL_PATHOGEN_CREATURES, ";")
		create_pathogen_creatures_html = file2text('html/create_xenos.html')
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "null /* hive paths */", "\"[hive_types]\"")
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "null /* xeno paths */", "\"[xeno_types]\"")
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_pathogen_creatures_html, "/* ref src */", "\ref[src]"), "Create Pathogen Creatures", "create_pathogen_creatures", width = 450, height = 630)

/client/proc/create_pathogen_creatures()
	set name = "Create Pathogen Creatures"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_pathogen_creatures(usr)


/// WEEDS
/obj/effect/alien/weeds/node/pathogen
	name = "mycelium blight node"
	desc = "A weird, pulsating node."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/weedwall/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/datum/action/xeno_action/onclick/plant_weeds/pathogen
	name = "Spread Blight (200)"
	action_icon_state = "plant_weeds"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_plant_weeds
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 1 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	plant_on_semiweedable = TRUE
	node_type = /obj/effect/alien/weeds/node/pathogen
