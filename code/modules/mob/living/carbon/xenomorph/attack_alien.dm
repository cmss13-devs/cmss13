//This file deals with xenos clicking on stuff in general. Including mobs, objects, general atoms, etc.
//Abby

/*
 * Important note about attack_alien : In our code, attack_ procs are received by src, not dealt by src
 * For example, attack_alien defined for humans means what will happen to THEM when attacked by an alien
 * In that case, the first argument is always the attacker. For attack_alien, it should always be Xenomorph sub-types
 */

// this proc could use refactoring at some point
/mob/living/carbon/human/attack_alien(mob/living/carbon/xenomorph/attacking_xeno, dam_bonus)
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

			if(check_shields(0, attacking_xeno.name)) // Blocking check
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno]'s grab is blocked by [src]'s shield!"),
				SPAN_DANGER("Our grab was blocked by [src]'s shield!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			if(Adjacent(attacking_xeno)) //Logic!
				attacking_xeno.start_pulling(src)

		if(INTENT_HARM)
			if(attacking_xeno.can_not_harm(src))
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
				if(HAS_TRAIT(src, TRAIT_NESTED) && (status_flags & XENO_HOST))
					for(var/obj/item/alien_embryo/embryo in src)
						if(HIVE_ALLIED_TO_HIVE(attacking_xeno.hivenumber, embryo.hivenumber))
							to_chat(attacking_xeno, SPAN_WARNING("We should not harm this host! It has a sister inside."))
							return XENO_NO_DELAY_ACTION

			if(check_shields(0, attacking_xeno.name)) // Blocking check
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
			if(check_shields(0, attacking_xeno.name)) // Blocking check
				attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno]'s tackle is blocked by [src]'s shield!"),
				SPAN_DANGER("We tackle is blocked by [src]'s shield!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION
			attacking_xeno.flick_attack_overlay(src, "disarm")

			var/tackle_mult = 1
			var/tackle_min_offset = 0
			var/tackle_max_offset = 0
			if (isyautja(src))
				tackle_mult = 0.2
				tackle_min_offset += 2
				tackle_max_offset += 2

			var/knocked_down
			if(attacking_xeno.attempt_tackle(src, tackle_mult, tackle_min_offset, tackle_max_offset))
				playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
				var/strength = rand(attacking_xeno.tacklestrength_min, attacking_xeno.tacklestrength_max)
				Stun(strength)
				KnockDown(strength) // Purely for knockdown visuals. All the heavy lifting is done by Stun
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
/mob/living/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.fortify || HAS_TRAIT(M, TRAIT_ABILITY_BURROWED))
		return XENO_NO_DELAY_ACTION

	switch(M.a_intent)
		if(INTENT_HELP)
			M.visible_message(SPAN_NOTICE("[M] caresses [src] with its claws."),
			SPAN_NOTICE("We caress [src] with our claws."), null, 5, CHAT_TYPE_XENO_FLUFF)

		if(INTENT_GRAB)
			if(M == src || anchored || buckled)
				return XENO_NO_DELAY_ACTION

			if(Adjacent(M)) //Logic!
				M.start_pulling(src)

		if(INTENT_HARM)
			if(isxeno(src) && xeno_hivenumber(src) == M.hivenumber)
				var/mob/living/carbon/xenomorph/X = src
				if(!X.banished)
					M.visible_message(SPAN_WARNING("[M] nibbles [src]."),
					SPAN_WARNING("We nibble [src]."), null, 5, CHAT_TYPE_XENO_FLUFF)
					return XENO_ATTACK_ACTION

			// copypasted from attack_alien.dm
			//From this point, we are certain a full attack will go out. Calculate damage and modifiers
			M.track_slashes(M.caste_type) //Adds to slash stat.
			var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)

			//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
			if(M.frenzy_aura > 0)
				damage += (M.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

			M.animation_attack_on(src)
			//Somehow we will deal no damage on this attack
			if(!damage)
				playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)

				M.visible_message(SPAN_DANGER("[M] lunges at [src]!"),
				SPAN_DANGER("We lunge at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				return XENO_ATTACK_ACTION

			handle_blood_splatter(get_dir(M.loc, loc))
			last_damage_data = create_cause_data(initial(M.name), M)
			M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
			SPAN_DANGER("We [M.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			attack_log += text("\[[time_stamp()]\] <font color='orange'>was [M.slash_verb]ed by [key_name(M)]</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>[M.slash_verb]ed [key_name(src)]</font>")
			log_attack("[key_name(M)] [M.slash_verb]ed [key_name(src)]")

			if(custom_slashed_sound)
				playsound(loc, custom_slashed_sound, 25, 1)
			else
				playsound(loc, M.slash_sound, 25, 1)
			apply_damage(damage, BRUTE)

		if(INTENT_DISARM)

			playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
			M.visible_message(SPAN_WARNING("[M] shoves [src]!"),
			SPAN_WARNING("We shove [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			if(ismonkey(src))
				apply_effect(8, WEAKEN)
	return XENO_ATTACK_ACTION

/mob/living/attack_larva(mob/living/carbon/xenomorph/larva/M)
	M.visible_message(SPAN_DANGER("[M] nudges its head against [src]."),
	SPAN_DANGER("We nudge our head against [src]."), null, 5, CHAT_TYPE_XENO_FLUFF)
	M.animation_attack_on(src)

/mob/living/proc/is_xeno_grabbable()
	if(stat == DEAD)
		return FALSE

	return TRUE

/mob/living/carbon/human/is_xeno_grabbable()
	if(stat != DEAD)
		return TRUE

	if(status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/AE in contents)
			if(AE.stage <= 1)
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

/obj/attack_larva(mob/living/carbon/xenomorph/larva/M)
	return //larva can't do anything

//Breaking tables and racks
/obj/structure/surface/table/attack_alien(mob/living/carbon/xenomorph/M)
	if(breakable)
		M.animation_attack_on(src)
		if(sheet_type == /obj/item/stack/sheet/wood)
			playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
		else
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		health -= rand(M.melee_damage_lower, M.melee_damage_upper)
		if(health <= 0)
			M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
			SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			deconstruct(FALSE)
		else
			M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
			SPAN_DANGER("We [M.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		return XENO_ATTACK_ACTION

//Breaking barricades
/obj/structure/barricade/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	take_damage( rand(M.melee_damage_lower, M.melee_damage_upper) * brute_multiplier)
	if(barricade_hitsound)
		playsound(src, barricade_hitsound, 25, 1)
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
		SPAN_DANGER("We [M.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	if(is_wired)
		M.visible_message(SPAN_DANGER("The barbed wire slices into [M]!"),
		SPAN_DANGER("The barbed wire slices into us!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		M.apply_damage(10)
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
		xeno.apply_damage(5)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/surface/rack/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
	SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	deconstruct(FALSE)
	return XENO_ATTACK_ACTION

//Default "structure" proc. This should be overwritten by sub procs.
//If we sent it to monkey we'd get some weird shit happening.
/obj/structure/attack_alien(mob/living/carbon/xenomorph/M)
	// fuck off dont destroy my unslashables
	if(unslashable || health <= 0 && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		to_chat(M, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

/obj/structure/magazine_box/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION
	else
		. = ..()

//Beds, nests and chairs - unbuckling
/obj/structure/bed/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.a_intent == INTENT_HARM)
		if(unslashable)
			return
		M.animation_attack_on(src)
		playsound(src, hit_bed_sound, 25, 1)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		unbuckle()
		deconstruct(FALSE)
		return XENO_ATTACK_ACTION
	else
		attack_hand(M)
		return XENO_NONCOMBAT_ACTION


//Medevac stretchers. Unbuckle ony
/obj/structure/bed/medevac_stretcher/attack_alien(mob/living/carbon/xenomorph/M)
	unbuckle()
	return XENO_NONCOMBAT_ACTION

//Portable surgical bed. Ditto, though it's meltable.
/obj/structure/bed/portable_surgery/attack_alien(mob/living/carbon/xenomorph/M)
	unbuckle()
	return XENO_NONCOMBAT_ACTION

//Smashing lights
/obj/structure/machinery/light/attack_alien(mob/living/carbon/xenomorph/M)
	if(is_broken()) //Ignore if broken. Note that we can't use defines here
		return FALSE
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M] smashes [src]!"),
	SPAN_DANGER("We smash [src]!"), null, 5)
	broken() //Smashola!
	return XENO_ATTACK_ACTION

//Smashing windows
/obj/structure/window/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.a_intent == INTENT_HELP)
		playsound(loc, 'sound/effects/glassknock.ogg', 25, 1)
		M.visible_message(SPAN_WARNING("[M] creepily taps on [src] with its huge claw."),
		SPAN_WARNING("We creepily tap on [src]."),
		SPAN_WARNING("You hear a glass tapping sound."), 5, CHAT_TYPE_XENO_COMBAT)
	else
		attack_generic(M, M.melee_damage_lower)
	return XENO_ATTACK_ACTION

//Slashing bots
/obj/structure/machinery/bot/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	health -= rand(15, 30)
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
		SPAN_DANGER("We [M.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(loc, "alien_claw_metal", 25, 1)
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(loc)
	healthcheck()
	return XENO_ATTACK_ACTION

//Slashing cameras
/obj/structure/machinery/camera/attack_alien(mob/living/carbon/xenomorph/M)
	if(status)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		playsound(loc, "alien_claw_metal", 25, 1)
		wires = 0 //wires all cut
		light_disabled = 0
		toggle_cam_status(M, TRUE)
		return XENO_ATTACK_ACTION

//Slashing windoors
/obj/structure/machinery/door/window/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
	M.visible_message(SPAN_DANGER("[M] smashes against [src]!"),
	SPAN_DANGER("We smash against [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	var/damage = 25
	if(M.mob_size >= MOB_SIZE_BIG)
		damage = 40
	take_damage(damage)
	return XENO_ATTACK_ACTION

//Slashing grilles
/obj/structure/grille/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	var/damage_dealt = 5
	M.visible_message(SPAN_DANGER("[M] mangles [src]!"),
	SPAN_DANGER("We mangle [src]!"),
	SPAN_DANGER("We hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)

	if(shock(M, 70))
		M.visible_message(SPAN_DANGER("ZAP! [M] spazzes wildly amongst a smell of burnt ozone."),
		SPAN_DANGER("ZAP! You twitch and dance like a monkey on hyperzine!"),
		SPAN_DANGER("You hear a sharp ZAP and a smell of ozone."))
		return XENO_NO_DELAY_ACTION //Intended apparently ?

	health -= damage_dealt
	healthcheck()
	return XENO_ATTACK_ACTION

//Slashing fences
/obj/structure/fence/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	var/damage_dealt = 25
	M.visible_message(SPAN_DANGER("[M] mangles [src]!"),
	SPAN_DANGER("We mangle [src]!"),
	SPAN_DANGER("We hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)

	health -= damage_dealt
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/fence/electrified/attack_alien(mob/living/carbon/xenomorph/M)
	if(electrified && !cut)
		electrocute_mob(M, get_area(breaker_switch), src, 0.75)
	return ..()


//Slashin mirrors
/obj/structure/mirror/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	if(shattered)
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return XENO_ATTACK_ACTION

	if(M.a_intent == INTENT_HELP)
		M.visible_message(SPAN_WARNING("[M] ogles its own reflection in [src]."),
			SPAN_WARNING("We ogle our own reflection in [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
		return XENO_NONCOMBAT_ACTION
	else
		M.visible_message(SPAN_DANGER("[M] smashes [src]!"),
			SPAN_DANGER("We smash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		shatter()
	return XENO_ATTACK_ACTION


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


//Prying open doors
/obj/structure/machinery/door/airlock/attack_alien(mob/living/carbon/xenomorph/M)
	var/turf/cur_loc = M.loc
	if(isElectrified())
		if(shock(M, 100))
			return XENO_NO_DELAY_ACTION

	if(!density)
		to_chat(M, SPAN_WARNING("[src] is already open!"))
		return XENO_NO_DELAY_ACTION

	if(heavy)
		to_chat(M, SPAN_WARNING("[src] is too heavy to open."))
		return XENO_NO_DELAY_ACTION

	if(welded)
		if(M.claw_type >= CLAW_TYPE_SHARP)
			M.animation_attack_on(src)
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
			take_damage(damage_cap / XENO_HITS_TO_DESTROY_WELDED_DOOR)
			return XENO_ATTACK_ACTION
		else
			to_chat(M, SPAN_WARNING("[src] is welded shut."))
			return XENO_NO_DELAY_ACTION

	if(locked)
		if(M.claw_type >= CLAW_TYPE_SHARP)
			M.animation_attack_on(src)
			playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
			take_damage(HEALTH_DOOR / XENO_HITS_TO_DESTROY_BOLTED_DOOR)
			return XENO_ATTACK_ACTION
		else
			to_chat(M, SPAN_WARNING("[src] is bolted down tight."))
			return XENO_NO_DELAY_ACTION

	if(!istype(cur_loc))
		return XENO_NO_DELAY_ACTION //Some basic logic here

	if(M.action_busy)
		return XENO_NO_DELAY_ACTION

	if(M.is_mob_incapacitated() || M.body_position != STANDING_UP)
		return XENO_NO_DELAY_ACTION

	var/delay = 4 SECONDS

	if(!arePowerSystemsOn())
		delay = 1 SECONDS
		playsound(loc, "alien_doorpry", 25, TRUE)
	else
		switch(M.mob_size)
			if(MOB_SIZE_XENO_SMALL, MOB_SIZE_XENO_VERY_SMALL)
				delay = 4 SECONDS
			if(MOB_SIZE_BIG)
				delay = 1 SECONDS
			if(MOB_SIZE_XENO)
				delay = 3 SECONDS
		playsound(loc, "alien_doorpry", 25, TRUE)

	M.visible_message(SPAN_WARNING("[M] digs into [src] and begins to pry it open."),
	SPAN_WARNING("We dig into [src] and begin to pry it open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno_attack_delay(M)

	if(do_after(M, delay, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(M.loc != cur_loc)
			return XENO_NO_DELAY_ACTION //Make sure we're still there
		if(M.is_mob_incapacitated() || M.body_position != STANDING_UP)
			return XENO_NO_DELAY_ACTION
		if(locked)
			to_chat(M, SPAN_WARNING("[src] is bolted down tight."))
			return XENO_NO_DELAY_ACTION
		if(welded)
			to_chat(M, SPAN_WARNING("[src] is welded shut."))
			return XENO_NO_DELAY_ACTION
		if(density) //Make sure it's still closed
			spawn(0)
				open(1)
				M.visible_message(SPAN_DANGER("[M] pries [src] open."),
				SPAN_DANGER("We pry [src] open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_NO_DELAY_ACTION

/obj/structure/machinery/door/airlock/attack_larva(mob/living/carbon/xenomorph/larva/M)
	M.scuttle(src)

//Prying open FIREdoors
/obj/structure/machinery/door/firedoor/attack_alien(mob/living/carbon/xenomorph/M)
	var/turf/cur_loc = M.loc
	if(blocked)
		to_chat(M, SPAN_WARNING("[src] is welded shut."))
		return XENO_NO_DELAY_ACTION
	if(!istype(cur_loc))
		return XENO_NO_DELAY_ACTION //Some basic logic here
	if(!density)
		to_chat(M, SPAN_WARNING("[src] is already open!"))
		return XENO_NO_DELAY_ACTION

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, 1)
	M.visible_message(SPAN_WARNING("[M] digs into [src] and begins to pry it open."),
	SPAN_WARNING("We dig into [src] and begin to pry it open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno_attack_delay(M)

	if(do_after(M, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(M.loc != cur_loc)
			return XENO_NO_DELAY_ACTION //Make sure we're still there
		if(blocked)
			to_chat(M, SPAN_WARNING("[src] is welded shut."))
			return XENO_NO_DELAY_ACTION
		if(density) //Make sure it's still closed
			spawn(0)
				open(1)
				M.visible_message(SPAN_DANGER("[M] pries [src] open."),
				SPAN_DANGER("We pry [src] open."), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_NO_DELAY_ACTION

/obj/structure/mineral_door/resin/attack_larva(mob/living/carbon/xenomorph/larva/M)
	var/turf/cur_loc = M.loc
	if(!istype(cur_loc))
		return FALSE
	TryToSwitchState(M)
	return TRUE

//clicking on resin doors attacks them, or opens them without harm intent
/obj/structure/mineral_door/resin/attack_alien(mob/living/carbon/xenomorph/M)
	var/turf/cur_loc = M.loc
	if(!istype(cur_loc))
		return XENO_NO_DELAY_ACTION //Some basic logic here
	if(M.a_intent != INTENT_HARM)
		TryToSwitchState(M)
		return XENO_NONCOMBAT_ACTION
	else
		if(islarva(M))
			return
		else
			M.visible_message(SPAN_XENONOTICE("[M] claws [src]!"),
			SPAN_XENONOTICE("We claw [src]."), null, null, CHAT_TYPE_XENO_COMBAT)
			playsound(loc, "alien_resin_break", 25)

		M.animation_attack_on(src)
		if (hivenumber == M.hivenumber)
			qdel(src)
		else
			health -= M.melee_damage_lower * RESIN_XENO_DAMAGE_MULTIPLIER
			healthcheck()
	return XENO_ATTACK_ACTION


//Xenomorphs can't use machinery, not even the "intelligent" ones
//Exception is Queen and shuttles, because plot power
/obj/structure/machinery/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable || health <= 0 && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		to_chat(M, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(M.melee_damage_lower, M.melee_damage_upper))
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [M.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

// Destroying reagent dispensers
/obj/structure/reagent_dispensers/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable || health <= 0 && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		to_chat(M, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(M.melee_damage_lower, M.melee_damage_upper))
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [M.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

// Destroying filing cabinets
/obj/structure/filingcabinet/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable || health <= 0)
		to_chat(M, SPAN_WARNING("We stare at \the [src] cluelessly."))
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(M.melee_damage_lower, M.melee_damage_upper))
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices \the [src] apart!"),
		SPAN_DANGER("We slice \the [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		if(!unacidable)
			qdel(src)
	else
		M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] \the [src]!"),
		SPAN_DANGER("We [M.slash_verb] \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

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

/datum/shuttle/ferry/marine/proc/hijack(mob/living/carbon/xenomorph/M, shuttle_tag)
	if(!queen_locked) //we have not hijacked it yet
		if(world.time < SHUTTLE_LOCK_TIME_LOCK)
			to_chat(M, SPAN_XENODANGER("We can't mobilize the strength to hijack the shuttle yet. Please wait another [time_left_until(SHUTTLE_LOCK_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
			return

		var/message
		if(shuttle_tag == "Ground Transport 1") // CORSAT monorail
			message = "We have wrested away remote control of the metal crawler! Rejoice!"
		else
			message = "We have wrested away remote control of the metal bird! Rejoice!"
			if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding))
				MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)

		to_chat(M, SPAN_XENONOTICE("We interact with the machine and disable remote control."))
		xeno_message(SPAN_XENOANNOUNCE("[message]"),3,M.hivenumber)
		last_locked = world.time
		if(GLOB.almayer_orbital_cannon)
			GLOB.almayer_orbital_cannon.is_disabled = TRUE
			addtimer(CALLBACK(GLOB.almayer_orbital_cannon, TYPE_PROC_REF(/obj/structure/orbital_cannon, enable)), 10 MINUTES, TIMER_UNIQUE)
		queen_locked = 1

/datum/shuttle/ferry/marine/proc/door_override(mob/living/carbon/xenomorph/M, shuttle_tag)
	if(!door_override)
		to_chat(M, SPAN_XENONOTICE("We override the doors."))
		xeno_message(SPAN_XENOANNOUNCE("The doors of the metal bird have been overridden! Rejoice!"),3,M.hivenumber)
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


		for(var/obj/structure/machinery/door/airlock/dropship_hatch/D in GLOB.machines)
			if(D.id == ship_id)
				D.unlock()

		var/obj/structure/machinery/door/airlock/multi_tile/almayer/reardoor
		switch(ship_id)
			if("sh_dropship1")
				for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1/D in GLOB.machines)
					reardoor = D
			if("sh_dropship2")
				for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2/D in GLOB.machines)
					reardoor = D
		if(!reardoor)
			CRASH("Shuttle crashed trying to override invalid rear door with shuttle id [ship_id]")
		reardoor.unlock()

//APCs.
/obj/structure/machinery/power/apc/attack_alien(mob/living/carbon/xenomorph/M)

	if(stat & BROKEN)
		to_chat(M, SPAN_XENONOTICE("[src] is already broken!"))
		return XENO_NO_DELAY_ACTION
	else if(beenhit >= XENO_HITS_TO_CUT_WIRES && M.mob_size < MOB_SIZE_BIG)
		to_chat(M, SPAN_XENONOTICE("We aren't big enough to further damage [src]."))
		return XENO_NO_DELAY_ACTION
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
	SPAN_DANGER("We [M.slash_verb] [src]!"), null, 5)
	playsound(loc, "alien_claw_metal", 25, 1)
	if (beenhit >= XENO_HITS_TO_CUT_WIRES)
		set_broken()
		visible_message(SPAN_DANGER("[src]'s electronics are destroyed!"), null, null, 5)
	else if(wiresexposed)
		for(var/wire = 1; wire <= length(get_wire_descriptions()); wire++) // Cut all the wires because xenos don't know any better
			if(!isWireCut(wire)) // Xenos don't need to mend the wires either
				cut(wire, M, FALSE) // This is XOR so it toggles; FALSE just because we don't want the messages
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

/obj/structure/ladder/attack_alien(mob/living/carbon/xenomorph/M)
	attack_hand(M)
	return XENO_NO_DELAY_ACTION

/obj/structure/ladder/attack_larva(mob/living/carbon/xenomorph/larva/M)
	return attack_hand(M)

/obj/structure/machinery/colony_floodlight/attack_alien(mob/living/carbon/xenomorph/M)
	if(!is_on)
		to_chat(M, SPAN_WARNING("Why bother? It's just some weird metal thing."))
		return XENO_NO_DELAY_ACTION
	if(damaged)
		to_chat(M, SPAN_WARNING("It's already damaged."))
		return XENO_NO_DELAY_ACTION
	M.animation_attack_on(src)
	M.visible_message("[M] slashes away at [src]!","We slash and claw at the bright light!", max_distance = 5, message_flags = CHAT_TYPE_XENO_COMBAT)
	health  = max(health - rand(M.melee_damage_lower, M.melee_damage_upper), 0)
	if(!health)
		set_damaged()
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/colony_floodlight/attack_larva(mob/living/carbon/xenomorph/larva/M)
	M.visible_message("[M] starts biting [src]!","In a rage, we start biting [src], but with no effect!", null, 5, CHAT_TYPE_XENO_COMBAT)

//Digging up snow
/turf/open/snow/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.a_intent == INTENT_HARM) //Missed slash.
		return
	if(M.a_intent == INTENT_HELP || !bleed_layer)
		return ..()

	M.visible_message(SPAN_NOTICE("[M] starts clearing out \the [src]..."), SPAN_NOTICE("We start \the clearing out [src]..."), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)

	while(bleed_layer > 0)
		xeno_attack_delay(M)
		var/size = max(M.mob_size, 1)
		if(!do_after(M, 12/size, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			return XENO_NO_DELAY_ACTION

		if(!bleed_layer)
			to_chat(M, SPAN_WARNING("There is nothing to clear out!"))
			return XENO_NO_DELAY_ACTION

		bleed_layer--
		update_icon(1, 0)

	return XENO_NO_DELAY_ACTION

/turf/open/snow/attack_larva(mob/living/carbon/xenomorph/larva/M)
	return //Larvae can't do shit


//Crates, closets, other paraphernalia
/obj/structure/closet/attack_alien(mob/living/carbon/xenomorph/M)
	if(!unacidable)
		M.animation_attack_on(src)
		if(!opened)
			var/difficulty = 70 //if its just closed we can smash open quite easily
			if(welded)
				difficulty = 30 // if its welded shut it should be harder to smash open
			if(prob(difficulty))
				break_open()
				M.visible_message(SPAN_DANGER("[M] smashes \the [src] open!"),
				SPAN_DANGER("We smash \the [src] open!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		else
			M.visible_message(SPAN_DANGER("[M] smashes [src]!"),
			SPAN_DANGER("We smash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		return XENO_ATTACK_ACTION

/obj/structure/machinery/vending/attack_alien(mob/living/carbon/xenomorph/M)
	if(is_tipped_over)
		to_chat(M, SPAN_WARNING("There's no reason to bother with that old piece of trash."))
		return XENO_NO_DELAY_ACTION

	if(M.a_intent == INTENT_HARM)
		M.animation_attack_on(src)
		if(prob(M.melee_damage_lower))
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
			M.visible_message(SPAN_DANGER("[M] smashes [src] beyond recognition!"),
			SPAN_DANGER("We enter a frenzy and smash [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			malfunction()
			tip_over()
		else
			M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
			SPAN_DANGER("We [M.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		return XENO_ATTACK_ACTION

	if(M.action_busy)
		return XENO_NO_DELAY_ACTION
	M.visible_message(SPAN_WARNING("[M] begins to lean against [src]."),
	SPAN_WARNING("We begin to lean against [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	var/shove_time = 100
	if(M.mob_size >= MOB_SIZE_BIG)
		shove_time = 50
	if(istype(M,/mob/living/carbon/xenomorph/crusher))
		shove_time = 15

	xeno_attack_delay(M)

	if(do_after(M, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		M.animation_attack_on(src)
		M.visible_message(SPAN_DANGER("[M] knocks [src] down!"),
		SPAN_DANGER("We knock [src] down!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		tip_over()
	return XENO_NO_DELAY_ACTION


/obj/structure/inflatable/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	deflate(1)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/vending/proc/tip_over()
	var/matrix/A = matrix()
	is_tipped_over = TRUE
	density = FALSE
	A.Turn(90)
	apply_transform(A)
	malfunction()

/obj/structure/machinery/vending/proc/flip_back()
	icon_state = initial(icon_state)
	is_tipped_over = FALSE
	density = TRUE
	var/matrix/A = matrix()
	apply_transform(A)
	stat &= ~BROKEN //Remove broken. MAGICAL REPAIRS

//Misc
/obj/structure/prop/invuln/joey/attack_alien(mob/living/carbon/xenomorph/alien)
	alien.animation_attack_on(src)
	alien.visible_message(SPAN_DANGER("[alien] [alien.slashes_verb] [src]!"),
	SPAN_DANGER("We [alien.slash_verb] [src]!"), null, 5)
	playsound(loc, "alien_claw_metal", 25, 1)
	attacked()
	return XENO_ATTACK_ACTION
