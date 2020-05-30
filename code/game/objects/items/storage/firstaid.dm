/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = SPEED_FAST
	throw_range = 8
	cant_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/tool
	) //to prevent powergaming.
	var/empty = 0 //whether the kit starts empty
	var/icon_full //icon state to use when kit is full
	var/possible_icons_full

/obj/item/storage/firstaid/Initialize()
	..()

	if(possible_icons_full)
		icon_full = pick(possible_icons_full)
	else
		icon_full = icon_state
	
	if(!empty)
		fill_firstaid_kit()
		
	update_icon()


/obj/item/storage/firstaid/update_icon()
	if(!contents.len  || empty)
		icon_state = "kit_empty"
	else
		icon_state = icon_full

/obj/item/storage/firstaid/attack_self(mob/living/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.swap_hand()
		open(user)

//to fill medkits with stuff when spawned
/obj/item/storage/firstaid/proc/fill_firstaid_kit()
	return


/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"
	possible_icons_full = list("ointment","firefirstaid")

	fill_firstaid_kit()
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
		new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
		new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
		new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"

	fill_firstaid_kit()
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/reagent_container/hypospray/autoinjector/skillless(src)
		new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)
		new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"
	possible_icons_full = list("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

	fill_firstaid_kit()
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/storage/pill_bottle/antitox(src)
		new /obj/item/reagent_container/pill/antitox(src)
		new /obj/item/reagent_container/pill/antitox(src)
		new /obj/item/reagent_container/pill/antitox(src)

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	fill_firstaid_kit()
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/reagent_container/pill/dexalin(src)
		new /obj/item/reagent_container/pill/dexalin(src)
		new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
		new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
		new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
		new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline(src)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

	fill_firstaid_kit()
		new /obj/item/reagent_container/hypospray/autoinjector/tricord(src)
		new /obj/item/stack/medical/advanced/bruise_pack(src)
		new /obj/item/stack/medical/advanced/bruise_pack(src)
		new /obj/item/stack/medical/advanced/bruise_pack(src)
		new /obj/item/stack/medical/advanced/ointment(src)
		new /obj/item/stack/medical/advanced/ointment(src)
		new /obj/item/stack/medical/splint(src)


/obj/item/storage/firstaid/rad
	name = "radiation first-aid kit"
	desc = "Contains treatment for radiation exposure"
	icon_state = "purplefirstaid"

	fill_firstaid_kit()
		new /obj/item/reagent_container/pill/russianRed(src)
		new /obj/item/reagent_container/pill/russianRed(src)
		new /obj/item/reagent_container/pill/russianRed(src)
		new /obj/item/reagent_container/pill/russianRed(src)
		new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
		new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)


	/*
 * Syringe Case
 */


/obj/item/storage/syringe_case
	name = "syringe case"
	desc = "It's an medical case for storing syringes and bottles."
	icon_state = "syringe_case"
	throw_speed = SPEED_FAST
	throw_range = 8
	storage_slots = 3
	w_class = SIZE_SMALL
	can_hold = list(
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/paper,
		/obj/item/reagent_container/syringe,
		/obj/item/reagent_container/hypospray/autoinjector
	)

/obj/item/storage/syringe_case/regular

/obj/item/storage/syringe_case/regular/Initialize()
		..()
		new /obj/item/reagent_container/syringe( src )
		new /obj/item/reagent_container/glass/bottle/inaprovaline( src )
		new /obj/item/reagent_container/glass/bottle/tricordrazine( src )

/obj/item/storage/syringe_case/burn

/obj/item/storage/syringe_case/burn/Initialize()
		..()
		new /obj/item/reagent_container/syringe( src )
		new /obj/item/reagent_container/glass/bottle/kelotane( src )
		new /obj/item/reagent_container/glass/bottle/tricordrazine( src )

/obj/item/storage/syringe_case/tox

/obj/item/storage/syringe_case/tox/Initialize()
		..()
		new /obj/item/reagent_container/syringe( src )
		new /obj/item/reagent_container/glass/bottle/antitoxin( src )
		new /obj/item/reagent_container/glass/bottle/antitoxin( src )

/obj/item/storage/syringe_case/oxy

