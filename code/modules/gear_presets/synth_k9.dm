/datum/equipment_preset/synth_k9
	name = "K9 Synthetic"
	uses_special_name = TRUE
	languages = ALL_SYNTH_LANGUAGES
	skills = /datum/skills/synth_k9
	minimap_icon = "synth_k9"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/gold
	assignment = JOB_SYNTH_K9
	job_title = JOB_SYNTH_K9
	paygrades = list(PAY_SHORT_SYN_K9 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "K9"

/datum/equipment_preset/synth_k9/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/synth_k9/load_race(mob/living/carbon/human/new_human)
	. = ..()
	new_human.h_style = "Bald"
	new_human.f_style = "Shaved"
	if(new_human.client?.prefs?.synthetic_type)
		new_human.set_species(new_human.client.prefs.synthetic_type)
		return
	new_human.set_species(SYNTH_K9)

/datum/equipment_preset/synth_k9/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = "Rex"
	if(new_human.client?.prefs)
		final_name = new_human.client.prefs.synthetic_name
		if(!final_name || final_name == "Undefined")
			final_name = "Rex"
	new_human.change_real_name(new_human, final_name)

/datum/equipment_preset/synth_k9/load_skills(mob/living/carbon/human/new_human)
	. = ..()
	new_human.allow_gun_usage = FALSE
