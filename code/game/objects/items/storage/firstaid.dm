/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Pill Packets
 */

//---------FIRST AID KITS---------
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = SPEED_FAST
	throw_range = 8
	use_sound = "toolbox"
	matter = list("plastic" = 2000)
	cant_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/tool
	) //to prevent powergaming.
	storage_flags = STORAGE_FLAGS_BOX
	var/icon_full //icon state to use when kit is full
	var/possible_icons_full

/obj/item/storage/firstaid/Initialize()
	. = ..()

	if(possible_icons_full)
		icon_full = pick(possible_icons_full)
	else
		icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/firstaid/update_icon()
	if(content_watchers || !length(contents))
		icon_state = "kit_empty"
	else
		icon_state = icon_full

/obj/item/storage/firstaid/attack_self(mob/living/user)
	..()

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.swap_hand()
		open(user)

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the dropship ammo storage <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"
	possible_icons_full = list("ointment","firefirstaid")


/obj/item/storage/firstaid/fire/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)

/obj/item/storage/firstaid/fire/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"

/obj/item/storage/firstaid/regular/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/regular/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/robust
	icon_state = "firstaid"

/obj/item/storage/firstaid/robust/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/robust/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/toxin
	name = "toxin first-aid kit"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"
	possible_icons_full = list("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/toxin/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/reagent_container/pill/antitox(src)
	new /obj/item/reagent_container/pill/antitox(src)
	new /obj/item/reagent_container/pill/antitox(src)

/obj/item/storage/firstaid/toxin/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first-aid kit"
	desc = "A box full of reoxygenating goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/storage/firstaid/o2/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_container/pill/dexalin(src)
	new /obj/item/reagent_container/pill/dexalin(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline(src)

/obj/item/storage/firstaid/o2/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

/obj/item/storage/firstaid/adv/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/tricord(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/adv/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/rad
	name = "radiation first-aid kit"
	desc = "Contains treatment for radiation exposure"
	icon_state = "purplefirstaid"

/obj/item/storage/firstaid/rad/fill_preset_inventory()
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)

/obj/item/storage/firstaid/rad/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/surgical
	name = "basic field surgery kit"
	desc = "Contains a surgical line, cautery, scalpel, hemostat, retractor, drapes and an oxycodone injector for tending wounds surgically."
	icon_state = "bezerk"
	cant_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade
	) // we need surgery tools buddy

/obj/item/storage/firstaid/surgical/fill_preset_inventory()
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)

/obj/item/storage/firstaid/surgical/empty/fill_preset_inventory()
	return


//---------SYRINGE CASE---------

/obj/item/storage/syringe_case
	name = "syringe case"
	desc = "It's a medical case for storing syringes and bottles."
	icon_state = "syringe_case"
	throw_speed = SPEED_FAST
	throw_range = 8
	storage_slots = 3
	w_class = SIZE_SMALL
	matter = list("plastic" = 1000)
	can_hold = list(
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/paper,
		/obj/item/reagent_container/syringe,
		/obj/item/reagent_container/hypospray/autoinjector
	)

/obj/item/storage/syringe_case/regular

/obj/item/storage/syringe_case/regular/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/inaprovaline( src )
	new /obj/item/reagent_container/glass/bottle/tricordrazine( src )

/obj/item/storage/syringe_case/burn

/obj/item/storage/syringe_case/burn/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/kelotane( src )
	new /obj/item/reagent_container/glass/bottle/tricordrazine( src )

/obj/item/storage/syringe_case/tox

/obj/item/storage/syringe_case/tox/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/antitoxin( src )
	new /obj/item/reagent_container/glass/bottle/antitoxin( src )

/obj/item/storage/syringe_case/oxy

/obj/item/storage/syringe_case/oxy/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/inaprovaline( src )
	new /obj/item/reagent_container/glass/bottle/dexalin( src )


//---------PILL BOTTLES---------

