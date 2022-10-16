/obj/item/reagent_container/hypospray/autoinjector
	name = "inaprovaline autoinjector"
	var/chemname = "inaprovaline"
	//desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc = "An autoinjector containing Inaprovaline.  Useful for saving lives."
	icon_state = "empty"
	item_state = "empty"
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
	maptext_width = 16
	maptext_x = 18
	maptext_y = 3

/obj/item/reagent_container/hypospray/autoinjector/Initialize()
	. = ..()
	if(mixed_chem)
		return
	reagents.add_reagent(chemname, volume)
	if(display_maptext == TRUE)
		verbs += /obj/item/storage/pill_bottle/verb/set_maptext
	update_icon()

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
	if(uses_left)
		overlays += "[chemname]_[uses_left]"
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = "<span class='langchat'>[maptext_label]</span>"
	else
		maptext = ""

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
	desc = "An autoinjector loaded with 3 uses of Tricordrazine, a weak general use medicine for treating damage."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tc"

/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless
	name = "tricordrazine EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 uses of Tricordrazine, a weak general use medicine for treating damage. Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/quickclot
	name = "quick clot autoinjector"
	chemname = "quickclot"
	desc = "An autoinjector loaded with 3 uses of Quick Clot, a chemical designed to pause all bleeding. Renew doses as needed."
	amount_per_transfer_from_this = LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Qc"

/obj/item/reagent_container/hypospray/autoinjector/adrenaline
	name = "epinephrine autoinjector"
	chemname = "adrenaline"
	desc = "An autoinjector loaded with 3 uses of Epinephrine, better known as Adrenaline, a nerve stimulant useful in restarting the heart."
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ep"

/obj/item/reagent_container/hypospray/autoinjector/dexalinp
	name = "dexalin plus autoinjector"
	chemname = "dexalinp"
	desc = "An autoinjector loaded with 3 uses of Dexalin+, designed to immediately oxygenate the entire body."
	amount_per_transfer_from_this = 1
	volume = 3
	display_maptext = TRUE
	maptext_label = "D+"

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate
	name = "anesthetic autoinjector"
	chemname = "anesthetic"
	desc = "An autoinjector loaded with 3 uses of Chloral Hydrate and Sleeping Agent. Good to quickly pacify someone, for surgery of course."
	amount_per_transfer_from_this = 10
	volume = 30
	mixed_chem = TRUE
	display_maptext = TRUE //if you want to give it a label you can, but it won't come with one by default.

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 1*3)
	reagents.add_reagent("stoxin", 9*3)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/tramadol
	name = "tramadol autoinjector"
	chemname = "tramadol"
	desc = "An auto-injector loaded with 3 uses of Tramadol, a weak but effective painkiller for normal wounds."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tr"

/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless
	name = "tramadol EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 uses of Tramadol, a weak but effective painkiller for normal wounds. Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/oxycodone
	name = "oxycodone autoinjector (EXTREME PAINKILLER)"
	chemname = "oxycodone"
	desc = "An auto-injector loaded with 3 uses of Oxycodone, a powerful painkiller intended for life-threatening situations."
	amount_per_transfer_from_this = MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ox"

/obj/item/reagent_container/hypospray/autoinjector/kelotane
	name = "kelotane autoinjector"
	chemname = "kelotane"
	desc = "An auto-injector loaded with 3 uses of Kelotane, a common burn medicine."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Kl"

/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless
	name = "kelotane EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 uses of Kelotane, a common burn medicine. Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/bicaridine
	name = "bicaridine autoinjector"
	chemname = "bicaridine"
	desc = "An auto-injector loaded with 3 uses of Bicaridine, a common brute and circulatory damage medicine."
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Bi"

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless
	name = "bicaridine EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 uses of Bicaridine, a common brute and circulatory damage medicine.  Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/inaprovaline
	name = "inaprovaline autoinjector"
	chemname = "inaprovaline"
	desc = "An auto-injector loaded with 3 uses of Inaprovaline, an emergency stabilization medicine for patients in critical condition."
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "In"

