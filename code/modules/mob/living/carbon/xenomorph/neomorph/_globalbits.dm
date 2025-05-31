/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

/datum/caste_datum/pathogen/get_minimap_icon()
	var/image/background = mutable_appearance('icons/mob/neo/neo_blips.dmi', minimap_background)

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/mob/neo/neo_blips.dmi', icon_state = iconstate)
	icon.appearance_flags = RESET_COLOR
	background.overlays += icon

	return background



/datum/admins/var/create_neomorphs_html = null
/datum/admins/proc/create_neomorphs(mob/user)
	if(!create_xenos_html)
		var/hive_types = XENO_HIVE_NEOMORPH
		var/xeno_types = jointext(ALL_NEOMORPH_CASTES, ";")
		create_neomorphs_html = file2text('html/create_xenos.html')
		create_neomorphs_html = replacetext(create_neomorphs_html, "null /* hive paths */", "\"[hive_types]\"")
		create_neomorphs_html = replacetext(create_neomorphs_html, "null /* xeno paths */", "\"[xeno_types]\"")
		create_neomorphs_html = replacetext(create_neomorphs_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_neomorphs_html, "/* ref src */", "\ref[src]"), "Create Neomorphs", "create_neomorphs", width = 450, height = 630)

/client/proc/create_neomorphs()
	set name = "Create Neomorphs"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_neomorphs(usr)