/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/items/chemistry.dmi'
	item_state = "contsolid"
	w_class = SIZE_SMALL
	matter = list("plastic" = 500)
	can_hold = list(
		/obj/item/reagent_container/pill,
		/obj/item/toy/dice,
		/obj/item/paper
	)
	storage_flags = STORAGE_FLAGS_BOX|STORAGE_CLICK_GATHER|STORAGE_QUICK_GATHER
	storage_slots = null
	use_sound = "pillbottle"
	max_storage_space = 16
	var/skilllock = SKILL_MEDICAL_DEFAULT
	var/pill_type_to_fill //type of pill to use to fill in the bottle in /Initialize()
	var/bottle_lid = TRUE //Whether it shows a visual lid when opened or closed.
	var/display_maptext = TRUE
	var/maptext_label
	maptext_height = 16
	maptext_width = 16
	maptext_x = 18
	maptext_y = 3

/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	if(display_maptext == FALSE)
		verbs -= /obj/item/storage/pill_bottle/verb/set_maptext

/obj/item/storage/pill_bottle/fill_preset_inventory()
	if(pill_type_to_fill)
		for(var/i=1 to max_storage_space)
			new pill_type_to_fill(src)

/obj/item/storage/pill_bottle/update_icon()
	if(!bottle_lid)
		return
	overlays.Cut()
	if(content_watchers || !length(contents))
		overlays += "pills_open"
	else
		overlays += "pills_closed"

	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = "<span class='langchat'>[maptext_label]</span>"
	else
		maptext = ""

/obj/item/storage/pill_bottle/get_examine_text(mob/user)
	. = ..()
	var/pills_amount = contents.len
	if(pills_amount)
		var/percentage_filled = round(pills_amount/max_storage_space * 100)
		switch(percentage_filled)
			if(80 to 101)
				. += SPAN_INFO("The [name] seems fairly full.")
			if(60 to 79)
				. += SPAN_INFO("The [name] feels more than half full.")
			if(40 to 59)
				. += SPAN_INFO("The [name] seems to be around half full.")
			if(20 to 39)
				. += SPAN_INFO("The [name] feels less than half full.")
			if(0 to 19)
				. += SPAN_INFO("The [name] feels like it's nearly empty!")
	else
		. += SPAN_INFO("The [name] is empty.")


