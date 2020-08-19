
/mob/proc/has_disease(var/datum/disease/virus)
	for(var/datum/disease/D in viruses)
		if(D.IsSame(virus))
			//error("[D.name]/[D.type] is the same as [virus.name]/[virus.type]")
			return 1
	return 0

// This proc has some procs that should be extracted from it. I believe we can develop some helper procs from it - Rockdtben
/mob/proc/contract_disease(var/datum/disease/virus, var/skip_this = 0, var/force_species_check=1, var/spread_type = -5)
	if(stat == DEAD)
		return
	if(istype(virus, /datum/disease/advance))
		var/datum/disease/advance/A = virus
		if(A.GetDiseaseID() in resistances)
			return
		if(count_by_type(viruses, /datum/disease/advance) >= 3)
			return

	else
		if(src.resistances.Find(virus.type))
			return

	if(has_disease(virus))
		return

	if(force_species_check)
		var/fail = TRUE
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			for(var/vuln_species in virus.affected_species)
				if(H.species.name == vuln_species)
					fail = FALSE
					break
		
		if(fail) return

	if(skip_this == 1)
		//if(src.virus)				< -- this used to replace the current disease. Not anymore!
			//src.virus.cure(0)
		var/datum/disease/v = virus.Copy()
		src.viruses += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(v.can_carry && prob(5))
			v.carrier = 1
		return

	if(prob(15/virus.permeability_mod)) return //the power of immunity compels this disease! but then you forgot resistances
	var/passed = 1

	//chances to target this zone
	var/head_ch
	var/body_ch
	var/hands_ch
	var/feet_ch

	if(spread_type == -5)
		spread_type = virus.spread_type

	switch(spread_type)
		if(CONTACT_HANDS)
			head_ch = 0
			body_ch = 0
			hands_ch = 100
			feet_ch = 0
		if(CONTACT_FEET)
			head_ch = 0
			body_ch = 0
			hands_ch = 0
			feet_ch = 100
		else
			head_ch = 100
			body_ch = 100
			hands_ch = 25
			feet_ch = 25


	var/target_zone = pick(head_ch;1,body_ch;2,hands_ch;3,feet_ch;4)//1 - head, 2 - body, 3 - hands, 4- feet

	passed = check_disease_pass_clothes(target_zone)

	if(!passed && spread_type == AIRBORNE && !internal)
		passed = (prob((50*virus.permeability_mod) - 1))

	if(passed)
		AddDisease(virus)

/mob/living/carbon/human/contract_disease(datum/disease/virus, skip_this = 0, force_species_check=1, spread_type = -5)
	if(species.flags & IS_SYNTHETIC) return //synthetic species are immune
	..(virus, skip_this, force_species_check, spread_type)

/mob/proc/AddDisease(datum/disease/D, var/roll_for_carrier = TRUE)
	var/datum/disease/DD = new D.type(1, D)
	viruses += DD
	DD.affected_mob = src
	DD.strain_data = DD.strain_data.Copy()
	DD.holder = src
	if(DD.can_carry && roll_for_carrier && prob(5))
		DD.carrier = 1

	return DD


/mob/living/carbon/human/AddDisease(datum/disease/D)
	..()
	med_hud_set_status()

//returns whether the mob's clothes stopped the disease from passing through
/mob/proc/check_disease_pass_clothes(target_zone)
	return 1

/mob/living/carbon/human/check_disease_pass_clothes(target_zone)
	var/obj/item/clothing/Cl
	switch(target_zone)
		if(1)
			if(isobj(head) && !istype(head, /obj/item/paper))
				Cl = head
				. = prob((Cl.permeability_coefficient*100) - 1)
			if(. && wear_mask)
				. = prob((Cl.permeability_coefficient*100) - 1)
		if(2)//arms and legs included
			if(isobj(wear_suit))
				Cl = wear_suit
				. = prob((Cl.permeability_coefficient*100) - 1)
			if(. && isobj(WEAR_BODY))
				Cl = WEAR_BODY
				. = prob((Cl.permeability_coefficient*100) - 1)
		if(3)
			if(isobj(wear_suit) && wear_suit.flags_armor_protection & BODY_FLAG_HANDS)
				Cl = wear_suit
				. = prob((Cl.permeability_coefficient*100) - 1)

			if(. && isobj(gloves))
				Cl = gloves
				. = prob((Cl.permeability_coefficient*100) - 1)
		if(4)
			if(isobj(wear_suit) && wear_suit.flags_armor_protection & BODY_FLAG_FEET)
				Cl = wear_suit
				. = prob((Cl.permeability_coefficient*100) - 1)

			if(. && isobj(shoes))
				Cl = shoes
				. = prob((Cl.permeability_coefficient*100) - 1)
		else
			to_chat(src, "Something bad happened with disease target zone code, tell a dev or admin ")

