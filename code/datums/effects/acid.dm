/datum/effects/acid
	effect_name = "acid"
	duration = 20
	icon_path = 'icons/effects/status_effects.dmi'
	obj_icon_state_path = "+acid"
	mob_icon_state_path = "human_acid"
	var/original_duration = 50			//Set to 50 for safety reasons if something fails
	var/damage_in_total_human = 25
	var/damage_in_total_obj = 75
	var/acid_multiplier = 1
	 /// How 'goopy' the acid is. Each value is one stop drop roll.
	var/acid_goopiness = 1
	 /// If it's been enhanced by a spit combo.
	var/acid_enhanced = FALSE

/datum/effects/acid/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest")
	..(A, from, last_dmg_source, zone)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_effects()

	if(isobj(A))
		var/obj/O = A
		if(istype(O, /obj/structure/barricade))
			var/obj/structure/barricade/B = O
			acid_multiplier = B.burn_multiplier
		O.update_icon()

	original_duration = duration

/datum/effects/acid/validate_atom(var/atom/A)
	if(istype(A, /obj/structure/barricade))
		return TRUE

	if(isobj(A))
		return FALSE

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.status_flags & XENO_HOST && HAS_TRAIT(H, TRAIT_NESTED) || H.stat == DEAD)
			return FALSE

	. = ..()

/datum/effects/acid/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.last_damage_data = cause_data
	affected_mob.apply_armoured_damage((damage_in_total_human * acid_multiplier)/original_duration, ARMOR_BIO, BURN, def_zone, 40)

	return TRUE

/datum/effects/acid/process_obj()
	. = ..()
	if(!.)
		return FALSE

	var/obj/affected_obj = affected_atom
	affected_obj.update_health((damage_in_total_obj * acid_multiplier)/original_duration)

	return TRUE

/datum/effects/acid/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)

	if(ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		H.update_effects()

	if(isobj(affected_atom))
		var/obj/O = affected_atom
		O.update_icon()
	return ..()

/datum/effects/acid/proc/enhance_acid()
	duration = 40
	damage_in_total_human = 50
	acid_multiplier = 1.5
	acid_goopiness++
	acid_enhanced = TRUE
	mob_icon_state_path = "human_acid_enhanced"
	if(ishuman(affected_atom))
		var/mob/living/carbon/human/affected_human = affected_atom
		affected_human.update_effects()

/datum/effects/acid/proc/cleanse_acid()
	acid_goopiness--
	if(acid_goopiness <= 0)
		return TRUE
	else return FALSE
