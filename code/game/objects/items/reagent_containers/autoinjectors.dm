/obj/item/reagent_container/hypospray/autoinjector
	name = "inaprovaline autoinjector"
	var/chemname = "inaprovaline"
	var/autoinjector_type = "autoinjector" //referencing the icon state name in syringe.dmi
	//desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc = "An autoinjector that injects an emergency oxygen stabilizer for critical patients."
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
	skilllock = SKILL_MEDICAL_DEFAULT
	var/uses_left = 3
	var/mixed_chem = FALSE //mini tank will not accept mixed_chem autoinjector types
	var/cannot_refill = FALSE
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
	if(uses_left >= 0)
		if(istype(src, /obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison))
			. += SPAN_NOTICE("It is currently loaded with [reagents.total_volume / amount_per_transfer_from_this]/[volume / amount_per_transfer_from_this] injections of ... Something? You don't know what's in this.")
		else if(volume == amount_per_transfer_from_this) //one-use autoinjectors
			. += SPAN_NOTICE("It is currently loaded with a single injection of [amount_per_transfer_from_this]u [capitalize(chemname)].")
			if(istype(src, /obj/item/reagent_container/hypospray/autoinjector/yautja)) //this is a yautja crystal
				if(isyautja(user)) //is a yautja looking at it or not?
					. += SPAN_NOTICE("It is currently loaded with a single injection of [amount_per_transfer_from_this]u [capitalize(chemname)].")
				else
					. += SPAN_NOTICE("You do not know how many injections it has or what is in it.")
		else
			. += SPAN_NOTICE("It is currently loaded with [reagents.total_volume / amount_per_transfer_from_this]/[volume / amount_per_transfer_from_this] injections of [amount_per_transfer_from_this]u [capitalize(chemname)].")


	else if(uses_left <= 0)
		if(cannot_refill == TRUE)
			if(istype(src, /obj/item/reagent_container/hypospray/autoinjector/yautja)) //this is a yautja crystal
				if(isyautja(user)) //is a yautja looking at it or not?
					. += SPAN_WARNING("It is spent and will soon disintegrate.")
				else
					. += SPAN_NOTICE("You do not know how many injections it has or what is in it.")
			else
				. += SPAN_WARNING("It is spent and it has no means of refilling. It must be disposed of.")
		else if(istype(src, /obj/item/reagent_container/hypospray/autoinjector/ez) || istype(src, /obj/item/reagent_container/hypospray/autoinjector/tutorial))
			. += SPAN_NOTICE("It is empty, but you can refill it at any Wey-Med Plus Dispenser, any Wall-Med, or with an MS-11 Smart Refill Tank.")
		else if(istype(src, /obj/item/reagent_container/hypospray/autoinjector/standard))
			. += SPAN_NOTICE("It is empty, but you can refill it at any Wey-Med Plus Dispenser, Wey-Med resupply station, or with an MS-11 Smart Refill Tank.")
		else
			. += SPAN_NOTICE("It is empty.")
	if(!istype(src, /obj/item/reagent_container/hypospray/autoinjector/yautja))
		if(skilllock == SKILL_MEDICAL_MEDIC)
			. += SPAN_NOTICE("It has a lock on it similar to pill bottles. Only those with sufficient medical training can unlock it.")
		else
			. += SPAN_NOTICE("It doesn't have a lock on it, so anyone can use it.")



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

/obj/item/reagent_container/hypospray/autoinjector/standard //pathing purposes only
	name = "autoinjector"
	chemname = "tricordrazine"
	desc = "You're not supposed to see this. Please Ahelp."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tc"
	skilllock = SKILL_MEDICAL_MEDIC

/obj/item/reagent_container/hypospray/autoinjector/standard/tricordrazine
	name = "tricordrazine autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector that injects a general-use medicine for slowly treating the four types of damage."
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
	desc = "An autoinjector that injects a nerve stimulant useful in restarting the heart after defibrillation."
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "Ep"

/obj/item/reagent_container/hypospray/autoinjector/standard/dexalinp
	name = "dexalin plus autoinjector"
	chemname = "dexalinp"
	desc = "An autoinjector that injects a medication designed to immediately oxygenate the entire body."
	amount_per_transfer_from_this = 1
	volume = 3
	maptext_label = "D+"

/obj/item/reagent_container/hypospray/autoinjector/standard/tramadol
	name = "tramadol autoinjector"
	chemname = "tramadol"
	desc = "An autoinjector that injects weak but effective painkiller for normal wounds."
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
	desc = "An autoinjector that injects powerful painkiller intended for life-threatening situations."
	amount_per_transfer_from_this = MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "Ox"