/obj/item/storage/syringe_case/oxy/Initialize()
		..()
		new /obj/item/reagent_container/syringe( src )
		new /obj/item/reagent_container/glass/bottle/inaprovaline( src )
		new /obj/item/reagent_container/glass/bottle/dexalin( src )

/*
 * Pill Bottles
 */


/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/items/chemistry.dmi'
	item_state = "contsolid"
	w_class = SIZE_SMALL
	can_hold = list(
		/obj/item/reagent_container/pill,
		/obj/item/toy/dice,
		/obj/item/paper
	)
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_CLICK_GATHER|STORAGE_QUICK_GATHER
	storage_slots = null
	use_sound = null
	max_storage_space = 16
	var/skilllock = 1
	var/pill_type_to_fill //type of pill to use to fill in the bottle in /Initialize()

/obj/item/storage/pill_bottle/Initialize()
	..()
	if(pill_type_to_fill)
		for(var/i=1 to max_storage_space)
			new pill_type_to_fill(src)

/obj/item/storage/pill_bottle/examine(mob/user)
	..()
	var/pills_amount = contents.len
	if(pills_amount)
		var/percentage_filled = round(pills_amount/max_storage_space * 100)
		switch(percentage_filled)
			if(80 to 101)
				to_chat(user, SPAN_INFO("The [src] seems fairly full."))
			if(60 to 79)
				to_chat(user, SPAN_INFO("The [src] feels more than half full."))
			if(40 to 59)
				to_chat(user, SPAN_INFO("The [src] seems to be around half full."))
			if(20 to 39)
				to_chat(user, SPAN_INFO("The [src] feels less than half full."))
			if(0 to 19)
				to_chat(user, SPAN_INFO("The [src] feels like it's nearly empty!"))
	else
		to_chat(user, SPAN_INFO("The [src] is empty."))
				

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_NOTICE("It must have some kind of ID lock..."))
		return
	if(user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need an empty hand to take out a pill."))
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(user.put_in_inactive_hand(I))
			remove_from_storage(I,user)
			to_chat(user, SPAN_NOTICE("You take a pill out of \the [src]."))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
			return
	else
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return


/obj/item/storage/pill_bottle/open(mob/user)
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_NOTICE("It must have some kind of ID lock..."))
		return
	..()



