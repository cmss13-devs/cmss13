/datum/battlepass_reward/xeno

/datum/battlepass_reward/xeno/can_claim(mob/target_mob)
	. = ..()
	if(!.)
		return .

	if(!isxeno(target_mob))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph
	var/has_halo = FALSE as num

/mob/living/carbon/xenomorph/proc/get_halo_iconname()
	return lowertext(caste_type)

/mob/living/carbon/xenomorph/praetorian/get_halo_iconname()
	if(!strain)
		return "basePrae"

	switch(strain.type)
		if(/datum/xeno_strain/vanguard)
			return "vanguardPrae"
		if(/datum/xeno_strain/dancer)
			return "dancerPrae"
		if(/datum/xeno_strain/warden)
			return "wardenPrae"
		if(/datum/xeno_strain/oppressor)
			return "oppPrae"

/datum/battlepass_reward/xeno/halo
	name = "Halo"
	icon_state = "halo"
	category = REWARD_CATEGORY_OVERLAY

/datum/battlepass_reward/xeno/halo/on_claim(mob/living/carbon/xenomorph/target_mob)
	target_mob.create_halo()
	return TRUE