/obj/item/reagent_container/hypospray/autoinjector/standard/kelotane
	name = "kelotane autoinjector"
	chemname = "kelotane"
	desc = "An autoinjector that injects a common burn-salving medicine."
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
	desc = "An autoinjector that injects a common brute-mending medicine."
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
	desc = "An autoinjector that injects a common toxin damage-purging medicine."
	maptext_label = "Dy"

/obj/item/reagent_container/hypospray/autoinjector/standard/meralyne
	name = "meralyne autoinjector"
	desc = "An autoinjector that injects an advanced brute-mending medicine."
	chemname = "meralyne"
	maptext_label = "Me"

/obj/item/reagent_container/hypospray/autoinjector/standard/dermaline
	name = "dermaline autoinjector"
	desc = "An autoinjector that injects an advanced burn-salving medicine."
	chemname = "dermaline"
	maptext_label = "De"

/obj/item/reagent_container/hypospray/autoinjector/standard/inaprovaline
	name = "inaprovaline autoinjector"
	chemname = "inaprovaline"
	desc = "An autoinjector that injects an emergency oxygen stabilizer for critical patients."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "In"

/obj/item/reagent_container/hypospray/autoinjector/standard/peridaxon
	name = "peridaxon autoinjector"
	chemname = "peridaxon"
	desc = "An autoinjector that injects an emergency medicine used to stabilize a patient's organs before surgery."
	amount_per_transfer_from_this = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Pr"


//EZ AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/ez
	name = "EZ autoinjector"
	chemname = "tricordrazine"
	desc = "You're not supposed to see this. Ahelp it."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	icon_state = "empty_ez"
	autoinjector_type = "autoinjector"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "EzTc"

/obj/item/reagent_container/hypospray/autoinjector/ez/tricordrazine
	name = "tricordrazine EZ autoinjector"
	chemname = "tricordrazine"
	desc = "An EZ autoinjector that injects a general-use medicine for slowly treating the four types of damage."
	maptext_label = "EzTc"

/obj/item/reagent_container/hypospray/autoinjector/ez/inaprovaline
	name = "inaprovaline EZ autoinjector"
	chemname = "tricordrazine"
	desc = "An EZ autoinjector that injects an emergency oxygen stabilizer for critical patients."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	maptext_label = "EzIn"

/obj/item/reagent_container/hypospray/autoinjector/ez/tramadol
	name = "tramadol EZ autoinjector"
	chemname = "tramadol"
	desc = "An EZ autoinjector that injects a weak but effective painkiller for normal wounds."
	maptext_label = "EzTr"

/obj/item/reagent_container/hypospray/autoinjector/ez/kelotane
	name = "kelotane EZ autoinjector"
	chemname = "kelotane"
	desc = "An EZ autoinjector that injects a common burn-mending medicine."
	maptext_label = "EzKl"

/obj/item/reagent_container/hypospray/autoinjector/ez/bicaridine
	name = "bicaridine EZ autoinjector"
	chemname = "bicaridine"
	desc = "An EZ autoinjector that injects a common brute=mending medicine."
	maptext_label = "EzBi"

/obj/item/reagent_container/hypospray/autoinjector/ez/antitoxin
	name = "dylovene EZ autoinjector"
	chemname = "anti_toxin"
	desc = "An EZ autoinjector that injects a common toxin damage-purging medicine."
	maptext_label = "EzDy"

/obj/item/reagent_container/hypospray/autoinjector/ez/dexalin
	name = "dexaline EZ autoinjector"
	chemname = "dexalin"
	desc = "An EZ autoinjector that injects a common toxin damage-purging medicine."
	maptext_label = "EzDx"



//MARINE AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/ez/one_use
	name = "EZ autoinjector"
	chemname = "tricordrazine"
	desc = "You're not supposed to see this. Ahelp it."
	icon_state = "empty_single"
	autoinjector_type = "autoinjector_single"
	skilllock = SKILL_MEDICAL_DEFAULT
	uses_left = 1
	display_maptext = TRUE
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD


