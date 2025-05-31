/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

/datum/caste_datum/pathogen/get_minimap_icon()
	var/image/background = mutable_appearance('icons/mob/neo/neo_blips.dmi', minimap_background)

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/mob/neo/neo_blips.dmi', icon_state = iconstate)
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
