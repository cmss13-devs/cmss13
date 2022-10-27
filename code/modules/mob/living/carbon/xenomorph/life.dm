//Xenomorph Life - Colonial Marines - Apophis775 - Last Edit: 03JAN2015

#define XENO_ARMOR_REGEN_DELAY 30 SECONDS
/mob/living/carbon/Xenomorph/Life(delta_time)
	set invisibility = 0
	set background = 1

	if(!loc)
		return

	..()

	if(is_zoomed && (stat || lying))
		zoom_out()

	if(stat != DEAD) //Stop if dead. Performance boost

		update_progression()

		//Status updates, death etc.
		handle_xeno_fire()
		handle_pheromones()
		handle_regular_status_updates()
		handle_stomach_contents()
		handle_overwatch() // For new Xeno hivewide overwatch - Fourk, 6/24/19
		update_canmove()
		update_icons()
		handle_luminosity()

		if(behavior_delegate)
			behavior_delegate.on_life()

		if(loc)
			handle_environment()
		if(client)
			handle_regular_hud_updates()

/mob/living/carbon/Xenomorph/proc/update_progression()
	if(isnull(hive))
		return
	var/progress_amount = 1
	if(SSxevolution)
		progress_amount = SSxevolution.get_evolution_boost_power(hive.hivenumber)
	var/ovipositor_check = (hive.allow_no_queen_actions || hive.evolution_without_ovipositor || (hive.living_xeno_queen && hive.living_xeno_queen.ovipositor) || caste?.evolve_without_queen)
	if(caste && caste.evolution_allowed && evolution_stored < evolution_threshold && ovipositor_check)
		evolution_stored = min(evolution_stored + progress_amount, evolution_threshold)
		if(evolution_stored >= evolution_threshold)
			evolve_message()

/mob/living/carbon/Xenomorph/proc/evolve_message()
	to_chat(src, SPAN_XENODANGER("Your carapace crackles and your tendons strengthen. You are ready to <a href='?src=\ref[src];evolve=1;'>evolve</a>!")) //Makes this bold so the Xeno doesn't miss it
	playsound_client(client, sound('sound/effects/xeno_evolveready.ogg'))

// Always deal 80% of damage and deal the other 20% depending on how many fire stacks mob has
#define PASSIVE_BURN_DAM_CALC(intensity, duration, fire_stacks) intensity*(fire_stacks/duration*0.2 + 0.8)

/mob/living/carbon/Xenomorph/proc/handle_xeno_fire()
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
		var/dmg = armor_damage_reduction(GLOB.xeno_fire, PASSIVE_BURN_DAM_CALC(fire_reagent.intensityfire, fire_reagent.durationfire, fire_stacks))
		apply_damage(dmg, BURN)
		INVOKE_ASYNC(src, /mob.proc/emote, pick("roar", "needhelp"))

#undef PASSIVE_BURN_DAM_CALC

/mob/living/carbon/Xenomorph/proc/handle_pheromones()
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
					var/mob/living/carbon/Xenomorph/Queen/Q = src
					var/atom/phero_center = Q
					if(Q.observed_xeno)
						phero_center = Q.observed_xeno
					if(!phero_center || !phero_center.loc)
						return
					if(phero_center.loc.z == Q.loc.z)//Only same Z-level
						use_current_aura = TRUE
						aura_center = phero_center
				else
					use_current_aura = TRUE

		if(leader_current_aura && hive && hive.living_xeno_queen && hive.living_xeno_queen.loc.z == loc.z) //Same Z-level as the Queen!
			use_leader_aura = TRUE

		if(use_current_aura || use_leader_aura)
			for(var/mob/living/carbon/Xenomorph/Z as anything in GLOB.living_xeno_list)
				if(Z.ignores_pheromones || Z.ignore_aura == current_aura || Z.ignore_aura == leader_current_aura || Z.z != z || get_dist(aura_center, Z) > round(6 + aura_strength * 2) || !HIVE_ALLIED_TO_HIVE(Z.hivenumber, hivenumber))
					continue
				if(use_leader_aura)
					Z.affected_by_pheromones(leader_current_aura, leader_aura_strength)
				if(use_current_aura)
					Z.affected_by_pheromones(current_aura, aura_strength)

	if(frenzy_aura != frenzy_new || warding_aura != warding_new || recovery_aura != recovery_new)
		frenzy_aura = frenzy_new
		warding_aura = warding_new
		recovery_aura = recovery_new
		recalculate_move_delay = TRUE
		hud_set_pheromone()

	frenzy_new = 0
	warding_new = 0
	recovery_new = 0

