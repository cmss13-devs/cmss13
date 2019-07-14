//This file deals with xenos clicking on stuff in general. Including mobs, objects, general atoms, etc.
//Abby

/*
 * Important note about attack_alien : In our code, attack_ procs are received by src, not dealt by src
 * For example, attack_alien defined for humans means what will happen to THEM when attacked by an alien
 * In that case, the first argument is always the attacker. For attack_alien, it should always be Xenomorph sub-types
 */


/mob/living/carbon/human/attack_alien(mob/living/carbon/Xenomorph/M, dam_bonus)
	if (M.fortify || M.burrow)
		return 0

	//Reviewing the four primary intents
	switch(M.a_intent)

		if("help")
			if(on_fire)
				extinguish_mob(M)
			else
				M.visible_message(SPAN_NOTICE("\The [M] caresses [src] with its scythe-like arm."), \
				SPAN_NOTICE("You caress [src] with your scythe-like arm."), null, 5)

		if("grab")
			if(M == src || anchored || buckled)
				return 0

			if(check_shields(0, M.name) && prob(66)) //Bit of a bonus
				M.visible_message(SPAN_DANGER("\The [M]'s grab is blocked by [src]'s shield!"), \
				SPAN_DANGER("Your grab was blocked by [src]'s shield!"), null, 5)
				playsound(loc, 'sound/weapons/alien_claw_block.ogg', 25, 1) //Feedback
				return 0

			if(Adjacent(M)) //Logic!
				M.start_pulling(src)

		if("hurt")
			if(!M.hive.slashing_allowed && !M.caste.is_intelligent)
				to_chat(M, SPAN_WARNING("Slashing is currently <b>forbidden</b> by the Queen. You refuse to slash [src]."))
				r_FAL

			if(stat == DEAD)
				to_chat(M, SPAN_WARNING("[src] is dead, why would you want to touch it?"))
				r_FAL

			if(!M.caste.is_intelligent)
				if(M.hive.slashing_allowed == 2)
					if(status_flags & XENO_HOST)
						for(var/obj/item/alien_embryo/embryo in src)
							if(embryo.hivenumber == M.hivenumber)
								to_chat(M, SPAN_WARNING("You try to slash [src], but find you <B>cannot</B>. There is a host inside!"))
								r_FAL

					if(M.health > round(2 * M.maxHealth / 3)) //Note : Under 66 % health
						to_chat(M, SPAN_WARNING("You try to slash [src], but find you <B>cannot</B>. You are not yet injured enough to overcome the Queen's orders."))
						r_FAL

				else if(istype(buckled, /obj/structure/bed/nest) && (status_flags & XENO_HOST))
					for(var/obj/item/alien_embryo/embryo in src)
						if(embryo.hivenumber == M.hivenumber)
							to_chat(M, SPAN_WARNING("You should not harm this host! It has a sister inside."))
							r_FAL

			if(check_shields(0, M.name) && prob(66)) //Bit of a bonus
				M.visible_message(SPAN_DANGER("\The [M]'s slash is blocked by [src]'s shield!"), \
				SPAN_DANGER("Your slash is blocked by [src]'s shield!"), null, 5)
				r_FAL

			//From this point, we are certain a full attack will go out. Calculate damage and modifiers
			var/damage = rand(M.melee_damage_lower, M.melee_damage_upper) + dam_bonus
			var/acid_damage = 0
			if(M.burn_damage_lower)
				acid_damage = rand(M.burn_damage_lower, M.burn_damage_upper)

			//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
			if(M.frenzy_aura > 0)
				damage += (M.frenzy_aura * 2)
				if(acid_damage)
					acid_damage += (M.frenzy_aura * 2)

			M.animation_attack_on(src)

			//Check for a special bite attack
			if(prob(M.caste.bite_chance))
				M.bite_attack(src, damage)
				return 1

			//Check for a special bite attack
			if(prob(M.caste.tail_chance))
				M.tail_attack(src, damage)
				return 1

			//Somehow we will deal no damage on this attack
			if(!damage)
				playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
				M.animation_attack_on(src)
				M.visible_message(SPAN_DANGER("\The [M] lunges at [src]!"), \
				SPAN_DANGER("You lunge at [src]!"), null, 5)
				return 0

			M.flick_attack_overlay(src, "slash")
			var/datum/limb/affecting
			affecting = get_limb(ran_zone(M.zone_selected, 70))
			if(!affecting) //No organ, just get a random one
				affecting = get_limb(ran_zone(null, 0))
			if(!affecting) //Still nothing??
				affecting = get_limb("chest") //Gotta have a torso?!

			var/armor_block = getarmor(affecting, ARMOR_MELEE)

			if(isYautja(src) && check_zone(M.zone_selected) == "head")
				if(istype(wear_mask, /obj/item/clothing/mask/gas/yautja))
					var/knock_chance = 1
					if(M.frenzy_aura > 0)
						knock_chance += 2 * M.frenzy_aura
					if(M.caste.is_intelligent)
						knock_chance += 2
					knock_chance += min(round(damage * 0.25), 10) //Maximum of 15% chance.
					if(prob(knock_chance))
						playsound(loc, "alien_claw_metal", 25, 1)
						M.visible_message(SPAN_DANGER("The [M] smashes off [src]'s [wear_mask.name]!"), \
						SPAN_DANGER("You smash off [src]'s [wear_mask.name]!"), null, 5)
						drop_inv_item_on_ground(wear_mask)
						emote("roar")
						return 1

			//The normal attack proceeds
			playsound(loc, "alien_claw_flesh", 25, 1)
			M.visible_message(SPAN_DANGER("\The [M] slashes [src]!"), \
			SPAN_DANGER("You slash [src]!"))

			//Logging, including anti-rulebreak logging
			if(src.status_flags & XENO_HOST && src.stat != DEAD)
				if(istype(src.buckled, /obj/structure/bed/nest)) //Host was buckled to nest while infected, this is a rule break
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'><B>was slashed by [M.name] ([M.ckey]) while they were infected and nested</B></font>")
					M.attack_log += text("\[[time_stamp()]\] <font color='red'><B>slashed [src.name] ([src.ckey]) while they were infected and nested</B></font>")
					msg_admin_ff("[key_name(M)] slashed [key_name(src)] while they were infected and nested.") //This is a blatant rulebreak, so warn the admins
				else //Host might be rogue, needs further investigation
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [M.name] ([M.ckey]) while they were infected</font>")
					M.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [src.name] ([src.ckey]) while they were infected</font>")
			else //Normal xenomorph friendship with benefits
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [M.name] ([M.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [src.name] ([src.ckey])</font>")
			log_attack("[M.name] ([M.ckey]) slashed [src.name] ([src.ckey])")

			if (isXenoRavager(M))
				var/mob/living/carbon/Xenomorph/Ravager/R = M
				if (R.delimb(src, affecting))
					return 1
			
			// Snowflake code for Praetorian, unfortunately there's no place to put this other than here. Fortunately its very cheap
			if (isXenoPraetorian(M))
				var/mob/living/carbon/Xenomorph/Praetorian/P = M
				var/datum/caste_datum/praetorian/pCaste = P.caste
				if (P.prae_status_flags & PRAE_DANCER_STATSBUFFED && P.mutation_type == PRAETORIAN_DANCER)
					damage += 15 // Only slightly stronger than a normal attack, Praes should be using impale here
					to_chat(P, SPAN_WARNING("You expend your dance to empower your attack!"))
					P.speed_modifier += pCaste.dance_speed_buff
					P.evasion_modifier -= pCaste.dance_evasion_buff
					P.recalculate_speed()
					P.recalculate_evasion()
					P.prae_status_flags &= ~PRAE_DANCER_STATSBUFFED


			var/n_damage = armor_damage_reduction(config.marine_melee, damage, armor_block)
			//nice messages so people know that armor works
			if (n_damage <= 0.34*damage)
				show_message(SPAN_WARNING("Your armor absorbs the blow!"))
			else if (n_damage <= 0.67*damage)
				show_message(SPAN_WARNING("Your armor softens the blow!"))

			apply_damage(n_damage, BRUTE, affecting, 0, sharp = 1, edge = 1) //This should slicey dicey
			if(acid_damage)
				playsound(loc, "acid_hit", 25, 1)
				var/armor_block_acid = getarmor(affecting, ARMOR_BIO)
				var/n_acid_damage = armor_damage_reduction(config.marine_melee, acid_damage, armor_block_acid)
				//nice messages so people know that armor works
				if (n_acid_damage <= 0.34*acid_damage)
					show_message(SPAN_WARNING("Your armor protects your from acid!"))
				else if (n_acid_damage <= 0.67*acid_damage)
					show_message(SPAN_WARNING("Your armor reduces the effect of the acid!"))
				apply_damage(n_acid_damage, BURN, affecting, 0) //Burn damage

			updatehealth()

		if("disarm")
			if(M.legcuffed && isYautja(src))
				to_chat(M, SPAN_XENODANGER("You don't have the dexterity to tackle the headhunter with that thing on your leg!"))
				return 0
			M.animation_attack_on(src)
			if(check_shields(0, M.name) && prob(66)) //Bit of a bonus
				M.visible_message(SPAN_DANGER("\The [M]'s tackle is blocked by [src]'s shield!"), \
				SPAN_DANGER("Your tackle is blocked by [src]'s shield!"), null, 5)
				return 0
			M.flick_attack_overlay(src, "disarm")
			if(knocked_down)
				if(isYautja(src))
					if(prob(95))
						M.visible_message(SPAN_DANGER("[src] avoids \the [M]'s tackle!"), \
						SPAN_DANGER("[src] avoids your attempt to tackle them!"), null, 5)
						playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
						return 1
				else if(prob(80))
					playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
					M.visible_message(SPAN_DANGER("\The [M] tries to tackle [src], but they are already down!"), \
					SPAN_DANGER("You try to tackle [src], but they are already down!"), null, 5)
					return 1
				playsound(loc, 'sound/weapons/pierce.ogg', 25, 1)
				KnockDown(rand(M.tacklemin, M.tacklemax)) //Min and max tackle strenght. They are located in individual caste files.
				M.visible_message(SPAN_DANGER("\The [M] tackles down [src]!"), \
				SPAN_DANGER("You tackle down [src]!"), null, 5)

			else
				var/tackle_bonus = 0
				if(M.frenzy_aura > 0)
					tackle_bonus = M.frenzy_aura * 3
				if(isYautja(src))
					if(prob((M.caste.tackle_chance + tackle_bonus)*0.2))
						playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
						KnockDown(rand(M.tacklemin, M.tacklemax))
						M.visible_message(SPAN_DANGER("\The [M] tackles down [src]!"), \
						SPAN_DANGER("You tackle down [src]!"), null, 5)
						return 1
					else
						playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
						M.visible_message(SPAN_DANGER("\The [M] tries to tackle [src]"), \
						SPAN_DANGER("You try to tackle [src]"), null, 5)
						return 1
				else if(prob(M.caste.tackle_chance + tackle_bonus)) //Tackle_chance is now a special var for each caste.
					playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
					KnockDown(rand(M.tacklemin, M.tacklemax))
					M.visible_message(SPAN_DANGER("\The [M] tackles down [src]!"), \
					SPAN_DANGER("You tackle down [src]!"), null, 5)
					return 1

				playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
				M.visible_message(SPAN_DANGER("\The [M] tries to tackle [src]"), \
				SPAN_DANGER("You try to tackle [src]"), null, 5)
	return 1


//Every other type of nonhuman mob
/mob/living/attack_alien(mob/living/carbon/Xenomorph/M)
	if (M.fortify || M.burrow)
		return 0

	switch(M.a_intent)
		if("help")
			M.visible_message(SPAN_NOTICE("\The [M] caresses [src] with its scythe-like arm."), \
			SPAN_NOTICE("You caress [src] with your scythe-like arm."), null, 5)
			return 0

		if("grab")
			if(M == src || anchored || buckled)
				return 0

			if(Adjacent(M)) //Logic!
				M.start_pulling(src)

		if("hurt")
			if(isXeno(src) && xeno_hivenumber(src) == M.hivenumber)
				M.visible_message(SPAN_WARNING("\The [M] nibbles [src]."), \
				SPAN_WARNING("You nibble [src]."), null, 5)
				return 1

			if(!M.caste.is_intelligent)
				if(M.hive.slashing_allowed == 2)
					if(status_flags & XENO_HOST)
						for(var/obj/item/alien_embryo/embryo in src)
							if(embryo.hivenumber == M.hivenumber)
								to_chat(M, SPAN_WARNING("You try to slash [src], but find you <B>cannot</B>. There is a host inside!"))
								r_FAL

					if(M.health > round(2 * M.maxHealth / 3)) //Note : Under 66 % health
						to_chat(M, SPAN_WARNING("You try to slash [src], but find you <B>cannot</B>. You are not yet injured enough to overcome the Queen's orders."))
						r_FAL

				else if(istype(buckled, /obj/structure/bed/nest) && (status_flags & XENO_HOST))
					for(var/obj/item/alien_embryo/embryo in src)
						if(embryo.hivenumber == M.hivenumber)
							to_chat(M, SPAN_WARNING("You should not harm this host! It has a sister inside."))
							r_FAL

			if(issilicon(src) && stat != DEAD) //A bit of visual flavor for attacking Cyborgs. Sparks!
				var/datum/effect_system/spark_spread/spark_system
				spark_system = new /datum/effect_system/spark_spread()
				spark_system.set_up(5, 0, src)
				spark_system.attach(src)
				spark_system.start(src)
				playsound(loc, "alien_claw_metal", 25, 1)

			// copypasted from attack_alien.dm
			//From this point, we are certain a full attack will go out. Calculate damage and modifiers
			var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)

			//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
			if(M.frenzy_aura > 0)
				damage += (M.frenzy_aura * 2)

			//Somehow we will deal no damage on this attack
			if(!damage)
				playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
				M.animation_attack_on(src)
				M.visible_message(SPAN_DANGER("\The [M] lunges at [src]!"), \
				SPAN_DANGER("You lunge at [src]!"), null, 5)
				return 0

			M.visible_message(SPAN_DANGER("\The [M] slashes [src]!"), \
			SPAN_DANGER("You slash [src]!"), null, 5)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [M.name] ([M.ckey])</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [src.name] ([src.ckey])</font>")
			log_attack("[M.name] ([M.ckey]) slashed [src.name] ([src.ckey])")

			playsound(loc, "alien_claw_flesh", 25, 1)
			apply_damage(damage, BRUTE)

		if("disarm")
			playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
			M.visible_message(SPAN_WARNING("\The [M] shoves [src]!"), \
			SPAN_WARNING("You shove [src]!"), null, 5)
			if(ismonkey(src))
				KnockDown(8)
	return 0

/mob/living/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	M.visible_message(SPAN_DANGER("[M] nudges its head against [src]."), \
	SPAN_DANGER("You nudge your head against [src]."), null, 5)

//This proc is here to prevent Xenomorphs from picking up objects (default attack_hand behaviour)
//Note that this is overriden by every proc concerning a child of obj unless inherited
/obj/item/attack_alien(mob/living/carbon/Xenomorph/M)
	return

/obj/item/clothing/mask/facehugger/attack_alien(mob/living/carbon/Xenomorph/M)
	attack_hand(M)


/obj/vehicle/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent == "hurt")
		M.animation_attack_on(src)
		playsound(loc, "alien_claw_metal", 25, 1)
		M.flick_attack_overlay(src, "slash")
		health -= 15
		playsound(src.loc, "alien_claw_metal", 25, 1)
		M.visible_message(SPAN_DANGER("[M] slashes [src]."),SPAN_DANGER("You slash [src]."), null, 5)
		healthcheck()
	else
		attack_hand(M)


