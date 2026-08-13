/obj/item/reagent_container/hypospray/autoinjector
	name = "inaprovaline autoinjector"
	var/chemname = "inaprovaline"
	var/autoinjector_type = "autoinjector" //referencing the icon state name in syringe.dmi
	//desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc = "An autoinjector loaded with three 30u doses of Inaprovaline, an emergency oxygen stabilizer for critical patients. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
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
	var/mixed_chem = FALSE //mini tank will not accept mixed_chem autoinjector types
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
/obj/item/reagent_container/hypospray/autoinjector/standard/tricordrazine
	name = "tricordrazine autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with three 15u doses of Tricordrazine, a general-use medicine for slowly treating the four types of damage. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tc"

/obj/item/reagent_container/hypospray/autoinjector/standard/tricordrazine/random_amount

/obj/item/reagent_container/hypospray/autoinjector/standard/tricordrazine/random_amount/Initialize()
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

/obj/item/reagent_container/hypospray/autoinjector/standard/adrenaline
	name = "epinephrine autoinjector"
	chemname = "adrenaline"
	desc = "An autoinjector loaded with three 5.25u doses of Epinephrine, better known as Adrenaline, a nerve stimulant useful in restarting the heart during defibrillation. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ep"

/obj/item/reagent_container/hypospray/autoinjector/standard/dexalinp
	name = "dexalin plus autoinjector"
	chemname = "dexalinp"
	desc = "An autoinjector loaded with three 1u doses of Dexalin+, a medication designed to oxygenate the entire body immediately. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = 1
	volume = 3
	display_maptext = TRUE
	maptext_label = "D+"

/obj/item/reagent_container/hypospray/autoinjector/standard/tramadol
	name = "tramadol autoinjector"
	chemname = "tramadol"
	desc = "An autoinjector loaded with three 15u doses of Tramadol, a weak but effective painkiller for normal wounds. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tr"

/obj/item/reagent_container/hypospray/autoinjector/standard/tramadol/random_amount

/obj/item/reagent_container/hypospray/autoinjector/standard/tramadol/random_amount/Initialize()
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

/obj/item/reagent_container/hypospray/autoinjector/standard/oxycodone
	name = "oxycodone autoinjector (EXTREME PAINKILLER)"
	chemname = "oxycodone"
	desc = "An autoinjector loaded with three 10u doses of Oxycodone, a powerful painkiller intended for life-threatening situations. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ox"

/obj/item/reagent_container/hypospray/autoinjector/standard/kelotane
	name = "kelotane autoinjector"
	chemname = "kelotane"
	desc = "An autoinjector loaded with three 15u doses of Kelotane, a common burn medicine. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Kl"

/obj/item/reagent_container/hypospray/autoinjector/standard/kelotane/random_amount

/obj/item/reagent_container/hypospray/autoinjector/standard/kelotane/random_amount/Initialize()
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


/obj/item/reagent_container/hypospray/autoinjector/standard/bicaridine
	name = "bicaridine autoinjector"
	chemname = "bicaridine"
	desc = "An autoinjector loaded with three 15u doses of Bicaridine, a common brute and circulatory damage medicine. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Bi"

/obj/item/reagent_container/hypospray/autoinjector/standard/bicaridine/random_amount

/obj/item/reagent_container/hypospray/autoinjector/standard/bicaridine/random_amount/Initialize()
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

/obj/item/reagent_container/hypospray/autoinjector/standard/antitoxin
	name = "dylovene autoinjector"
	chemname = "anti_toxin"
	desc = "An autoinjector loaded with three 15u doses of Dylovene, a common toxin damage-purging medicine. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Dy"

/obj/item/reagent_container/hypospray/autoinjector/standard/meralyne
	name = "meralyne autoinjector"
	desc = "An autoinjector loaded with three 15u doses of Meralyne, an advanced brute and circulatory damage medicine. You cannot refill it at Wey-Med vending machines, but you can refill it with a smart tank."
	chemname = "meralyne"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Me"

/obj/item/reagent_container/hypospray/autoinjector/standard/dermaline
	name = "dermaline autoinjector"
	desc = "An autoinjector loaded with three 15u doses of Dermaline, an advanced burn medicine. You cannot refill it at Wey-Med vending machines, but you can refill it with a smart tank."
	chemname = "dermaline"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "De"

/obj/item/reagent_container/hypospray/autoinjector/standard/inaprovaline
	name = "inaprovaline autoinjector"
	chemname = "inaprovaline"
	desc = "An autoinjector loaded with three 30u doses of Inaprovaline, an emergency oxygen stabilization medicine for critical patients. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "In"

