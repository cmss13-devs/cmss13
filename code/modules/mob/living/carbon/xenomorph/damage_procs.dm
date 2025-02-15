/mob/living/carbon/xenomorph/attackby(obj/item/item, mob/user)
	if(user.a_intent != INTENT_HELP)
		return ..()
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL) && ishuman(user))
		var/mob/living/carbon/human/programmer = user
		if(!iff_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an IFF tag to reprogram."))
			return
		programmer.visible_message(SPAN_NOTICE("[programmer] starts reprogramming \the [src]'s IFF tag..."), SPAN_NOTICE("You start reprogramming \the [src]'s IFF tag..."), max_distance = 3)
		if(!do_after(programmer, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		if(!iff_tag)
			to_chat(programmer, SPAN_WARNING("\The [src]'s tag got removed while you were reprogramming it!"))
			return
		if(!iff_tag.handle_reprogramming(programmer, src))
			return
		programmer.visible_message(SPAN_NOTICE("[programmer] reprograms \the [src]'s IFF tag."), SPAN_NOTICE("You reprogram \the [src]'s IFF tag."), max_distance = 3)
		return
	if(stat == DEAD)
		if(!istype(item, /obj/item/reagent_container/syringe))
			var/datum/surgery/current_surgery = active_surgeries[user.zone_selected]
			if(current_surgery)
				if(current_surgery.attempt_next_step(user, item))
					return
			else
				if(initiate_surgery_moment(item, src, "head" , user))
					return
		return
	if(item.type in SURGERY_TOOLS_PINCH)
		if(!iff_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an IFF tag to remove."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts removing \the [src]'s IFF tag..."), SPAN_NOTICE("You start removing \the [src]'s IFF tag..."), max_distance = 3)
		if(!do_after(user, 5 SECONDS * SURGERY_TOOLS_PINCH[item.type], INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		if(!iff_tag)
			to_chat(user, SPAN_WARNING("\The [src]'s tag got removed while you were removing it!"))
			return
		user.put_in_hands(iff_tag)
		iff_tag = null
		user.visible_message(SPAN_NOTICE("[user] removes \the [src]'s IFF tag."), SPAN_NOTICE("You remove \the [src]'s IFF tag."), max_distance = 3)
		if(hive.hivenumber == XENO_HIVE_RENEGADE) //it's important to know their IFF settings for renegade
			to_chat(src, SPAN_NOTICE("With the removal of the device, your instincts have returned to normal."))
		return
	return ..()

/mob/living/carbon/xenomorph/ex_act(severity, direction, datum/cause_data/cause_data, pierce=0)

	if(body_position == LYING_DOWN && direction)
		severity *= EXPLOSION_PRONE_MULTIPLIER

	if(severity >= 30)
		flash_eyes()

	last_damage_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)

	if(severity > EXPLOSION_THRESHOLD_LOW && length(stomach_contents))
		for(var/mob/M in stomach_contents)
			M.ex_act(severity - EXPLOSION_THRESHOLD_LOW, last_damage_data, pierce)

	var/b_loss = 0
	var/f_loss = 0

	var/damage = severity

	var/cfg = armor_deflection==0 ? GLOB.xeno_explosive_small : GLOB.xeno_explosive
	var/total_explosive_resistance = caste != null ? caste.xeno_explosion_resistance + armor_explosive_buff : armor_explosive_buff
	damage = armor_damage_reduction(cfg, damage, total_explosive_resistance, pierce, 1, 0.5, armor_integrity)
	var/armor_punch = armor_break_calculation(cfg, damage, total_explosive_resistance, pierce, 1, 0.5, armor_integrity)
	apply_armorbreak(armor_punch)

	last_hit_time = world.time

	var/shieldtotal = 0
	for (var/datum/xeno_shield/XS in xeno_shields)
		shieldtotal += XS.amount

	if (damage >= (health + shieldtotal) && damage >= EXPLOSION_THRESHOLD_GIB)
		var/oldloc = loc
		gib(last_damage_data)
		create_shrapnel(oldloc, rand(16, 24), , , /datum/ammo/bullet/shrapnel/light/xeno, last_damage_data)
		return
	if (damage >= 0)
		b_loss += damage * 0.5
		f_loss += damage * 0.5
		apply_damage(b_loss, BRUTE)
		apply_damage(f_loss, BURN)
		updatehealth()

		var/powerfactor_value = round( damage * 0.05 ,1)
		powerfactor_value = min(powerfactor_value,20)
		if(powerfactor_value > 0 && small_explosives_stun)
			KnockDown(powerfactor_value/5)
			Stun(powerfactor_value/5) // Due to legacy knockdown being considered an impairement
			if(mob_size < MOB_SIZE_BIG)
				Slow(powerfactor_value)
				Superslow(powerfactor_value/2)
			else
				Slow(powerfactor_value/3)
			explosion_throw(severity, direction)
		else if(powerfactor_value > 10)
			powerfactor_value /= 5
			KnockDown(powerfactor_value/5)
			if(mob_size < MOB_SIZE_BIG)
				Slow(powerfactor_value)
				Superslow(powerfactor_value/2)
			else
				Slow(powerfactor_value/3)

/mob/living/carbon/xenomorph/apply_armoured_damage(damage = 0, armour_type = ARMOR_MELEE, damage_type = BRUTE, def_zone = null, penetration = 0, armour_break_pr_pen = 0, armour_break_flat = 0, effectiveness_mult = 1)
	if(damage <= 0)
		return ..(damage, armour_type, damage_type, def_zone)

	var/armour_config = GLOB.xeno_ranged
	if(armour_type == ARMOR_MELEE)
		armour_config = GLOB.xeno_melee

	var/list/damagedata = list(
		"damage" = damage,
		"armor" = (armor_deflection + armor_deflection_buff - armor_deflection_debuff) * effectiveness_mult,
		"penetration" = penetration,
		"armour_break_pr_pen" = armour_break_pr_pen,
		"armour_break_flat" = armour_break_flat,
		"armor_integrity" = armor_integrity,
		"armour_type" = armour_type,
	)
	SEND_SIGNAL(src, COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE, damagedata)
	var/modified_damage = armor_damage_reduction(armour_config, damage,
		damagedata["armor"], damagedata["penetration"], damagedata["armour_break_pr_pen"],
		damagedata["armour_break_flat"], damagedata["armor_integrity"])

	var/armor_punch = armor_break_calculation(armour_config, damage,
		damagedata["armor"], damagedata["penetration"], damagedata["armour_break_pr_pen"],
		damagedata["armour_break_flat"], damagedata["armor_integrity"])

	apply_armorbreak(armor_punch)

	apply_damage(modified_damage, damage_type)

	return modified_damage

/mob/living/carbon/xenomorph/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, used_weapon = null, sharp = 0, edge = 0, force = FALSE)
	if(!damage)
		return


	var/list/damagedata = list("damage" = damage)
	if(SEND_SIGNAL(src, COMSIG_XENO_TAKE_DAMAGE, damagedata, damagetype) & COMPONENT_BLOCK_DAMAGE)
		return
	damage = damagedata["damage"]

	//We still want to check for blood splash before we get to the damage application.
	var/chancemod = 0
	if(used_weapon && sharp)
		chancemod += 10
	if(used_weapon && edge) //Pierce weapons give the most bonus
		chancemod += 12
	if(def_zone != "chest") //Which it generally will be, vs xenos
		chancemod += 5

	var/list/damage_data = list(
		"bonus_damage" = 0,
		"damage" = damage
	)
	SEND_SIGNAL(src, COMSIG_BONUS_DAMAGE, damage_data)
	damage += damage_data["bonus_damage"]

	if(damage > 12) //Light damage won't splash.
		check_blood_splash(damage, damagetype, chancemod)

	if(damage > 0 && stat == DEAD)
		return

	var/shielded = FALSE
	if(length(xeno_shields) != 0 && damage > 0)
		shielded = TRUE
		for(var/datum/xeno_shield/XS in xeno_shields)
			damage = XS.on_hit(damage)

			if(damage > 0)
				XS.on_removal()
				QDEL_NULL(XS)

			if(damage == 0)
				return

		overlay_shields()

	if(shielded) // We were shielded, but damage went through.
		playsound(src, "shield_shatter", 50, 1)

	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage)
		if(BURN)
			adjustFireLoss(damage)

	updatehealth()

	last_hit_time = world.time
	if(damagetype != HALLOSS && damage > 0)
		life_damage_taken_total += damage

	return 1

#define XENO_ARMOR_BREAK_PASS_TIME 0.5 SECONDS
#define XENO_ARMOR_BREAK_25PERCENT_IMMUNITY_TIME 2 SECONDS

/mob/living/carbon/xenomorph/var/armor_break_to_apply = 0
/mob/living/carbon/xenomorph/proc/apply_armorbreak(armorbreak = 0)
	if(GLOB.xeno_general.armor_ignore_integrity)
		return FALSE

	if(stat == DEAD)
		return

	if(armor_deflection<=0)
		return

	//Immunity check
	if(world.time < armor_integrity_immunity_time && world.time>armor_integrity_last_damage_time + XENO_ARMOR_BREAK_PASS_TIME)
		return 1

	if(world.time>armor_integrity_immunity_time)
		armor_integrity_immunity_time = world.time
		armor_integrity_last_damage_time = world.time
		armor_break_to_apply = 0
		post_apply_armorbreak()

	var/delay = ((armor_integrity - armorbreak / 10)/25)*XENO_ARMOR_BREAK_25PERCENT_IMMUNITY_TIME
	armor_break_to_apply += armorbreak
	armor_integrity_immunity_time += delay

	if(armor_integrity_immunity_time - world.time > XENO_ARMOR_BREAK_25PERCENT_IMMUNITY_TIME * 4)
		armor_integrity_immunity_time = world.time + XENO_ARMOR_BREAK_25PERCENT_IMMUNITY_TIME * 4

	return 1

/mob/living/carbon/xenomorph/proc/post_apply_armorbreak()
	set waitfor = 0
	if(!caste)
		return
	sleep(XENO_ARMOR_BREAK_PASS_TIME)
	if(warding_aura && armor_break_to_apply > 0) //Damage to armor reduction
		armor_break_to_apply = floor(armor_break_to_apply * ((100 - (warding_aura * 15)) / 100))
	if(caste)
		armor_integrity -= armor_break_to_apply
	if(armor_integrity < 0)
		armor_integrity = 0
	armor_break_to_apply = 0
	updatehealth()

/mob/living/carbon/xenomorph/proc/check_blood_splash(damage = 0, damtype = BRUTE, chancemod = 0, radius = 1)
	if(!damage || !acid_blood_damage || world.time < acid_splash_last + acid_splash_cooldown || SSticker?.mode?.hardcore)
		return FALSE
	var/chance = 20 //base chance
	if(damtype == BRUTE)
		chance += 5
	chance += chancemod + (damage * 0.33)
	var/turf/T = loc
	if(!T || !istype(T))
		return

	if(radius > 1 || prob(chance))
		var/decal_chance = 50
		if(prob(decal_chance))
			var/obj/effect/decal/cleanable/blood/xeno/decal = locate(/obj/effect/decal/cleanable/blood/xeno) in T
			if(!decal) //Let's not stack blood, it just makes lagggggs.
				add_splatter_floor(T) //Drop some on the ground first.
			else
				if(decal.random_icon_states && length(decal.random_icon_states) > 0) //If there's already one, just randomize it so it changes.
					decal.icon_state = pick(decal.random_icon_states)

		var/splash_chance = 40 //Base chance of getting splashed. Decreases with # of victims.
		var/i = 0 //Tally up our victims.

		for(var/mob/living/carbon/human/victim in orange(radius, src)) //Loop through all nearby victims, including the tile.
			splash_chance = 65 - (i * 5)
			if(victim.loc == loc)
				splash_chance += 30 //Same tile? BURN
			if(victim.species?.acid_blood_dodge_chance)
				splash_chance -= victim.species.acid_blood_dodge_chance

			if(splash_chance > 0 && prob(splash_chance)) //Success!
				var/dmg = list("damage" = acid_blood_damage)
				if(SEND_SIGNAL(src, COMSIG_XENO_DEAL_ACID_DAMAGE, victim, dmg) & COMPONENT_BLOCK_DAMAGE)
					continue
				i++
				victim.visible_message(SPAN_DANGER("\The [victim] is scalded with hissing green blood!"),
				SPAN_DANGER("You are splattered with sizzling blood! IT BURNS!"))
				if(prob(60) && !victim.stat && victim.pain.feels_pain)
					INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "scream") //Topkek
				victim.apply_armoured_damage(dmg["damage"], ARMOR_BIO, BURN) //Sizzledam! This automagically burns a random existing body part.
				victim.add_blood(get_blood_color(), BLOOD_BODY)
				acid_splash_last = world.time
				handle_blood_splatter(get_dir(src, victim), 1 SECONDS)
				playsound(victim, "acid_sizzle", 25, TRUE)
				animation_flash_color(victim, "#FF0000") //pain hit flicker

