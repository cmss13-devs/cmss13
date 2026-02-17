/obj/item/reagent_container/hypospray/autoinjector
	name = "inaprovaline autoinjector"
	var/chemname = "inaprovaline"
	var/autoinjector_type = "autoinjector" //referencing the icon state name in syringe.dmi
	//desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc = "An autoinjector containing Inaprovaline. Useful for saving lives."
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


/obj/item/reagent_container/hypospray/autoinjector/tricord
	name = "tricordrazine autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with 3 doses of 15u of Tricordrazine, a weak general use medicine for treating damage."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tc"

/obj/item/reagent_container/hypospray/autoinjector/tricord/random_amount

/obj/item/reagent_container/hypospray/autoinjector/tricord/random_amount/Initialize()
	. = ..()
	var/amount = rand(1, 6)
	switch(amount)
		if(1)
			reagents.add_reagent("tricordrazine", -45)
			uses_left = 0
			update_icon()
		if(2, 3)
			reagents.add_reagent("tricordrazine", -30)
			uses_left = 1
			update_icon()
		if(4, 5)
			reagents.add_reagent("tricordrazine", -15)
			uses_left = 2
			update_icon()

/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless
	name = "tricordrazine EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Tricordrazine, a weak general use medicine for treating damage. You can refill it at Wey-Med vending machines and it does not require any training to use."
	icon_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzTc"

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

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate
	name = "anesthetic autoinjector"
	chemname = "anesthetic"
	desc = "An autoinjector loaded with 3 doses of 1u of Chloral Hydrate and 9u of Sleeping Agent. Good to quickly pacify someone, for surgery of course."
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

/obj/item/reagent_container/hypospray/autoinjector/tramadol
	name = "tramadol autoinjector"
	chemname = "tramadol"
	desc = "An autoinjector loaded with 3 doses of 15u of Tramadol, a weak but effective painkiller for normal wounds. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tr"

/obj/item/reagent_container/hypospray/autoinjector/tramadol/random_amount

/obj/item/reagent_container/hypospray/autoinjector/tramadol/random_amount/Initialize()
	. = ..()
	var/amount = rand(1, 6)
	switch(amount)
		if(1)
			reagents.add_reagent("tramadol", -45)
			uses_left = 0
			update_icon()
		if(2, 3)
			reagents.add_reagent("tramadol", -30)
			uses_left = 1
			update_icon()
		if(4, 5)
			reagents.add_reagent("tramadol", -15)
			uses_left = 2
			update_icon()

/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless
	name = "tramadol EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Tramadol, a weak but effective painkiller for normal wounds. You can refill it at Wey-Med vending machines and it doesn't require any training to use."
	icon_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzTr"

/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use
	name = "single-use tramadol EZ autoinjector"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Tramadol, a weak but effective painkiller for normal wounds. You cannot refill it, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	display_maptext = TRUE
	maptext_label = "OuTr"

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

/obj/item/reagent_container/hypospray/autoinjector/kelotane/random_amount

/obj/item/reagent_container/hypospray/autoinjector/kelotane/random_amount/Initialize()
	. = ..()
	var/amount = rand(1, 6)
	switch(amount)
		if(1)
			reagents.add_reagent("kelotane", -45)
			uses_left = 0
			update_icon()
		if(2 , 3)
			reagents.add_reagent("kelotane", -30)
			uses_left = 1
			update_icon()
		if(4 , 5)
			reagents.add_reagent("kelotane", -15)
			uses_left = 2
			update_icon()

/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless
	name = "kelotane EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Kelotane, a common burn medicine. Doesn't require any training to use. You can refill it at Wey-Med vending machines."
	icon_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = TRUE
	maptext_label = "EzKl"

/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use
	name = "single-use kelotane EZ autoinjector"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Kelotane, a common burn medicine. You cannot refill it, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	display_maptext = TRUE
	maptext_label = "OuKl"

/obj/item/reagent_container/hypospray/autoinjector/bicaridine
	name = "bicaridine autoinjector"
	chemname = "bicaridine"
	desc = "An autoinjector loaded with 3 doses of 15u of Bicaridine, a common brute and circulatory damage medicine. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Bi"

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/random_amount

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/random_amount/Initialize()
	. = ..()
	var/amount = rand(1, 6)
	switch(amount)
		if(1)
			reagents.add_reagent("bicaridine", -45)
			uses_left = 0
			update_icon()
		if(2, 3)
			reagents.add_reagent("bicaridine", -30)
			uses_left = 1
			update_icon()
		if(4, 5)
			reagents.add_reagent("bicaridine", -15)
			uses_left = 2
			update_icon()

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless
	name = "bicaridine EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Bicaridine, a common brute and circulatory damage medicine. Doesn't require any training to use."
	icon_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = TRUE
	maptext_label = "EzBi"

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use
	name = "single-use bicaridine EZ autoinjector"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Bicaridine, a common brute and circulatory damage medicine. You cannot refill it, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	display_maptext = TRUE
	maptext_label = "OuBi"

/obj/item/reagent_container/hypospray/autoinjector/antitoxin
	name = "dylovene autoinjector"
	chemname = "anti_toxin"
	desc = "An autoinjector loaded with 3 doses of 15u of Dylovene, a common toxin damage medicine. You can refill it at Wey-Med vending machines."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Dy"