/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	..()

	if(user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need an empty hand to take out a pill."))
		return
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		error_idlock(user)
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(user.put_in_inactive_hand(I))
			playsound(loc, use_sound, 10, TRUE, 3)
			remove_from_storage(I,user)
			to_chat(user, SPAN_NOTICE("You take a pill out of the [name]."))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
			return
	else
		to_chat(user, SPAN_WARNING("The [name] is empty."))
		return


/obj/item/storage/pill_bottle/attackby(var/obj/item/storage/pill_bottle/W, mob/user)
	if(istype(W))
		if((skilllock || W.skilllock) && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			error_idlock(user)
			return
		dump_into(W,user)
	else
		return ..()


/obj/item/storage/pill_bottle/open(mob/user)
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		error_idlock(user)
		return
	..()

/obj/item/storage/pill_bottle/can_be_inserted(obj/item/W, stop_messages = 0)
	. = ..()
	if(.)
		if(skilllock && !skillcheck(usr, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			error_idlock(usr)
			return

/obj/item/storage/pill_bottle/clicked(var/mob/user, var/list/mods)
	if(..())
		return TRUE
	if(!istype(loc, /obj/item/storage/belt/medical))
		return FALSE
	var/obj/item/storage/belt/medical/M = loc
	if(!M.mode)
		return FALSE
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		error_idlock(user)
		return FALSE
	if(user.get_active_hand())
		return FALSE
	var/mob/living/carbon/C = user
	if(C.is_mob_restrained())
		to_chat(user, SPAN_WARNING("You are restrained!"))
		return FALSE
	if(!contents.len)
		to_chat(user, SPAN_WARNING("The [name] is empty."))
		return FALSE
	var/obj/item/I = contents[1]
	if(user.put_in_active_hand(I))
		remove_from_storage(I,user)
		to_chat(user, SPAN_NOTICE("You take [I] out of the [name]."))
		return TRUE

/obj/item/storage/pill_bottle/empty(var/mob/user, var/turf/T)
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		error_idlock(user)
		return
	..()

/obj/item/storage/pill_bottle/equipped()
	..()
	update_icon()

/obj/item/storage/pill_bottle/on_exit_storage()
	..()
	update_icon()

/obj/item/storage/pill_bottle/dropped()
	..()
	update_icon()

/obj/item/storage/pill_bottle/proc/error_idlock(mob/user)
	to_chat(user, SPAN_WARNING("It must have some kind of ID lock..."))

/obj/item/storage/pill_bottle/verb/set_maptext()
	set category = "Object"
	set name = "Set Short Label (on-sprite)"
	set src in usr

	if(src && ishuman(usr))
		var/str = copytext(reject_bad_text(input(usr,"Label text? (2 CHARACTERS MAXIMUM)", "Set \the [src]'s on-sprite label", "")), 1, 3)
		if(!str || !length(str))
			to_chat(usr, SPAN_NOTICE("You clear the label off \the [src]."))
			maptext_label = null
			update_icon()
			return
		maptext_label = str
		to_chat(usr, SPAN_NOTICE("You label \the [src] with '[str]' in big, blocky letters."))
		update_icon()

/obj/item/storage/pill_bottle/kelotane
	name = "\improper Kelotane pill bottle"
	icon_state = "pill_canister2"
	pill_type_to_fill = /obj/item/reagent_container/pill/kelotane
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Kl"

/obj/item/storage/pill_bottle/kelotane/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/antitox
	name = "\improper Dylovene pill bottle"
	icon_state = "pill_canister6"
	pill_type_to_fill = /obj/item/reagent_container/pill/antitox
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Dy"


/obj/item/storage/pill_bottle/antitox/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/inaprovaline
	name = "\improper Inaprovaline pill bottle"
	icon_state = "pill_canister3"
	pill_type_to_fill = /obj/item/reagent_container/pill/inaprovaline
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "In"

/obj/item/storage/pill_bottle/inaprovaline/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/tramadol
	name = "\improper Tramadol pill bottle"
	icon_state = "pill_canister5"
	pill_type_to_fill = /obj/item/reagent_container/pill/tramadol
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Tr"

/obj/item/storage/pill_bottle/tramadol/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/spaceacillin
	name = "\improper Spaceacillin pill bottle"
	icon_state = "pill_canister4"
	pill_type_to_fill = /obj/item/reagent_container/pill/spaceacillin
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Sp"

/obj/item/storage/pill_bottle/spaceacillin/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/bicaridine
	name = "\improper Bicaridine pill bottle"
	icon_state = "pill_canister11"
	pill_type_to_fill = /obj/item/reagent_container/pill/bicaridine
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Bi"

/obj/item/storage/pill_bottle/bicaridine/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/dexalin
	name = "\improper Dexalin pill bottle"
	icon_state = "pill_canister1"
	pill_type_to_fill = /obj/item/reagent_container/pill/dexalin
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Dx"

/obj/item/storage/pill_bottle/dexalin/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//Alkysine
/obj/item/storage/pill_bottle/alkysine
	name = "\improper Alkysine pill bottle"
	icon_state = "pill_canister7"
	pill_type_to_fill = /obj/item/reagent_container/pill/alkysine
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Al"

/obj/item/storage/pill_bottle/alkysine/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//imidazoline
/obj/item/storage/pill_bottle/imidazoline
	name = "\improper Imidazoline pill bottle"
	icon_state = "pill_canister9"
	pill_type_to_fill = /obj/item/reagent_container/pill/imidazoline
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Im"

/obj/item/storage/pill_bottle/imidazoline/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//PERIDAXON
/obj/item/storage/pill_bottle/peridaxon
	name = "\improper Peridaxon pill bottle"
	icon_state = "pill_canister10"
	pill_type_to_fill = /obj/item/reagent_container/pill/peridaxon
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Pr"

/obj/item/storage/pill_bottle/peridaxon/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//RUSSIAN RED ANTI-RAD
/obj/item/storage/pill_bottle/russianRed
	name = "\improper Russian Red pill bottle"
	icon_state = "pill_canister"
	pill_type_to_fill = /obj/item/reagent_container/pill/russianRed
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Rr"

/obj/item/storage/pill_bottle/russianRed/skillless
	skilllock = SKILL_MEDICAL_DEFAULT


/obj/item/storage/pill_bottle/quickclot
	name = "\improper Quickclot pill bottle"
	icon_state = "pill_canister8"
	pill_type_to_fill = /obj/item/reagent_container/pill/quickclot
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "Qc"

/obj/item/storage/pill_bottle/quickclot/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//Ultrazine
/obj/item/storage/pill_bottle/ultrazine
	name = "pill bottle"
	icon_state = "pill_canister11"
	max_storage_space = 5
	skilllock = SKILL_MEDICAL_DEFAULT //CL can open it
	var/idlock = 1
	pill_type_to_fill = /obj/item/reagent_container/pill/ultrazine/unmarked
	display_maptext = FALSE //for muh corporate secrets - Stan_Albatross

	req_access = list(ACCESS_WY_CORPORATE)
	var/req_role = JOB_CORPORATE_LIAISON


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
	display_maptext = TRUE
	maptext_label = "Uz"

/obj/item/storage/pill_bottle/mystery
	name = "\improper Weird-looking pill bottle"
	desc = "You can't seem to identify this."
	skilllock = SKILL_MEDICAL_MEDIC

/obj/item/storage/pill_bottle/mystery/Initialize()
	icon_state = "pill_canister[rand(1, 12)]"
	maptext_label = "??"
	. = ..()

/obj/item/storage/pill_bottle/mystery/fill_preset_inventory()
	var/list/cool_pills = subtypesof(/obj/item/reagent_container/pill)
	for(var/i=1 to max_storage_space)
		var/pill_to_fill = pick(cool_pills)
		var/obj/item/reagent_container/pill/P = new pill_to_fill(src)
		P.identificable = FALSE

/obj/item/storage/pill_bottle/mystery/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/stimulant
	name = "\improper Stimulant pill bottle"
	icon_state = "pill_canister12"
	pill_type_to_fill = /obj/item/reagent_container/pill/stimulant
	skilllock = SKILL_MEDICAL_MEDIC
	maptext_label = "ST"

/obj/item/storage/pill_bottle/stimulant/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//---------PILL PACKETS---------
obj/item/storage/pill_bottle/packet
	name = "\improper pill packet"
	desc = "Contains pills. Once you take them out, they don't go back in."
	icon_state = "pill_packet"
	bottle_lid = FALSE
	storage_slots = 4
	max_w_class = 0
	max_storage_space = 4
	skilllock = SKILL_MEDICAL_DEFAULT
	storage_flags = STORAGE_FLAGS_BOX
	display_maptext = FALSE

/obj/item/storage/pill_bottle/packet/tricordrazine
	name = "Tricordazine pill packet"
	icon_state = "tricordrazine_packet"
	desc = "This packet contains Tricordazine pills. Heals all types of damage slightly. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/tricordrazine

/obj/item/storage/pill_bottle/packet/tramadol
	name = "Tramadol pill packet"
	icon_state = "tramadol_packet"
	desc = "This packet contains Tramadol pills, a mild painkiller. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/tramadol

/obj/item/storage/pill_bottle/packet/bicaridine
    name = "Bicaridine pill packet"
    icon_state = "bicaridine_packet"
    desc = "This packet contains Bicaridine pills. Heals brute damage effectively. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
    pill_type_to_fill = /obj/item/reagent_container/pill/bicaridine

/obj/item/storage/pill_bottle/packet/kelotane
    name = "kelotane pill packet"
    icon_state = "kelotane_packet"
    desc = "This packet contains kelotane pills. Heals burn damage effectively. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
    pill_type_to_fill = /obj/item/reagent_container/pill/kelotane

/obj/item/storage/pill_bottle/packet/oxycodone
    name = "oxycodone pill packet"
    icon_state = "oxycodone_packet"
    desc = "This packet contains oxycodone pills. A highly effective painkiller. Once you take them out, they don't go back in. Don't take more than 1 pill in a short period."
    pill_type_to_fill = /obj/item/reagent_container/pill/oxycodone