/obj/item/reagent_container/hypospray/autoinjector/standard/peridaxon
	name = "peridaxon autoinjector"
	chemname = "peridaxon"
	desc = "An autoinjector loaded with three 7.5u doses of Peridaxon, an emergency medicine used to stabilize organs while a patient waits for surgery. Does not fix organ damage. Only those trained in medicine can use it. You can refill it at Wey-Med vending machines or with a smart tank."
	amount_per_transfer_from_this = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Pr"

//EZ AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/ez //for ERT only
	chemname = "inaprovaline"
	desc = "An EZ autoinjector loaded with three 30u doses of Inaprovaline, a common oxygen stabilizer for critical patients. You can refill it at Wey-Med vending machines or with a smart tank, and it does not require any training to use."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "emptyskill"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzIn"

/obj/item/reagent_container/hypospray/autoinjector/ez/tricordrazine
	name = "tricordrazine EZ autoinjector"
	chemname = "tricordrazine"
	desc = "An EZ autoinjector loaded with three 15u doses of Tricordrazine, a common-spectrum damage healer. You can refill it at Wey-Med vending machines or with a smart tank and it does not require any training to use."
	maptext_label = "EzTc"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/ez/tramadol
	name = "tramadol EZ autoinjector"
	chemname = "tramadol"
	desc = "An EZ autoinjector loaded with three 15u doses of Tramadol, a weak but effective painkiller for normal wounds. You can refill it at Wey-Med vending machines or with a smart tank and it doesn't require any training to use."
	maptext_label = "EzTr"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/ez/kelotane
	name = "kelotane EZ autoinjector"
	chemname = "kelotane"
	desc = "An EZ autoinjector loaded with three 15u doses of Kelotane, a common burn-repairing medicine. You can refill it at Wey-Med vending machines or with a smart tank and it doesn't require any training to use."
	maptext_label = "EzKl"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/ez/bicaridine
	name = "bicaridine EZ autoinjector"
	chemname = "bicaridine"
	desc = "An EZ autoinjector loaded with three 15u doses of Bicaridine, a common brute and circulatory damage-repairing medicine. You can refill it at Wey-Med vending machines or with a smart tank and it doesn't require any training to use."
	maptext_label = "EzBi"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/ez/antitoxin
	name = "dylovene EZ autoinjector"
	chemname = "anti_toxin"
	desc = "An EZ autoinjector loaded with three 15u doses of Dylovene, a common toxin damage-purging medicine. You can refill it at Wey-Med vending machines or with a smart tank and it doesn't require any training to use. Thankfully, there's no lock on it, so anyone can use it!"
	maptext_label = "EzDy"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

//MARINE AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/ez/one_use
	name = "crit-save EZ autoinjector"
	chemname = "inaprovaline"
	desc = "An EZ autoinjector loaded with a single 30u dose of Inaprovaline for marines to self-administer if they think they will pass out. You can refill it at Wey-Med vending machines or with a smart tank."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	skilllock = SKILL_MEDICAL_DEFAULT
	uses_left = 1
	display_maptext = TRUE
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/tricordrazine
	name = "first-aid EZ autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with a single 15u dose of Tricordrazine for marines to self-administer for treating basic wounds. You can refill it at Wey-Med vending machines, at wall-meds, or with a smart tank. Thankfully, there's no lock on it, so anyone can use it!"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "OuTc"


/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/tramadol
	name = "pain-stop EZ autoinjector"
	chemname = "tramadol"
	desc = "An autoinjector loaded with a single 15u dose of Tramadol for marines to self-administer to alleviate their pain. You can refill it at Wey-Med vending machines, at wall meds, or with a smart tank. Thankfully, there's no lock on it, so anyone can use it!"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "OuTr"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/antitoxin
	name = "antitoxin EZ autoinjector"
	chemname = "anti_toxin"
	desc = "An autoinjector loaded with a single 15u dose of Dylovene for marines to self-administer for removing toxins. You can refill it at Wey-Med vending machines, at wall meds, or with a smart tank. Thankfully, there's no lock on it, so anyone can use it!"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "OuDy"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/bicaridine
	name = "wound care EZ autoinjector"
	chemname = "bicaridine"
	desc = "An autoinjector loaded with a single 15u dose of Bicaridine for marines to self-administer for treating serious wounds. You can refill it at Wey-Med vending machines, at wall meds, or with a smart tank. Thankfully, there's no lock on it, so anyone can use it!"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "OuBi"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/kelotane
	name = "burn care EZ autoinjector"
	chemname = "kelotane"
	desc = "An autoinjector loaded with a single 15u dose of Kelotane for marines to self-administer for the most serious burns. You can refill it at Wey-Med vending machines, at wall meds, or with a smart tank. Thankfully, there's no lock on it, so anyone can use it!"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "OuKl"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/dexalin
	name = "inhaler EZ autoinjector"
	chemname = "kelotane"
	desc = "An autoinjector loaded with a single 15u dose of Dexalin for marines to self-administer for when they cannot breathe. You can refill it at Wey-Med vending machines, at wall meds, or with a smart tank. Thankfully, there's no lock on it, so anyone can use it!"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "OuDx"