/mob/living/carbon/Xenomorph/proc/affected_by_pheromones(var/aura, var/strength)
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

/mob/living/carbon/Xenomorph/handle_regular_status_updates(regular_update = TRUE)
	if(regular_update && health <= 0 && (!caste || (caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE) || !on_fire)) //Sleeping Xenos are also unconscious, but all crit Xenos are under 0 HP. Go figure
		var/turf/T = loc
		if(istype(T))
			if(!check_weeds_for_healing()) //In crit, damage is maximal if you're caught off weeds
				apply_damage(2.5 - warding_aura*0.5, BRUTE) //Warding can heavily lower the impact of bleedout. Halved at 2.5 phero, stopped at 5 phero
			else
				apply_damage(-warding_aura, BRUTE)

	updatehealth()

	if(health > 0 && stat != DEAD)	//alive and not in crit! Turn on their vision.
		see_in_dark = 50

		SetEarDeafness(0) //All this stuff is prob unnecessary
		ear_damage = 0
		eye_blind = 0

		if(knocked_out) //If they're down, make sure they are actually down.
			blinded = 1
			stat = UNCONSCIOUS
			if(regular_update && halloss > 0)
				apply_damage(-3, HALLOSS)
		else if(sleeping)
			if(regular_update && halloss > 0)
				apply_damage(-3, HALLOSS)
			if(regular_update && mind)
				if((mind.active && client != null) || immune_to_ssd)
					sleeping = max(sleeping - 1, 0)
			blinded = 1
			stat = UNCONSCIOUS
		else
			blinded = 0
			stat = CONSCIOUS
			if(regular_update && halloss > 0)
				if(resting)
					apply_damage(-3, HALLOSS)
				else
					apply_damage(-1, HALLOSS)

		if(regular_update)
			if(eye_blurry)
				overlay_fullscreen("eye_blurry", /atom/movable/screen/fullscreen/impaired, 5)
				src.eye_blurry--
				src.eye_blurry = max(0, src.eye_blurry)
			else
				clear_fullscreen("eye_blurry")

			handle_statuses()//natural decrease of stunned, knocked_down, etc...
			handle_interference()

	return TRUE

/mob/living/carbon/Xenomorph/proc/handle_stomach_contents()
	//Deal with dissolving/damaging stuff in stomach.
	if(stomach_contents.len)
		for(var/atom/movable/M in stomach_contents)
			if(isHumanStrict(M))
				if(world.time == (devour_timer - 30))
					to_chat(usr, SPAN_WARNING("You're about to regurgitate [M]..."))
					playsound(loc, 'sound/voice/alien_drool1.ogg', 50, 1)
				var/mob/living/carbon/human/H = M
				if(world.time > devour_timer || (H.stat == DEAD && !H.chestburst))
					regurgitate(H)

			M.acid_damage++
			if(M.acid_damage > 300)
				to_chat(src, SPAN_XENODANGER("\The [M] is dissolved in your gut with a gurgle."))
				stomach_contents.Remove(M)
				qdel(M)

