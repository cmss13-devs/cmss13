/datum/species/synthetic/colonial/working_joe
	name = SYNTH_WORKING_JOE
	name_plural = "Working Joes"
	death_message = "violently gargles fluid and seizes up, the glow in their eyes dimming..."
	uses_skin_color = FALSE
	burn_mod = 0.65 // made for hazardous environments, withstanding temperatures up to 1210 degrees
	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_INTENT_EYES, TRAIT_EMOTE_CD_EXEMPT, TRAIT_CANNOT_EAT, TRAIT_UNSTRIPPABLE, TRAIT_IRON_TEETH)

	slowdown = 0.45
	hair_color = "#000000"
	icobase = 'icons/mob/humans/species/r_synthetic.dmi'
	deform = 'icons/mob/humans/species/r_synthetic.dmi'
	/// Used to assign which variant of emote_panel to give to user
	var/emote_panel_type = /datum/joe_emote_panel

/datum/species/synthetic/colonial/working_joe/hazard
	name = SYNTH_HAZARD_JOE //TECHNICALLY the proper name would be Hazard Working Joes, but we will stick with Hazard Joe for now
	name_plural = "Hazard Joes"
	emote_panel_type = /datum/joe_emote_panel/hazard

/datum/species/synthetic/colonial/working_joe/handle_post_spawn(mob/living/carbon/human/joe)
	. = ..()
	give_action(joe, /datum/action/joe_emote_panel)

// Special death noise for Working Joe
/datum/species/synthetic/colonial/working_joe/handle_death(mob/living/carbon/human/dying_joe, gibbed)
	if(!gibbed) //A gibbed Joe won't have a death rattle
		playsound(dying_joe.loc, pick_weight(list('sound/voice/joe/death_normal.ogg' = 75, 'sound/voice/joe/death_silence.ogg' = 10, 'sound/voice/joe/death_tomorrow.ogg' = 10,'sound/voice/joe/death_dream.ogg' = 5)), 25, FALSE)
	return ..()

/// Open the WJ's emote panel, which allows them to use voicelines
/datum/species/synthetic/colonial/working_joe/open_emote_panel()
	var/datum/joe_emote_panel/ui = new emote_panel_type(usr)
	ui.ui_interact(usr)

/datum/action/joe_emote_panel
	name = "Open Voice Synthesizer"
	action_icon_state = "looc_toggle"


/datum/action/joe_emote_panel/can_use_action()
	. = ..()
	if(!.)
		return FALSE

	if(!isworkingjoe(owner))
		return FALSE

	return TRUE


/datum/action/joe_emote_panel/action_activate()
	. = ..()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/human_owner = owner
	var/datum/species/synthetic/colonial/working_joe/joe_species = human_owner.species
	joe_species.open_emote_panel()


/datum/joe_emote_panel
	COOLDOWN_DECLARE(panel_emote_cooldown)

/datum/joe_emote_panel/proc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "JoeEmotes")
		ui.open()


/datum/joe_emote_panel/ui_state(mob/user)
	return GLOB.conscious_state


/datum/joe_emote_panel/ui_data(mob/user)
	var/list/data = list()

	data["on_cooldown"] = !COOLDOWN_FINISHED(src, panel_emote_cooldown)

	return data


/datum/joe_emote_panel/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = GLOB.wj_categories
	data["emotes"] = list()

	for(var/datum/emote/living/carbon/human/synthetic/working_joe/emote as anything in GLOB.wj_emotes)
		data["emotes"] += list(list(
			"id" = initial(emote.key),
			"text" = (initial(emote.override_say) || initial(emote.say_message)),
			"category" = initial(emote.category),
			"path" = "[emote]",
		))

	return data

/datum/joe_emote_panel/hazard/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = GLOB.hj_categories
	data["emotes"] = list()

	for(var/datum/emote/living/carbon/human/synthetic/working_joe/emote as anything in GLOB.hj_emotes)
		data["emotes"] += list(list(
			"id" = initial(emote.key),
			"text" = (initial(emote.override_say) || initial(emote.say_message)),
			"category" = initial(emote.category),
			"path" = "[emote]",
		))

	return data


/datum/joe_emote_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("emote")
			var/datum/emote/living/carbon/human/synthetic/working_joe/path
			if(!params["emotePath"])
				return

			path = text2path(params["emotePath"])

			if(!path || !COOLDOWN_FINISHED(src, panel_emote_cooldown))
				return

			if(!(path in subtypesof(/datum/emote/living/carbon/human/synthetic/working_joe)))
				return

			COOLDOWN_START(src, panel_emote_cooldown, 2.5 SECONDS)
			usr.emote(initial(path.key))
			return TRUE
