//Xenomorph Life - Colonial Marines - Apophis775 - Last Edit: 03JAN2015

#define XENO_ARMOR_REGEN_DELAY 30 SECONDS
/mob/living/carbon/xenomorph/Life(delta_time)
	set invisibility = 0
	set background = 1

	if(!loc)
		return

	if(banished)
		apply_armoured_damage(max(ceil(health / XENO_BANISHMENT_DMG_DIVISOR), 1))

	..()

	// replace this by signals or trait signals
	if(!HAS_TRAIT(src, TRAIT_ABILITY_SIGHT_IGNORE_REST) && is_zoomed && (stat || body_position == LYING_DOWN))
		zoom_out()

	if(stat != DEAD) //Stop if dead. Performance boost

		update_progression()

		//Status updates, death etc.
		handle_xeno_fire()
		handle_pheromones()
		handle_regular_status_updates()
		handle_overwatch() // For new Xeno hivewide overwatch - Fourk, 6/24/19
		update_icons()
		handle_luminosity()
		handle_blood()

		behavior_delegate?.on_life()
		handle_environment()
		if(client)
			handle_regular_hud_updates()

/mob/living/carbon/xenomorph/proc/update_progression()
	if(isnull(hive))
		return
	var/progress_amount = 1
	if(SSxevolution)
		progress_amount = SSxevolution.get_evolution_boost_power(hive.hivenumber)
	var/ovipositor_check = (hive.allow_no_queen_evo || hive.evolution_without_ovipositor || (hive.living_xeno_queen && hive.living_xeno_queen.ovipositor))
	if(caste && caste.evolution_allowed && (ovipositor_check || caste?.evolve_without_queen))
		if(evolution_stored >= evolution_threshold)
			if(!got_evolution_message)
				evolve_message()
				got_evolution_message = TRUE

			if(ROUND_TIME < XENO_ROUNDSTART_PROGRESS_TIME_2)
				evolution_stored += progress_amount
				return

			if(evolution_stored > evolution_threshold + progress_amount)
				evolution_stored -= progress_amount
				return

		else
			evolution_stored += progress_amount

/mob/living/carbon/xenomorph/proc/evolve_message()
	to_chat(src, SPAN_XENODANGER("Our carapace crackles and our tendons strengthen. We are ready to <a href='byond://?src=\ref[src];evolve=1;'>evolve</a>!")) //Makes this bold so the Xeno doesn't miss it
	playsound_client(client, sound('sound/effects/xeno_evolveready.ogg'))

	var/datum/action/xeno_action/onclick/evolve/evolve_action = new()
	evolve_action.give_to(src)

// Always deal 80% of damage and deal the other 20% depending on how many fire stacks mob has
#define PASSIVE_BURN_DAM_CALC(intensity, duration, fire_stacks) intensity*(fire_stacks/duration*0.2 + 0.8)

/mob/living/carbon/xenomorph/proc/handle_xeno_fire()
	if(!on_fire)
		return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	var/obj/item/clothing/mask/facehugger/G = get_inactive_hand()
	if(istype(F))
		F.die()
		drop_inv_item_on_ground(F)
	if(istype(G))
		G.die()
		drop_inv_item_on_ground(G)
	if(!caste || !(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE) || fire_reagent.fire_penetrating)
		if(caste.fire_immunity & FIRE_VULNERABILITY && caste.fire_vulnerability_mult >= 1)
			apply_damage(PASSIVE_BURN_DAM_CALC(fire_reagent.intensityfire, fire_reagent.durationfire, fire_stacks) * caste.fire_vulnerability_mult, BURN)
		else
			apply_damage(armor_damage_reduction(GLOB.xeno_fire, PASSIVE_BURN_DAM_CALC(fire_reagent.intensityfire, fire_reagent.durationfire, fire_stacks)), BURN)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), pick("roar", "needhelp"))

#undef PASSIVE_BURN_DAM_CALC

