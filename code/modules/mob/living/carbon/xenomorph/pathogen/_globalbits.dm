/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

/datum/caste_datum/var/pathogen_creature = FALSE
/datum/caste_datum/pathogen
	minimum_evolve_time = 0
	pathogen_creature = TRUE
	language = LANGUAGE_PATHOGEN

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

/obj/effect/alien/weeds/weedwall/window/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/weedwall/frame/pathogen
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

/datum/action/xeno_action/onclick/plant_weeds/pathogen/popper
	name = "Spread Blight (100)"
	plasma_cost = 100

// LANGUAGE SHIT
/mob/living/carbon/xenomorph/proc/make_pathogen_speaker()
	set_languages(list(LANGUAGE_PATHOGEN, LANGUAGE_PATHOGEN_MIND, LANGUAGE_XENOMORPH))
	langchat_color = "#c2c38d"
	speaking_key = "-"

/datum/language/pathogen
	name = LANGUAGE_PATHOGEN
	color = "pathogen"
	desc = "The common tongue of the Pathogen Confluence."
	speech_verb = "clicks"
	ask_verb = "clicks"
	exclaim_verb = "clicks"
	key = "-"
	flags = RESTRICTED
	syllables = list("sss", "sSs", "SSS")

/datum/language/pathogen_mind
	name = LANGUAGE_PATHOGEN_MIND
	desc = "Pathogen Creatures have the strange ability to commune over a mycelial hivemind."
	speech_verb = "hiveminds"
	ask_verb = "hiveminds"
	exclaim_verb = "hiveminds"
	color = "pathogen"
	key = "q"//Same key as xeno hivemind because it does the same backend, it only appears different for language menu.
	flags = RESTRICTED|HIVEMIND

//Make queens BOLD text
/datum/language/pathogen_mind/broadcast(mob/living/speaker, message, speaker_mask)
	if(iscarbon(speaker))
		var/mob/living/carbon/C = speaker

		if(!(C.hivenumber in GLOB.hive_datum))
			return

		C.hivemind_broadcast(message, GLOB.hive_datum[C.hivenumber])
