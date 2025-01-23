#define INJECTABLE_TAG		(1<<0)
#define REPROGRAMMABLE_TAG	(1<<1)
#define ORGAN_TAG			(1<<2)

DEFINE_BITFIELD(iff_flag_flags, list(
	"INJECTABLE_TAG" = INJECTABLE_TAG,
	"REPROGRAMMABLE_TAG" = REPROGRAMMABLE_TAG,
	"ORGAN_TAG" = ORGAN_TAG,
))

/mob
	var/obj/item/faction_tag/organ/organ_faction_tag = null
	var/obj/item/faction_tag/faction_tag = null

/obj/item/faction_tag
	name = "Faction IFF tag"
	desc = "A tag containing a small IFF computer that gets inserted into the body. You can modify the IFF groups by using an access tuner on it, or on the body of implanted if it's already implanted."
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "iff_tag"

	var/tag_flags = INJECTABLE_TAG|REPROGRAMMABLE_TAG
	var/ally_factions_initialize = TRUE
	var/list/datum/faction/factions = list()

	var/faction_to_get = null
	var/datum/faction/faction = null

/obj/item/faction_tag/Initialize(mapload, _faction_to_get)
	. = ..()
	if(_faction_to_get)
		faction_to_get = _faction_to_get
		faction = GLOB.faction_datums[_faction_to_get]
		if(faction)
			factions |= faction
			if(ally_factions_initialize)
				for(var/datum/faction/faction_ally in faction.relations_datum.allies)
					factions |= faction_ally

/obj/item/faction_tag/attack(mob/living/carbon/mob, mob/living/carbon/injector)
	if((isxeno(mob) || ishuman(mob)) && tag_flags & INJECTABLE_TAG)
		if(mob.stat == DEAD)
			to_chat(injector, SPAN_WARNING("\The [mob] is dead..."))
			return
		if(mob.faction_tag)
			to_chat(injector, SPAN_WARNING("\The [mob] already has a tag inside it."))
			return
		injector.visible_message(SPAN_NOTICE("[injector] starts forcing \the [src] into [mob]'s body..."), SPAN_NOTICE("You start forcing \the [src] into [mob]'s body..."))
		if(!do_after(injector, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, mob, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		injector.visible_message(SPAN_NOTICE("[injector] forces \the [src] into [mob]'s body!"), SPAN_NOTICE("You force \the [src] into [mob]'s body!"))
		mob.faction_tag = src
		injector.drop_inv_item_to_loc(src, mob)
		return
	return ..()

/obj/item/faction_tag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) && ishuman(user) && tag_flags & REPROGRAMMABLE_TAG)
		handle_reprogramming(user)
		return
	return ..()

/obj/item/faction_tag/proc/handle_reprogramming(mob/living/carbon/human/programmer, mob/living/carbon/mob)
	var/list/datum/faction/id_faction_groups = programmer.faction
	var/option = tgui_alert(programmer, "Current Faction IFF reads as: [english_list(factions, "None")]\nYour ID's Faction IFF reads as: [english_list(id_faction_groups, "None")]", "Faction IFF Tag", list("Overwrite", "Add", "Remove"))
	if(!option)
		return FALSE
	if(mob)
		if(!mob.faction_tag)
			to_chat(programmer, SPAN_WARNING("\The [src]'s tag got removed while you were reprogramming it!"))
			return FALSE
		if(!programmer.Adjacent(mob))
			to_chat(programmer, SPAN_WARNING("You need to stay close to the tag to reprogram the tag!"))
			return FALSE
	switch(option)
		if("Overwrite")
			factions = id_faction_groups
		if("Add")
			factions |= id_faction_groups
		if("Remove")
			factions = list()
	to_chat(programmer, SPAN_NOTICE("You <b>[option]</b> the Faction IFF data, the Faction IFF on the tag now reads as: [english_list(factions, "None")]"))
	return TRUE

/obj/item/faction_tag/organ
	name = "Sticky Gland"
	desc = "Strange organic object, that somehow help to be indentificated."
	icon_state = "gland_tag"
	tag_flags = ORGAN_TAG

/obj/item/faction_tag/organ/zombie
	faction_to_get = FACTION_ZOMBIE

/obj/item/faction_tag/organ/xenomorph
	faction_to_get = FACTION_XENOMORPH

/obj/item/faction_tag/organ/xenomorph/normal
	faction_to_get = FACTION_XENOMORPH_NORMAL

/obj/item/faction_tag/organ/xenomorph/corrupted
	faction_to_get = FACTION_XENOMORPH_CORRUPTED

/obj/item/faction_tag/organ/xenomorph/alpha
	faction_to_get = FACTION_XENOMORPH_ALPHA