/mob/living/carbon/xenomorph/proc/handle_pheromones()
	//Rollercoaster of fucking stupid because Xeno life ticks aren't synchronised properly and values reset just after being applied
	//At least it's more efficient since only Xenos with an aura do this, instead of all Xenos
	//Basically, we use a special tally var so we don't reset the actual aura value before making sure they're not affected
	//Now moved out of healthy only state, because crit xenos can def still be affected by pheros

	if(!stat)
		var/use_current_aura = FALSE
		var/use_leader_aura = FALSE
		var/aura_center = src
		if(aura_strength > 0) //Ignoring pheromone underflow
			if(current_aura && plasma_stored > 5)
				if(caste_type == XENO_CASTE_QUEEN && anchored) //stationary queen's pheromone apply around the observed xeno.
					var/mob/living/carbon/xenomorph/queen/Q = src
					var/atom/phero_center = Q
					if(Q.observed_xeno)
						phero_center = Q.observed_xeno
					if(!phero_center || !phero_center.loc)
						return
					if(SSmapping.same_z_map(phero_center.loc.z, Q.loc.z))//Only same map
						use_current_aura = TRUE
						aura_center = phero_center
				else
					use_current_aura = TRUE

		if(leader_current_aura && hive && hive.living_xeno_queen && SSmapping.same_z_map(hive.living_xeno_queen.loc.z, loc.z)) //Same map as the Queen!
			use_leader_aura = TRUE

		if(use_current_aura || use_leader_aura)
			for(var/mob/living/carbon/xenomorph/Z as anything in GLOB.living_xeno_list)
				if(Z.ignores_pheromones || Z.ignore_aura == current_aura || Z.ignore_aura == leader_current_aura || !SSmapping.same_z_map(Z.z, z) || get_dist(aura_center, Z) > floor(6 + aura_strength * 2) || !HIVE_ALLIED_TO_HIVE(Z.hivenumber, hivenumber))
					continue
				if(use_leader_aura)
					Z.affected_by_pheromones(leader_current_aura, leader_aura_strength)
				if(use_current_aura)
					Z.affected_by_pheromones(current_aura, aura_strength)

	if(frenzy_aura != frenzy_new || warding_aura != warding_new || recovery_aura != recovery_new)
		frenzy_aura = frenzy_new
		if(health > crit_health || warding_new > warding_aura || !check_weeds_for_healing())
			warding_aura = warding_new
		recovery_aura = recovery_new
		recalculate_move_delay = TRUE
		hud_set_pheromone()

	frenzy_new = 0
	warding_new = 0
	recovery_new = 0

/mob/living/carbon/xenomorph/proc/affected_by_pheromones(aura, strength)
	switch(aura)
		if("all")
			if(strength > frenzy_new)
				frenzy_new = strength
			if(strength > warding_new)
				warding_new = strength
			if(strength > recovery_new)
				recovery_new = strength
		if("frenzy")
			if(strength > frenzy_new)
				frenzy_new = strength
		if("warding")
			if(strength > warding_new)
				warding_new = strength
		if("recovery")
			if(strength > recovery_new)
				recovery_new = strength

	// Also cap the auras
	for(var/capped_aura in received_phero_caps)
		switch(capped_aura)
			if("frenzy")
				frenzy_new = min(frenzy_new, received_phero_caps[capped_aura])
			if("warding")
				warding_new = min(warding_new, received_phero_caps[capped_aura])
			if("recovery")
				recovery_new = min(recovery_new, received_phero_caps[capped_aura])