/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/inaprovaline
	name = "crit-save EZ autoinjector"
	chemname = "inaprovaline"
	desc = "An EZ one-use autoinjector that injects a medicine for marines to self-administer if they think they will pass out."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	maptext_label = "OuIn"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/tricordrazine
	name = "first-aid EZ autoinjector"
	chemname = "tricordrazine"
	desc = "An EZ one-use autoinjector that injects medicine for marines to self-administer for treating basic wounds. It injects its entire payload immediately."
	maptext_label = "OuTc"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/tramadol
	name = "pain-stop EZ autoinjector"
	chemname = "tramadol"
	desc = "An EZ one-use autoinjector that injects medicine for marines to self-administer to alleviate their pain. It injects its entire payload immediately."
	maptext_label = "OuTr"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/antitoxin
	name = "antitoxin EZ autoinjector"
	chemname = "anti_toxin"
	desc = "An EZ one-use autoinjector that injects medicine for marines to self-administer for removing toxins. It injects its entire payload immediately."
	maptext_label = "OuDy"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/bicaridine
	name = "wound care EZ autoinjector"
	chemname = "bicaridine"
	desc = "An EZ one-use autoinjector that injects medicine for marines to self-administer for mending serious wounds from the inside out. It injects its entire payload immediately."
	maptext_label = "OuBi"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/kelotane
	name = "burn care EZ autoinjector"
	chemname = "kelotane"
	desc = "An EZ one-use autoinjector that injects medicine for marines to self-administer for treating serious burns from the inside out. It injects its entire payload immediately."
	maptext_label = "OuKl"

/obj/item/reagent_container/hypospray/autoinjector/ez/one_use/dexalin
	name = "inhaler EZ autoinjector"
	chemname = "kelotane"
	desc = "An EZ one-use autoinjector that injects medicine for marines to self-administer for when they're struggling to breathe. It injects its entire payload immediately."
	maptext_label = "OuDx"

//TUTORIAL AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/tutorial
	name = "tricordrazine EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "tricordrazine"
	desc = "An EZ one-use autoinjector that injects a common wide-spectrum damage healer. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	icon_state = "empty_tutorial"
	autoinjector_type = "autoinjector_single"
	display_maptext = TRUE
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	uses_left = 1
	maptext_label = "OuTc"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/tramadol
	name = "tramadol EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "tramadol"
	desc = "An EZ one-use autoinjector that injects Tramadol, a common pain-killing medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuTr"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/kelotane
	name = "kelotane EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "kelotane"
	desc = "An EZ one-use autoinjector that injects a common burn-mending medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuKl"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/bicaridine
	name = "bicaridine EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "bicaridine"
	desc = "An EZ one-use autoinjector that injects a common brute-mending medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuBi"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/dexalinp //in case we ever want to add oxygen damage to the medical tutorial
	name = "dexalin plus EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "dexalinp"
	desc = "An EZ one-use autoinjector that injects an instant oxygen damage killer. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	volume = 1
	amount_per_transfer_from_this = 1
	maptext_label = "OuD+"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/antitoxin //in case we ever want to add toxin damage to the medical tutorial
	name = "dylovene EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "anti_toxin"
	desc = "An EZ one-use autoinjector that injects a common toxin damage-purging medicine. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuDy"

/obj/item/reagent_container/hypospray/autoinjector/tutorial/adrenaline //in case we ever want to add defibrillation to the medical tutorial
	name = "epinephrine EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "adrenaline"
	desc = "An EZ one-use autoinjector that injects a medicine used to stabilize defibrillated patients. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuEp"
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD

/obj/item/reagent_container/hypospray/autoinjector/tutorial/inaprovaline //in case we ever want to treat critical patients during the the medical tutorial
	name = "inaprovaline EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "inaprovaline"
	desc = "An EZ one-use autoinjector that injects an emergency medicine used to stabilize critical patients. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuIn"
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD

/obj/item/reagent_container/hypospray/autoinjector/tutorial/peridaxon //in case we ever want to simulate transporting somebody to surgery.
	name = "peridaxon EZ autoinjector (FOR TRAINING USE ONLY)"
	chemname = "peridaxon"
	desc = "An EZ one-use autoinjector that injects an emergency medicine used to stabilize a patient's organs before surgery. To use it, click the autoinjector while it is in your hand. You can also click any person one tile near you, or yourself, to inject its contents."
	maptext_label = "OuPr"
	amount_per_transfer_from_this = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD


