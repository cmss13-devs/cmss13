/*
	Xenomorph
*/

/mob/living/carbon/xenomorph/UnarmedAttack(atom/target, proximity, click_parameters, tile_attack = FALSE, ignores_resin = FALSE)
	if(body_position == LYING_DOWN || HAS_TRAIT(src, TRAIT_ABILITY_BURROWED) || cannot_slash) //No attacks while laying down
		return FALSE
	var/mob/alt

	if(target == src) //Clicking self.
		target = params2turf(click_parameters[SCREEN_LOC], get_turf(src), client)
		tile_attack = TRUE

	if(target.z != z)
		return

	if(isturf(target) && tile_attack) //Attacks on turfs must be done indirectly through directional attacks or clicking own sprite.
		var/turf/T = target
		var/mob/living/non_xeno_target
		for(var/mob/living/L in T)
			if (!iscarbon(L))
				if (!alt)
					alt = L // last option is a simple mob
				continue
			if(HAS_TRAIT(L, TRAIT_NESTED))
				continue

			if (!L.is_xeno_grabbable() || L == src) //Xenos never attack themselves.
				continue
			var/isxeno = isxeno(L)
			if(!isxeno)
				non_xeno_target = L
			if (L.body_position == LYING_DOWN)
				alt = L
				continue
			else if (!isxeno)
				break
			target = L
		if (target == T && alt)
			target = alt
		if(non_xeno_target)
			target = non_xeno_target
		if (T && ignores_resin) // Will not target resin walls and doors if this is set to true. This is normally only set to true through a directional attack.
			if(istype(T, /obj/structure/mineral_door/resin))
				var/obj/structure/mineral_door/resin/attacked_door = T
				if(hivenumber == attacked_door.hivenumber)
					return FALSE
			if(istype(T, /turf/closed/wall/resin))
				var/turf/closed/wall/resin/attacked_wall = T
				if(hivenumber == attacked_wall.hivenumber)
					return FALSE

	target = target.handle_barriers(src, , (PASS_MOB_THRU_XENO|PASS_TYPE_CRAWLER)) // Checks if target will be attacked by the current alien OR if the blocker will be attacked
	switch(target.attack_alien(src))
		if(XENO_ATTACK_ACTION)
			xeno_attack_delay(src)
		if(XENO_NONCOMBAT_ACTION)
			xeno_noncombat_delay(src)
		if(XENO_NO_DELAY_ACTION)
			next_move = world.time
		else
			if(!tile_attack) // Patting flames for Xenos
				var/firepatted = FALSE
				if(src.a_intent == INTENT_HELP)
					var/fire_level_to_extinguish = 5
					var/turf/target_turf = target
					for(var/obj/flamer_fire/fire in target_turf)
						firepatted = TRUE
						if(!(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE) || fire.tied_reagent?.fire_penetrating)
							var/firedamage = max(fire.burnlevel - check_fire_intensity_resistance(), 0) * 0.5
							apply_damage(firedamage, BURN, fire)
						if((fire.firelevel > fire_level_to_extinguish) && (!fire.fire_variant)) //If fire_variant = 0, default fire extinguish behavior.
							fire.firelevel -= fire_level_to_extinguish
							fire.update_flame()
						else
							switch(fire.fire_variant)
								if(FIRE_VARIANT_TYPE_B) //Armor Shredding Greenfire, extinguishes faster.
									if(fire.firelevel > 2*fire_level_to_extinguish)
										firepatted = TRUE
										fire.firelevel -= 2*fire_level_to_extinguish
										fire.update_flame()
									else
										qdel(fire)
								else
									qdel(fire)
				xeno_miss_delay(src)
				animation_attack_on(target)
				playsound(loc, 'sound/weapons/alien_claw_swipe.ogg', 10, 1) //Quiet to limit spam/nuisance.
				if(firepatted)
					src.visible_message(SPAN_DANGER("\The [src] pats at the fire!"),
					SPAN_DANGER("We pat the fire!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				else
					src.visible_message(SPAN_DANGER("\The [src] swipes at \the [target]!"),
					SPAN_DANGER("We swipe at \the [target]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TRUE

/mob/living/carbon/xenomorph/RangedAttack(atom/A)
	. = ..()
	if (.)
		return
	if (client && client.prefs && client.prefs.toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK)
		next_move += 0.25 SECONDS //Slight delay on missed directional attacks. If it finds a mob in the target tile, this will be overwritten by the attack delay.
		return UnarmedAttack(get_step(src, Get_Compass_Dir(src, A)), tile_attack = TRUE, ignores_resin = TRUE)
	return FALSE

/**The parent proc, will default to UnarmedAttack behaviour unless overridden
Return XENO_ATTACK_ACTION if it does something and the attack should have full attack delay.
Return XENO_NONCOMBAT_ACTION if it did something and should have some delay.
Return XENO_NO_DELAY_ACTION if it gave an error message or should have no delay at all, ex. "You can't X that, it's Y!"
Return FALSE if it didn't do anything and should count as a missed slash.

If using do_afters or sleeps, use invoke_async (or manually add the relevant action delayand return FALSE
so that it doesn't double up on the delays) so that it applies the delay immediately instead of when it finishes.**/
/atom/proc/attack_alien(mob/user as mob)
	return

/mob/living/carbon/xenomorph/click(atom/target, list/mods)
	if(queued_action)
		handle_queued_action(target)
		return TRUE

	var/left_pressed = mods[LEFT_CLICK] == "1"
	var/alt_pressed = mods[ALT_CLICK] == "1"
	var/shift_pressed = mods[SHIFT_CLICK] == "1"
	var/middle_pressed = mods[MIDDLE_CLICK] == "1"
	var/right_pressed = mods[RIGHT_CLICK] == "1"

	if(alt_pressed && shift_pressed)
		if(istype(target, /mob/living/carbon/xenomorph))
			var/mob/living/carbon/xenomorph/xeno = target
			if(!QDELETED(xeno) && xeno.stat != DEAD && !should_block_game_interaction(xeno) && xeno.check_state(TRUE) && xeno.hivenumber == hivenumber)
				overwatch(xeno)
				next_move = world.time + 3 // Some minimal delay so this isn't crazy spammy
				return TRUE

	var/preference = get_ability_mouse_key() // client is already tested to be non-null by caller
	var/activate_ability = FALSE
	switch(preference)
		if(XENO_ABILITY_CLICK_MIDDLE)
			activate_ability = middle_pressed && !shift_pressed
		if(XENO_ABILITY_CLICK_RIGHT)
			activate_ability = right_pressed
		if(XENO_ABILITY_CLICK_SHIFT)
			activate_ability = left_pressed && shift_pressed

	if(activate_ability && selected_ability)
		if(istype(target, /atom/movable/screen))
			// Click through the UI: Currently this won't attempt to sprite click any mob there, just the turf
			var/turf/turf = params2turf(mods[SCREEN_LOC], get_turf(client.eye), client)
			if(turf)
				target = turf
		selected_ability.use_ability_wrapper(target, mods)
		return TRUE

	if(next_move >= world.time)
		return FALSE

	return ..()

//Larva attack, will default to attack_alien behaviour unless overridden
/atom/proc/attack_larva(mob/living/carbon/xenomorph/larva/user)
	return attack_alien(user)