/mob/living/carbon/Xenomorph/proc/handle_regular_hud_updates()
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

	var/severity = HUD_PAIN_STATES_XENO - Ceiling(((max(health, 0) / maxHealth) * HUD_PAIN_STATES_XENO))
	if(severity)
		overlay_fullscreen("xeno_pain", /atom/movable/screen/fullscreen/xeno_pain, severity)
	else
		clear_fullscreen("xeno_pain")

	if(blinded)
		overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")

	if(interactee)
		interactee.check_eye(src)
	else if(client && !client.adminobs)
		reset_view(null)

	if(dazed)
		overlay_fullscreen("dazed", /atom/movable/screen/fullscreen/impaired, 5)
	else
		clear_fullscreen("dazed")

	if(!hud_used)
		return TRUE

	if(hud_used.healths)
		var/health_stacks = Ceiling((health / maxHealth) * HUD_HEALTH_STATES_XENO)
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
			hud_used.alien_plasma_display.icon_state = "power_display_[Ceiling(plasma_stacks)]"
			if(plasma_stacks >= HUD_PLASMA_STATES_XENO)
				hud_used.alien_plasma_display.icon_state = "power_display_full"
			else if(plasma_stacks <= 0)
				hud_used.alien_plasma_display.icon_state = "power_display_empty"

	if(hud_used.alien_armor_display)
		var/armor_stacks = min((get_armor_integrity_percentage() * 0.01) * HUD_ARMOR_STATES_XENO, HUD_ARMOR_STATES_XENO)
		hud_used.alien_armor_display.icon_state = "armor_[Floor(armor_stacks)]0"

	return TRUE

/*Heal 1/70th of your max health in brute per tick. 1 as a bonus, to help smaller pools.
Additionally, recovery pheromones mutiply this base healing, up to 2.5 times faster at level 5
Modified via m, to multiply the number of wounds healed.
Heal from fire half as fast
Xenos don't actually take oxyloss, oh well
hmmmm, this is probably unnecessary
Make sure their actual health updates immediately.*/

/mob/living/carbon/Xenomorph/proc/heal_wounds(m, recov)
	var/heal_penalty = 0
	var/list/L = list("healing" = heal_penalty)
	SEND_SIGNAL(src, COMSIG_XENO_ON_HEAL_WOUNDS, L)
	heal_penalty = - L["healing"]
	apply_damage(min(-((maxHealth / 70) + 0.5 + (maxHealth / 70) * recov/2)*(m) + heal_penalty, 0), BRUTE)
	apply_damage(min(-(maxHealth / 60 + 0.5 + (maxHealth / 60) * recov/2)*(m) + heal_penalty, 0), BURN)
	apply_damage(min(-(maxHealth * 0.1 + 0.5 + (maxHealth * 0.1) * recov/2)*(m) + heal_penalty, 0), OXY)
	apply_damage(min(-(maxHealth / 5 + 0.5 + (maxHealth / 5) * recov/2)*(m) + heal_penalty, 0), TOX)
	updatehealth()


/mob/living/carbon/Xenomorph/proc/handle_environment()
	var/turf/T = loc
	var/recoveryActual = (!caste || (caste.fire_immunity & FIRE_IMMUNITY_NO_IGNITE) || fire_stacks == 0) ? recovery_aura : 0
	var/env_temperature = loc.return_temperature()
	if(caste && !(caste.fire_immunity & FIRE_IMMUNITY_NO_DAMAGE))
		if(env_temperature > (T0C + 66))
			apply_damage((env_temperature - (T0C + 66)) / 5, BURN) //Might be too high, check in testing.
			updatehealth() //Make sure their actual health updates immediately
			if(prob(20))
				to_chat(src, SPAN_WARNING("You feel a searing heat!"))

	if(!T || !istype(T))
		return

	var/is_runner_hiding

	if(isXenoRunner(src) && layer != initial(layer))
		is_runner_hiding = 1

	if(caste)
		if(caste.innate_healing || check_weeds_for_healing())
			if(!hive) return // can't heal if you have no hive, sorry bud
			plasma_stored += plasma_gain * plasma_max / 100
			if(recovery_aura)
				plasma_stored += round(plasma_gain * plasma_max / 100 * recovery_aura/4) //Divided by four because it gets massive fast. 1 is equivalent to weed regen! Only the strongest pheromones should bypass weeds
			if(health < maxHealth && !hardcore && is_hive_living(hive) && last_hit_time + caste.heal_delay_time <= world.time)
				if(lying || resting)
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

		else //Xenos restore plasma VERY slowly off weeds, regardless of health, as long as they are not using special abilities
			if(prob(50) && !is_runner_hiding && !current_aura)
				plasma_stored += 0.1 * plasma_max / 100

		if(isXenoHivelord(src))
			var/mob/living/carbon/Xenomorph/Hivelord/H = src
			if(H.weedwalking_activated)
				plasma_stored -= 30
				if(plasma_stored < 0)
					H.weedwalking_activated = 0
					to_chat(src, SPAN_WARNING("You feel dizzy as the world slows down."))
					recalculate_move_delay = TRUE

		if(current_aura)
			plasma_stored -= 5

	if(plasma_stored > plasma_max)
		plasma_stored = plasma_max
	if(plasma_stored < 0)
		plasma_stored = 0
		if(current_aura)
			current_aura = null
			to_chat(src, SPAN_WARNING("You have run out of pheromones and stopped emitting pheromones."))

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

	hud_set_plasma() //update plasma amount on the plasma mob_hud