/mob/living/carbon/xenomorph/handle_regular_status_updates(regular_update = TRUE)
	if(regular_update && health <= 0 && (!caste || (caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE) || !on_fire)) //Sleeping Xenos are also unconscious, but all crit Xenos are under 0 HP. Go figure
		if(!check_weeds_for_healing()) //In crit, damage is maximal if you're caught off weeds
			apply_damage(2.5 - warding_aura*0.5, BRUTE) //Warding can heavily lower the impact of bleedout. Halved at 2.5 phero, stopped at 5 phero
		else
			apply_damage(-warding_aura, BRUTE)

	updatehealth()

	if(health > 0 && stat != DEAD) //alive and not in crit! Turn on their vision.
		see_in_dark = 50

		SetEarDeafness(0) //All this stuff is prob unnecessary
		ear_damage = 0
		SetEyeBlind(0)

		if(HAS_TRAIT(src, TRAIT_KNOCKEDOUT)) //If they're down, make sure they are actually down.
			blinded = TRUE
			if(regular_update && halloss > 0)
				apply_damage(-3, HALLOSS)
		else if(sleeping)
			if(regular_update && halloss > 0)
				apply_damage(-3, HALLOSS)
			if(regular_update && mind)
				if((mind.active && client != null) || immune_to_ssd)
					sleeping = max(sleeping - 1, 0)
			blinded = TRUE
			set_stat(UNCONSCIOUS)
		else
			if(!HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))//If their connection to hivemind is affected, their vision should be too.
				blinded = FALSE
			set_stat(CONSCIOUS)
			if(regular_update && halloss > 0)
				if(resting)
					apply_damage(-3, HALLOSS)
				else
					apply_damage(-1, HALLOSS)

		if(regular_update)
			if(eye_blurry)
				src.ReduceEyeBlur(1)

			handle_statuses()//natural decrease of stunned, knocked_down, etc...

	return TRUE


/mob/living/carbon/xenomorph/proc/handle_regular_hud_updates()
	if(!mind)
		return TRUE

	if(stat == DEAD)
		clear_fullscreen("xeno_pain")
		if(hud_used)
			if(hud_used.healths)
				hud_used.healths.icon_state = "health_dead"
			if(hud_used.alien_plasma_display)
				hud_used.alien_plasma_display.icon_state = "power_display_empty"
			if(hud_used.alien_armor_display)
				hud_used.alien_armor_display.icon_state = "armor_00"
		return TRUE

	var/severity = HUD_PAIN_STATES_XENO - ceil(((max(health, 0) / maxHealth) * HUD_PAIN_STATES_XENO))
	if(severity)
		overlay_fullscreen("xeno_pain", /atom/movable/screen/fullscreen/xeno_pain, severity)
	else
		clear_fullscreen("xeno_pain")

	if(blinded)
		overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")

	if(interactee && isatom(interactee))
		interactee.check_eye(src)
	else if(client && !client.adminobs)
		reset_view(null)

	if(!hud_used)
		return TRUE

	if(hud_used.healths)
		var/health_stacks = ceil((health / maxHealth) * HUD_HEALTH_STATES_XENO)
		hud_used.healths.icon_state = "health_[health_stacks]"
		if(health_stacks >= HUD_HEALTH_STATES_XENO)
			hud_used.healths.icon_state = "health_full"
		else if(health_stacks <= 0)
			hud_used.healths.icon_state = "health_critical"

	if(hud_used.alien_plasma_display)
		if(plasma_max == 0)
			hud_used.alien_plasma_display.icon_state = "power_display_empty"
		else
			var/plasma_stacks = (get_plasma_percentage() * 0.01) * HUD_PLASMA_STATES_XENO
			hud_used.alien_plasma_display.icon_state = "power_display_[ceil(plasma_stacks)]"
			if(plasma_stacks >= HUD_PLASMA_STATES_XENO)
				hud_used.alien_plasma_display.icon_state = "power_display_full"
			else if(plasma_stacks <= 0)
				hud_used.alien_plasma_display.icon_state = "power_display_empty"

	if(hud_used.alien_armor_display)
		var/armor_stacks = min((get_armor_integrity_percentage() * 0.01) * HUD_ARMOR_STATES_XENO, HUD_ARMOR_STATES_XENO)
		hud_used.alien_armor_display.icon_state = "armor_[floor(armor_stacks)]0"

	return TRUE

/mob/living/carbon/xenomorph/on_dazed_trait_gain(datum/source)
	. = ..()
	overlay_fullscreen("dazed", /atom/movable/screen/fullscreen/impaired, 5)
/mob/living/carbon/xenomorph/on_dazed_trait_loss(datum/source)
	. = ..()
	clear_fullscreen("dazed")