//MIXED/MISC AUTOINJECTORS THAT CANNOT BE REFILLED
/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate
	name = "anesthetic autoinjector"
	chemname = "anesthetic"
	desc = "An autoinjector that injects a cocktail of anesthetics. Good to quickly pacify someone--for surgery, of course! What? Are you some sort of criminal?"
	amount_per_transfer_from_this = 10
	volume = 30
	mixed_chem = TRUE
	display_maptext = TRUE
	maptext_label = "Zzz"
	cannot_refill = TRUE

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 1*3)
	reagents.add_reagent("stoxin", 9*3)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/emergency
	name = "emergency EZ autoinjector (HIGH DOSE CAUTION)"
	desc = "A massive ez autoinjector that injects a special cocktail of chemicals to be used in life-threatening situations. It doesn't require any training to administer. WARNING: DO NOT USE IF THE PATIENT HAS BICARIDINE, KELOTANE, OR OXYCODONE IN THEIR SYSTEM AS THE PATIENT *WILL* OVERDOSE!"
	icon_state = "empty_emergency"
	chemname = "emergency mix"
	autoinjector_type = "autoinjector_single"
	amount_per_transfer_from_this = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1) + 1 //dexalin plus is the +1
	volume = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1) + 1 //dexalin plus is the +1
	mixed_chem = TRUE
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	injectVOL = 70 //limited-supply emergency injector with v.large injection of drugs. Variable sfx freq sometimes rolls too quiet.
	display_maptext = TRUE //see anaesthetic injector
	maptext_label = "!!"
	skilllock = SKILL_MEDICAL_DEFAULT
	cannot_refill = TRUE

