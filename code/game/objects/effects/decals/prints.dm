/obj/effect/decal/prints
	name = "suspicious prints"
	icon = 'icons/effects/fingerprints.dmi'
	icon_state = "prints"
	anchored = TRUE
	unacidable = TRUE

	var/description = null

	var/criminal_name = null
	var/criminal_rank = null
	var/criminal_squad = null

	var/created_time = 0

/obj/effect/decal/prints/New(var/turf/location, var/mob/living/carbon/human/criminal_mob, var/incident = "")
	. = ..()

	forceMove(location)
	criminal_name = criminal_mob.name

	var/obj/item/card/id/I = criminal_mob.get_idcard()
	if(I)
		criminal_rank = I.rank

	if(criminal_mob.assigned_squad)
		criminal_squad = criminal_mob.assigned_squad.name

	description = incident

	created_time = world.timeofday

	SSclues.prints_list += src

/obj/effect/decal/prints/attackby(var/obj/item/W, var/mob/living/user)
	if(!istype(W, /obj/item/device/clue_scanner))
		..()
		return

	var/obj/item/device/clue_scanner/S = W

	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [S]..."))
		return

	S.scanning = TRUE
	S.update_icon()
	to_chat(user, SPAN_NOTICE("You start scanning [src]..."))
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		S.scanning = FALSE
		S.update_icon()
		return
	S.scanning = FALSE

	moveToNullspace()
	S.found_prints = src
	S.update_icon()
	to_chat(user, SPAN_INFO("Print set found: [generate_clue()]"))

/obj/effect/decal/prints/proc/generate_clue()
	return md5(criminal_name + criminal_rank)

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
