//Not to be confused with /obj/item/reagent_container/food/drinks/bottle

/obj/item/reagent_container/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle-1"
	item_state = "bottle-1"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,40,50,60)
	flags_atom = FPRINT|OPENCONTAINER
	volume = 60
	attack_speed = 4
	var/randomize = TRUE

/obj/item/reagent_container/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/bottle/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_container/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/glass/bottle/Initialize()
	. = ..()
	if(randomize)
		icon_state = "bottle-[rand(1,4)]"

/obj/item/reagent_container/glass/bottle/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0)
				filling.icon_state = null
			if(1 to 20)
				filling.icon_state = "[icon_state]-20"
			if(21 to 40)
				filling.icon_state = "[icon_state]-40"
			if(41 to 60)
				filling.icon_state = "[icon_state]-60"
			if(61 to 80)
				filling.icon_state = "[icon_state]-80"
			if(81 to INFINITY)
				filling.icon_state = "[icon_state]-100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[icon_state]")
		overlays += lid


/obj/item/reagent_container/glass/bottle/inaprovaline
	name = "\improper Inaprovaline bottle"
	desc = "A small bottle filled with inaprovaline - used to stabilize critical patients."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/kelotane
	name = "\improper Kelotane bottle"
	desc = "A small bottle filled with kelotane - used to treat burned areas."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/kelotane/Initialize()
	. = ..()
	reagents.add_reagent("kelotane", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/dexalin
	name = "\improper Dexalin bottle"
	desc = "A small bottle filled with dexalin, a drug used to reoxygenate patients."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/dexalin/Initialize()
	. = ..()
	reagents.add_reagent("dexalin", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/spaceacillin
	name = "\improper Spaceacillin bottle"
	desc = "A small bottle filled with spaceacillin, a common and potent antiviral and antibiotic."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/spaceacillin/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
/obj/item/reagent_container/glass/bottle/toxin/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. It smells like bitter almonds. Seriously, do not drink this."

/obj/item/reagent_container/glass/bottle/cyanide/Initialize()
	. = ..()
	reagents.add_reagent("cyanide", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/stoxin
	name = "Soporific bottle"
	desc = "A small bottle filled with soporific, otherwise known as 'sleep toxin'. Sniffing its fumes make you sleepy."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/stoxin/Initialize()
	. = ..()
	reagents.add_reagent("stoxin", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/chloralhydrate
	name = "Chloral Hydrate bottle"
	desc = "A small bottle of Chloral Hydrate, a potent, last-ditch hypnotic drug used to sedate patients when Oxycodone and anesthetic tanks are not available and soporific won't do the job."

/obj/item/reagent_container/glass/bottle/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 30) //Intentionally low since it is so strong. Still enough to knock someone out.
	update_icon()

/obj/item/reagent_container/glass/bottle/antitoxin
	name = "\improper Dylovene bottle"
	desc = "A small bottle of dylovene, known for removing toxins from the body. A wonder drug."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."

/obj/item/reagent_container/glass/bottle/mutagen/Initialize()
	. = ..()
	reagents.add_reagent("mutagen", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle of ammonia."

/obj/item/reagent_container/glass/bottle/ammonia/Initialize()
	. = ..()
	reagents.add_reagent("ammonia", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle of diethylamine, a potent fertilizer."

/obj/item/reagent_container/glass/bottle/diethylamine/Initialize()
	. = ..()
	reagents.add_reagent("diethylamine", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/flu_virion
	name = "flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/flu_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/flu(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/epiglottis_virion
	name = "epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/epiglottis_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/voice_change(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/liver_enhance_virion
	name = "liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/liver_enhance_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/heal(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/hullucigen_virion
	name = "hullucigen virion culture bottle"
	desc = "A small bottle. Contains hullucigen virion culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/hullucigen_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/hullucigen(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/pierrot_throat
	name = "\improper Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/pierrot_throat/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/pierrot_throat(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/cold
	name = "rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/cold/Initialize()
	. = ..()
	var/datum/disease/advance/F = new /datum/disease/advance/cold(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/random
	name = "random culture bottle"
	desc = "A small bottle. Contains a random disease."

/obj/item/reagent_container/glass/bottle/random/Initialize()
	. = ..()
	var/datum/disease/advance/F = new(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/gbs
	name = "\improper GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/glass/bottle/gbs/Initialize()
	. = ..()
	create_reagents(20)
	var/datum/disease/F = new /datum/disease/gbs
	var/list/data = list("virus"= F)
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/fake_gbs
	name = "\improper GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit

/obj/item/reagent_container/glass/bottle/fake_gbs/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/fake_gbs(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/*
/obj/item/reagent_container/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."//Or simply - General BullShit
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)
		update_icon()

*/

/obj/item/reagent_container/glass/bottle/brainrot
	name = "\improper Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."

/obj/item/reagent_container/glass/bottle/brainrot/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/brainrot(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/magnitis
	name = "\improper Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."

/obj/item/reagent_container/glass/bottle/magnitis/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/magnitis(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
	update_icon()

/obj/item/reagent_container/glass/bottle/pacid
	name = "polytrinic acid bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid, an extremely potent and dangerous acid."

/obj/item/reagent_container/glass/bottle/pacid/Initialize()
	. = ..()
	reagents.add_reagent("pacid", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/adminordrazine
	name = "\improper Adminordrazine bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."

/obj/item/reagent_container/glass/bottle/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent("adminordrazine", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/capsaicin
	name = "\improper Capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."

/obj/item/reagent_container/glass/bottle/capsaicin/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/frostoil
	name = "\improper Frost Oil bottle"
	desc = "A small bottle. Contains cold sauce."

/obj/item/reagent_container/glass/bottle/frostoil/Initialize()
	. = ..()
	reagents.add_reagent("frostoil", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/bicaridine
	name = "\improper Bicaridine bottle"
	desc = "A small bottle filled with Bicaridine - used to treat brute damage."
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/bicaridine/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/peridaxon
	name = "\improper Peridaxon bottle"
	desc = "A small bottle filled with Peridaxon, used by doctors temporarily halt the effects of internal organ damage during transportation to surgery."
	volume = 60
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/peridaxon/Initialize()
	. = ..()
	reagents.add_reagent("peridaxon", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/tramadol
	name = "\improper Tramadol bottle"
	desc = "A small bottle filled with Tramadol - used as a basic painkiller."
	volume = 60
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/tramadol/Initialize()
	. = ..()
	reagents.add_reagent("tramadol", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/oxycodone
	name = "\improper Oxycodone bottle"
	desc = "A small bottle filled with Oxycodone - used as an extreme painkiller and for anesthesia when anesthetic tanks are not available."
	volume = 60
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/glass/bottle/oxycodone/Initialize()
	. = ..()
	reagents.add_reagent("oxycodone", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/tricordrazine
	name = "\improper Tricordrazine bottle"
	desc = "A small bottle filled with tricordrazine - a weak but catch-all medicine for treating all sorts of damage."
	volume = 60

/obj/item/reagent_container/glass/bottle/tricordrazine/Initialize()
	. = ..()
	reagents.add_reagent("tricordrazine", 60)
	update_icon()

/obj/item/reagent_container/glass/bottle/epinephrine
	name = "\improper Epinephrine bottle"
	desc = "A small bottle filled with Epinephrine. Also known as adrenaline, it is used to increase a patients arterial blood pressure, amongst other actions, to assist in cardiopulmonary resuscitation." //"I can't lie to you about your odds of a successful resuscitation, but you have my sympathies"
	volume = 60

/obj/item/reagent_container/glass/bottle/epinephrine/Initialize()
	. = ..()
	reagents.add_reagent("adrenaline", 60)
	update_icon()
