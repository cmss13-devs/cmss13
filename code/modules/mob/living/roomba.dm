/// A cheap little roomba that runs around and keeps ground clean to decrease maptick and marines always make fucking mess at fob.
/mob/living/roomba
	name = "Roomba"
	desc = "A robot vacuum cleaner. The roomba is designed to keep areas clean from dirty marines."
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "roomba"
	speed = 1
	mob_size = MOB_SIZE_SMALL
	health = 80
	maxHealth = 80
	var/vaccum = TRUE
	var/mopping = TRUE
	var/list/target_vaccum_types = list() //defines list for vaccum
	var/list/target_mopping_types = list() //defines list for mopping

// --- Initializes anything you need on load, its essential for lists, action buttons, updating etc. ---

/mob/living/roomba/Initialize(mapload, ...)
	. = ..()
	src.get_vaccum_targets()
	src.get_mopping_targets()
	give_action(src, /datum/action/vaccum_toggle)
	give_action(src, /datum/action/mopping_toggle)

// --- Every time you move to new tile it will check list of items to delete ---

/mob/living/roomba/Move(NewLoc, direct)
	. = ..()
	vaccum_suck()
	mopping_floor()

// --- Action Button(s) ---

/datum/action/vaccum_toggle
	name = "Vaccum Module"
	action_icon_state = "recoil_compensation"

/datum/action/vaccum_toggle/give_to(mob/living/L)
	..()
	update_vaccum_skill()

/datum/action/vaccum_toggle/remove_from(/mob/living/roomba/A)
	owner.mob_flags &= ~VACCUM_MODE_ON
	..()

/datum/action/vaccum_toggle/proc/update_vaccum_skill()
	if(!(owner.mob_flags & VACCUM_MODE_ON))
		button.icon_state = "template_on"
		owner.mob_flags |= VACCUM_MODE_ON

/datum/action/vaccum_toggle/action_activate()
	. = ..()
	var/mob/living/roomba/current_roomba = owner
	if(owner.mob_flags & VACCUM_MODE_ON)
		button.icon_state = "template"
		owner.mob_flags &= ~VACCUM_MODE_ON
		current_roomba.vaccum = FALSE
		to_chat(owner, "You deactivate vaccum module.")
	else
		button.icon_state = "template_on"
		owner.mob_flags |= VACCUM_MODE_ON
		current_roomba.vaccum = TRUE
		to_chat(owner, "You activate vaccum module.")

/datum/action/mopping_toggle
	name = "Mopping Module"
	action_icon_state = "vulture_tripod_close"

/datum/action/mopping_toggle/give_to(mob/living/L)
	..()
	update_mopping_skill()

/datum/action/mopping_toggle/remove_from(/mob/living/roomba/B)
	owner.mob_flags &= ~MOPPING_MODE_ON
	..()

/datum/action/mopping_toggle/proc/update_mopping_skill()
	if(!(owner.mob_flags & MOPPING_MODE_ON))
		button.icon_state = "template_on"
		owner.mob_flags |= MOPPING_MODE_ON

/datum/action/mopping_toggle/action_activate()
	. = ..()
	var/mob/living/roomba/current_roomba = owner
	if(owner.mob_flags & MOPPING_MODE_ON)
		button.icon_state = "template"
		owner.mob_flags &= ~MOPPING_MODE_ON
		current_roomba.mopping = FALSE
		to_chat(owner, "You deactivate mopping module.")
	else
		button.icon_state = "template_on"
		owner.mob_flags |= MOPPING_MODE_ON
		current_roomba.mopping = TRUE
		to_chat(owner, "You activate mopping module.")

// --- Flags for mob ---

/mob/living/roomba/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (pass_flags)
		pass_flags.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		pass_flags.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

// --- Existence of life and death ---

/mob/living/roomba/spawn_gibs()
	robogibs(loc)

// --- Handles vaccum and mopping "logic" for "cleaning" list ---

/mob/living/roomba/proc/vaccum_suck()
	if(vaccum == FALSE)
		return
	else
		for(var/atom/possible_trash in loc)
			for(var/trash in src.target_vaccum_types)
				if(possible_trash.type == trash)
					qdel(possible_trash)

/mob/living/roomba/proc/mopping_floor()
	if(mopping == FALSE)
		return
	else
		for(var/atom/possible_trash in loc)
			for(var/trash in src.target_mopping_types)
				if(possible_trash.type == trash)
					qdel(possible_trash)

// --- List of items it should "clean" ---

/mob/living/roomba/proc/get_vaccum_targets()
	src.target_vaccum_types = new/list()

	target_vaccum_types += /obj/item/trash/uscm_mre
	target_vaccum_types += /obj/item/storage/box/MRE

/mob/living/roomba/proc/get_mopping_targets()
	src.target_mopping_types = new/list()

	target_mopping_types += /obj/effect/decal/cleanable/blood/oil
	target_mopping_types += /obj/effect/decal/cleanable/vomit
	target_mopping_types += /obj/effect/decal/cleanable/crayon
	target_mopping_types += /obj/effect/decal/cleanable/liquid_fuel
	target_mopping_types += /obj/effect/decal/cleanable/mucus
	target_mopping_types += /obj/effect/decal/cleanable/dirt