/obj/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	return //larva can't do anything

//Closets are used just like humans would
/obj/structure/closet/attack_alien(mob/user as mob)
	return src.attack_hand(user)

//Breaking tables and racks
/obj/structure/table/attack_alien(mob/living/carbon/Xenomorph/M)
	if(breakable)
		M.animation_attack_on(src)
		if(sheet_type == /obj/item/stack/sheet/wood)
			playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
		else
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		health -= rand(M.melee_damage_lower, M.melee_damage_upper)
		if(health <= 0)
			M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"), \
			SPAN_DANGER("You slice [src] apart!"), null, 5)
			destroy()
		else
			M.visible_message(SPAN_DANGER("[M] slashes [src]!"), \
			SPAN_DANGER("You slash [src]!"), null, 5)

//Breaking barricades
/obj/structure/barricade/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	take_damage( rand(M.melee_damage_lower, M.melee_damage_upper) )
	if(barricade_hitsound)
		playsound(src, barricade_hitsound, 25, 1)
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"), \
		SPAN_DANGER("You slice [src] apart!"), null, 5)
	else
		M.visible_message(SPAN_DANGER("[M] slashes [src]!"), \
		SPAN_DANGER("You slash [src]!"), null, 5)
	if(is_wired)
		M.visible_message(SPAN_DANGER("The barbed wire slices into [M]!"),
		SPAN_DANGER("The barbed wire slices into you!"), null, 5)
		M.apply_damage(10)


