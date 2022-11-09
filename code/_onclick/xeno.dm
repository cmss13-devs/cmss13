/*
	Xenomorph
*/

/mob/living/carbon/Xenomorph/UnarmedAttack(atom/target, proximity, click_parameters, tile_attack = FALSE)
	if(lying || burrow) //No attacks while laying down
		return FALSE
	var/mob/alt

	if(target == src) //Clicking self.
		target = params2turf(click_parameters["screen-loc"], get_turf(src), client)
		tile_attack = TRUE

	if(isturf(target) && tile_attack) //Attacks on turfs must be done indirectly through directional attacks or clicking own sprite.
		var/turf/T = target
		for(var/mob/living/L in T)
			if (!iscarbon(L))
				if (!alt)
					alt = L // last option is a simple mob
				continue

			if (!L.is_xeno_grabbable() || L == src) //Xenos never attack themselves.
				continue
			if (L.lying)
				alt = L
				continue
			target = L
			break
		if (target == T && alt)
			target = alt
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
					src.visible_message(SPAN_DANGER("\The [src] pats at the fire!"), \
					SPAN_DANGER("You pat the fire!"), null, 5, CHAT_TYPE_XENO_COMBAT)
				else
					src.visible_message(SPAN_DANGER("\The [src] swipes at \the [target]!"), \
					SPAN_DANGER("You swipe at \the [target]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return TRUE

/mob/living/carbon/Xenomorph/RangedAttack(var/atom/A)
	. = ..()
	if (.)
		return
	if (client && client.prefs && client.prefs.toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK)
		next_move += 0.25 SECONDS //Slight delay on missed directional attacks. If it finds a mob in the target tile, this will be overwritten by the attack delay.
		return UnarmedAttack(get_step(src, Get_Compass_Dir(src, A)), tile_attack = TRUE)
	return FALSE

/**The parent proc, will default to UnarmedAttack behaviour unless overriden
Return XENO_ATTACK_ACTION if it does something and the attack should have full attack delay.
Return XENO_NONCOMBAT_ACTION if it did something and should have some delay.
Return XENO_NO_DELAY_ACTION if it gave an error message or should have no delay at all, ex. "You can't X that, it's Y!"
Return FALSE if it didn't do anything and should count as a missed slash.

If using do_afters or sleeps, use invoke_async (or manually add the relevant action delayand return FALSE
so that it doesn't double up on the delays) so that it applies the delay immediately instead of when it finishes.**/
/atom/proc/attack_alien(mob/user as mob)
	return

/mob/living/carbon/Xenomorph/click(var/atom/A, var/list/mods)
	if (queued_action)
		handle_queued_action(A)
		return TRUE

	if (mods["alt"] && mods["shift"])
		if (istype(A, /mob/living/carbon/Xenomorph))
			var/mob/living/carbon/Xenomorph/X = A

			if (X && !QDELETED(X) && X != observed_xeno && X.stat != DEAD && !is_admin_level(X.z) && X.check_state(1) && X.hivenumber == hivenumber)
				if (caste && istype(caste, /datum/caste_datum/queen))
					var/mob/living/carbon/Xenomorph/oldXeno = observed_xeno
					overwatch(X, FALSE)

					if (oldXeno)
						oldXeno.hud_set_queen_overwatch()
					if (X && !QDELETED(X))
						X.hud_set_queen_overwatch()

				else
					overwatch(X)

				next_move = world.time + 3 // Some minimal delay so this isn't crazy spammy
				return 1

	if(mods["shift"] && !mods["middle"])
		if(selected_ability && client && client.prefs && !(client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK))
			selected_ability.use_ability_wrapper(A, mods)
			return TRUE

	if(mods["middle"] && !mods["shift"])
		if(selected_ability && client && client.prefs && client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK)
			selected_ability.use_ability_wrapper(A, mods)
			return TRUE

	if(next_move >= world.time)
		return TRUE

	return ..()

//Larva attack, will default to attack_alien behaviour unless overriden
/atom/proc/attack_larva(mob/living/carbon/Xenomorph/Larva/user)
	return attack_alien(user)
