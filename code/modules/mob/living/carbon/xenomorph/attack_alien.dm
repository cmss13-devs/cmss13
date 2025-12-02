//This file deals with xenos clicking on stuff in general. Including mobs, objects, general atoms, etc.
//Abby

/*
 * Important note about attack_alien : In our code, attack_ procs are received by src, not dealt by src
 * For example, attack_alien defined for humans means what will happen to THEM when attacked by an alien
 * In that case, the first argument is always the attacker. For attack_alien, it should always be Xenomorph sub-types
 */

// this proc could use refactoring at some point
/mob/living/carbon/human/attack_alien(mob/living/carbon/xenomorph/attacking_xeno, dam_bonus, unblockable = FALSE)
	if(attacking_xeno.fortify || HAS_TRAIT(attacking_xeno, TRAIT_ABILITY_BURROWED))
		return XENO_NO_DELAY_ACTION

	if(HAS_TRAIT(src, TRAIT_HAULED))
		to_chat(attacking_xeno, SPAN_WARNING("[src] is being hauled, we cannot do anything to them."))
		return

	var/intent = attacking_xeno.a_intent

	if(attacking_xeno.behavior_delegate)
		intent = attacking_xeno.behavior_delegate.override_intent(src)

	//Reviewing the four primary intents
	switch(intent)

		if(INTENT_HELP)
			if(on_fire)
				extinguish_mob(attacking_xeno)
			else
				attacking_xeno.visible_message(SPAN_NOTICE("[attacking_xeno] caresses [src] with its claws."),
				SPAN_NOTICE("We caress [src] with our claws."), null, 5, CHAT_TYPE_XENO_FLUFF)

		if(INTENT_GRAB)
			if(attacking_xeno == src || anchored || buckled)
				return XENO_NO_DELAY_ACTION

			if(!unblockable && check_shields(attacking_xeno.name, get_dir(src, attacking_xeno), custom_response = TRUE)) // Blocking check
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno]'s grab is blocked by [src]'s shield!"),
				SPAN_DANGER("Our grab was blocked by [src]'s shield!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			if(Adjacent(attacking_xeno)) //Logic!
				attacking_xeno.start_pulling(src)

		if(INTENT_HARM)
			if(attacking_xeno.claw_restrained())
				attacking_xeno.animation_attack_on(src)
				attacking_xeno.visible_message(SPAN_NOTICE("[attacking_xeno] tries to strike [src]"),
				SPAN_XENONOTICE("We try to strike [src] but fail due to our restraints!"))
				return XENO_ATTACK_ACTION

			if(attacking_xeno.can_not_harm(src, check_hive_flags=FALSE)) // We manually check hive_flags later
				attacking_xeno.animation_attack_on(src)
				attacking_xeno.visible_message(SPAN_NOTICE("[attacking_xeno] nibbles [src]"),
				SPAN_XENONOTICE("We nibble [src]"))
				return XENO_ATTACK_ACTION

			if(attacking_xeno.behavior_delegate && attacking_xeno.behavior_delegate.handle_slash(src))
				return XENO_NO_DELAY_ACTION

			if(stat == DEAD)
				to_chat(attacking_xeno, SPAN_WARNING("[src] is dead, why would we want to touch it?"))
				return XENO_NO_DELAY_ACTION

			if(attacking_xeno.caste && !attacking_xeno.caste.is_intelligent)
				var/embryo_allied = FALSE
				if(status_flags & XENO_HOST)
					for(var/obj/item/alien_embryo/embryo in src)
						if(HIVE_ALLIED_TO_HIVE(attacking_xeno.hivenumber, embryo.hivenumber))
							embryo_allied = TRUE
							break

				if(embryo_allied)
					if(HAS_TRAIT(src, TRAIT_NESTED))
						attacking_xeno.animation_attack_on(src)
						attacking_xeno.visible_message(SPAN_NOTICE("[attacking_xeno] nibbles [src]"),
						SPAN_XENONOTICE("We nibble [src], as it has a sister inside we should not harm."))
						return XENO_NO_DELAY_ACTION
					if(!HAS_FLAG(attacking_xeno.hive.hive_flags, XENO_SLASH_INFECTED))
						attacking_xeno.animation_attack_on(src)
						attacking_xeno.visible_message(SPAN_NOTICE("[attacking_xeno] nibbles [src]"),
						SPAN_XENONOTICE("We nibble [src], as queen forbade slashing of infected hosts!"))
						return XENO_ATTACK_ACTION
				if(!HAS_FLAG(attacking_xeno.hive.hive_flags, XENO_SLASH_NORMAL))
					attacking_xeno.animation_attack_on(src)
					attacking_xeno.visible_message(SPAN_NOTICE("[attacking_xeno] nibbles [src]"),
					SPAN_XENONOTICE("We nibble [src], as queen forbade slashing!"))
					return XENO_ATTACK_ACTION

			if(!unblockable && check_shields(attacking_xeno.name, get_dir(src, attacking_xeno), custom_response = TRUE)) // Blocking check
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno]'s slash is blocked by [src]'s shield!"),
				SPAN_DANGER("Our slash is blocked by [src]'s shield!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			//From this point, we are certain a full attack will go out. Calculate damage and modifiers
			attacking_xeno.track_slashes(attacking_xeno.caste_type) //Adds to slash stat.
			var/damage = rand(attacking_xeno.melee_damage_lower, attacking_xeno.melee_damage_upper) + dam_bonus
			var/acid_damage = 0

			//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
			if(attacking_xeno.frenzy_aura > 0)
				damage += (attacking_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)
				if(acid_damage)
					acid_damage += (attacking_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

			attacking_xeno.animation_attack_on(src)

			//Somehow we will deal no damage on this attack
			if(!damage)
				playsound(attacking_xeno.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
				attacking_xeno.animation_attack_on(src)
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] lunges at [src]!"),
				SPAN_DANGER("We lunge at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			attacking_xeno.flick_attack_overlay(src, "slash")
			var/obj/limb/affecting
			affecting = get_limb(rand_zone(attacking_xeno.zone_selected, 70))
			if(!affecting) //No organ, just get a random one
				affecting = get_limb(rand_zone(null, 0))
			if(!affecting) //Still nothing??
				affecting = get_limb("chest") //Gotta have a torso?!

			var/armor_block = getarmor(affecting, ARMOR_MELEE)

			if(wear_mask && check_zone(attacking_xeno.zone_selected) == "head")
				if(istype(wear_mask, /obj/item/clothing/mask/gas/yautja))
					var/knock_chance = 1
					if(attacking_xeno.frenzy_aura > 0)
						knock_chance += 2 * attacking_xeno.frenzy_aura
					if(attacking_xeno.caste && attacking_xeno.caste.is_intelligent)
						knock_chance += 2
					knock_chance += min(floor(damage * 0.25), 10) //Maximum of 15% chance.
					if(prob(knock_chance))
						playsound(loc, "alien_claw_metal", 25, 1)
						attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] smashes off [src]'s [wear_mask.name]!"),
						SPAN_DANGER("We smash off [src]'s [wear_mask.name]!"), null, 5)
						drop_inv_item_on_ground(wear_mask)
						if(isyautja(src))
							emote("roar")
						else
							emote("scream")
						return XENO_ATTACK_ACTION

			var/n_damage = armor_damage_reduction(GLOB.marine_melee, damage, armor_block)

			if(attacking_xeno.behavior_delegate)
				n_damage = attacking_xeno.behavior_delegate.melee_attack_modify_damage(n_damage, src)
				attacking_xeno.behavior_delegate.melee_attack_additional_effects_target(src)
				attacking_xeno.behavior_delegate.melee_attack_additional_effects_self()

			var/slash_noise = attacking_xeno.slash_sound
			var/list/slashdata = list("n_damage" = n_damage, "slash_noise" = slash_noise)
			SEND_SIGNAL(src, COMSIG_HUMAN_XENO_ATTACK, slashdata, attacking_xeno)
			var/f_damage = slashdata["n_damage"]
			slash_noise = slashdata["slash_noise"]

			//The normal attack proceeds
			playsound(loc, slash_noise, 25, TRUE)
			attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] [attacking_xeno.slashes_verb] [src]!"),
			SPAN_DANGER("We [attacking_xeno.slash_verb] [src]!"), null, null, CHAT_TYPE_XENO_COMBAT)

			handle_blood_splatter(get_dir(attacking_xeno.loc, src.loc))

			last_damage_data = create_cause_data(initial(attacking_xeno.name), attacking_xeno)

			//Logging, including anti-rulebreak logging
			if(status_flags & XENO_HOST && stat != DEAD)
				if(HAS_TRAIT(src, TRAIT_NESTED)) //Host was buckled to nest while infected, this is a rule break
					attack_log += text("\[[time_stamp()]\] <font color='orange'><B>was [attacking_xeno.slash_verb]ed by [key_name(attacking_xeno)] while they were infected and nested</B></font>")
					attacking_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'><B>[attacking_xeno.slash_verb]ed [key_name(src)] while they were infected and nested</B></font>")
					message_admins("[key_name(attacking_xeno)] [attacking_xeno.slash_verb]ed [key_name(src)] while they were infected and nested.") //This is a blatant rulebreak, so warn the admins
				else //Host might be rogue, needs further investigation
					attack_log += text("\[[time_stamp()]\] <font color='orange'>was [attacking_xeno.slash_verb]ed by [key_name(attacking_xeno)] while they were infected</font>")
					attacking_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>[attacking_xeno.slash_verb]ed [key_name(src)] while they were infected</font>")
			else //Normal xenomorph friendship with benefits
				attack_log += text("\[[time_stamp()]\] <font color='orange'>was [attacking_xeno.slash_verb]ed by [key_name(attacking_xeno)]</font>")
				attacking_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>[attacking_xeno.slash_verb]ed [key_name(src)]</font>")
			log_attack("[key_name(attacking_xeno)] [attacking_xeno.slash_verb]ed [key_name(src)]")

			//nice messages so people know that armor works
			if(f_damage <= 0.34*damage)
				to_chat(src, SPAN_WARNING("Your armor absorbs the blow!"))
			else if(f_damage <= 0.67*damage)
				to_chat(src, SPAN_WARNING("Your armor softens the blow!"))

			apply_damage(f_damage, BRUTE, affecting, sharp = 1, edge = 1) //This should slicey dicey
			if(acid_damage)
				playsound(loc, "acid_strike", 25, 1)
				var/armor_block_acid = getarmor(affecting, ARMOR_BIO)
				var/n_acid_damage = armor_damage_reduction(GLOB.marine_melee, acid_damage, armor_block_acid)
				//nice messages so people know that armor works
				if(n_acid_damage <= 0.34*acid_damage)
					to_chat(src, SPAN_WARNING("Your armor absorbs the acid!"))
				else if(n_acid_damage <= 0.67*acid_damage)
					to_chat(src, SPAN_WARNING("Your armor softens the acid!"))
				apply_damage(n_acid_damage, BURN, affecting) //Burn damage

			SEND_SIGNAL(attacking_xeno, COMSIG_HUMAN_ALIEN_ATTACK, src)

			updatehealth()

		if(INTENT_DISARM)
			if(attacking_xeno.legcuffed && isyautja(src))
				to_chat(attacking_xeno, SPAN_XENODANGER("We don't have the dexterity to tackle the headhunter with that thing on our leg!"))
				return XENO_NO_DELAY_ACTION

			attacking_xeno.animation_attack_on(src)
			if(!unblockable && check_shields(attacking_xeno.name, get_dir(src, attacking_xeno), custom_response = TRUE)) // Blocking check
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno]'s tackle is blocked by [src]'s shield!"),
				SPAN_DANGER("We tackle is blocked by [src]'s shield!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION
			attacking_xeno.flick_attack_overlay(src, "disarm")

			var/tackle_mult = 1
			var/tackle_min_offset = 0
			var/tackle_max_offset = 0
			if(isyautja(src))
				tackle_mult = 0.2
				tackle_min_offset += 2
				tackle_max_offset += 2

			var/knocked_down
			if(attacking_xeno.attempt_tackle(src, tackle_mult, tackle_min_offset, tackle_max_offset))
				var/strength = rand(attacking_xeno.tacklestrength_min, attacking_xeno.tacklestrength_max)
				var/datum/status_effect/incapacitating/stun/stun = Stun(strength, resistable=TRUE)
				var/stun_resisted = strength != stun.last_amount
				playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, stun_resisted ? 1.5 : 0)
				KnockDown(stun.last_amount) // Purely for knockdown visuals. All the heavy lifting is done by Stun
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] tackles down [src]!"),
				SPAN_DANGER("We tackle down [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				SEND_SIGNAL(src, COMSIG_MOB_TACKLED_DOWN, attacking_xeno)
				knocked_down = TRUE
			else
				playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] tries to tackle [src]!"),
				SPAN_DANGER("We try to tackle [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				knocked_down = FALSE

			attacking_xeno.attack_log += "\[[time_stamp()]\] <font color='red'>[knocked_down ? "S" : "Uns"]uccessfully tackled [key_name(src)]</font>"
			attack_log += "\[[time_stamp()]\] <font color='orange'>Has been [knocked_down ? "" : "un"]successfully tackled by [key_name(attacking_xeno)]</font>"
			log_attack("[key_name(attacking_xeno)] [knocked_down ? "" : "un"]successfully tackled [key_name(src)] in [get_area(src)] ([loc.x],[loc.y],[loc.z]).")
	return XENO_ATTACK_ACTION


//Every other type of nonhuman mob
/mob/living/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.fortify || HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		return XENO_NO_DELAY_ACTION

	switch(xeno.a_intent)
		if(INTENT_HELP)
			xeno.visible_message(SPAN_NOTICE("[xeno] caresses [src] with its claws."),
			SPAN_NOTICE("We caress [src] with our claws."), null, 5, CHAT_TYPE_XENO_FLUFF)

		if(INTENT_GRAB)
			if(xeno == src || anchored || buckled)
				return XENO_NO_DELAY_ACTION

			if(Adjacent(xeno)) //Logic!
				xeno.start_pulling(src)

		if(INTENT_HARM)
			if(isxeno(src) && xeno_hivenumber(src) == xeno.hivenumber)
				var/mob/living/carbon/xenomorph/X = src
				if(!X.banished)
					xeno.visible_message(SPAN_WARNING("[xeno] nibbles [src]."),
					SPAN_WARNING("We nibble [src]."), null, 5, CHAT_TYPE_XENO_FLUFF)
					return XENO_ATTACK_ACTION

			// copypasted from attack_alien.dm
			//From this point, we are certain a full attack will go out. Calculate damage and modifiers
			xeno.track_slashes(xeno.caste_type) //Adds to slash stat.
			var/damage = rand(xeno.melee_damage_lower, xeno.melee_damage_upper)

			//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
			if(xeno.frenzy_aura > 0)
				damage += (xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

			xeno.animation_attack_on(src)
			//Somehow we will deal no damage on this attack
			if(!damage)
				playsound(xeno.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)

				xeno.visible_message(SPAN_DANGER("[xeno] lunges at [src]!"),
				SPAN_DANGER("We lunge at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			handle_blood_splatter(get_dir(xeno.loc, loc))
			last_damage_data = create_cause_data(initial(xeno.name), xeno)
			xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
			SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			attack_log += text("\[[time_stamp()]\] <font color='orange'>was [xeno.slash_verb]ed by [key_name(xeno)]</font>")
			xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>[xeno.slash_verb]ed [key_name(src)]</font>")
			log_attack("[key_name(xeno)] [xeno.slash_verb]ed [key_name(src)]")

			if(custom_slashed_sound)
				playsound(loc, custom_slashed_sound, 25, 1)
			else
				playsound(loc, xeno.slash_sound, 25, 1)
			apply_damage(damage, BRUTE)

		if(INTENT_DISARM)

			playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
			xeno.visible_message(SPAN_WARNING("[xeno] shoves [src]!"),
			SPAN_WARNING("We shove [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			if(ismonkey(src))
				apply_effect(8, WEAKEN)
	return XENO_ATTACK_ACTION

/mob/living/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	xeno.visible_message(SPAN_DANGER("[xeno] nudges its head against [src]."),
	SPAN_DANGER("We nudge our head against [src]."), null, 5, CHAT_TYPE_XENO_FLUFF)
	xeno.animation_attack_on(src)

/mob/living/proc/is_xeno_grabbable()
	if(stat == DEAD)
		return FALSE

	return TRUE

/mob/living/carbon/human/is_xeno_grabbable()
	if(stat != DEAD)
		return TRUE

	if(status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/embryo in contents)
			if(embryo.stage <= 1)
				return FALSE
		if(world.time > timeofdeath + revive_grace_period)
			return FALSE // they ain't gonna burst now
		return TRUE
	return FALSE // leave the dead alone

//This proc is here to prevent Xenomorphs from picking up objects (default attack_hand behaviour)
//Note that this is overridden by every proc concerning a child of obj unless inherited
/obj/item/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(HAS_TRAIT(xeno, TRAIT_OPPOSABLE_THUMBS))
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION
	return

/obj/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	return //larva can't do anything

//Breaking tables and racks
/obj/structure/surface/table/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(breakable)
		xeno.animation_attack_on(src)
		if(sheet_type == /obj/item/stack/sheet/wood)
			playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
		else
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		health -= rand(xeno.melee_damage_lower, xeno.melee_damage_upper)
		if(health <= 0)
			xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
			SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			deconstruct(FALSE)
		else
			xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
			SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		return XENO_ATTACK_ACTION

/obj/structure/surface/table/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(!breakable || unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	if(sheet_type == /obj/item/stack/sheet/wood)
		playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	else
		playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	health -= xeno.melee_damage_upper
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		deconstruct(FALSE)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

//Breaking barricades
/obj/structure/barricade/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	take_damage( rand(xeno.melee_damage_lower, xeno.melee_damage_upper) * brute_multiplier)
	if(barricade_hitsound)
		playsound(src, barricade_hitsound, 25, 1)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
		SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	if(is_wired)
		xeno.visible_message(SPAN_DANGER("The barbed wire slices into [xeno]!"),
		SPAN_DANGER("The barbed wire slices into us!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(istype(xeno.strain, /datum/xeno_strain/shielder))
			xeno.apply_damage(5, enviro=TRUE)
		else
			xeno.apply_damage(10, enviro=TRUE)
	return XENO_ATTACK_ACTION

/obj/structure/barricade/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	take_damage((xeno.melee_damage_upper * 1.2) * brute_multiplier)
	if(barricade_hitsound)
		playsound(src, barricade_hitsound, 25, 1)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys \the [src] with its tail!"), SPAN_DANGER("We destroy \the [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes \the [src] with its tail!"), SPAN_DANGER("We strike \the [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	if(is_wired)
		xeno.visible_message(SPAN_DANGER("The barbed wire slices into \the [xeno]'s tail!"), SPAN_DANGER("The barbed wire slices into our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		xeno.apply_damage(5, enviro=TRUE)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/surface/rack/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
	SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	deconstruct(FALSE)
	return XENO_ATTACK_ACTION

/obj/structure/surface/rack/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	deconstruct(FALSE)
	xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
	SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

//Default "structure" proc. This should be overwritten by sub procs.
//If we sent it to monkey we'd get some weird shit happening.
/obj/structure/attack_alien(mob/living/carbon/xenomorph/xeno)
	// fuck off don't destroy my unslashables
	if(unslashable || health <= 0 && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		to_chat(xeno, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

/obj/structure/magazine_box/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION
	else
		. = ..()

//Beds, nests and chairs - unbuckling
/obj/structure/bed/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(src, hit_bed_sound, 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		unbuckle()
		deconstruct(FALSE)
		return XENO_ATTACK_ACTION
	else
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION

/obj/structure/bed/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, hit_bed_sound, 25, 1)
	xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
	SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	unbuckle()
	deconstruct(FALSE)
	return TAILSTAB_COOLDOWN_NORMAL

//Medevac stretchers. Unbuckle ony
/obj/structure/bed/medevac_stretcher/attack_alien(mob/living/carbon/xenomorph/xeno)
	unbuckle()
	return XENO_NONCOMBAT_ACTION

/obj/structure/bed/medevac_stretcher/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	unbuckle()
	xeno.visible_message(SPAN_DANGER("[xeno] smacks [src] with its tail!"),
	SPAN_DANGER("We smack [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_LOW

//Portable surgical bed. Ditto, though it's meltable.
/obj/structure/bed/portable_surgery/attack_alien(mob/living/carbon/xenomorph/xeno)
	unbuckle()
	return XENO_NONCOMBAT_ACTION

/obj/structure/bed/portable_surgery/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	unbuckle()
	xeno.visible_message(SPAN_DANGER("[xeno] smacks [src] with its tail!"),
	SPAN_DANGER("We smack [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_LOW

//Smashing lights
/obj/structure/machinery/light/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(is_broken()) //Ignore if broken. Note that we can't use defines here
		return FALSE
	xeno.animation_attack_on(src)
	xeno.visible_message(SPAN_DANGER("[xeno] smashes [src]!"),
	SPAN_DANGER("We smash [src]!"), null, 5)
	broken() //Smashola!
	return XENO_ATTACK_ACTION

//Smashing windows
/obj/structure/window/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HELP)
		playsound(loc, 'sound/effects/glassknock.ogg', 25, 1)
		xeno.visible_message(SPAN_WARNING("[xeno] creepily taps on [src] with its huge claw."),
		SPAN_WARNING("We creepily tap on [src]."),
		SPAN_WARNING("You hear a glass tapping sound."), 5, CHAT_TYPE_XENO_COMBAT)
	else
		attack_generic(xeno, xeno.melee_damage_lower)
	return XENO_ATTACK_ACTION

/obj/structure/window/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(not_damageable) //Impossible to destroy
		return TAILSTAB_COOLDOWN_NONE
	health -= xeno.melee_damage_upper
	xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] with its tail!"),
	SPAN_DANGER("We smash [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	healthcheck(TRUE, TRUE, TRUE, xeno)
	return TAILSTAB_COOLDOWN_NORMAL

//Slashing bots
/obj/structure/machinery/bot/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	health -= rand(15, 30)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
		SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(loc, "alien_claw_metal", 25, 1)
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(loc)
	healthcheck()
	return XENO_ATTACK_ACTION

//Slashing cameras
/obj/structure/machinery/camera/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(status)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		playsound(loc, "alien_claw_metal", 25, 1)
		wires = 0 //wires all cut
		light_disabled = 0
		toggle_cam_status(xeno, TRUE)
		return XENO_ATTACK_ACTION

/obj/structure/machinery/camera/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	. = TAILSTAB_COOLDOWN_NONE
	if(status)
		. = ..()
		if(. != TAILSTAB_COOLDOWN_NONE)
			wires = 0 //wires all cut
			light_disabled = 0
			toggle_cam_status(xeno, TRUE)

//Slashing windoors
/obj/structure/machinery/door/window/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
	xeno.visible_message(SPAN_DANGER("[xeno] smashes against [src]!"),
	SPAN_DANGER("We smash against [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	var/damage = 25
	if(xeno.mob_size >= MOB_SIZE_BIG)
		damage = 40
	take_damage(damage)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/door/window/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/Glasshit.ogg', 25, 1)
	update_health(40)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] shatters [src] with its tail!"),
		SPAN_DANGER("We shatter [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] with its tail!"),
		SPAN_DANGER("We smash [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

//Slashing grilles
/obj/structure/grille/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	var/damage_dealt = 5
	xeno.visible_message(SPAN_DANGER("[xeno] mangles [src]!"),
	SPAN_DANGER("We mangle [src]!"),
	SPAN_DANGER("You hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)

	if(shock(xeno, 70))
		xeno.visible_message(SPAN_DANGER("ZAP! [xeno] spazzes wildly amongst a smell of burnt ozone."),
		SPAN_DANGER("ZAP! You twitch and dance like a monkey on hyperzine!"),
		SPAN_DANGER("You hear a sharp ZAP and a smell of ozone."))
		return XENO_NO_DELAY_ACTION //Intended apparently ?

	health -= damage_dealt
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/grille/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/grillehit.ogg', 25, 1)

	xeno.visible_message(SPAN_DANGER("[xeno] mangles [src] with its tail!"),
	SPAN_DANGER("We mangle [src] with our tail!"),
	SPAN_DANGER("You hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)

	if(shock(xeno, 70))
		xeno.visible_message(SPAN_DANGER("ZAP! [xeno] spazzes wildly amongst a smell of burnt ozone."),
		SPAN_DANGER("ZAP! You twitch and dance like a monkey on hyperzine!"),
		SPAN_DANGER("You hear a sharp ZAP and a smell of ozone."))

	health -= 5
	healthcheck()
	return TAILSTAB_COOLDOWN_NORMAL

//Slashing fences
/obj/structure/fence/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	var/damage_dealt = 25
	xeno.visible_message(SPAN_DANGER("[xeno] mangles [src]!"),
	SPAN_DANGER("We mangle [src]!"),
	SPAN_DANGER("We hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)

	health -= damage_dealt
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/fence/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	xeno.visible_message(SPAN_DANGER("[xeno] mangles [src] with its tail!"),
	SPAN_DANGER("We mangle [src] with our tail!"),
	SPAN_DANGER("You hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)

	health -= 25
	healthcheck()
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/fence/electrified/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(electrified && !cut)
		electrocute_mob(xeno, get_area(breaker_switch), src, 0.75)
	return ..()

/obj/structure/fence/electrified/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(electrified && !cut)
		electrocute_mob(xeno, get_area(breaker_switch), src, 0.25)
	return ..()

//Slashin mirrors
/obj/structure/mirror/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	if(shattered)
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return XENO_ATTACK_ACTION

	if(xeno.a_intent == INTENT_HELP)
		xeno.visible_message(SPAN_WARNING("[xeno] ogles its own reflection in [src]."),
			SPAN_WARNING("We ogle our own reflection in [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
		return XENO_NONCOMBAT_ACTION
	else
		xeno.visible_message(SPAN_DANGER("[xeno] smashes [src]!"),
			SPAN_DANGER("We smash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		shatter()
	return XENO_ATTACK_ACTION

/obj/structure/mirror/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable)
		return TAILSTAB_COOLDOWN_NONE
	if(shattered)
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return TAILSTAB_COOLDOWN_LOW
	shatter()
	xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] with its tail!"),
	SPAN_DANGER("We smash [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

//airlock assemblies
/obj/structure/airlock_assembly/attack_alien(mob/living/carbon/xenomorph/xeno)
	. = XENO_ATTACK_ACTION

	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
		return

	xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
	SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)

/obj/structure/airlock_assembly/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(xeno.melee_damage_upper)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

//Prying open doors
/obj/structure/machinery/door/airlock/attack_alien(mob/living/carbon/xenomorph/xeno)
	var/turf/cur_loc = xeno.loc
	if(isElectrified())
		if(shock(xeno, 100))
			return XENO_NO_DELAY_ACTION

	if(!density)
		to_chat(xeno, SPAN_WARNING("[src] is already open!"))
		return XENO_NO_DELAY_ACTION

	if(heavy)
		to_chat(xeno, SPAN_WARNING("[src] is too heavy to open."))
		return XENO_NO_DELAY_ACTION

	if(welded)
		if(xeno.claw_type >= CLAW_TYPE_SHARP)
			xeno.animation_attack_on(src)
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
			take_damage(damage_cap / XENO_HITS_TO_DESTROY_WELDED_DOOR)
			return XENO_ATTACK_ACTION
		else
			to_chat(xeno, SPAN_WARNING("[src] is welded shut."))
			return XENO_NO_DELAY_ACTION

	if(locked)
		if(xeno.claw_type >= CLAW_TYPE_SHARP)
			xeno.animation_attack_on(src)
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
			take_damage(HEALTH_DOOR / XENO_HITS_TO_DESTROY_BOLTED_DOOR)
			return XENO_ATTACK_ACTION
		else
			to_chat(xeno, SPAN_WARNING("[src] is bolted down tight."))
			return XENO_NO_DELAY_ACTION

	if(!istype(cur_loc))
		return XENO_NO_DELAY_ACTION //Some basic logic here

	if(xeno.action_busy)
		return XENO_NO_DELAY_ACTION

	if(xeno.is_mob_incapacitated() || xeno.body_position != STANDING_UP)
		return XENO_NO_DELAY_ACTION

	var/delay = 4 SECONDS

	if(!arePowerSystemsOn())
		delay = 1 SECONDS
		playsound(loc, "alien_doorpry", 25, TRUE)
	else
		switch(xeno.mob_size)
			if(MOB_SIZE_XENO_SMALL, MOB_SIZE_XENO_VERY_SMALL)
				delay = 4 SECONDS
			if(MOB_SIZE_BIG)
				delay = 1 SECONDS
			if(MOB_SIZE_XENO)
				delay = 3 SECONDS
		playsound(loc, "alien_doorpry", 25, TRUE)

	xeno.visible_message(SPAN_WARNING("[xeno] digs into [src] and begins to pry it open."),
	SPAN_WARNING("We dig into [src] and begin to pry it open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno_attack_delay(xeno)

	if(do_after(xeno, delay, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(xeno.loc != cur_loc)
			return XENO_NO_DELAY_ACTION //Make sure we're still there
		if(xeno.is_mob_incapacitated() || xeno.body_position != STANDING_UP)
			return XENO_NO_DELAY_ACTION
		if(locked)
			to_chat(xeno, SPAN_WARNING("[src] is bolted down tight."))
			return XENO_NO_DELAY_ACTION
		if(welded)
			to_chat(xeno, SPAN_WARNING("[src] is welded shut."))
			return XENO_NO_DELAY_ACTION
		if(density) //Make sure it's still closed
			spawn(0)
				open(1)
				xeno.visible_message(SPAN_DANGER("[xeno] pries [src] open."),
				SPAN_DANGER("We pry [src] open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_NO_DELAY_ACTION

/obj/structure/machinery/door/airlock/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	xeno.scuttle(src)

//Prying open FIREdoors
/obj/structure/machinery/door/firedoor/attack_alien(mob/living/carbon/xenomorph/xeno)
	var/turf/cur_loc = xeno.loc
	if(blocked)
		to_chat(xeno, SPAN_WARNING("[src] is welded shut."))
		return XENO_NO_DELAY_ACTION
	if(!istype(cur_loc))
		return XENO_NO_DELAY_ACTION //Some basic logic here
	if(!density)
		to_chat(xeno, SPAN_WARNING("[src] is already open!"))
		return XENO_NO_DELAY_ACTION

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, 1)
	xeno.visible_message(SPAN_WARNING("[xeno] digs into [src] and begins to pry it open."),
	SPAN_WARNING("We dig into [src] and begin to pry it open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno_attack_delay(xeno)

	if(do_after(xeno, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(xeno.loc != cur_loc)
			return XENO_NO_DELAY_ACTION //Make sure we're still there
		if(blocked)
			to_chat(xeno, SPAN_WARNING("[src] is welded shut."))
			return XENO_NO_DELAY_ACTION
		if(density) //Make sure it's still closed
			spawn(0)
				open(1)
				xeno.visible_message(SPAN_DANGER("[xeno] pries [src] open."),
				SPAN_DANGER("We pry [src] open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_NO_DELAY_ACTION

/obj/structure/machinery/door/firedoor/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	return TAILSTAB_COOLDOWN_NONE

/obj/structure/mineral_door/resin/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	var/turf/cur_loc = xeno.loc
	if(!istype(cur_loc))
		return FALSE
	TryToSwitchState(xeno)
	return TRUE

//clicking on resin doors attacks them, or opens them without harm intent
/obj/structure/mineral_door/resin/attack_alien(mob/living/carbon/xenomorph/xeno)
	var/turf/cur_loc = xeno.loc
	if(!istype(cur_loc))
		return XENO_NO_DELAY_ACTION //Some basic logic here
	if(xeno.a_intent != INTENT_HARM)
		TryToSwitchState(xeno)
		return XENO_NONCOMBAT_ACTION
	else
		if(islarva(xeno))
			return
		else
			xeno.visible_message(SPAN_XENONOTICE("[xeno] claws [src]!"),
			SPAN_XENONOTICE("We claw [src]."), null, null, CHAT_TYPE_XENO_COMBAT)
			playsound(loc, "alien_resin_break", 25)

		xeno.animation_attack_on(src)
		if(hivenumber == xeno.hivenumber)
			qdel(src)
		else
			health -= xeno.melee_damage_lower * RESIN_XENO_DAMAGE_MULTIPLIER
			healthcheck()
	return XENO_ATTACK_ACTION


//Xenomorphs can't use machinery, not even the "intelligent" ones
//Exception is Queen and shuttles, because plot power
/obj/structure/machinery/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0 && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		to_chat(xeno, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [xeno.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(xeno.melee_damage_upper)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

// Destroying reagent dispensers
/obj/structure/reagent_dispensers/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0 && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		to_chat(xeno, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [xeno.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/reagent_dispensers/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(xeno.melee_damage_upper)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

// Destroying filing cabinets
/obj/structure/filingcabinet/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		to_chat(xeno, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [xeno.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/filingcabinet/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(xeno.melee_damage_upper)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

// Destroying morgues & crematoriums
/obj/structure/morgue/attack_alien(mob/living/carbon/xenomorph/alien)
	if(unslashable)
		to_chat(alien, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	var destroyloc = loc
	alien.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(alien.melee_damage_lower, alien.melee_damage_upper))
	if(health <= 0)
		alien.visible_message(SPAN_DANGER("[alien] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		new /obj/item/stack/sheet/metal(destroyloc, 2)
	else
		alien.visible_message(SPAN_DANGER("[alien] [alien.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [alien.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/morgue/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || health <= 0)
		return TAILSTAB_COOLDOWN_NONE
	var destroyloc = loc
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(xeno.melee_damage_upper)
	if(health <= 0)
		xeno.visible_message(SPAN_DANGER("[xeno] destroys [src] with its tail!"),
		SPAN_DANGER("We destroy [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		new /obj/item/stack/sheet/metal(destroyloc, 2)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] strikes [src] with its tail!"),
		SPAN_DANGER("We strike [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

// Destroying hydroponics trays
/obj/structure/machinery/portable_atmospherics/hydroponics/attack_alien(mob/living/carbon/xenomorph/alien)
	if(unslashable)
		to_chat(alien, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	alien.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(alien.melee_damage_lower, alien.melee_damage_upper))
	if(health <= 0)
		alien.visible_message(SPAN_DANGER("[alien] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		alien.visible_message(SPAN_DANGER("[alien] [alien.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [alien.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/datum/shuttle/ferry/marine/proc/hijack(mob/living/carbon/xenomorph/xeno, shuttle_tag)
	if(!queen_locked) //we have not hijacked it yet
		if(world.time < SHUTTLE_LOCK_TIME_LOCK)
			to_chat(xeno, SPAN_XENODANGER("We can't mobilize the strength to hijack the shuttle yet. Please wait another [time_left_until(SHUTTLE_LOCK_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
			return

		var/message
		if(shuttle_tag == "Ground Transport 1") // CORSAT monorail
			message = "We have wrested away remote control of the metal crawler! Rejoice!"
		else
			message = "We have wrested away remote control of the metal bird! Rejoice!"
			if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding))
				MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)

		to_chat(xeno, SPAN_XENONOTICE("We interact with the machine and disable remote control."))
		xeno_message(SPAN_XENOANNOUNCE("[message]"),3,xeno.hivenumber)
		last_locked = world.time
		if(GLOB.almayer_orbital_cannon)
			GLOB.almayer_orbital_cannon.is_disabled = TRUE
			addtimer(CALLBACK(GLOB.almayer_orbital_cannon, TYPE_PROC_REF(/obj/structure/orbital_cannon, enable)), 10 MINUTES, TIMER_UNIQUE)
		queen_locked = 1

/datum/shuttle/ferry/marine/proc/door_override(mob/living/carbon/xenomorph/xeno, shuttle_tag)
	if(!door_override)
		to_chat(xeno, SPAN_XENONOTICE("We override the doors."))
		xeno_message(SPAN_XENOANNOUNCE("The doors of the metal bird have been overridden! Rejoice!"),3,xeno.hivenumber)
		last_door_override = world.time
		door_override = 1

		var/ship_id = "sh_dropship1"
		if(shuttle_tag == DROPSHIP_NORMANDY)
			ship_id = "sh_dropship2"
		if(shuttle_tag == DROPSHIP_SAIPAN)
			ship_id = "sh_dropship3"
		if(shuttle_tag == DROPSHIP_MORANA)
			ship_id = "sh_dropship4"
		if(shuttle_tag == DROPSHIP_DEVANA)
			ship_id = "sh_dropship5"


		for(var/obj/structure/machinery/door/airlock/dropship_hatch/ship in GLOB.machines)
			if(ship.id == ship_id)
				ship.unlock()

		var/obj/structure/machinery/door/airlock/multi_tile/almayer/reardoor
		switch(ship_id)
			if("sh_dropship1")
				for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1/ship in GLOB.machines)
					reardoor = ship
			if("sh_dropship2")
				for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2/ship in GLOB.machines)
					reardoor = ship
		if(!reardoor)
			CRASH("Shuttle crashed trying to override invalid rear door with shuttle id [ship_id]")
		reardoor.unlock()

//APCs.
/obj/structure/machinery/power/apc/attack_alien(mob/living/carbon/xenomorph/xeno)

	if(stat & BROKEN)
		to_chat(xeno, SPAN_XENONOTICE("[src] is already broken!"))
		return XENO_NO_DELAY_ACTION
	else if(beenhit >= XENO_HITS_TO_CUT_WIRES && xeno.mob_size < MOB_SIZE_BIG)
		to_chat(xeno, SPAN_XENONOTICE("We aren't big enough to further damage [src]."))
		return XENO_NO_DELAY_ACTION
	xeno.animation_attack_on(src)
	xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
	SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5)
	playsound(loc, "alien_claw_metal", 25, 1)
	if(beenhit >= XENO_HITS_TO_CUT_WIRES)
		set_broken()
		visible_message(SPAN_DANGER("[src]'s electronics are destroyed!"), null, null, 5)
	else if(wiresexposed)
		for(var/wire = 1; wire <= length(GLOB.apc_wire_descriptions); wire++) // Cut all the wires because xenos don't know any better
			if(!isWireCut(wire)) // Xenos don't need to mend the wires either
				cut(wire, xeno, FALSE) // This is XOR so it toggles; FALSE just because we don't want the messages
		update_icon()
		beenhit = XENO_HITS_TO_CUT_WIRES
		visible_message(SPAN_DANGER("[src]'s wires snap apart in a rain of sparks!"), null, null, 5)
	else if(beenhit >= pick(XENO_HITS_TO_EXPOSE_WIRES_MIN, XENO_HITS_TO_EXPOSE_WIRES_MAX))
		wiresexposed = TRUE
		update_icon()
		visible_message(SPAN_DANGER("[src]'s cover swings open, exposing the wires!"), null, null, 5)
	else
		beenhit++
	return XENO_ATTACK_ACTION

/obj/structure/machinery/power/apc/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	return TAILSTAB_COOLDOWN_NONE

/obj/structure/ladder/attack_alien(mob/living/carbon/xenomorph/xeno)
	attack_hand(xeno)
	return XENO_NO_DELAY_ACTION

/obj/structure/ladder/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	return attack_hand(xeno)

/obj/structure/machinery/colony_floodlight/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!is_on)
		to_chat(xeno, SPAN_WARNING("Why bother? It's just some weird metal thing."))
		return XENO_NO_DELAY_ACTION
	if(damaged)
		to_chat(xeno, SPAN_WARNING("It's already damaged."))
		return XENO_NO_DELAY_ACTION
	xeno.animation_attack_on(src)
	xeno.visible_message("[xeno] slashes away at [src]!","We slash and claw at the bright light!", max_distance = 5, message_flags = CHAT_TYPE_XENO_COMBAT)
	health = max(health - rand(xeno.melee_damage_lower, xeno.melee_damage_upper), 0)
	if(!health)
		set_damaged()
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/colony_floodlight/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(!is_on || damaged)
		return TAILSTAB_COOLDOWN_NONE
	xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] with its tail!"),
	SPAN_DANGER("We smash at the bright light with our tail!"), max_distance = 5, message_flags = CHAT_TYPE_XENO_COMBAT)
	health = max(health - xeno.melee_damage_upper, 0)
	if(!health)
		set_damaged()
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/machinery/colony_floodlight/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	xeno.visible_message("[xeno] starts biting [src]!","In a rage, we start biting [src], but with no effect!", null, 5, CHAT_TYPE_XENO_COMBAT)

//Digging up snow
/turf/open/snow/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM) //Missed slash.
		return
	if(xeno.a_intent == INTENT_HELP || !bleed_layer)
		return ..()

	xeno.visible_message(SPAN_NOTICE("[xeno] starts clearing out \the [src]..."), SPAN_NOTICE("We start \the clearing out [src]..."), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(xeno.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)

	while(bleed_layer > 0)
		xeno_attack_delay(xeno)
		var/size = max(xeno.mob_size, 1)
		if(!do_after(xeno, 12/size, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			return XENO_NO_DELAY_ACTION

		if(!bleed_layer)
			to_chat(xeno, SPAN_WARNING("There is nothing to clear out!"))
			return XENO_NO_DELAY_ACTION

		bleed_layer--
		update_icon(1, 0)

	return XENO_NO_DELAY_ACTION

/turf/open/snow/attack_larva(mob/living/carbon/xenomorph/larva/xeno)
	return //Larvae can't do shit


//Crates, closets, other paraphernalia
/obj/structure/closet/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!unacidable)
		xeno.animation_attack_on(src)
		if(!opened)
			var/difficulty = 70 //if its just closed we can smash open quite easily
			if(welded)
				difficulty = 30 // if its welded shut it should be harder to smash open
			if(prob(difficulty))
				break_open(xeno)
				xeno.visible_message(SPAN_DANGER("[xeno] smashes \the [src] open!"),
				SPAN_DANGER("We smash \the [src] open!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		else
			xeno.visible_message(SPAN_DANGER("[xeno] smashes [src]!"),
			SPAN_DANGER("We smash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		return XENO_ATTACK_ACTION

/obj/structure/closet/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable || unacidable)
		return TAILSTAB_COOLDOWN_NONE
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	if(!opened)
		var/difficulty = 70 //if its just closed we can smash open quite easily
		if(welded)
			difficulty = 30 // if its welded shut it should be harder to smash open
		if(prob(difficulty))
			break_open(xeno)
			xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] open with its tail!"),
			SPAN_DANGER("We smash [src] open with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] with its tail!"),
		SPAN_DANGER("We smash [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/machinery/vending/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(is_tipped_over)
		to_chat(xeno, SPAN_WARNING("There's no reason to bother with that old piece of trash."))
		return XENO_NO_DELAY_ACTION

	if(xeno.a_intent == INTENT_HARM)
		xeno.animation_attack_on(src)
		if(prob(xeno.melee_damage_lower))
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
			xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] beyond recognition!"),
			SPAN_DANGER("We enter a frenzy and smash [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			malfunction()
			tip_over()
		else
			xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
			SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		return XENO_ATTACK_ACTION

	if(xeno.action_busy)
		return XENO_NO_DELAY_ACTION
	xeno.visible_message(SPAN_WARNING("[xeno] begins to lean against [src]."),
	SPAN_WARNING("We begin to lean against [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	var/shove_time = 100
	if(xeno.mob_size >= MOB_SIZE_BIG)
		shove_time = 50
	if(istype(xeno,/mob/living/carbon/xenomorph/crusher))
		shove_time = 15

	xeno_attack_delay(xeno)

	if(do_after(xeno, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		xeno.animation_attack_on(src)
		xeno.visible_message(SPAN_DANGER("[xeno] knocks [src] down!"),
		SPAN_DANGER("We knock [src] down!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		tip_over()
	return XENO_NO_DELAY_ACTION

/obj/structure/machinery/vending/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(is_tipped_over || unslashable)
		return TAILSTAB_COOLDOWN_NONE
	if(prob(xeno.melee_damage_upper))
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno] smashes [src] with its tail beyond recognition!"),
		SPAN_DANGER("You enter a frenzy and smash [src] with your tail apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		malfunction()
		tip_over()
	else
		xeno.visible_message(SPAN_DANGER("[xeno] slashes [src] with its tail!"),
		SPAN_DANGER("You slash [src] with your tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/inflatable/attack_alien(mob/living/carbon/xenomorph/xeno)
	xeno.animation_attack_on(src)
	deflate(1)
	return XENO_ATTACK_ACTION

/obj/structure/inflatable/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(unslashable)
		return TAILSTAB_COOLDOWN_NONE
	xeno.visible_message(SPAN_DANGER("[xeno] punctures [src] with its tail!"),
	SPAN_DANGER("We puncture [src] with our tail!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	deflate(TRUE)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/machinery/vending/proc/tip_over()
	var/matrix/rotate = matrix()
	is_tipped_over = TRUE
	density = FALSE
	rotate.Turn(90)
	apply_transform(rotate)
	malfunction()

/obj/structure/machinery/vending/proc/flip_back()
	icon_state = initial(icon_state)
	is_tipped_over = FALSE
	density = TRUE
	var/matrix/rotate = matrix()
	apply_transform(rotate)
	stat &= ~BROKEN //Remove broken. MAGICAL REPAIRS

//Misc
/obj/structure/prop/invuln/joey/attack_alien(mob/living/carbon/xenomorph/alien)
	alien.animation_attack_on(src)
	alien.visible_message(SPAN_DANGER("[alien] [alien.slashes_verb] [src]!"),
	SPAN_DANGER("We [alien.slash_verb] [src]!"), null, 5)
	playsound(loc, "alien_claw_metal", 25, 1)
	attacked()
	return XENO_ATTACK_ACTION