//TUTORIAL AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/tutorial
	name = "tricordrazine EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with a single 15u dose of Tricordrazine, a common wide-spectrum damage healer. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	icon_state = "empty_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	uses_left = 1
	maptext_label = "OuTc"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/tramadol
	name = "tramadol EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "tramadol"
	desc = "An autoinjector loaded with a single 15u dose of Tramadol, a common pain-killing medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuTr"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/kelotane
	name = "kelotane EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "kelotane"
	desc = "An autoinjector loaded with a single 15u dose of Kelotane, a common burn medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuKl"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/bicaridine
	name = "bicaridine EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "bicaridine"
	desc = "An autoinjector loaded with a single 15u dose of Bicaridine, a common brute and circulatory damage medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuBi"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/dexalinp //in case we ever want to add oxygen damage to the medical tutorial
	name = "dexalin plus EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "dexalinp"
	desc = "An autoinjector loaded with a single 1u dose of Dexalin Plus, an instant oxygen damage killer. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	volume = 1
	amount_per_transfer_from_this = 1
	maptext_label = "OuD+"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/antitoxin //in case we ever want to add toxin damage to the medical tutorial
	name = "dylovene EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "anti_toxin"
	desc = "An EZ autoinjector loaded with a single 15u dose of Dylovene, a common toxin damage-purging medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuDy"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/adrenaline //in case we ever want to add defibrillation to the medical tutorial
	name = "epinephrine EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "adrenaline"
	desc = "An EZ autoinjector loaded with a single 5u dose of Epinephrine, a medicine used to stabilize defibrillated patients. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuDy"
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/inaprovaline //in case we ever want to treat critical patients during the the medical tutorial
	name = "inaprovaline EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "inaprovaline"
	desc = "An EZ autoinjector loaded with a single 30u dose of Inaprovaline, an emergency medicine used to stabilize critical patients. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuIn"
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

/obj/item/reagent_container/hypospray/autoinjector/tutorial/peridaxon //in case we ever want to simulate transporting somebody to surgery.
	name = "peridaxon EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "peridaxon"
	desc = "An EZ autoinjector loaded with a single 7.5u dose of Peridaxon, used to stabilize a patient's organs before surgery. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents. Most autoinjectors can be refilled with a Wey-Med vending machine."
	maptext_label = "OuIn"
	amount_per_transfer_from_this = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES

//MIXED/MISC CHEMS THAT CANNOT BE REFILLED
/obj/item/reagent_container/hypospray/autoinjector/no_refill/chloralhydrate
	name = "anesthetic autoinjector"
	chemname = "anesthetic"
	desc = "An autoinjector loaded with three 1u doses of Chloral Hydrate and three 9u doses of a sleep agent. Good to quickly pacify someone--for surgery, of course! What? Are you some sort of criminal?"
	amount_per_transfer_from_this = 10
	volume = 30
	mixed_chem = TRUE
	display_maptext = TRUE
	maptext_label = "Zzz"

/obj/item/reagent_container/hypospray/autoinjector/no_refill/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 1*3)
	reagents.add_reagent("stoxin", 9*3)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/no_refill/emergency
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