/obj/item/storage/pill_bottle/can_be_inserted(obj/item/W, stop_messages = 0)
	. = ..()
	if(.)
		if(skilllock && !skillcheck(usr, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(usr, SPAN_NOTICE("You can't open [src], it has some kind of lock."))
			return 0

/obj/item/storage/pill_bottle/clicked(var/mob/user, var/list/mods)
	if(..())
		return 1
	else
		if(istype(loc, /obj/item/storage/belt/medical))
			var/obj/item/storage/belt/medical/M = loc
			if(M.mode)
				if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
					to_chat(user, SPAN_NOTICE("It must have some kind of ID lock..."))
					return 0
				if(user.get_active_hand())
					return 0
				var/mob/living/carbon/C = user
				if(C.handcuffed)
					to_chat(user, SPAN_WARNING("You are handcuffed!"))
					return
				if(contents.len)
					var/obj/item/I = contents[1]
					if(user.put_in_active_hand(I))
						remove_from_storage(I,user)
						to_chat(user, SPAN_NOTICE("You take a pill out of \the [src]."))
						return 1
				else
					to_chat(user, SPAN_WARNING("\The [src] is empty."))
					return 0
			else
				return 0

/obj/item/storage/pill_bottle/kelotane
	name = "\improper Kelotane pill bottle"
	icon_state = "pill_canister2"
	pill_type_to_fill = /obj/item/reagent_container/pill/kelotane

/obj/item/storage/pill_bottle/kelotane/skillless
	skilllock = 0

/obj/item/storage/pill_bottle/antitox
	name = "\improper Dylovene pill bottle"
	icon_state = "pill_canister6"
	pill_type_to_fill = /obj/item/reagent_container/pill/antitox

/obj/item/storage/pill_bottle/antitox/skillless
	skilllock = 0

/obj/item/storage/pill_bottle/inaprovaline
	name = "\improper Inaprovaline pill bottle"
	icon_state = "pill_canister3"
	pill_type_to_fill = /obj/item/reagent_container/pill/inaprovaline

/obj/item/storage/pill_bottle/inaprovaline/skillless
	skilllock = 0

/obj/item/storage/pill_bottle/tramadol
	name = "\improper Tramadol pill bottle"
	icon_state = "pill_canister5"
	pill_type_to_fill = /obj/item/reagent_container/pill/tramadol

/obj/item/storage/pill_bottle/tramadol/skillless
	skilllock = 0

/obj/item/storage/pill_bottle/spaceacillin
	name = "\improper Spaceacillin pill bottle"
	icon_state = "pill_canister4"
	pill_type_to_fill = /obj/item/reagent_container/pill/spaceacillin

/obj/item/storage/pill_bottle/spaceacillin/skillless
	skilllock = 0

/obj/item/storage/pill_bottle/bicaridine
	name = "\improper Bicaridine pill bottle"
	icon_state = "pill_canister11"
	pill_type_to_fill = /obj/item/reagent_container/pill/bicaridine

/obj/item/storage/pill_bottle/bicaridine/skillless
	skilllock = 0

/obj/item/storage/pill_bottle/dexalin
	name = "\improper Dexalin pill bottle"
	icon_state = "pill_canister1"
	pill_type_to_fill = /obj/item/reagent_container/pill/dexalin

/obj/item/storage/pill_bottle/dexalin/skillless
	skilllock = 0

//Alkysine
/obj/item/storage/pill_bottle/alkysine
	name = "\improper Alkysine pill bottle"
	icon_state = "pill_canister7"
	pill_type_to_fill = /obj/item/reagent_container/pill/alkysine


//imidazoline
/obj/item/storage/pill_bottle/imidazoline
	name = "\improper Imidazoline pill bottle"
	icon_state = "pill_canister9"
	pill_type_to_fill = /obj/item/reagent_container/pill/imidazoline

//PERIDAXON
/obj/item/storage/pill_bottle/peridaxon
	name = "\improper Peridaxon pill bottle"
	icon_state = "pill_canister10"
	pill_type_to_fill = /obj/item/reagent_container/pill/peridaxon

/obj/item/storage/pill_bottle/peridaxon/skillless
	skilllock = 0

//RUSSIAN RED ANTI-RAD
/obj/item/storage/pill_bottle/russianRed
	name = "\improper Russian Red pill bottle"
	icon_state = "pill_canister"
	pill_type_to_fill = /obj/item/reagent_container/pill/russianRed


/obj/item/storage/pill_bottle/quickclot
	name = "\improper Quickclot pill bottle"
	icon_state = "pill_canister8"
	pill_type_to_fill = /obj/item/reagent_container/pill/quickclot


//Ultrazine
/obj/item/storage/pill_bottle/ultrazine
	name = "pill bottle"
	icon_state = "pill_canister11"
	max_storage_space = 5
	skilllock = 0 //CL can open it
	var/idlock = 1
	pill_type_to_fill = /obj/item/reagent_container/pill/ultrazine

	req_access = list(ACCESS_WY_CORPORATE)
	var/req_role = "Corporate Liaison"


/obj/item/storage/pill_bottle/ultrazine/proc/id_check(mob/user)

	if(!idlock)
		return 1

	var/mob/living/carbon/human/H = user

	if(!allowed(user))
		to_chat(user, SPAN_NOTICE("It must have some kind of ID lock..."))
		return 0

	var/obj/item/card/id/I = H.wear_id
	if(!istype(I)) //not wearing an ID
		to_chat(H, SPAN_NOTICE("It must have some kind of ID lock..."))
		return 0

	if(I.registered_name != H.real_name)
		to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
		return 0

	if(req_role && I.rank != req_role)
		to_chat(H, SPAN_NOTICE("It must have some kind of ID lock..."))
		return 0

	return 1

/obj/item/storage/pill_bottle/ultrazine/attack_self(mob/living/user)
	if(!id_check(user))
		return
	..()

/obj/item/storage/pill_bottle/ultrazine/open(mob/user)
	if(!id_check(user))
		return
	..()

/obj/item/storage/pill_bottle/ultrazine/skillless
	name = "\improper Ultrazine pill bottle"
	idlock = 0