/obj/item/reagent_container/hypospray/autoinjector/emergency/Initialize() //29u bicaridine, 29u kelotane, 19u oxycodone, 1u dexalin +.
	. = ..()
	reagents.add_reagent("bicaridine", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("kelotane", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("oxycodone", MED_REAGENTS_OVERDOSE-1)
	reagents.add_reagent("dexalinp", 1) //I can breathe! Get me to surgery, please!
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/black_goo_cure
	name = "\"Pathogen\" cure EZ autoinjector (SINGLE-USE)"
	desc = "An EZ autoinjectort that injects a cure for Agent A0-3959X.91–15, also known as the 'black goo.'"
	icon_state = "empty_research_single"
	chemname = "antiZed"
	autoinjector_type = "autoinjector_single"
	amount_per_transfer_from_this = 5
	volume = 5
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	mixed_chem = TRUE
	display_maptext = TRUE
	maptext_label = "!!!"
	skilllock = SKILL_MEDICAL_DEFAULT
	cannot_refill = TRUE

/obj/item/reagent_container/hypospray/autoinjector/black_goo_cure/Initialize()
	. = ..()
	reagents.add_reagent("antiZed", 5)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/ultrazine
	name = "ultrazine stimpack"
	chemname = "ultrazine"
	desc = "An stimpack that injects ultrazine, a special and illegal muscle stimulant. It doesn't require any training to administer. Do not administer more than twice at a time. Highly addictive."
	amount_per_transfer_from_this = 5
	volume = 25
	uses_left = 5
	icon_state = "stimpack"
	autoinjector_type = "+stimpack_custom"
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = FALSE //corporate secret
	cannot_refill = TRUE

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/update_icon()
	. = ..()
	icon_state = uses_left ? "stimpack" : "stimpack0"
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[maptext_label]")
	else
		maptext = ""

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/empty
	name = "ultrazine stimpack"
	volume = 0
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison
	name = "strange stimpack"
	desc = "You know what they say, don't jab yourself with suspicious syringes."
	maptext_label = "???"

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
	cannot_refill = TRUE

/obj/item/reagent_container/hypospray/autoinjector/yautja/thrall
	name = "orange unusual crystal"
	chemname = "dathwei"
	color = "#c46b41"

/obj/item/reagent_container/hypospray/autoinjector/yautja/attack(mob/M as mob, mob/user as mob)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		..()
	else
		to_chat(user, SPAN_DANGER("You have no idea where or how to inject [src]."))

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
/obj/item/reagent_container/hypospray/autoinjector/research
	name = "custom autoinjector (15u)"
	desc = "A custom-made autoinjector, likely from research."
	icon_state = "empty_research"
	skilllock = SKILL_MEDICAL_TRAINED
	mixed_chem = TRUE
	amount_per_transfer_from_this = 15
	volume = 45
	uses_left = 0
	display_maptext = FALSE

/obj/item/reagent_container/hypospray/autoinjector/research/get_examine_text(mob/user)
	if(uses_left >= 0)
		. += SPAN_NOTICE("It is currently loaded with [reagents.total_volume / amount_per_transfer_from_this]/[volume / amount_per_transfer_from_this] injections of [amount_per_transfer_from_this]u of whatever you put in it.")
		if(volume == amount_per_transfer_from_this)
			. += SPAN_NOTICE("It is currently loaded with a single injection of [amount_per_transfer_from_this]u of whatever you put in it.") //one-use autoinjectors
	else if(uses_left <= 0)
		. += SPAN_NOTICE("It is empty, but you can refill it with a pressurized reagent canister pouch.")

	if(skilllock == SKILL_MEDICAL_MEDIC)
		. += SPAN_NOTICE("It has a lock on it similar to pill bottles. Only those with sufficient medical training can unlock it.")
	else
		. += SPAN_NOTICE("It doesn't have a lock on it, so anyone can use it.")

/obj/item/reagent_container/hypospray/autoinjector/research/verb/flush_autoinjector()
	set category = "Object"
	set name = "Flush Autoinjector"
	set desc = "Flush the autoinjector to empty its reagents."
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	if(reagents.total_volume <= 0)
		to_chat(usr, SPAN_NOTICE("[src] is already empty."))
		return

	to_chat(usr, SPAN_NOTICE("You hold down the emergency flush button. Wait 1 second..."))

	if(!do_after(usr, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(usr, SPAN_WARNING("You get distracted and stop trying to empty [src]."))
		return

	playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1, 3)
	to_chat(usr, SPAN_WARNING("You work the flush valve and successfully flush [src]'s contents!"))
	reagents.clear_reagents()
	uses_left = 0
	update_icon()
	return

/obj/item/reagent_container/hypospray/autoinjector/research/small
	name = "custom autoinjector (5u)"
	amount_per_transfer_from_this = 5
	volume = 15

/obj/item/reagent_container/hypospray/autoinjector/research/medium
	name = "custom autoinjector (15u)"
	amount_per_transfer_from_this = 15
	volume = 45

/obj/item/reagent_container/hypospray/autoinjector/research/large
	name = "custom autoinjector (30u)"
	amount_per_transfer_from_this = 30
	volume = 90

/obj/item/reagent_container/hypospray/autoinjector/research/huge
	name = "custom autoinjector (60u)"
	amount_per_transfer_from_this = 60
	volume = 180


//CUSTOM EZ AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/research/ez
	name = "custom EZ one-use autoinjector (15u)"
	desc = "A custom-made EZ autoinjector, likely from research. It injects its entire payload immediately."
	icon_state = "empty_research_single"
	autoinjector_type = "autoinjector_single"
	amount_per_transfer_from_this = 15
	skilllock = SKILL_MEDICAL_DEFAULT
	volume = 15
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/research/ez/unit
	name = "custom EZ one-use autoinjector (1u)"
	amount_per_transfer_from_this = 1
	volume = 1


/obj/item/reagent_container/hypospray/autoinjector/research/ez/verysmall
	name = "custom EZ one-use autoinjector (5u)"
	volume = 5
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/research/ez/small
	name = "custom EZ one-use autoinjector (10u)"
	volume = 10
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/research/ez/medium
	name = "custom EZ one-use autoinjector (15u)"
	volume = 15
	amount_per_transfer_from_this = 15

/obj/item/reagent_container/hypospray/autoinjector/research/ez/large
	name = "custom EZ one-use autoinjector (30u)"
	volume = 30
	amount_per_transfer_from_this = 30

/obj/item/reagent_container/hypospray/autoinjector/research/ez/extralarge
	name = "custom EZ one-use autoinjector (45u)"
	volume = 45
	amount_per_transfer_from_this = 45

/obj/item/reagent_container/hypospray/autoinjector/research/ez/huge
	name = "custom EZ one-use autoinjector (60u)"
	volume = 60
	amount_per_transfer_from_this = 60

//REAGENT POUCH AUTOINJECTORS
/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch
	name = "reagent canister pouch autoinjector (15u)"
	desc = "An autoinjector specifically designed to fit inside and refill only from pressurized reagent canister pouches with filled canisters inside. It uniquely fits up to 6 doses of medicine."
	skilllock = SKILL_MEDICAL_MEDIC
	volume = 90
	amount_per_transfer_from_this = 15
	autoinjector_type = "autoinjector_medic"
	icon_state = "empty_medic"
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/tiny
	name = "reagent canister pouch autoinjector (1u)"
	volume = 6
	amount_per_transfer_from_this = 1

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/extrasmall
	name = "reagent canister pouch autoinjector (5u)"
	volume = 30
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/small
	name = "reagent canister pouch autoinjector (10u)"
	volume = 60
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/medium
	name = "reagent canister pouch autoinjector (15u)"
	volume = 90
	amount_per_transfer_from_this = 15

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/large //Unused, but will still throw it here.
	name = "reagent canister pouch autoinjector (20u)"
	volume = 120
	amount_per_transfer_from_this = 20

/obj/item/reagent_container/hypospray/autoinjector/research/reagent_pouch/extralarge //haven't seen anyone use this yet.
	name = "reagent canister pouch autoinjector (30u)"
	volume = 180
	amount_per_transfer_from_this = 30
