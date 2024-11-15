//Updates the mob's health from limbs and mob damage variables
/mob/living/carbon/human/updatehealth()

	if(status_flags & GODMODE)
		health = species.total_health
		set_stat(CONSCIOUS)
		return
	var/total_burn = 0
	var/total_brute = 0
	for(var/obj/limb/O in limbs) //hardcoded to streamline things a bit
		total_brute += O.brute_dam
		total_burn += O.burn_dam

	var/oxy_l = ((species && species.flags & NO_BREATHE) ? 0 : getOxyLoss())
	var/tox_l = ((species && species.flags & NO_POISON) ? 0 : getToxLoss())
	var/clone_l = getCloneLoss()

	health = ((species != null)? species.total_health : 200) - oxy_l - tox_l - clone_l - total_burn - total_brute

	recalculate_move_delay = TRUE

	med_hud_set_health()
	med_hud_set_armor()
	med_hud_set_status()



/mob/living/carbon/human/adjustBrainLoss(amount)

	if(status_flags & GODMODE)
		return FALSE //godmode

	if(species.has_organ["brain"])
		var/datum/internal_organ/brain/sponge = internal_organs_by_name["brain"]
		if(sponge)
			sponge.take_damage(amount)
			sponge.damage = clamp(sponge.damage, 0, maxHealth*2)
			brainloss = sponge.damage
		else
			brainloss = 200
	else
		brainloss = 0

/mob/living/carbon/human/setBrainLoss(amount)

	if(status_flags & GODMODE)
		return FALSE //godmode

	if(species.has_organ["brain"])
		var/datum/internal_organ/brain/sponge = internal_organs_by_name["brain"]
		if(sponge)
			sponge.damage = clamp(amount, 0, maxHealth*2)
			brainloss = sponge.damage
		else
			brainloss = 200
	else
		brainloss = 0

/mob/living/carbon/human/getBrainLoss()

	if(status_flags & GODMODE)
		return FALSE //godmode

	if(species.has_organ["brain"])
		var/datum/internal_organ/brain/sponge = internal_organs_by_name["brain"]
		if(istype(sponge)) //Make sure they actually have a brain
			brainloss = min(sponge.damage,maxHealth*2)
		else
			brainloss = 50 //No brain!
	else
		brainloss = 0
	return brainloss