/obj/item/reagent_container/hypospray/autoinjector/antitoxin/skillless
	name = "dylovene EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 doses of 15u of Dylovene, a common toxin damage medicine. Doesn't require any training to use. You can refill it at Wey-Med vending machines."
	icon_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = TRUE
	maptext_label = "EzDy"

/obj/item/reagent_container/hypospray/autoinjector/antitoxin/skillless/one_use
	name = "single-use dylovene EZ autoinjector"
	desc = "An EZ autoinjector loaded with a single dose of 15u of Dylovene, a common toxin damage medicine. You cannot refill it, but it doesn't require any training to use."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1
	display_maptext = TRUE
	maptext_label = "OuDy"

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

/obj/item/reagent_container/hypospray/autoinjector/emergency
	name = "emergency autoinjector (CAUTION)"
	desc = "An autoinjector loaded with a single dose of 77u of a special cocktail of chemicals, to be used in life-threatening situations. Doesn't require any training to use."
	icon_state = "empty_emergency"
	chemname = "emergency"
	autoinjector_type = "autoinjector_oneuse"
	amount_per_transfer_from_this = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1)
	volume = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1)
	mixed_chem = TRUE
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	injectVOL = 70//limited-supply emergency injector with v.large injection of drugs. Variable sfx freq sometimes rolls too quiet.
	display_maptext = TRUE //see anaesthetic injector
	maptext_label = "!!"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/emergency/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("kelotane", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("oxycodone", MED_REAGENTS_OVERDOSE-1)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/black_goo_cure
	name = "\"Pathogen\" cure autoinjector (SINGLE-USE)"
	desc = "An autoinjector loaded with a single dose of a cure for Agent A0-3959X.91–15, also known as the 'black-goo'. Doesn't require any training to administrate."
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
	desc = "An autoinjector loaded with 5 doses of 5u of Ultrazine, a special and illegal muscle stimulant. Do not administer more than twice at a time. Highly addictive."
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
	name = "white autoinjector"
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

/obj/item/reagent_container/hypospray/autoinjector/skillless
	name = "first-aid autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with a single dose of 15u of tricordrazine for marines to treat themselves with. You can refill it at Wey-Med vending machines."
	icon_state = "tricord"
	autoinjector_type = null
	amount_per_transfer_from_this = 15
	volume = 15
	skilllock = SKILL_MEDICAL_DEFAULT
	uses_left = 1
	display_maptext = TRUE
	maptext_label = "OuTc"

/obj/item/reagent_container/hypospray/autoinjector/skillless/attack(mob/M as mob, mob/user as mob)
	. = ..()
	if(.)
		if(!uses_left) //Prevents autoinjectors to be refilled.
			icon_state += "0"
			name += " expended"
			flags_atom &= ~OPENCONTAINER

/obj/item/reagent_container/hypospray/autoinjector/skillless/attackby()
	return

/obj/item/reagent_container/hypospray/autoinjector/skillless/get_examine_text(mob/user)
	. = ..()
	if(reagents && length(reagents.reagent_list))
		. += SPAN_NOTICE("It is currently loaded.")
	else if(!uses_left)
		. += SPAN_NOTICE("It is spent.")
	else
		. += SPAN_NOTICE("It is empty.")

/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol
	name = "pain-stop autoinjector"
	chemname = "tramadol"
	icon_state = "tramadol"
	desc = "An autoinjector loaded with a single 15u dose of tramadol for marines to self-administer. You can refill it at Wey-Med vending machines."
	maptext_label = "OuPs"

/obj/item/reagent_container/hypospray/autoinjector/empty
	name = "5u custom autoinjector"
	desc = "A custom-made autoinjector, likely from research. You can refill it with a pressurized reagent canister pouch."
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
	name = "15u custom autoinjector"
	amount_per_transfer_from_this = 15
	volume = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/medium
	name = "30u custom autoinjector"
	amount_per_transfer_from_this = 30
	volume = 90

/obj/item/reagent_container/hypospray/autoinjector/empty/large
	name = "60u custom autoinjector"
	amount_per_transfer_from_this = 60
	volume = 180

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless
	name = "15u custom EZ autoinjector"
	desc = "A custom-made EZ autoinjector, likely from research. You can refill it with a pressurized reagent canister pouch. It injects its entire payload immediately and doesn't require any training."
	icon_state = "empty_research_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = 15
	volume = 15
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/unit
	name = "1u custom EZ autoinjector"
	volume = 1
	amount_per_transfer_from_this = 1

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall
	name = "5u custom EZ autoinjector"
	volume = 5
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small
	name = "10u custom EZ autoinjector"
	volume = 10
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/medium
	name = "30u custom EZ autoinjector"
	volume = 30
	amount_per_transfer_from_this = 30

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/large
	name = "45u custom EZ autoinjector"
	volume = 45
	amount_per_transfer_from_this = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/extralarge
	name = "60u custom EZ autoinjector"
	volume = 60
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/hypospray/autoinjector/empty/medic
	name = "15u Reagent Pouch Autoinjector"
	desc = "An autoinjector specifically designed to fit inside and refill from Pressurized Reagent Canister Pouches. Has a similar lock to pill bottles, and fits up to 6 injections."
	skilllock = SKILL_MEDICAL_MEDIC
	volume = 90
	amount_per_transfer_from_this = 15
	autoinjector_type = "autoinjector_medic"
	icon_state = "empty_medic"
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/large
	name = "30u Reagent Pouch Autoinjector"
	volume = 180
	amount_per_transfer_from_this = 30
