#define BICAOD_BLOOD_REDUCTION 0.67 //15 OD ticks to heal 1 blood loss
#define CRYO_BLOOD_REDUCTION 0.67
#define THWEI_BLOOD_REDUCTION 0.75
#define BLOOD_ADD_PENALTY 1.5

/datum/effects/bleeding
	effect_name = "bleeding"
	duration = null
	flags = NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE
	var/blood_loss = 0 //How much blood to lose every tick
	var/obj/limb/limb = null
	var/blood_duration_multiplier = 2.5
	var/blood_loss_divider = 80

/datum/effects/bleeding/New(atom/A, obj/limb/L = null, damage = 0)
	..()
	duration = damage * blood_duration_multiplier
	blood_loss = damage / blood_loss_divider
	if(L && istype(L))
		limb = L

/datum/effects/bleeding/Destroy()
	if(limb)
		SEND_SIGNAL(limb, COMSIG_LIMB_STOP_BLEEDING, TRUE, FALSE)
		limb.bleeding_effects_list -= src
		limb = null
	return ..()

/datum/effects/bleeding/validate_atom(atom/A)
	if(isobj(A))
		return FALSE
	. = ..()

/datum/effects/bleeding/process_mob()
	. = ..()
	if(!.)
		return FALSE

	if(blood_loss <= 0)
		qdel(src)
		return FALSE

	if(!limb)
		qdel(src)
		return FALSE

	var/mob/living/carbon/human/affected_mob = affected_atom
	if(affected_mob.status_flags & NO_PERMANENT_DAMAGE)
		return FALSE

	return TRUE

/datum/effects/bleeding/proc/add_on(damage)
	if(damage)
		duration += damage * (blood_duration_multiplier / BLOOD_ADD_PENALTY)
		blood_loss += damage / (blood_loss_divider * BLOOD_ADD_PENALTY) //Make the first hit count, adding on bleeding has a penalty

/datum/effects/bleeding/external
	var/buffer_blood_loss = 0

/datum/effects/bleeding/external/process_mob()
	. = ..()
	if(!.)
		return FALSE

	buffer_blood_loss += blood_loss

	var/mob/living/carbon/affected_mob = affected_atom
	if(duration % 3 == 0) //Do it every third tick
		if(affected_mob.reagents) // Annoying QC check
			if(affected_mob.reagents.get_reagent_amount("thwei"))
				blood_loss -= THWEI_BLOOD_REDUCTION

			if(affected_mob.bodytemperature <= BODYTEMP_CRYO_LIQUID_THRESHOLD && (affected_mob.reagents.get_reagent_amount("cryoxadone") || affected_mob.reagents.get_reagent_amount("clonexadone")))
				var/obj/structure/machinery/cryo_cell/cryo = affected_mob.loc
				if(istype(cryo) && cryo.on && cryo.operable())
					blood_loss -= CRYO_BLOOD_REDUCTION

			var/mob/living/carbon/human/affected_human = affected_mob
			if(istype(affected_human))
				if(affected_human.chem_effect_flags & CHEM_EFFECT_NO_BLEEDING)
					buffer_blood_loss = 0
					return FALSE
				if(SEND_SIGNAL(affected_human, COMSIG_BLEEDING_PROCESS, FALSE) & COMPONENT_BLEEDING_CANCEL)
					return FALSE
		affected_mob.drip(buffer_blood_loss)
		buffer_blood_loss = 0

	return TRUE


/datum/effects/bleeding/internal
	effect_name = "internal bleeding"
	flags = INF_DURATION | NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE

/datum/effects/bleeding/internal/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	if(affected_mob.in_stasis == STASIS_IN_BAG)
		return FALSE

	if(affected_mob.reagents) // Annoying QC check
		if(affected_mob.reagents.get_reagent_amount("thwei"))
			blood_loss -= THWEI_BLOOD_REDUCTION

		if(affected_mob.bodytemperature <= BODYTEMP_CRYO_LIQUID_THRESHOLD && (affected_mob.reagents.get_reagent_amount("cryoxadone") || affected_mob.reagents.get_reagent_amount("clonexadone")))
			blood_loss -= CRYO_BLOOD_REDUCTION

		var/mob/living/carbon/human/affected_human = affected_mob
		if(istype(affected_human))
			if(affected_human.chem_effect_flags & CHEM_EFFECT_NO_BLEEDING)
				return FALSE
			if(SEND_SIGNAL(affected_human, COMSIG_BLEEDING_PROCESS, TRUE) & COMPONENT_BLEEDING_CANCEL)
				return FALSE

	blood_loss = max(blood_loss, 0) // Bleeding shouldn't give extra blood even if its only 1 tick
	affected_mob.blood_volume = max(affected_mob.blood_volume - blood_loss, 0)

	return TRUE

#undef BLOOD_ADD_PENALTY