/obj/structure/rack/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	M.visible_message(SPAN_DANGER("[M] slices [src] apart!"), \
	SPAN_DANGER("You slice [src] apart!"), null, 5)
	destroy()

//Default "structure" proc. This should be overwritten by sub procs.
//If we sent it to monkey we'd get some weird shit happening.
/obj/structure/attack_alien(mob/living/carbon/Xenomorph/M)
	return 0


//Beds, nests and chairs - unbuckling
/obj/structure/bed/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent == "hurt")
		M.animation_attack_on(src)
		playsound(src, hit_bed_sound, 25, 1)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
		SPAN_DANGER("You slice [src] apart!"), null, 5)
		unbuckle()
		destroy()
	else attack_hand(M)


//Medevac stretchers. Unbuckle ony
/obj/structure/bed/medevac_stretcher/attack_alien(mob/living/carbon/Xenomorph/M)
	unbuckle()

//Smashing lights
/obj/machinery/light/attack_alien(mob/living/carbon/Xenomorph/M)
	if(status == 2) //Ignore if broken. Note that we can't use defines here
		return 0
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("\The [M] smashes [src]!"), \
	SPAN_DANGER("You smash [src]!"), null, 5)
	broken() //Smashola!

//Smashing windows
/obj/structure/window/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent == HELP_INTENT)
		playsound(src.loc, 'sound/effects/glassknock.ogg', 25, 1)
		M.visible_message(SPAN_WARNING("\The [M] creepily taps on [src] with its huge claw."), \
		SPAN_WARNING("You creepily tap on [src]."), \
		SPAN_WARNING("You hear a glass tapping sound."), 5)
	else
		attack_generic(M, M.melee_damage_lower)