/mob/living/carbon/Xenomorph/proc/queen_locator()
	if(!hud_used || !hud_used.locate_leader)
		return

	var/atom/movable/screen/queen_locator/QL = hud_used.locate_leader
	if(!loc)
		QL.icon_state = "trackoff"
		return

	var/atom/tracking_atom
	switch(QL.track_state)
		if(TRACKER_QUEEN)
			if(!hive || !hive.living_xeno_queen)
				QL.icon_state = "trackoff"
				return
			tracking_atom = hive.living_xeno_queen
		if(TRACKER_HIVE)
			if(!hive || !hive.hive_location)
				QL.icon_state = "trackoff"
				return
			tracking_atom = hive.hive_location
		else
			var/leader_tracker = text2num(QL.track_state)
			if(!hive || !hive.xeno_leader_list)
				QL.icon_state = "trackoff"
				return
			if(leader_tracker > hive.xeno_leader_list.len)
				QL.icon_state = "trackoff"
				return
			if(!hive.xeno_leader_list[leader_tracker])
				QL.icon_state = "trackoff"
				return
			tracking_atom = hive.xeno_leader_list[leader_tracker]

	if(!tracking_atom)
		QL.icon_state = "trackoff"
		return

	if(tracking_atom.loc.z != loc.z || get_dist(src, tracking_atom) < 1 || src == tracking_atom)
		QL.icon_state = "trackondirect"
	else
		var/area/A = get_area(loc)
		var/area/QA = get_area(tracking_atom.loc)
		if(A.fake_zlevel == QA.fake_zlevel)
			QL.setDir(get_dir(src, tracking_atom))
			QL.icon_state = "trackon"
		else
			QL.icon_state = "trackondirect"

/mob/living/carbon/Xenomorph/proc/mark_locator()
	if(!hud_used || !hud_used.locate_marker || !tracked_marker.loc || !loc)
		return

	var/tracked_marker_z_level = tracked_marker.loc.z 		 //I was getting errors if the mark was deleted while this was operating,
	var/tracked_marker_turf = get_turf(tracked_marker)	 //so I made local variables to circumvent this
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
		ML.setDir(get_dir(src, tracked_marker_turf))
		ML.overlays |= image(tracked_marker.seenMeaning, "pixel_y" = 0)
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "center_glow")
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "direction")
	else //same z level, different fake z levels (decks of almayer)
		ML.overlays |= image(tracked_marker.seenMeaning, "pixel_y" = 0)
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "center_glow")
		ML.overlays |= image('icons/mob/hud/xeno_markers.dmi', "no_direction")

/mob/living/carbon/Xenomorph/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else if(xeno_shields.len != 0)
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
				var/grace_time = crit_grace_time > 0 ? crit_grace_time + (1 SECONDS * max(round(warding_aura - 1), 0)) : 0
				if(grace_time)
					sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC
					addtimer(CALLBACK(src, .proc/handle_crit), grace_time)
				else
					handle_crit()
				next_grace_time = world.time + grace_time
	med_hud_set_health()

