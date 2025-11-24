/obj/item/reagent_container/hypospray/autoinjector
	name = "inaprovaline autoinjector"
	var/chemname = "inaprovaline"
	var/autoinjector_type = "autoinjector" //referencing the icon state name in syringe.dmi
	//desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc = "An autoinjector containing Inaprovaline.  Useful for saving lives."
	icon_state = "empty"
	item_state = "autoinjector"
	item_state_slots = list(WEAR_AS_GARB = "injector")
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/medical.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	flags_atom = FPRINT
	matter = list("plastic" = 300)
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	possible_transfer_amounts = null
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	magfed = FALSE
	starting_vial = null
	transparent = FALSE
	var/uses_left = 3
	var/mixed_chem = FALSE
	var/display_maptext = FALSE
	var/maptext_label
	maptext_height = 16
	maptext_width = 24
	maptext_x = 4
	maptext_y = 2

/obj/item/reagent_container/hypospray/autoinjector/Initialize()
	. = ..()
	if(mixed_chem)
		return
	reagents.add_reagent(chemname, volume)
	if(display_maptext == TRUE)
		verbs += /obj/item/storage/pill_bottle/verb/set_maptext
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/proc/update_uses_left()
	var/UL = reagents.total_volume / amount_per_transfer_from_this
	UL = floor(UL) == UL ? UL : floor(UL) + 1
	uses_left = UL

/obj/item/reagent_container/hypospray/autoinjector/attack(mob/M, mob/user)
	if(uses_left <= 0)
		return
	. = ..()
	if(!.)
		return
	uses_left--
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/update_icon()
	overlays.Cut()
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[maptext_label]")
	else
		maptext = ""

	if(uses_left && autoinjector_type)
		var/image/filling = image('icons/obj/items/syringe.dmi', src, "[autoinjector_type]_[uses_left]")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling
		return

/obj/item/reagent_container/hypospray/autoinjector/get_examine_text(mob/user)
	. = ..()
	if(uses_left)
		. += SPAN_NOTICE("It is currently loaded with [uses_left].")
	else
		. += SPAN_NOTICE("It is empty.")

/obj/item/reagent_container/hypospray/autoinjector/equipped()
	..()
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/on_exit_storage()
	..()
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/dropped()
	..()
	update_icon()


//REGULAR AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/tricord
	name = "tricordrazine autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with 3 doses of 15u of Tricordrazine, a weak general use medicine for treating damage."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tc"

/obj/item/reagent_container/hypospray/autoinjector/adrenaline
	name = "epinephrine autoinjector"
	chemname = "adrenaline"
	desc = "An autoinjector loaded with 3 doses of 5.25u of Epinephrine, better known as Adrenaline, a nerve stimulant useful in restarting the heart. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ep"

/obj/item/reagent_container/hypospray/autoinjector/dexalinp
	name = "dexalin plus autoinjector"
	chemname = "dexalinp"
	desc = "An autoinjector loaded with 3 doses of 1u of Dexalin+, designed to immediately oxygenate the entire body. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = 1
	volume = 3
	display_maptext = TRUE
	maptext_label = "D+"

/obj/item/reagent_container/hypospray/autoinjector/tramadol
	name = "tramadol autoinjector"
	chemname = "tramadol"
	desc = "An autoinjector loaded with 3 doses of 15u of Tramadol, a weak but effective painkiller for normal wounds. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tr"

/obj/item/reagent_container/hypospray/autoinjector/oxycodone
	name = "oxycodone autoinjector (EXTREME PAINKILLER)"
	chemname = "oxycodone"
	desc = "An autoinjector loaded with 3 doses of 10u of Oxycodone, a powerful painkiller intended for life-threatening situations. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ox"

/obj/item/reagent_container/hypospray/autoinjector/kelotane
	name = "kelotane autoinjector"
	chemname = "kelotane"
	desc = "An autoinjector loaded with 3 doses of 15u of Kelotane, a common burn medicine. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Kl"

/obj/item/reagent_container/hypospray/autoinjector/bicaridine
	name = "bicaridine autoinjector"
	chemname = "bicaridine"
	desc = "An autoinjector loaded with 3 doses of 15u of Bicaridine, a common brute and circulatory damage medicine. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Bi"