//Slashing bots
/obj/machinery/bot/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	health -= rand(15, 30)
	if(health <= 0)
		M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"), \
		SPAN_DANGER("You slice [src] apart!"), null, 5)
	else
		M.visible_message(SPAN_DANGER("[M] slashes [src]!"), \
		SPAN_DANGER("You slash [src]!"), null, 5)
	playsound(loc, "alien_claw_metal", 25, 1)
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	healthcheck()

//Slashing cameras
/obj/machinery/camera/attack_alien(mob/living/carbon/Xenomorph/M)
	if(status)
		M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"), \
		SPAN_DANGER("You slice [src] apart!"), null, 5)
		playsound(loc, "alien_claw_metal", 25, 1)
		wires = 0 //wires all cut
		light_disabled = 0
		toggle_cam_status(M, TRUE)

//Slashing windoors
/obj/machinery/door/window/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	M.visible_message(SPAN_DANGER("[M] smashes against [src]!"), \
	SPAN_DANGER("You smash against [src]!"), null, 5)
	var/damage = 25
	if(M.mob_size == MOB_SIZE_BIG)
		damage = 40
	take_damage(damage)

//Slashing mechas
/obj/mecha/attack_alien(mob/living/carbon/Xenomorph/M)
	log_message("Attack by claw. Attacker - [M].", 1)

	if(!prob(deflect_chance))
		take_damage((rand(M.melee_damage_lower, M.melee_damage_upper)/2))
		check_for_internal_damage(list(MECHA_INT_CONTROL_LOST))
		playsound(loc, "alien_claw_metal", 25, 1)
		M.visible_message(SPAN_DANGER("[M] slashes [src]'s armor!"), \
		SPAN_DANGER("You slash [src]'s armor!"), null, 5)
	else
		src.log_append_to_last("Armor saved.")
		playsound(loc, "alien_claw_metal", 25, 1)
		M.visible_message(SPAN_WARNING("[M] slashes [src]'s armor to no effect!"), \
		SPAN_DANGER("You slash [src]'s armor to no effect!"), null, 5)

