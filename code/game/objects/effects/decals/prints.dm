/obj/effect/decal/prints
	name = "suspicious prints"
	gender = PLURAL
	icon = 'icons/effects/fingerprints.dmi'
	icon_state = "prints"
	anchored = TRUE
	unacidable = TRUE

	var/description = null

	var/criminal_name = null
	var/criminal_rank = null
	var/criminal_squad = null

	var/created_time = 0

/obj/effect/decal/prints/New(turf/location, mob/living/carbon/human/criminal_mob, incident = "")
	. = ..()

	if(!criminal_mob)
		return

	forceMove(location)
	criminal_name = criminal_mob.name

	var/obj/item/card/id/id_card = criminal_mob.get_idcard()
	if(id_card)
		criminal_rank = id_card.rank

	if(criminal_mob.assigned_squad)
		criminal_squad = criminal_mob.assigned_squad.name

	description = incident

	created_time = world.timeofday

	SSclues.prints_list += src

/obj/effect/decal/prints/attackby(obj/item/W, mob/living/user)
	if(!istype(W, /obj/item/device/clue_scanner))
		..()
		return

	var/obj/item/device/clue_scanner/scanner = W

	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [scanner]..."))
		return

	scanner.scanning = TRUE
	scanner.update_icon()
	to_chat(user, SPAN_NOTICE("You start scanning [src]..."))
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		scanner.scanning = FALSE
		scanner.update_icon()
		return
	scanner.scanning = FALSE

	moveToNullspace()
	LAZYADD(scanner.print_list, src)
	scanner.update_icon()
	to_chat(user, SPAN_INFO("New print sets found: 1, total amount: [length(scanner.print_list)]"))

/obj/effect/decal/prints/proc/decipher_clue()
	var/information = ""
	information += criminal_name

	if(!criminal_rank)
		return information

	information += ", "
	information += "criminal_rank"

	if(!criminal_squad)
		return information

	information += " "
	information += criminal_squad

	return information

/obj/effect/decal/prints/Destroy()
	SSclues.prints_list -= src

	. = ..()