/obj/item/faction_tag/organ/xenomorph/bravo
	faction_to_get = FACTION_XENOMORPH_BRAVO

/obj/item/faction_tag/organ/xenomorph/charlie
	faction_to_get = FACTION_XENOMORPH_CHARLIE

/obj/item/faction_tag/organ/xenomorph/delta
	faction_to_get = FACTION_XENOMORPH_DELTA

/obj/item/faction_tag/organ/xenomorph/feral
	faction_to_get = FACTION_XENOMORPH_FERAL

/obj/item/faction_tag/organ/xenomorph/forsaken
	faction_to_get = FACTION_XENOMORPH_FORSAKEN

/obj/item/faction_tag/organ/xenomorph/tamed
	faction_to_get = FACTION_XENOMORPH_TAMED

/obj/item/faction_tag/organ/xenomorph/mutated
	faction_to_get = FACTION_XENOMORPH_MUTATED

/obj/item/faction_tag/organ/xenomorph/yautja
	faction_to_get = FACTION_XENOMORPH_YAUTJA

/obj/item/faction_tag/organ/xenomorph/renegade
	faction_to_get = FACTION_XENOMORPH_RENEGADE

/obj/item/faction_tag/colonist
	faction_to_get = FACTION_COLONIST

/obj/item/faction_tag/contractor
	faction_to_get = FACTION_CONTRACTOR

/obj/item/faction_tag/uscm
	faction_to_get = FACTION_USCM

/obj/item/faction_tag/uscm/marine
	faction_to_get = FACTION_MARINE

/obj/item/faction_tag/uscm/cmb
	faction_to_get = FACTION_CMB

/obj/item/faction_tag/uscm/marsoc
	ally_factions_initialize = FALSE
	faction_to_get = FACTION_MARSOC

/obj/item/faction_tag/wy
	faction_to_get = FACTION_WY

/obj/item/faction_tag/wy/pmc_handler
	faction_to_get = FACTION_USCM

/obj/item/faction_tag/wy/pmc
	faction_to_get = FACTION_PMC

/obj/item/faction_tag/wy/death_sqaud
	ally_factions_initialize = FALSE
	faction_to_get = FACTION_WY_DEATHSQUAD

/obj/item/faction_tag/upp
	faction_to_get = FACTION_UPP

/obj/item/faction_tag/clf
	faction_to_get = FACTION_CLF

/obj/item/faction_tag/contractor
	faction_to_get = FACTION_CONTRACTOR

/obj/item/faction_tag/freelancer
	faction_to_get = FACTION_FREELANCER

//CASE FOR TAGS
/obj/item/storage/tag_case
	name = "tag case"
	desc = "A sturdy case designed to store IFF tags."
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "tag_box"
	use_sound = "toolbox"
	storage_slots = 8
	can_hold = list(
		/obj/item/faction_tag,
		/obj/item/device/multitool
	)
	black_market_value = 25

/obj/item/storage/tag_case/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/faction_tag(src)
	new /obj/item/device/multitool(src)

/obj/item/storage/tag_case/uscm/marine

/obj/item/storage/tag_case/uscm/marine/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/faction_tag/uscm/marine(src)
	new /obj/item/device/multitool(src)

/obj/item/storage/tag_case/wy

/obj/item/storage/tag_case/wy/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/faction_tag/wy(src)
	new /obj/item/device/multitool(src)