//Slashing grilles
/obj/structure/grille/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	var/damage_dealt = 5
	M.visible_message(SPAN_DANGER("\The [M] mangles [src]!"), \
	SPAN_DANGER("You mangle [src]!"), \
	SPAN_DANGER("You hear twisting metal!"), 5)

	if(shock(M, 70))
		M.visible_message(SPAN_DANGER("ZAP! \The [M] spazzes wildly amongst a smell of burnt ozone."), \
		SPAN_DANGER("ZAP! You twitch and dance like a monkey on hyperzine!"), \
		SPAN_DANGER("You hear a sharp ZAP and a smell of ozone."))
		return 0 //Intended apparently ?

	health -= damage_dealt
	healthcheck()

//Slashing fences
/obj/structure/fence/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	var/damage_dealt = 5
	M.visible_message(SPAN_DANGER("\The [M] mangles [src]!"), \
	SPAN_DANGER("You mangle [src]!"), \
	SPAN_DANGER("You hear twisting metal!"), 5)

	health -= damage_dealt
	healthcheck()

//Slashin mirrors
/obj/structure/mirror/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	if(shattered)
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return 1

	if(M.a_intent == HELP_INTENT)
		M.visible_message(SPAN_WARNING("\The [M] oogles its own reflection in [src]."), \
			SPAN_WARNING("You oogle your own reflection in [src]."), null, 5)
	else
		M.visible_message(SPAN_DANGER("\The [M] smashes [src]!"), \
			SPAN_DANGER("You smash [src]!"), null, 5)
		shatter()

//Foamed metal
/obj/structure/foamedmetal/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	if(prob(33))
		M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"), \
			SPAN_DANGER("You slice [src] apart!"), null, 5)
		qdel(src)
		return 1
	else
		M.visible_message(SPAN_DANGER("\The [M] tears some shreds off [src]!"), \
			SPAN_DANGER("You tear some shreds off [src]!"), null, 5)