/*Heal 1/70th of your max health in brute per tick. 1 as a bonus, to help smaller pools.
Additionally, recovery pheromones mutiply this base healing, up to 2.5 times faster at level 5
Modified via m, to multiply the number of wounds healed.
Heal from fire half as fast
Xenos don't actually take oxyloss, oh well
hmmmm, this is probably unnecessary
Make sure their actual health updates immediately.*/

/mob/living/carbon/xenomorph/proc/heal_wounds(m, recov)
	var/heal_penalty = 0
	var/list/L = list("healing" = heal_penalty)
	SEND_SIGNAL(src, COMSIG_XENO_ON_HEAL_WOUNDS, L)
	heal_penalty = - L["healing"]
	apply_damage(min(-((maxHealth / 70) + 0.5 + (maxHealth / 70) * recov/2)*(m) + heal_penalty, 0), BRUTE)
	apply_damage(min(-(maxHealth / 60 + 0.5 + (maxHealth / 60) * recov/2)*(m) + heal_penalty, 0), BURN)
	apply_damage(min(-(maxHealth * 0.1 + 0.5 + (maxHealth * 0.1) * recov/2)*(m) + heal_penalty, 0), OXY)
	apply_damage(min(-(maxHealth / 5 + 0.5 + (maxHealth / 5) * recov/2)*(m) + heal_penalty, 0), TOX)
	updatehealth()


/mob/living/carbon/xenomorph/proc/handle_environment()
	var/turf/T = loc
	var/recoveryActual = (!caste || (caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE) || !on_fire) ? recovery_aura : 0
	var/env_temperature = loc.return_temperature()
	if(caste && !(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE))
		if(env_temperature > (T0C + 66))
			apply_damage((env_temperature - (T0C + 66)) / 5, BURN) //Might be too high, check in testing.
			updatehealth() //Make sure their actual health updates immediately
			if(prob(20))
				to_chat(src, SPAN_WARNING("You feel a searing heat!"))

	if(!T || !istype(T))
		return

	if(caste)
		if(caste.innate_healing || check_weeds_for_healing())
			if(!hive)
				return // can't heal if you have no hive, sorry bud
			plasma_stored += plasma_gain * plasma_max / 100
			if(recovery_aura)
				plasma_stored += floor(plasma_gain * plasma_max / 100 * recovery_aura/4) //Divided by four because it gets massive fast. 1 is equivalent to weed regen! Only the strongest pheromones should bypass weeds
			if(health < maxHealth && !hardcore && is_hive_living(hive) && last_hit_time + caste.heal_delay_time <= world.time)
				if(body_position == LYING_DOWN || resting)
					if(health < 0) //Unconscious
						heal_wounds(caste.heal_knocked_out * regeneration_multiplier, recoveryActual) //Healing is much slower. Warding pheromones make up for the rest if you're curious
					else
						heal_wounds(caste.heal_resting * regeneration_multiplier, recoveryActual)
				else
					heal_wounds(caste.heal_standing * regeneration_multiplier, recoveryActual)
				updatehealth()

			if(armor_integrity < armor_integrity_max && armor_deflection > 0 && world.time > armor_integrity_last_damage_time + XENO_ARMOR_REGEN_DELAY)
				var/curve_factor = armor_integrity/armor_integrity_max
				curve_factor *= curve_factor
				if(curve_factor < 0.5)
					curve_factor = 0.5
				if(armor_integrity/armor_integrity_max < 0.3)
					curve_factor /= 2

				var/factor = ((armor_deflection / 60) * 3 MINUTES) // 60 armor is restored in 10 minutes in 2 seconds intervals
				armor_integrity += 100*curve_factor/factor

			if(armor_integrity > armor_integrity_max)
				armor_integrity = armor_integrity_max

		else if(prob(50) && !current_aura) //Xenos restore plasma VERY slowly off weeds, regardless of health, as long as they are not using special abilities
			plasma_stored += 0.1 * plasma_max / 100


		for(var/datum/action/xeno_action/action in src.actions)
			action.life_tick()

		if(current_aura)
			plasma_stored -= 5

	if(plasma_stored > plasma_max)
		plasma_stored = plasma_max
	if(plasma_stored < 0)
		plasma_stored = 0
		if(current_aura)
			current_aura = null
			to_chat(src, SPAN_WARNING("We have run out of plasma and stopped emitting pheromones."))

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

	hud_set_plasma() //update plasma amount on the plasma mob_hud

