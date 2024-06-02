/datum/emote/living/carbon/human/yautja
	species_type_allowed_typecache = list(/datum/species/yautja)
	keybind_category = CATEGORY_YAUTJA_EMOTE
	emote_type = EMOTE_AUDIBLE
	/// A general category for the emote, for use in the Yautja emote panel. See [code/__DEFINES/emote_panels.dm] for categories.
	var/category = ""
	/// Override text for the emote to be displayed in the Yautja emote panel
	var/override_say = ""
	/// Override for being in panel or not
	var/no_panel = FALSE