/mob/living/carbon/Xenomorph/proc/handle_crit()
	if(stat == DEAD || gibbing)
		return

	sound_environment_override = SOUND_ENVIRONMENT_NONE
	stat = UNCONSCIOUS
	blinded = 1
	see_in_dark = 5
	if(layer != initial(layer)) //Unhide
		layer = initial(layer)
	recalculate_move_delay = TRUE
	if(!lying)
		update_canmove()

/mob/living/carbon/Xenomorph/proc/handle_luminosity()
	var/new_luminosity = 0
	if(caste)
		new_luminosity += caste.caste_luminosity
	if(on_fire)
		new_luminosity += min(fire_stacks, 5)
	SetLuminosity(new_luminosity) // light up xenos

/mob/living/carbon/Xenomorph/handle_stunned()
	if(stunned)
		stunned = max(stunned-1.5,0)
		stun_callback_check()

	return stunned

/mob/living/carbon/Xenomorph/proc/handle_interference()
	if(interference)
		interference = max(interference-2, 0)

	if(observed_xeno && observed_xeno.interference)
		overwatch(observed_xeno,TRUE)

	return interference

/mob/living/carbon/Xenomorph/handle_dazed()
	if(dazed)
		dazed = max(dazed-1.5,0)
	return dazed

/mob/living/carbon/Xenomorph/handle_slowed()
	if(slowed)
		slowed = max(slowed-1.5,0)
	return slowed

/mob/living/carbon/Xenomorph/handle_superslowed()
	if(superslowed)
		superslowed = max(superslowed-1.5,0)
	return superslowed

/mob/living/carbon/Xenomorph/handle_knocked_down()
	if(knocked_down)
		knocked_down = max(knocked_down-1.5,0)
		knocked_down_callback_check()
	return knocked_down

/mob/living/carbon/Xenomorph/handle_knocked_out()
	if(knocked_out)
		knocked_out = max(knocked_out - 1.5, 0)
		knocked_out_callback_check()
	return knocked_out

//Returns TRUE if xeno is on weeds
//Returns TRUE if xeno is off weeds AND doesn't need weeds for healing AND is not on Almayer UNLESS Queen is also on Almayer (aka - no solo Lurker Almayer hero)
/mob/living/carbon/Xenomorph/proc/check_weeds_for_healing()
	var/turf/T = loc

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in T

	if(W && W.linked_hive.is_ally(src))
		return TRUE //weeds, yes!
	if(need_weeds)
		return FALSE //needs weeds, doesn't have any
	if(hive && hive.living_xeno_queen && !is_mainship_level(hive.living_xeno_queen.loc.z) && is_mainship_level(loc.z))
		return FALSE //We are on the ship, but the Queen isn't
	return TRUE //we have off-weed healing, and either we're on Almayer with the Queen, or we're on non-Almayer, or the Queen is dead, good enough!


#define XENO_TIMER_TO_EFFECT_CONVERSION 1.5/20 //once per 2 seconds, with 1.5 effect per that once

// This is here because sometimes our stun comes too early and tick is about to start, so we need to compensate
// this is the best place to do it, tho name might be a bit misleading I guess
/mob/living/carbon/Xenomorph/stun_clock_adjustment()
	var/shift_left = (SSxeno.next_fire - world.time) * XENO_TIMER_TO_EFFECT_CONVERSION
	if(stunned > shift_left)
		stunned += SSxeno.wait * XENO_TIMER_TO_EFFECT_CONVERSION - shift_left

/mob/living/carbon/Xenomorph/knockdown_clock_adjustment()
	var/shift_left = (SSxeno.next_fire - world.time) * XENO_TIMER_TO_EFFECT_CONVERSION
	if(knocked_down > shift_left)
		knocked_down += SSxeno.wait * XENO_TIMER_TO_EFFECT_CONVERSION - shift_left

/mob/living/carbon/Xenomorph/knockout_clock_adjustment()
	var/shift_left = (SSxeno.next_fire - world.time) * XENO_TIMER_TO_EFFECT_CONVERSION
	if(knocked_out > shift_left)
		knocked_out += SSxeno.wait * XENO_TIMER_TO_EFFECT_CONVERSION - shift_left