//Prying open doors
/obj/machinery/door/airlock/attack_alien(mob/living/carbon/Xenomorph/M)
	var/turf/cur_loc = M.loc
	if(isElectrified())
		if(shock(M, 70))
			return
	if(locked)
		to_chat(M, SPAN_WARNING("\The [src] is bolted down tight."))
		return 0
	if(welded)
		to_chat(M, SPAN_WARNING("\The [src] is welded shut."))
		return 0
	if(!istype(cur_loc))
		return 0 //Some basic logic here
	if(!density)
		to_chat(M, SPAN_WARNING("\The [src] is already open!"))
		return 0

	if(M.action_busy)
		return 0

	if(M.lying)
		return 0

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, 1)
	M.visible_message(SPAN_WARNING("\The [M] digs into \the [src] and begins to pry it open."), \
	SPAN_WARNING("You dig into \the [src] and begin to pry it open."), null, 5)

	if(do_after(M, 40, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(M.loc != cur_loc)
			return 0 //Make sure we're still there
		if(M.lying)
			return 0
		if(locked)
			to_chat(M, SPAN_WARNING("\The [src] is bolted down tight."))
			return 0
		if(welded)
			to_chat(M, SPAN_WARNING("\The [src] is welded shut."))
			return 0
		if(density) //Make sure it's still closed
			spawn(0)
				open(1)
				M.visible_message(SPAN_DANGER("\The [M] pries \the [src] open."), \
				SPAN_DANGER("You pry \the [src] open."), null, 5)

/obj/machinery/door/airlock/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	for(var/atom/movable/AM in get_turf(src))
		if(AM != src && AM.density && !AM.CanPass(M, M.loc))
			to_chat(M, SPAN_WARNING("\The [AM] prevents you from squeezing under \the [src]!"))
			return
	if(locked || welded) //Can't pass through airlocks that have been bolted down or welded
		to_chat(M, SPAN_WARNING("\The [src] is locked down tight. You can't squeeze underneath!"))
		return
	M.visible_message(SPAN_WARNING("\The [M] scuttles underneath \the [src]!"), \
	SPAN_WARNING("You squeeze and scuttle underneath \the [src]."), null, 5)
	M.forceMove(loc)

//Prying open FIREdoors
/obj/machinery/door/firedoor/attack_alien(mob/living/carbon/Xenomorph/M)
	var/turf/cur_loc = M.loc
	if(blocked)
		to_chat(M, SPAN_WARNING("\The [src] is welded shut."))
		return 0
	if(!istype(cur_loc))
		return 0 //Some basic logic here
	if(!density)
		to_chat(M, SPAN_WARNING("\The [src] is already open!"))
		return 0

	playsound(src.loc, 'sound/effects/metal_creaking.ogg', 25, 1)
	M.visible_message(SPAN_WARNING("\The [M] digs into \the [src] and begins to pry it open."), \
	SPAN_WARNING("You dig into \the [src] and begin to pry it open."), null, 5)

	if(do_after(M, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(M.loc != cur_loc)
			return 0 //Make sure we're still there
		if(blocked)
			to_chat(M, SPAN_WARNING("\The [src] is welded shut."))
			return 0
		if(density) //Make sure it's still closed
			spawn(0)
				open(1)
				M.visible_message(SPAN_DANGER("\The [M] pries \the [src] open."), \
				SPAN_DANGER("You pry \the [src] open."), null, 5)


//Nerfing the damn Cargo Tug Train
/obj/vehicle/train/attack_alien(mob/living/carbon/Xenomorph/M)
	attack_hand(M)


/obj/structure/mineral_door/resin/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	var/turf/cur_loc = M.loc
	if(!istype(cur_loc))
		return 0
	TryToSwitchState(M)
	return 1

//clicking on resin doors attacks them, or opens them without harm intent
/obj/structure/mineral_door/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	var/turf/cur_loc = M.loc
	if(!istype(cur_loc))
		return 0 //Some basic logic here
	if(M.a_intent != "hurt")
		TryToSwitchState(M)
		return 1
	else
		if(isXenoLarva(M))
			return
		else
			M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"), \
			SPAN_XENONOTICE("You claw \the [src]."))
			playsound(loc, "alien_resin_break", 25)
			health -= rand(35,45) // takes two or three hits
		qdel(src)

//Xenomorphs can't use machinery, not even the "intelligent" ones
//Exception is Queen and shuttles, because plot power
/obj/machinery/attack_alien(mob/living/carbon/Xenomorph/M)
	to_chat(M, SPAN_WARNING("You stare at \the [src] cluelessly."))

/datum/shuttle/ferry/marine/proc/hijack(mob/living/carbon/Xenomorph/M)
	if(!queen_locked) //we have not hijacked it yet
		if(world.time < SHUTTLE_LOCK_TIME_LOCK)
			to_chat(M, SPAN_XENODANGER("You can't mobilize the strength to hijack the shuttle yet. Please wait another [round((SHUTTLE_LOCK_TIME_LOCK-world.time)/MINUTES_1)] minutes before trying again."))
			return
		to_chat(M, SPAN_XENONOTICE("You interact with the machine and disable remote control."))
		xeno_message(SPAN_XENOANNOUNCE("We have wrested away remote control of the metal bird! Rejoice!"),3,M.hivenumber)
		last_locked = world.time
		queen_locked = 1

/datum/shuttle/ferry/marine/proc/door_override(mob/living/carbon/Xenomorph/M)
	if(!door_override)
		to_chat(M, SPAN_XENONOTICE("You override the doors."))
		xeno_message(SPAN_XENOANNOUNCE("The doors of the metal bird have been overridden! Rejoice!"),3,M.hivenumber)
		last_door_override = world.time
		door_override = 1

		var/ship_id = "sh_dropship1"
		if(shuttle_tag == "[MAIN_SHIP_NAME] Dropship 2")
			ship_id = "sh_dropship2"

		for(var/obj/machinery/door/airlock/dropship_hatch/D in machines)
			if(D.id == ship_id)
				D.unlock()

		var/obj/machinery/door/airlock/multi_tile/almayer/reardoor
		switch(ship_id)
			if("sh_dropship1")
				for(var/obj/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1/D in machines)
					reardoor = D
			if("sh_dropship2")
				for(var/obj/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2/D in machines)
					reardoor = D

		reardoor.unlock()

/obj/machinery/computer/shuttle_control/attack_alien(mob/living/carbon/Xenomorph/M)
	var/datum/shuttle/ferry/marine/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		..()
		return
	if(M.caste.is_intelligent)
		attack_hand(M)
		if(!shuttle.iselevator)
			shuttle.door_override(M)
			if(onboard) //This is the shuttle's onboard console
				shuttle.hijack(M)
	else
		..()

/obj/machinery/door_control/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.caste.is_intelligent && normaldoorcontrol == CONTROL_DROPSHIP)
		var/shuttle_tag
		switch(id)
			if("sh_dropship1")
				shuttle_tag = "[MAIN_SHIP_NAME] Dropship 1"
			if("sh_dropship2")
				shuttle_tag = "[MAIN_SHIP_NAME] Dropship 2"
			else
				return

		var/datum/shuttle/ferry/marine/shuttle = shuttle_controller.shuttles[shuttle_tag]
		shuttle.door_override(M)
		if(do_after(usr, 50, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			shuttle.hijack(M)
	else
		..()

//APCs.
/obj/machinery/power/apc/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M] slashes \the [src]!"), \
	SPAN_DANGER("You slash \the [src]!"), null, 5)
	playsound(loc, "alien_claw_metal", 25, 1)
	var/allcut = 1
	for(var/wire in apcwirelist)
		if(!isWireCut(apcwirelist[wire]))
			allcut = 0
			break

	if(beenhit >= pick(3, 4) && wiresexposed != 1)
		wiresexposed = 1
		update_icon()
		visible_message(SPAN_DANGER("\The [src]'s cover swings open, exposing the wires!"), null, null, 5)

	else if(wiresexposed == 1 && allcut == 0)
		for(var/wire in apcwirelist)
			cut(apcwirelist[wire])
		update_icon()
		visible_message("<span class='danger'>\The [src]'s wires snap apart in a rain of sparks!", null, null, 5)
	else
		beenhit += 1

/obj/structure/ladder/attack_alien(mob/living/carbon/Xenomorph/M)
	return attack_hand(M)

/obj/structure/ladder/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	return attack_hand(M)

/obj/machinery/colony_floodlight/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!is_lit)
		to_chat(M, "Why bother? It's just some weird metal thing.")
		return 0
	else if(damaged)
		to_chat(M, "It's already damaged.")
		return 0
	else
		M.animation_attack_on(src)
		M.visible_message("[M] slashes away at [src]!","You slash and claw at the bright light!", null, null, 5)
		health  = max(health - rand(M.melee_damage_lower, M.melee_damage_upper), 0)
		if(!health)
			playsound(src, "shatter", 70, 1)
			damaged = TRUE
			if(is_lit)
				SetLuminosity(0)
			update_icon()
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)

/obj/machinery/colony_floodlight/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	M.visible_message("[M] starts biting [src]!","In a rage, you start biting [src], but with no effect!", null, 5)



//Digging up snow
/turf/open/snow/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent == HELP_INTENT)
		return 0

	if(!slayer)
		to_chat(M, SPAN_WARNING("There is nothing to clear out!"))
		return 0

	M.visible_message(SPAN_NOTICE("\The [M] starts clearing out \the [src]."), \
	SPAN_NOTICE("You start clearing out \the [src]."), null, 5)
	playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
	if(!do_after(M, 25, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return 0

	if(!slayer)
		M  << SPAN_WARNING("There is nothing to clear out!")
		return

	M.visible_message(SPAN_NOTICE("\The [M] clears out \the [src]."), \
	SPAN_NOTICE("You clear out \the [src]."), null, 5)
	slayer -= 1
	update_icon(1, 0)

/turf/open/snow/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	return //Larvae can't do shit


//Crates, closets, other paraphernalia
/obj/structure/largecrate/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	new /obj/item/stack/sheet/wood(src)
	var/turf/T = get_turf(src)
	for(var/obj/O in contents)
		O.loc = T
	M.visible_message(SPAN_DANGER("\The [M] smashes \the [src] apart!"), \
	SPAN_DANGER("You smash \the [src] apart!"), \
	SPAN_DANGER("You hear splitting wood!"), 5)
	qdel(src)

/obj/structure/closet/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent == "hurt" && !unacidable)
		M.animation_attack_on(src)
		if(!opened && prob(70))
			break_open()
			M.visible_message(SPAN_DANGER("\The [M] smashes \the [src] open!"), \
			SPAN_DANGER("You smash \the [src] open!"), null, 5)
		else
			M.visible_message(SPAN_DANGER("\The [M] smashes \the [src]!"), \
			SPAN_DANGER("You smash \the [src]!"), null, 5)
	else
		return M.UnarmedAttack(src)

/obj/structure/girder/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.caste.tier < 2 || unacidable)
		to_chat(M, SPAN_WARNING("Your claws aren't sharp enough to damage \the [src]."))
		return 0
	else
		M.animation_attack_on(src)
		health -= round(rand(M.melee_damage_lower, M.melee_damage_upper) / 2)
		if(health <= 0)
			M.visible_message(SPAN_DANGER("\The [M] smashes \the [src] apart!"), \
			SPAN_DANGER("You slice \the [src] apart!"), null, 5)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
			dismantle()
		else
			M.visible_message(SPAN_DANGER("[M] smashes \the [src]!"), \
			SPAN_DANGER("You slash \the [src]!"), null, 5)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)