//These procs fetch a cumulative total damage from all limbs
/mob/living/carbon/human/getBruteLoss(organic_only = FALSE, robotic_only = FALSE)
	var/amount = 0
	for(var/obj/limb/O in limbs)
		if(organic_only && (O.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			continue
		if(robotic_only && !(O.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			continue
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss(organic_only = FALSE, robotic_only = FALSE)
	var/amount = 0
	for(var/obj/limb/O in limbs)
		if(organic_only && (O.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			continue
		if(robotic_only && !(O.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			continue
		amount += O.burn_dam
	return amount


/mob/living/carbon/human/adjustBruteLoss(amount)
	if(amount > 0)
		var/brute_mod = get_brute_mod()
		if(brute_mod)
			amount *= brute_mod

	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)


/mob/living/carbon/human/adjustFireLoss(amount)
	if(amount > 0)
		var/burn_mod = get_burn_mod()
		if(burn_mod)
			amount *= burn_mod

	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)


/mob/living/carbon/human/proc/adjustBruteLossByPart(amount, organ_name, obj/damage_source = null)
	if(amount > 0)
		var/brute_mod = get_brute_mod()
		if(brute_mod)
			amount *= brute_mod

	for(var/X in limbs)
		var/obj/limb/O = X
		if(O.name == organ_name)
			if(amount > 0)
				O.take_damage(amount, 0, sharp=is_sharp(damage_source), edge=has_edge(damage_source), used_weapon=damage_source)
			else
				//if you don't want to heal robot limbs, they you will have to check that yourself before using this proc.
				O.heal_damage(-amount, 0, O.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			break



/mob/living/carbon/human/proc/adjustFireLossByPart(amount, organ_name, obj/damage_source = null)
	if(amount > 0)
		var/burn_mod = get_burn_mod()
		if(burn_mod)
			amount *= burn_mod

	for(var/X in limbs)
		var/obj/limb/O = X
		if(O.name == organ_name)
			if(amount > 0)
				O.take_damage(0, amount, sharp=is_sharp(damage_source), edge=has_edge(damage_source), used_weapon=damage_source)
			else
				//if you don't want to heal robot limbs, they you will have to check that yourself before using this proc.
				O.heal_damage(0, -amount, O.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			break



/mob/living/carbon/human/getCloneLoss()
	if(species && species.flags & (IS_SYNTHETIC|NO_CLONE_LOSS))
		cloneloss = 0
	return ..()

/mob/living/carbon/human/setCloneLoss(amount)
	if(species && species.flags & (IS_SYNTHETIC|NO_CLONE_LOSS))
		cloneloss = 0
	else
		..()

/mob/living/carbon/human/adjustCloneLoss(amount)
	..()

	if(species && species.flags & (IS_SYNTHETIC|NO_CLONE_LOSS))
		cloneloss = 0
		return

	var/heal_prob = max(0, 80 - getCloneLoss())
	var/mut_prob = min(80, getCloneLoss()+10)
	if(amount > 0)
		if(prob(mut_prob))
			var/list/obj/limb/candidates = list()
			for(var/obj/limb/O in limbs)
				if(O.status & (LIMB_ROBOT|LIMB_DESTROYED|LIMB_MUTATED|LIMB_SYNTHSKIN)) continue
				candidates |= O
			if(length(candidates))
				var/obj/limb/O = pick(candidates)
				O.mutate()
				to_chat(src, SPAN_NOTICE("Something is not right with your [O.display_name]..."))
				return
	else
		if(prob(heal_prob))
			for(var/obj/limb/O in limbs)
				if(O.status & LIMB_MUTATED)
					O.unmutate()
					to_chat(src, SPAN_NOTICE("Your [O.display_name] is shaped normally again."))
					return

	if(getCloneLoss() < 1)
		for(var/obj/limb/O in limbs)
			if(O.status & LIMB_MUTATED)
				O.unmutate()
				to_chat(src, SPAN_NOTICE("Your [O.display_name] is shaped normally again."))


// Defined here solely to take species flags into account without having to recast at mob/living level.
/mob/living/carbon/human/getOxyLoss()
	if(species && species.flags & NO_BREATHE)
		oxyloss = 0
	return ..()

/mob/living/carbon/human/adjustOxyLoss(amount)
	if(species && species.flags & NO_BREATHE)
		oxyloss = 0
	else
		..()

/mob/living/carbon/human/setOxyLoss(amount)
	if(species && species.flags & NO_BREATHE)
		oxyloss = 0
	else
		..()

/mob/living/carbon/human/getToxLoss()
	if(species && species.flags & NO_POISON)
		toxloss = 0
	return ..()

/mob/living/carbon/human/adjustToxLoss(amount)
	if(species && species.flags & NO_POISON)
		toxloss = 0
	else
		..()

/mob/living/carbon/human/setToxLoss(amount)
	if(species && species.flags & NO_POISON)
		toxloss = 0
	else
		..()

////////////////////////////////////////////

//Returns a list of damaged limbs
/mob/living/carbon/human/proc/get_damaged_limbs(brute, burn)
	var/list/obj/limb/parts = list()
	for(var/obj/limb/O in limbs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable limbs
/mob/living/carbon/human/proc/get_damageable_limbs(inclusion_chance)
	var/list/obj/limb/parts = list()
	for(var/obj/limb/limb in limbs)
		if(limb.brute_dam + limb.burn_dam >= limb.max_damage)
			continue
		if(inclusion_chance && !prob(inclusion_chance))
			continue
		parts += limb
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_limb_damage(brute, burn)
	var/list/obj/limb/parts = get_damaged_limbs(brute,burn)
	if(!length(parts))
		return
	var/obj/limb/picked = pick(parts)
	if(brute != 0)
		apply_damage(-brute, BRUTE, picked)
	if(burn != 0)
		apply_damage(-burn, BURN, picked)
	UpdateDamageIcon()
	updatehealth()


/*
In most cases it makes more sense to use apply_damage() instead! And make sure to check armour if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_limb_damage(brute, burn, sharp = 0, edge = 0)
	var/list/obj/limb/parts = get_damageable_limbs()
	if(!length(parts)) return
	var/obj/limb/picked = pick(parts)
	if(brute != 0)
		apply_damage(brute, BRUTE, picked, sharp, edge)
	if(burn != 0)
		apply_damage(burn, BURN, picked, sharp, edge)
	UpdateDamageIcon()
	updatehealth()


//Heal MANY limbs, in random order
/mob/living/carbon/human/heal_overall_damage(brute, burn, robo_repair = FALSE)
	var/list/obj/limb/parts = get_damaged_limbs(brute,burn)

	var/update = 0
	while(length(parts) && (brute>0 || burn>0) )
		var/obj/limb/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute, burn, robo_repair)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()

	if(update) UpdateDamageIcon()

// damage MANY limbs, in random order
/mob/living/carbon/human/take_overall_damage(brute, burn, used_weapon = null, limb_damage_chance = 80)
	if(status_flags & GODMODE)
		return //godmode
	var/list/obj/limb/parts = get_damageable_limbs(limb_damage_chance)
	var/amount_of_parts = length(parts)
	for(var/obj/limb/L as anything in parts)
		L.take_damage(brute / amount_of_parts, burn / amount_of_parts, sharp = FALSE, edge = FALSE, used_weapon = used_weapon)
	updatehealth()
	UpdateDamageIcon()

// damage MANY LIMBS, in random order, but consider armor
/mob/living/carbon/human/proc/take_overall_armored_damage(damage, armour_type = ARMOR_MELEE, damage_type = BRUTE, limb_damage_chance = 80, penetration = 0)
	if(status_flags & GODMODE)
		return //godmode
	var/list/obj/limb/parts = get_damageable_limbs(limb_damage_chance)
	var/amount_of_parts = length(parts)
	var/armour_config = GLOB.marine_ranged
	if(armour_type == ARMOR_MELEE)
		armour_config = GLOB.marine_melee
	if(armour_type == ARMOR_BOMB)
		armour_config = GLOB.marine_explosive
	for(var/obj/limb/L as anything in parts)
		var/armor = getarmor(L, armour_type)
		var/modified_damage = armor_damage_reduction(armour_config, damage, armor, penetration, 0, 0)
		if(damage_type == BURN)
			L.take_damage(burn = modified_damage / amount_of_parts)
		else
			L.take_damage(modified_damage / amount_of_parts)

	updatehealth()
	UpdateDamageIcon()



////////////////////////////////////////////



/*
This function restores all limbs.
*/
/mob/living/carbon/human/restore_all_organs()
	for(var/obj/limb/E in limbs)
		E.rejuvenate()

	//replace missing internal organs
	for(var/organ_slot in species.has_organ)
		var/internal_organ_type = species.has_organ[organ_slot]
		if(!internal_organs_by_name[organ_slot])
			var/datum/internal_organ/IO = new internal_organ_type(src)
			internal_organs_by_name[organ_slot] = IO



/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/obj/limb/E = get_limb(zone)
	if(E.heal_damage(brute, burn))
		UpdateDamageIcon()


/mob/living/carbon/proc/get_limb(zone)
	return

/mob/living/carbon/human/get_limb(zone)
	RETURN_TYPE(/obj/limb)
	zone = check_zone(zone)
	return (locate(GLOB.limb_types_by_name[zone]) in limbs)


/mob/living/carbon/human/apply_armoured_damage(damage = 0, armour_type = ARMOR_MELEE, damage_type = BRUTE, def_zone = null, penetration = 0, armour_break_pr_pen = 0, armour_break_flat = 0)
	if(damage <= 0)
		return ..(damage, armour_type, damage_type, def_zone)

	var/obj/limb/target_limb = null
	if(def_zone)
		target_limb = get_limb(check_zone(def_zone))
	else
		target_limb = get_limb(check_zone(rand_zone()))
	if(isnull(target_limb))
		return FALSE

	var/armor = getarmor(target_limb, armour_type)

	var/armour_config = GLOB.marine_ranged
	if(armour_type == ARMOR_MELEE)
		armour_config = GLOB.marine_melee

	var/modified_damage = armor_damage_reduction(armour_config, damage, armor, penetration, 0, 0)
	apply_damage(modified_damage, damage_type, target_limb)

	return modified_damage

/*
	Describes how human mobs get damage applied.
	Less clear vars:
	* permanent_kill: whether this attack causes human to become irrevivable
*/
/mob/living/carbon/human/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, \
	sharp = 0, edge = 0, obj/used_weapon = null, no_limb_loss = FALSE, \
	permanent_kill = FALSE, mob/firer = null, force = FALSE
)
	if(protection_aura && damage > 0)
		damage = floor(damage * ((ORDER_HOLD_CALC_LEVEL - protection_aura) / ORDER_HOLD_CALC_LEVEL))

	//Handle other types of damage
	if(damage < 0 || (damagetype != BRUTE) && (damagetype != BURN))
		if(damagetype == HALLOSS && pain.feels_pain)
			if((damage > 25 && prob(20)) || (damage > 50 && prob(60)))
				INVOKE_ASYNC(src, PROC_REF(emote), "pain")

		..(damage, damagetype, def_zone)
		return TRUE

	var/list/damagedata = list("damage" = damage)
	if(SEND_SIGNAL(src, COMSIG_HUMAN_TAKE_DAMAGE, damagedata, damagetype) & COMPONENT_BLOCK_DAMAGE) return
	damage = damagedata["damage"]

	var/obj/limb/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)
			def_zone = rand_zone(def_zone)
		organ = get_limb(check_zone(def_zone))
	if(!organ)
		return FALSE

	var/list/damage_data = list(
		"bonus_damage" = 0,
		"damage" = damage
	)
	SEND_SIGNAL(src, COMSIG_BONUS_DAMAGE, damage_data)
	damage += damage_data["bonus_damage"]

	switch(damagetype)
		if(BRUTE)
			damageoverlaytemp = 20
			if(!force)
				var/brute_mod = get_brute_mod()
				if(brute_mod)
					damage *= brute_mod
			if(organ.take_damage(damage, 0, sharp, edge, used_weapon, no_limb_loss = no_limb_loss, attack_source = firer))
				UpdateDamageIcon()
		if(BURN)
			damageoverlaytemp = 20
			if(!force)
				var/burn_mod = get_burn_mod()
				if(burn_mod)
					damage *= burn_mod
			if(organ.take_damage(0, damage, sharp, edge, used_weapon, no_limb_loss = no_limb_loss, attack_source = firer))
				UpdateDamageIcon()

	pain.apply_pain(damage, damagetype)

	if(damagetype != HALLOSS && damage > 0)
		life_damage_taken_total += damage

	if(permanent_kill)
		status_flags |= PERMANENTLY_DEAD

	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	updatehealth()
	return TRUE

// Heal or damage internal organs
// Organ has to be either an internal organ by string or a limb with internal organs in.
/mob/living/carbon/human/apply_internal_damage(damage = 0, organ)
	if(!damage)
		return

	var/obj/limb/L = null
	var/datum/internal_organ/I
	if(internal_organs_by_name[organ])
		I = internal_organs_by_name[organ]
	else if(istype(organ, /datum/internal_organ))
		I = organ
	else
		if(isorgan(organ))
			L = organ
		else
			L = get_limb(check_zone(organ))
		if(istype(L) && !isnull(L) && L.internal_organs)
			I = pick(internal_organs)

	if(isnull(I))
		return

	if(istype(I) && !isnull(I))
		if(damage > 0)
			I.take_damage(damage)
		else
			// The damage is negative so we want to heal, but heal damage only takes positive numbers.
			I.heal_damage(-1 * damage)

	pain.apply_pain(damage * PAIN_ORGAN_DAMAGE_MULTIPLIER)

/mob/living/carbon/human/apply_stamina_damage(damage, def_zone, armor_type)
	if(!def_zone || !armor_type || !stamina)
		return ..()

	var/armor = getarmor(def_zone, armor_type)

	var/damage_to_deal = damage * max(1 - (armor / CLOTHING_ARMOR_ULTRAHIGH), 0.1) // stamina damage. Has to deal 10% or less stamina damage, can't be any lower

	if(reagents && reagents.has_reagent("antag_stimulant"))
		damage_to_deal *= 0.25 // Massively reduced effectiveness

	stamina.apply_damage(damage_to_deal)