/obj/item/reagent_container/hypospray/autoinjector/antitoxin
	name = "dylovene autoinjector"
	chemname = "anti_toxin"
	desc = "An autoinjector loaded with 3 doses of 15u of Dylovene, a common toxin damage medicine. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Dy"

/obj/item/reagent_container/hypospray/autoinjector/meralyne
	name = "meralyne autoinjector"
	desc = "An autoinjector loaded with 3 doses of 15u of Meralyne, an advanced brute and circulatory damage medicine."
	chemname = "meralyne"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Me"

/obj/item/reagent_container/hypospray/autoinjector/dermaline
	name = "dermaline autoinjector"
	desc = "An autoinjector loaded with 3 doses of 15u of Dermaline, an advanced burn medicine."
	chemname = "dermaline"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "De"

/obj/item/reagent_container/hypospray/autoinjector/inaprovaline
	name = "inaprovaline autoinjector"
	chemname = "inaprovaline"
	desc = "An autoinjector loaded with 3 doses of 30u of Inaprovaline, an emergency stabilization medicine for patients in critical condition. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "In"

/obj/item/reagent_container/hypospray/autoinjector/peridaxon
	name = "peridaxon autoinjector"
	chemname = "peridaxon"
	desc = "An autoinjector loaded with 3 doses of 7.5u of Peridaxon, an emergency medicine used to stop most symptoms of organ damage. Does not fix organ damage. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Pr"


//EZ AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/skillless/tricord
	name = "tricordrazine EZ autoinjector"
	chemname = "tricordrazine"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Tricordrazine, a weak general use medicine for treating damage. You can refill it at Wey-Med vending machines and it does not require any training to use."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "emptyskill"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzTc"

/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol
	name = "tramadol EZ autoinjector"
	chemname = "tramadol"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Tramadol, a weak but effective painkiller for normal wounds. You can refill it at Wey-Med vending machines and it doesn't require any training to use."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD //these all have the same OD limit, but just in case we have some that don't...
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "emptyskill"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzTr"

/obj/item/reagent_container/hypospray/autoinjector/skillless/kelotane
	name = "kelotane EZ autoinjector"
	chemname = "kelotane"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Kelotane, a common burn repairing medicine. You can refill it at Wey-Med vending machines and it doesn't require any training to use."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "emptyskill"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzKl"

/obj/item/reagent_container/hypospray/autoinjector/skillless/bicaridine
	name = "bicaridine EZ autoinjector"
	chemname = "bicaridine"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Bicaridine, a common brute and circulatory damage repairing medicine. You can refill it at Wey-Med vending machines and it doesn't require any training to use."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "emptyskill"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzBi"

/obj/item/reagent_container/hypospray/autoinjector/skillless/antitoxin
	name = "dylovene EZ autoinjector"
	chemname = "anti_toxin"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Dylovene, a common toxin damage medicine. You can refill it at Wey-Med vending machines and it doesn't require any training to use."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "emptyskill"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzDy"


//ONE-USE EZ AUTOINJECTORS

/obj/item/reagent_container/hypospray/autoinjector/skillless/one_use/kelotane
	name = "single-use kelotane EZ autoinjector"
	chemname = "kelotane"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Kelotane, a common burn medicine. ou can only refill it wih a MS-11 Smart Refill Tank, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	maptext_label = "OuKl"

/obj/item/reagent_container/hypospray/autoinjector/skillless/one_use/bicaridine
	name = "single-use bicaridine EZ autoinjector"
	chemname = "bicaridine"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Bicaridine, a common brute and circulatory damage medicine. ou can only refill it wih a MS-11 Smart Refill Tank, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	maptext_label = "OuBi"

/obj/item/reagent_container/hypospray/autoinjector/skillless/one_use/antitoxin
	name = "single-use dylovene EZ autoinjector"
	chemname = "anti_toxin"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Dylovene, a common toxin damage medicine. You can only refill it wih a MS-11 Smart Refill Tank, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	maptext_label = "OuDy"


//MARINE AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/skillless/marine
	name = "first-aid autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with a single dose of 15u of tricordrazine to self-administer for wound care. You can refill it at Wey-Med vending machines. Thankfully, there's no lock on it, so anyone can use it!"
	icon_state = "tricord"
	autoinjector_type = "marine_oneuse"
	amount_per_transfer_from_this = 15
	volume = 15
	skilllock = SKILL_MEDICAL_DEFAULT
	uses_left = 1
	display_maptext = TRUE
	maptext_label = "OuTc"