/mob/living/carbon/xenomorph/get_target_lock(access_to_check)
	if(isnull(access_to_check))
		return

	if(!iff_tag)
		return ..()

	if(!islist(access_to_check))
		return access_to_check in iff_tag.faction_groups

	var/list/overlap = iff_tag.faction_groups & access_to_check
	return length(overlap)

/mob/living/carbon/xenomorph/handle_flamer_fire(obj/flamer_fire/fire, damage, delta_time)
	. = ..()
	switch(fire.fire_variant)
		if(FIRE_VARIANT_TYPE_B)
			if(!armor_deflection_debuff) //Only adds another reset timer if the debuff is currently on 0, so at the start or after a reset has recently occurred.
				reset_xeno_armor_debuff_after_time(src, delta_time*10)
			fire.type_b_debuff_xeno_armor(src) //Always reapplies debuff each time to minimize gap.

/mob/living/carbon/xenomorph/handle_flamer_fire_crossed(obj/flamer_fire/fire)
	. = ..()
	switch(fire.fire_variant)
		if(FIRE_VARIANT_TYPE_B) //Armor Shredding Greenfire
			if(!armor_deflection_debuff) //Only applies the xeno armor shred reset when the debuff isn't present or was recently removed.
				reset_xeno_armor_debuff_after_time(src, 20)
			var/resist_modifier = fire.type_b_debuff_xeno_armor(src)
			fire.set_on_fire(src) //Deals an extra proc of fire when you're crossing it. 30 damage per tile crossed, plus 15 per Process().
			next_move_slowdown = next_move_slowdown + (SLOWDOWN_AMT_GREENFIRE * resist_modifier)
			if(resist_modifier > 0)
				to_chat(src, SPAN_DANGER("We feel pieces of our exoskeleton fusing with the viscous fluid below and tearing off as we struggle to move through the flames!"))