/obj/machinery/vending/attack_alien(mob/living/carbon/Xenomorph/M)
	if(tipped_level)
		to_chat(M, SPAN_WARNING("There's no reason to bother with that old piece of trash."))
		return 0

	if(M.a_intent == "hurt")
		M.animation_attack_on(src)
		if(prob(M.melee_damage_lower))
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
			M.visible_message(SPAN_DANGER("\The [M] smashes \the [src] beyond recognition!"), \
			SPAN_DANGER("You enter a frenzy and smash \the [src] apart!"), null, 5)
			malfunction()
			return 1
		else
			M.visible_message(SPAN_DANGER("[M] slashes \the [src]!"), \
			SPAN_DANGER("You slash \the [src]!"), null, 5)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		return 1

	M.visible_message(SPAN_WARNING("\The [M] begins to lean against \the [src]."), \
	SPAN_WARNING("You begin to lean against \the [src]."), null, 5)
	tipped_level = 1
	var/shove_time = 100
	if(M.mob_size == MOB_SIZE_BIG)
		shove_time = 50
	if(istype(M,/mob/living/carbon/Xenomorph/Crusher))
		shove_time = 15
	if(do_after(M, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		M.visible_message(SPAN_DANGER("\The [M] knocks \the [src] down!"), \
		SPAN_DANGER("You knock \the [src] down!"), null, 5)
		tip_over()
	else
		tipped_level = 0

/obj/structure/inflatable/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	deflate(1)

/obj/machinery/vending/proc/tip_over()
	var/matrix/A = matrix()
	tipped_level = 2
	density = 0
	A.Turn(90)
	transform = A
	malfunction()

/obj/machinery/vending/proc/flip_back()
	icon_state = initial(icon_state)
	tipped_level = 0
	density = 1
	var/matrix/A = matrix()
	transform = A
	stat &= ~BROKEN //Remove broken. MAGICAL REPAIRS