/mob/attackby(obj/item/item, mob/user)
	if(ishuman(user))
		if(user.a_intent == INTENT_HELP && HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
			var/mob/living/carbon/human/programmer = user
			if(!faction_tag)
				to_chat(user, SPAN_WARNING("\The [src] doesn't have an Faction IFF tag to reprogram."))
				return
			programmer.visible_message(SPAN_NOTICE("[programmer] starts reprogramming \the [src]'s [faction_tag]..."), SPAN_NOTICE("You start reprogramming \the [src]'s [faction_tag]..."), max_distance = 3)
			if(!do_after(programmer, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
				return
			if(!faction_tag)
				to_chat(programmer, SPAN_WARNING("\The [src]'s Faction IFF tag got removed while you were reprogramming it!"))
				return
			if(!faction_tag.handle_reprogramming(programmer, src))
				return
			programmer.visible_message(SPAN_NOTICE("[programmer] reprograms \the [src]'s [faction_tag]."), SPAN_NOTICE("You reprogram \the [src]'s [faction_tag]."), max_distance = 3)
			return
		if(user.a_intent != INTENT_HELP && (item.type in SURGERY_TOOLS_PINCH))
			if(!faction_tag)
				to_chat(user, SPAN_WARNING("\The [src] doesn't have an Faction IFF tag to remove."))
				return
			user.visible_message(SPAN_NOTICE("[user] starts removing \the [src]'s [faction_tag]..."), SPAN_NOTICE("You start removing \the [src]'s [faction_tag]..."), max_distance = 3)
			if(!do_after(user, 5 SECONDS * SURGERY_TOOLS_PINCH[item.type], INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
				return
			if(!faction_tag)
				to_chat(user, SPAN_WARNING("\The [src]'s Faction IFF tag got removed while you were removing it!"))
				return
			user.put_in_hands(faction_tag)
			faction_tag = null
			user.visible_message(SPAN_NOTICE("[user] removes \the [src]'s Faction IFF tag."), SPAN_NOTICE("You remove \the [src]'s Faction IFF tag."), max_distance = 3)
			return
	. = ..()

/*
/obj/item/iff_tag
	name = "xenomorph IFF tag"
	desc = "A tag containing a small IFF computer that gets inserted into the carapace of a xenomorph. You can modify the IFF groups by using an access tuner on it, or on the xeno if it's already implanted."
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "xeno_tag"
	var/list/faction_groups = list()

/obj/item/iff_tag/attack(mob/living/carbon/xenomorph/xeno, mob/living/carbon/human/injector)
	if(isxeno(xeno))
		if(xeno.stat == DEAD)
			to_chat(injector, SPAN_WARNING("\The [xeno] is dead..."))
			return
		if(xeno.iff_tag)
			to_chat(injector, SPAN_WARNING("\The [xeno] already has a tag inside it."))
			return
		injector.visible_message(SPAN_NOTICE("[injector] starts forcing \the [src] into [xeno]'s carapace..."), SPAN_NOTICE("You start forcing \the [src] into [xeno]'s carapace..."))
		if(!do_after(injector, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, xeno, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		injector.visible_message(SPAN_NOTICE("[injector] forces \the [src] into [xeno]'s carapace!"), SPAN_NOTICE("You force \the [src] into [xeno]'s carapace!"))
		xeno.iff_tag = src
		injector.drop_inv_item_to_loc(src, xeno)
		if(xeno.hive.hivenumber == XENO_HIVE_RENEGADE) //it's important to know their IFF settings for renegade
			to_chat(xeno, SPAN_NOTICE("With the insertion of the device into your carapace, your instincts have changed compelling you to protect [english_list(faction_groups, "no one")]."))
		return
	return ..()

/obj/item/iff_tag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) && ishuman(user))
		handle_reprogramming(user)
		return
	return ..()

/obj/item/iff_tag/proc/handle_reprogramming(mob/living/carbon/human/programmer, mob/living/carbon/xenomorph/xeno)
	var/list/id_faction_groups = programmer.get_id_faction_group()
	var/option = tgui_alert(programmer, "The xeno tag's current IFF groups reads as: [english_list(faction_groups, "None")]\nYour ID's IFF group reads as: [english_list(id_faction_groups, "None")]", "Xenomorph IFF Tag", list("Overwrite", "Add", "Remove"))
	if(!option)
		return FALSE
	if(xeno)
		if(!xeno.iff_tag)
			to_chat(programmer, SPAN_WARNING("\The [src]'s tag got removed while you were reprogramming it!"))
			return FALSE
		if(!programmer.Adjacent(xeno))
			to_chat(programmer, SPAN_WARNING("You need to stay close to the xenomorph to reprogram the tag!"))
			return FALSE
	switch(option)
		if("Overwrite")
			faction_groups = id_faction_groups
		if("Add")
			faction_groups |= id_faction_groups
		if("Remove")
			faction_groups = list()
	to_chat(programmer, SPAN_NOTICE("You <b>[option]</b> the IFF group data, the IFF group on the tag now reads as: [english_list(faction_groups, "None")]"))
	if(xeno?.hive.hivenumber == XENO_HIVE_RENEGADE) //it's important to know their IFF settings for renegade
		to_chat(xeno, SPAN_NOTICE("Your instincts have changed, you seem compelled to protect [english_list(faction_groups, "no one")]."))
	return TRUE

/obj/item/iff_tag/pmc_handler
	faction_groups = FACTION_LIST_MARINE_WY


/obj/item/storage/xeno_tag_case
	name = "xenomorph tag case"
	desc = "A sturdy case designed to store and charge xenomorph IFF tags. Provided by the Wey-Yu Research and Data(TM) Division."
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "tag_box"
	use_sound = "toolbox"
	storage_slots = 8
	can_hold = list(
		/obj/item/iff_tag,
		/obj/item/device/multitool,
	)
	black_market_value = 25

/obj/item/storage/xeno_tag_case/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/iff_tag(src)
	new /obj/item/device/multitool(src)
*/