/mob/living/carbon/xenomorph/proc/queen_locator()
	if(!hud_used?.locate_leader)
		return

	var/atom/movable/screen/queen_locator/locator = hud_used.locate_leader
	if(!loc || !hive)
		locator.reset_tracking()
		return

	var/atom/tracking_atom
	switch(locator.tracker_type)
		if(TRACKER_QUEEN)
			tracking_atom = hive.living_xeno_queen
		if(TRACKER_HIVE)
			tracking_atom = hive.hive_location
		if(TRACKER_LEADER)
			var/atom/leader = locator.tracking_ref?.resolve()
			// If the leader exists, and is actually in the leader list.
			if(leader && (leader in hive.xeno_leader_list))
				tracking_atom = leader
		if(TRACKER_TUNNEL)
			tracking_atom = locator.tracking_ref?.resolve()

	// If the atom can't be found/has been deleted.
	if(!tracking_atom)
		var/already_tracking_queen = (locator.tracker_type == TRACKER_QUEEN)

		// Reset the tracker back to the queen.
		locator.reset_tracking()

		// If it wasn't the queen that couldn't be found above, try again with her as the target.
		// This is just to avoid the tracker going blank for one life tick.
		// (There's no risk of an infinite loop here since `locator.tracker_type` just got set to `TRACKER_QUEEN`.)
		if(!already_tracking_queen)
			queen_locator()
		return

	if(tracking_atom.loc.z != loc.z && SSinterior.in_interior(tracking_atom))
		var/datum/interior/interior = SSinterior.get_interior_by_coords(tracking_atom.x, tracking_atom.y, tracking_atom.z)
		var/atom/exterior = interior.exterior
		if(exterior)
			tracking_atom = exterior

	if(tracking_atom.loc.z != loc.z || get_dist(src, tracking_atom) < 1 || src == tracking_atom)
		locator.icon_state = "trackondirect"
	else
		var/area/our_area = get_area(loc)
		var/area/target_area = get_area(tracking_atom.loc)
		if(our_area.fake_zlevel == target_area.fake_zlevel)
			locator.setDir(Get_Compass_Dir(src, tracking_atom))
			locator.icon_state = "trackon"
		else
			locator.icon_state = "trackondirect"

/mob/living/carbon/xenomorph/proc/mark_locator()
	if(!hud_used || !hud_used.locate_marker || !tracked_marker.loc || !loc)
		return

	var/tracked_marker_z_level = tracked_marker.loc.z  //I was getting errors if the mark was deleted while this was operating,
	var/tracked_marker_turf = get_turf(tracked_marker)  //so I made local variables to circumvent this
	var/area/A = get_area(loc)
	var/area/MA = get_area(tracked_marker_turf)
	var/atom/movable/screen/mark_locator/ML = hud_used.locate_marker
	ML.desc = client

	ML.overlays.Cut()

	if(tracked_marker_z_level != loc.z) //different z levels
		ML.overlays |= image(tracked_marker.seenMeaning, "pixel_y" = 0)
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "center_glow")
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "z_direction")
		return
	else if(tracked_marker_turf == get_turf(src)) //right on top of the marker
		ML.overlays |= image(tracked_marker.seenMeaning, "pixel_y" = 0)
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "center_glow")
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "all_direction")
		return
	else if(A.fake_zlevel == MA.fake_zlevel) //normal tracking
		ML.setDir(Get_Compass_Dir(src, tracked_marker_turf))
		ML.overlays |= image(tracked_marker.seenMeaning, "pixel_y" = 0)
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "center_glow")
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "direction")
	else //same z level, different fake z levels (decks of almayer)
		ML.overlays |= image(tracked_marker.seenMeaning, "pixel_y" = 0)
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "center_glow")
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "no_direction")

