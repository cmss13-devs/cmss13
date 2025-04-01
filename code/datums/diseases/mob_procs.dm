/mob/proc/has_disease(datum/disease/virus)
	for(var/datum/disease/D in viruses)
		if(D.IsSame(virus))
			//error("[D.name]/[D.type] is the same as [virus.name]/[virus.type]")
			return 1
	return 0

// This proc has some procs that should be extracted from it. I believe we can develop some helper procs from it - Rockdtben
/mob/proc/contract_disease(datum/disease/virus, skip_this = 0, force_species_check=1, spread_type = -5)
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

		if(fail)
			return

	if(skip_this == 1)
		//if(src.virus) < -- this used to replace the current disease. Not anymore!
			//src.virus.cure(0)
		var/datum/disease/v = virus.Copy()
		src.viruses += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(v.can_carry && prob(5))
			v.carrier = 1
		return

	if(prob(15/virus.permeability_mod))
		return //the power of immunity compels this disease! but then you forgot resistances
	var/passed = 1

	if(spread_type == -5)
		spread_type = virus.spread_type

	passed = can_pass_disease()

	if(passed)
		AddDisease(virus)

/mob/living/carbon/human/contract_disease(datum/disease/virus, skip_this = 0, force_species_check=1, spread_type = -5)
	if(species.flags & IS_SYNTHETIC)
		return //synthetic species are immune
	..(virus, skip_this, force_species_check, spread_type)

/mob/proc/AddDisease(datum/disease/D, roll_for_carrier = TRUE)
	var/datum/disease/DD = new D.type(1, D)
	viruses += DD
	DD.affected_mob = src
	DD.strain_data = DD.strain_data.Copy()
	DD.holder = src
	if(DD.can_carry && roll_for_carrier && prob(5))
		DD.carrier = 1

	return DD

/mob/living/carbon/human/AddDisease(datum/disease/D)
	. = ..()
	med_hud_set_status()

