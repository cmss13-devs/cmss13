/mob/living/carbon/Xenomorph/ex_act(severity, direction, pierce=0)
	if(severity >= 30)
		flash_eyes()

	if(severity > EXPLOSION_THRESHOLD_LOW && stomach_contents.len)
		for(var/mob/M in stomach_contents)
			M.ex_act(severity - EXPLOSION_THRESHOLD_LOW)

	var/b_loss = 0
	var/f_loss = 0

	var/damage = severity
	
	var/cfg = armor_deflection==0 ? config.xeno_explosive_small : config.xeno_explosive
	var/total_explosive_resistance = caste.xeno_explosion_resistance + armor_explosive_buff
	damage = armor_damage_reduction(cfg, damage, total_explosive_resistance, pierce, 1, 0.5, armor_integrity)
	var/armor_punch = armor_break_calculation(cfg, damage, total_explosive_resistance, pierce, 1, 0.5, armor_integrity)
	apply_armorbreak(armor_punch)
	
	if (damage >= health && damage >= EXPLOSION_THRESHOLD_GIB)
		gib()
		return
	if (damage >= 0)
		b_loss += damage * 0.5
		f_loss += damage * 0.5
		apply_damage(b_loss, BRUTE)
		apply_damage(f_loss, BURN)
		updatehealth()

		var/knock_value = min( round( damage * 0.05 ,1) ,5) //unlike in humans, damage is used instead of severity to prevent t3 stunlocking
		if(knock_value > 0 && total_explosive_resistance < 60)
			KnockDown(knock_value)
			KnockOut(knock_value)
			explosion_throw(severity, direction)
		else if(knock_value == 5)
			KnockDown(1)
			KnockOut(1)



/mob/living/carbon/Xenomorph/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked = 0, used_weapon = null, sharp = 0, edge = 0)
	if(!damage) return

	//We still want to check for blood splash before we get to the damage application.
	var/chancemod = 0
	if(used_weapon && sharp)
		chancemod += 10
	if(used_weapon && edge) //Pierce weapons give the most bonus
		chancemod += 12
	if(def_zone != "chest") //Which it generally will be, vs xenos
		chancemod += 5

	if(damage > 12) //Light damage won't splash.
		check_blood_splash(damage, damagetype, chancemod)

	if(stat == DEAD) return

	if(def_zone == "head" || def_zone == "eyes" || def_zone == "mouth") //Little more damage vs the head
		damage = round(damage * 8 / 7)

	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage)
		if(BURN)
			adjustFireLoss(damage)

	updatehealth()
	return 1

#define XENO_ARMOR_BREAK_PASS_TIME 2
#define XENO_ARMOR_BREAK_25PERCENT_IMMUNITY_TIME SECONDS_2

/mob/living/carbon/Xenomorph/proc/apply_armorbreak(armorbreak = 0)
	if(!armorbreak) return

	if(stat == DEAD) return

	if(caste.armor_hardiness_mult <= 0 || armor_deflection<=0)
		return

	//Immunity check
	if(world.time < armor_integrity_immunity_time && world.time>armor_integrity_last_damage_time + XENO_ARMOR_BREAK_PASS_TIME)
		visible_message(SPAN_XENOWARNING("[src]'s broken exoskeleton plate takes the force of the impact!"))		
		return 1
	
	if(world.time>armor_integrity_immunity_time)
		armor_integrity_immunity_time = world.time

	armor_integrity_last_damage_time = world.time

	if(warding_aura && armorbreak > 0) //Damage to armor reduction
		armorbreak = round(armorbreak * ((100 - (warding_aura * 15)) / 100))
	var/old_integrity = armor_integrity
	armor_integrity -= armorbreak / caste.armor_hardiness_mult
	if(armor_integrity <= 0 && old_integrity > 10)
		visible_message(SPAN_XENODANGER("[src]'s thick exoskeleton falls apart!"))
		armor_integrity = 0
	else
		if(old_integrity - armor_integrity > 25  && old_integrity > 0)
			visible_message(SPAN_XENODANGER("[src]'s thick exoskeleton starts cracking!"))
	if(armor_integrity < 0)
		armor_integrity = 0

	var/delay = ((old_integrity - armor_integrity)/25)*XENO_ARMOR_BREAK_25PERCENT_IMMUNITY_TIME

	if(delay>2)
		armor_integrity_immunity_time += delay
	updatehealth()
	return 1

/mob/living/carbon/Xenomorph/proc/check_blood_splash(damage = 0, damtype = BRUTE, chancemod = 0, radius = 1)
	if(!damage)
		return 0
	if(map_tag == MAP_WHISKEY_OUTPOST)
		return 0
	var/chance = 20 //base chance
	if(damtype == BRUTE) chance += 5
	chance += chancemod + (damage * 0.33)
	var/turf/T = loc
	if(!T || !istype(T))
		return

	if(radius > 1 || prob(chance))

		var/obj/effect/decal/cleanable/blood/xeno/decal = locate(/obj/effect/decal/cleanable/blood/xeno) in T

		if(!decal) //Let's not stack blood, it just makes lagggggs.
			add_splatter_floor(T) //Drop some on the ground first.
		else
			if(decal.random_icon_states && length(decal.random_icon_states) > 0) //If there's already one, just randomize it so it changes.
				decal.icon_state = pick(decal.random_icon_states)

		var/splash_chance = 40 //Base chance of getting splashed. Decreases with # of victims.
		var/distance = 0 //Distance, decreases splash chance.
		var/i = 0 //Tally up our victims.

		for(var/mob/living/carbon/human/victim in range(radius,src)) //Loop through all nearby victims, including the tile.
			distance = get_dist(src,victim)

			splash_chance = 80 - (i * 5)
			if(victim.loc == loc) splash_chance += 30 //Same tile? BURN
			splash_chance += distance * -15
			if(victim.species && victim.species.name == "Yautja")
				splash_chance -= 70 //Preds know to avoid the splashback.

			if(splash_chance > 0 && prob(splash_chance)) //Success!
				i++
				victim.visible_message("<span class='danger'>\The [victim] is scalded with hissing green blood!</span>", \
				"<span class='danger'>You are splattered with sizzling blood! IT BURNS!</span>")
				if(prob(60) && !victim.stat && !(victim.species.flags & NO_PAIN))
					victim.emote("scream") //Topkek
				victim.take_limb_damage(0, rand(10, 25)) //Sizzledam! This automagically burns a random existing body part.