/mob/living/carbon/xenomorph/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else if(length(xeno_shields) != 0)
		overlay_shields()
		health = maxHealth - getFireLoss() - getBruteLoss()
	else
		health = maxHealth - getFireLoss() - getBruteLoss() //Xenos can only take brute and fire damage.

	if(stat != DEAD && !gibbing)
		var/warding_health = crit_health != 0 ? warding_aura * 20 : 0
		if(health <= crit_health - warding_health) //dead
			if(prob(gib_chance + 0.5*(crit_health - health)))
				async_gib(last_damage_data)
			else
				death(last_damage_data)
			return
		else if(health <= 0) //in crit
			if(hardcore)
				async_gib(last_damage_data)
			else if(world.time > next_grace_time && stat == CONSCIOUS)
				var/grace_time = crit_grace_time > 0 ? crit_grace_time + (1 SECONDS * max(floor(warding_aura - 1), 0)) : 0
				if(grace_time)
					addtimer(CALLBACK(src, PROC_REF(handle_crit)), grace_time)
				else
					handle_crit()
				next_grace_time = world.time + grace_time
		update_wounds()
		blinded = stat == UNCONSCIOUS // Xenos do not go blind from other sources - still, replace that by a status_effect or trait when able
	if(!gibbing)
		med_hud_set_health()


/mob/living/carbon/xenomorph/proc/handle_crit()
	if(stat <= CONSCIOUS && !gibbing)
		set_stat(UNCONSCIOUS)
		SEND_SIGNAL(src, COMSIG_XENO_ENTER_CRIT)

/mob/living/carbon/xenomorph/adjustBruteLoss(amount)
	if(status_flags & GODMODE)
		return //godmode
	bruteloss = max(bruteloss + amount, 0)

/mob/living/carbon/xenomorph/adjustFireLoss(amount)
	if(status_flags & GODMODE)
		return //godmode
	fireloss = max(fireloss + amount, 0)

/mob/living/carbon/xenomorph/set_stat(new_stat)
	. = ..()
	// Temporarily force triggering HUD updates so they apply immediately rather than on Life tick.
	// Remove this once effects have been ported to trait signals (blinded, dazed, etc)
	if(stat != .)
		handle_regular_hud_updates()

/mob/living/carbon/xenomorph/proc/handle_luminosity()
	var/new_luminosity = 0
	if(caste)
		new_luminosity += caste.caste_luminosity
	if(on_fire)
		new_luminosity += min(fire_stacks, 5)
	set_light_range(new_luminosity) // light up xenos
	if(new_luminosity)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)

/mob/living/carbon/xenomorph/GetStunDuration(amount)
	amount *= 2 / 3
	return ..()
/mob/living/carbon/xenomorph/GetKnockDownDuration(amount)
	amount *= 2 / 3
	return ..()
/mob/living/carbon/xenomorph/GetKnockOutDuration(amount)
	amount *= 2 / 3
	return ..()
/mob/living/carbon/xenomorph/GetDazeDuration(amount)
	amount *= 2 / 3
	return ..()

/mob/living/carbon/xenomorph/handle_slowed()
	if(slowed)
		adjust_effect(life_slow_reduction, SLOW, EFFECT_FLAG_LIFE)
	return slowed

/mob/living/carbon/xenomorph/handle_superslowed()
	if(superslowed)
		adjust_effect(life_slow_reduction, SUPERSLOW, EFFECT_FLAG_LIFE)
	return superslowed

//Returns TRUE if xeno is on weeds
//Returns TRUE if xeno is off weeds AND doesn't need weeds for healing AND is not on Almayer UNLESS Queen is also on Almayer (aka - no solo Lurker Almayer hero)
/mob/living/carbon/xenomorph/proc/check_weeds_for_healing()
	var/turf/T = loc

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in T

	if(W && W.linked_hive.is_ally(src))
		return TRUE //weeds, yes!
	if(need_weeds)
		return FALSE //needs weeds, doesn't have any
	if(hive && hive.living_xeno_queen && !is_mainship_level(hive.living_xeno_queen.loc.z) && is_mainship_level(loc.z))
		return FALSE //We are on the ship, but the Queen isn't
	return TRUE //we have off-weed healing, and either we're on Almayer with the Queen, or we're on non-Almayer, or the Queen is dead, good enough!