/obj/item/reagent_container/hypospray/autoinjector/no_refill/emergency/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("kelotane", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("oxycodone", MED_REAGENTS_OVERDOSE-1)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/no_refill/black_goo_cure
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

/obj/item/reagent_container/hypospray/autoinjector/no_refill/black_goo_cure/Initialize()
	. = ..()
	reagents.add_reagent("antiZed", 5)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/no_refill/ultrazine
	name = "ultrazine stimpack"
	chemname = "ultrazine"
	desc = "A stimpack loaded with 5 doses of 5u of Ultrazine, a special and illegal muscle stimulant. Do not administer more than twice at a time. Highly addictive."
	amount_per_transfer_from_this = 5
	volume = 25
	uses_left = 5
	autoinjector_type = "+stimpack_custom"
	icon_state = "stimpack"
	autoinjector_type = null
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = FALSE //corporate secret
	maptext_label = "Uz"

/obj/item/reagent_container/hypospray/autoinjector/no_refill/ultrazine/update_icon()
	. = ..()
	icon_state = uses_left ? "stimpack" : "stimpack0"
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[maptext_label]")
	else
		maptext = ""

/obj/item/reagent_container/hypospray/autoinjector/no_refill/ultrazine/empty
	name = "empty ultrazine stimpack"
	volume = 0
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/no_refill/ultrazine/liaison
	name = "white stimpack"
	desc = "You know what they say, don't jab yourself with suspicious syringes."
	maptext_label = "??"

/obj/item/reagent_container/hypospray/autoinjector/no_refill/yautja
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

/obj/item/reagent_container/hypospray/autoinjector/no_refill/yautja/thrall
	name = "orange unusual crystal"
	chemname = "dathwei"
	color = "#c46b41"

/obj/item/reagent_container/hypospray/autoinjector/no_refill/yautja/attack(mob/M as mob, mob/user as mob)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		..()
	else
		to_chat(user, SPAN_DANGER("You have no idea where to inject [src]."))

	if(uses_left == 0)
		addtimer(CALLBACK(src, PROC_REF(remove_crystal)), 120 SECONDS)

/obj/item/reagent_container/hypospray/autoinjector/no_refill/yautja/proc/remove_crystal()
	visible_message(SPAN_DANGER("[src] collapses into nothing."))
	qdel(src)

/obj/item/reagent_container/hypospray/autoinjector/no_refill/yautja/update_icon()
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

/obj/item/reagent_container/hypospray/autoinjector/research
	name = "5u custom autoinjector"
	desc = "A custom-made autoinjector, likely from research. You can refill it with a pressurized reagent canister pouch."
	icon_state = "empty_research"
	mixed_chem = TRUE
	amount_per_transfer_from_this = 5
	volume = 15
	uses_left = 0
	display_maptext = TRUE

/obj/item/reagent_container/hypospray/autoinjector/research/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It transfers [amount_per_transfer_from_this]u per injection and has a maximum of [volume/amount_per_transfer_from_this] injections.")

/obj/item/reagent_container/hypospray/autoinjector/research/small
	name = "15u custom autoinjector"
	amount_per_transfer_from_this = 15
	volume = 45

/obj/item/reagent_container/hypospray/autoinjector/research/medium
	name = "30u custom autoinjector"
	amount_per_transfer_from_this = 30
	volume = 90

/obj/item/reagent_container/hypospray/autoinjector/research/large
	name = "60u custom autoinjector"
	amount_per_transfer_from_this = 60
	volume = 180

/obj/item/reagent_container/hypospray/autoinjector/research/ez
	name = "15u custom EZ autoinjector"
	desc = "A custom-made EZ autoinjector, likely from research. You can refill it with a pressurized reagent canister pouch. It injects its entire payload immediately and doesn't require any training."
	icon_state = "empty_research_oneuse"
	autoinjector_type = "autoinjector_oneuse"
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = 15
	volume = 15
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/research/ez/unit
	name = "1u custom EZ autoinjector"
	volume = 1
	amount_per_transfer_from_this = 1

/obj/item/reagent_container/hypospray/autoinjector/research/ez/verysmall
	name = "5u custom EZ autoinjector"
	volume = 5
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/research/ez/small
	name = "10u custom EZ autoinjector"
	volume = 10
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/research/ez/medium
	name = "30u custom EZ autoinjector"
	volume = 30
	amount_per_transfer_from_this = 30

/obj/item/reagent_container/hypospray/autoinjector/research/ez/large
	name = "45u custom EZ autoinjector"
	volume = 45
	amount_per_transfer_from_this = 45

/obj/item/reagent_container/hypospray/autoinjector/research/ez/extralarge
	name = "60u custom EZ autoinjector"
	volume = 60
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/hypospray/autoinjector/research/medic
	name = "15u Reagent Pouch Autoinjector"
	desc = "An autoinjector specifically designed to fit inside and refill from Pressurized Reagent Canister Pouches. Has a similar lock to pill bottles, and fits up to 6 injections."
	skilllock = SKILL_MEDICAL_MEDIC
	volume = 90
	amount_per_transfer_from_this = 15
	autoinjector_type = "autoinjector_medic"
	icon_state = "empty_medic"
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/large
	name = "30u Reagent Pouch Autoinjector"
	volume = 180
	amount_per_transfer_from_this = 30