/obj/item/reagent_container/hypospray/autoinjector/emergency
	name = "emergency autoinjector (CAUTION)"
	chemname = "emergency"
	desc = "An auto-injector loaded with a special cocktail of chemicals, to be used in life-threatening situations."
	amount_per_transfer_from_this = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1)
	volume = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1)
	mixed_chem = TRUE
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	injectVOL = 70//limited-supply emergency injector with v.large injection of drugs. Variable sfx freq sometimes rolls too quiet.
	display_maptext = TRUE //see anaesthetic injector
	maptext_label = "!!"

/obj/item/reagent_container/hypospray/autoinjector/emergency/skillless
	name = "EZ emergency autoinjector (CAUTION)"
	desc = "An auto-injector loaded with a special cocktail of chemicals, to be used in life-threatening situations. Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/emergency/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("kelotane", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("oxycodone", MED_REAGENTS_OVERDOSE-1)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/yautja
	name = "unusual crystal"
	chemname = "thwei"
	desc = "A strange glowing crystal with a spike at one end."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "crystal"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE
	volume = REAGENTS_OVERDOSE
	uses_left = 1

/obj/item/reagent_container/hypospray/autoinjector/yautja/attack(mob/M as mob, mob/user as mob)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		..()
	else
		to_chat(user, SPAN_DANGER("You have no idea where to inject [src]."))

/obj/item/reagent_container/hypospray/autoinjector/skillless
	name = "first-aid autoinjector"
	chemname = "tricordrazine"
	desc = "An autoinjector loaded with a small dose of medicine for marines to treat themselves with."
	icon_state = "tricord"
	amount_per_transfer_from_this = 15
	volume = 15
	skilllock = SKILL_MEDICAL_DEFAULT
	uses_left = 1
	display_maptext = TRUE

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
	if(reagents && reagents.reagent_list.len)
		. += SPAN_NOTICE("It is currently loaded.")
	else if(!uses_left)
		. += SPAN_NOTICE("It is spent.")
	else
		. += SPAN_NOTICE("It is empty.")

/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol
	name = "pain-stop autoinjector"
	chemname = "tramadol"
	desc = "An auto-injector loaded with a small amount of painkiller for marines to self-administer."
	icon_state = "tramadol"

/obj/item/reagent_container/hypospray/autoinjector/empty
	name = "autoinjector (C-T)"
	desc = "A custom-made auto-injector, likely from research."
	chemname = "custom"
	mixed_chem = TRUE
	amount_per_transfer_from_this = 5
	volume = 15
	uses_left = 0
	display_maptext = TRUE

/obj/item/reagent_container/hypospray/autoinjector/empty/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It transfers [amount_per_transfer_from_this]u per injection and has a maximum of [volume/amount_per_transfer_from_this] injections.")

/obj/item/reagent_container/hypospray/autoinjector/empty/update_icon()
	overlays.Cut()
	if(uses_left)
		var/image/cust_fill = image('icons/obj/items/syringe.dmi', src, "[chemname]_[uses_left]")
		cust_fill.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += cust_fill

/obj/item/reagent_container/hypospray/autoinjector/empty/small
	name = "autoinjector (C-S)"
	amount_per_transfer_from_this = 15
	volume = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/medium
	name = "autoinjector (C-M)"
	amount_per_transfer_from_this = 30
	volume = 90

/obj/item/reagent_container/hypospray/autoinjector/empty/large
	name = "autoinjector (C-L)"
	amount_per_transfer_from_this = 60
	volume = 180

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless
	name = "Autoinjector (E-T)"
	desc = "A custom-made EZ autoinjector, likely from research. Injects its entire payload immediately and doesn't require any training."
	chemname = "custom_ez"
	icon_state = "empty_ez"
	item_state = "empty_ez"
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = 15
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall
	name = "Autoinjector (E-VS)"
	volume = 30
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small
	name = "Autoinjector (E-S)"
	volume = 45
	amount_per_transfer_from_this = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/
	name = "Medic Autoinjector (M-M)"
	desc = "A custom-made professional injector, likely from research. Has a similar lock to pill bottles, and fits up to 6 injections."
	skilllock = SKILL_MEDICAL_MEDIC
	volume = 90
	amount_per_transfer_from_this = 15
	chemname = "custom_medic"
	icon_state = "empty_medic"
	item_state = "empty_medic"
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/large
	name = "Medic Autoinjector (M-L)"
	volume = 180
	amount_per_transfer_from_this = 30
