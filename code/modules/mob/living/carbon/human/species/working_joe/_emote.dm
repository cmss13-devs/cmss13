/datum/emote/living/carbon/human/synthetic/working_joe
	species_type_allowed_typecache = list(/datum/species/synthetic/colonial/working_joe)
	keybind_category = CATEGORY_SYNTH_EMOTE
	volume = 75
	/// A general category for the emote, for use in the WJ emote panel. See [code/__DEFINES/emote_panels.dm] for categories.
	var/category = ""
	/// Override text for the emote to be displayed in the WJ emote panel
	var/override_say = ""
	/// Path to hazard joe variant sound
	var/haz_sound
	/// What Working Joe types can use this emote
	var/joe_flag = WORKING_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/get_sound(mob/living/user)
	if(ishazardjoe(user) && haz_sound)
		return haz_sound
	return sound