/obj/item/reagent_container/hypospray/autoinjector/skillless/marine/tramadol
	name = "pain-stop autoinjector"
	chemname = "tramadol"
	desc = "An autoinjector loaded with a single dose of 15u tramadol to self-administer for pain management. You can refill it at Wey-Med vending machines. Thankfully, there's no lock on it, so anyone can use it!"
	maptext_label = "OuPs"
	icon_state = "tramadol" //hehe 'I need an oops'

///obj/item/reagent_container/hypospray/autoinjector/skillless/marine/attack(mob/M as mob, mob/user as mob) is no longer necessary because these autoinjectors have proper fill overlays and are also SUPPOSED to be refilled, now.

///obj/item/reagent_container/hypospray/autoinjector/skillless/marine/get_examine_text(mob/user) is not necessary, either.



//MIXED CHEMS
/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate
	name = "anesthetic autoinjector"
	chemname = "anesthetic"
	desc = "An autoinjector loaded with 3 doses of 1u of Chloral Hydrate and 9u of Sleeping Agent. Good to quickly pacify someone--for surgery of course! What? Are you some sort of criminal?"
	amount_per_transfer_from_this = 10
	volume = 30
	mixed_chem = TRUE
	display_maptext = TRUE
	maptext_label = "ChSa"

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 1*3)
	reagents.add_reagent("stoxin", 9*3)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/emergency
	name = "emergency autoinjector (CAUTION)"
	desc = "An autoinjector loaded with a single dose of 78u of a special cocktail of chemicals, to be used in life-threatening situations. You cannot refill it, but it doesn't require any training to use."
	icon_state = "empty_emergency"
	chemname = "emergency"
	autoinjector_type = "autoinjector_oneuse"
	amount_per_transfer_from_this = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1) + 1 //dexalin plus is the +1
	volume = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1) + 1 //dexalin plus is the +1
	mixed_chem = TRUE
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	injectVOL = 70//limited-supply emergency injector with v.large injection of drugs. Variable sfx freq sometimes rolls too quiet.
	display_maptext = TRUE //see anaesthetic injector
	maptext_label = "!!"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/emergency/Initialize() //29u bicaridine, 29u kelotane, 19u oxycodone, 1u dexalin +.
	. = ..()
	reagents.add_reagent("bicaridine", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("kelotane", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("oxycodone", MED_REAGENTS_OVERDOSE-1)
	reagents.add_reagent("dexalinp", 1) //I can breathe! Get me to surgery, please!
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/black_goo_cure
	name = "\"Pathogen\" cure autoinjector (SINGLE-USE)"
	desc = "An autoinjector loaded with a single dose of a cure for Agent A0-3959X.91–15, also known as the 'black-goo'. It doesn't require any training to administer and it can be refilled with a mini reagent tank." //Yes, it can be refilled by a mini reagent tank because mixed_chem = FALSE
	icon_state = "empty_research_oneuse"
	chemname = "antiZed"
	autoinjector_type = "autoinjector_oneuse"
	amount_per_transfer_from_this = 5
	volume = 5
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	display_maptext = TRUE
	maptext_label = "!!!"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/black_goo_cure/Initialize()
	. = ..()
	reagents.add_reagent("antiZed", 5)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/ultrazine
	name = "ultrazine autoinjector"
	chemname = "ultrazine"
	desc = "An autoinjector loaded with 5 doses of 5u of Ultrazine, a special and illegal muscle stimulant. It doesn't require any training to administer and it can be refilled with a mini reagent tank. Do not administer more than twice at a time. Highly addictive."
	amount_per_transfer_from_this = 5
	volume = 25
	uses_left = 5
	autoinjector_type = "+stimpack_custom"
	icon_state = "stimpack"
	autoinjector_type = null
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = FALSE //corporate secret
	maptext_label = "Uz"

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/update_icon()
	. = ..()
	icon_state = uses_left ? "stimpack" : "stimpack0"
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[maptext_label]")
	else
		maptext = ""

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/empty
	name = "empty ultrazine autoinjector"
	volume = 0
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison
	name = "strange autoinjector"
	desc = "You know what they say, don't jab yourself with suspicious syringes."
	maptext_label = "??"

/obj/item/reagent_container/hypospray/autoinjector/yautja
	name = "unusual crystal"
	chemname = "thwei"
	desc = "A strange glowing crystal with a spike at one end."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "crystal"
	injectSFX = 'sound/items/pred_crystal_inject.ogg'
	autoinjector_type = "thwei"
	injectVOL = 15
	amount_per_transfer_from_this = REAGENTS_OVERDOSE
	volume = REAGENTS_OVERDOSE
	uses_left = 1
	black_market_value = 25

/obj/item/reagent_container/hypospray/autoinjector/yautja/attack(mob/M as mob, mob/user as mob)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		..()
	else
		to_chat(user, SPAN_DANGER("You have no idea where to inject [src]."))

	if(uses_left == 0)
		addtimer(CALLBACK(src, PROC_REF(remove_crystal)), 120 SECONDS)

/obj/item/reagent_container/hypospray/autoinjector/yautja/proc/remove_crystal()
	visible_message(SPAN_DANGER("[src] collapses into nothing."))
	qdel(src)

/obj/item/reagent_container/hypospray/autoinjector/yautja/update_icon()
	overlays.Cut()
	if(uses_left && autoinjector_type) //does not apply a colored fill overlay like the rest of the autoinjectors
		var/image/filling = image('icons/obj/items/hunter/pred_gear.dmi', src, "[autoinjector_type]_[uses_left]")
		overlays += filling
		return

//CUSTOM AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/empty
	name = "custom autoinjector (5u)"
	desc = "A custom-made autoinjector, likely from research. You can only refill it with a pressurized reagent canister pouch."
	icon_state = "empty_research"
	mixed_chem = TRUE
	amount_per_transfer_from_this = 5
	volume = 15
	uses_left = 0
	display_maptext = TRUE

/obj/item/reagent_container/hypospray/autoinjector/empty/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It transfers [amount_per_transfer_from_this]u per injection and has a maximum of [volume/amount_per_transfer_from_this] injections.")

/obj/item/reagent_container/hypospray/autoinjector/empty/small
	name = "custom autoinjector (15u)"
	amount_per_transfer_from_this = 15
	volume = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/medium
	name = "custom autoinjector (30u)"
	amount_per_transfer_from_this = 30
	volume = 90

/obj/item/reagent_container/hypospray/autoinjector/empty/large
	name = "custom autoinjector (60u)"
	amount_per_transfer_from_this = 60
	volume = 180


//CUSTOM EZ AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/empty/skillless
	name = "custom ez autoinjector (15u)"
	desc = "A custom-made EZ autoinjector, likely from research. You can refill it with a pressurized reagent canister pouch. It injects its entire payload immediately and doesn't require any training."
	icon_state = "empty_research_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = 15
	volume = 15
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/unit
	name = "custom EZ autoinjector (1u)"
	volume = 1
	amount_per_transfer_from_this = 1

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall
	name = "custom EZ autoinjector (5u)"
	volume = 5
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small
	name = "custom autoinjector (10u)"
	volume = 10
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/medium
	name = "custom EZ autoinjector (30u)"
	volume = 30
	amount_per_transfer_from_this = 30

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/large
	name = "custom EZ autoinjector (45u)"
	volume = 45
	amount_per_transfer_from_this = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/extralarge
	name = "custom EZ autoinjector (60u)"
	volume = 60
	amount_per_transfer_from_this = 60

//REAGENT POUCH AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/empty/medic //specifically for reagent canister pouches with three chemicals inside.
	name = "reagent canister pouch autoinjector (15u)"
	desc = "An autoinjector specifically designed to fit inside and refill from Pressurized Reagent Canister Pouches. Has a similar lock to pill bottles and fits up to 6 injections."
	skilllock = SKILL_MEDICAL_MEDIC
	volume = 90
	amount_per_transfer_from_this = 15
	autoinjector_type = "autoinjector_medic"
	icon_state = "empty_medic"
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/extrasmall //specifically for reagent canister pouches with only one chemical inside.
	name = "reagent canister pouch autoinjector (5u)"
	volume = 30
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/small //specifically for reagent canister pouches with two chemicals inside.
	name = "reagent canister pouch autoinjector (10u)"
	volume = 60
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/large //haven't seen anyone use this yet.
	name = "reagent canister pouch autoinjector (30u)
	volume = 180
	amount_per_transfer_from_this = 30
