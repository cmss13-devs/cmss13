//Xenomorph Life - Colonial Marines - Apophis775 - Last Edit: 03JAN2015

#define XENO_ARMOR_REGEN_DELAY SECONDS_30
/mob/living/carbon/Xenomorph/Life()
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

		if (behavior_delegate)
			var/datum/behavior_delegate/MD = behavior_delegate
			MD.on_life()


		if(loc)
			handle_environment()
		if(client)
			handle_regular_hud_updates()

/mob/living/carbon/Xenomorph/proc/update_progression()
	var/progress_amount = 1

	if((hive.living_xeno_queen && hive.living_xeno_queen.ovipositor) || (ticker.game_start_time + XENO_HIVE_EVOLUTION_FREETIME) >= world.time)
		progress_amount = SSxevolution.boost_power

	if(upgrade != -1 && upgrade < 3 && (hive && !hive.living_xeno_queen || hive && hive.living_xeno_queen.loc.z == loc.z)) //upgrade possible
		upgrade_stored = min(upgrade_stored + progress_amount, upgrade_threshold)

		if(upgrade_stored >= upgrade_threshold && !is_mob_incapacitated() && !handcuffed && !legcuffed && map_tag != MAP_WHISKEY_OUTPOST)
			INVOKE_ASYNC(src, .proc/upgrade_xeno, (upgrade + 1))

	//Add on any bonuses from evopods after applying upgrade progress
	if(hive && hive.has_special_structure(XENO_STRUCTURE_EVOPOD) && check_weeds_for_healing())
		progress_amount += (0.2 * hive.has_special_structure(XENO_STRUCTURE_EVOPOD))

	if(caste && caste.evolution_allowed && evolution_stored < evolution_threshold && hive.living_xeno_queen && (hive.living_xeno_queen.ovipositor || (ticker.game_start_time + XENO_HIVE_EVOLUTION_FREETIME) >= world.time))
		evolution_stored = min(evolution_stored + progress_amount, evolution_threshold)
		if(evolution_stored >= evolution_threshold - 1)
			to_chat(src, SPAN_XENODANGER("Your carapace crackles and your tendons strengthen. You are ready to evolve!")) //Makes this bold so the Xeno doesn't miss it
			src << sound('sound/effects/xeno_evolveready.ogg')

/mob/living/carbon/Xenomorph/proc/handle_xeno_fire()
	if(on_fire)
		var/obj/item/clothing/mask/facehugger/F = get_active_hand()
		var/obj/item/clothing/mask/facehugger/G = get_inactive_hand()
		if(istype(F))
			F.Die()
			drop_inv_item_on_ground(F)
		if(istype(G))
			G.Die()
			drop_inv_item_on_ground(G)
		if(!caste || !caste.fire_immune)
			var/dmg = armor_damage_reduction(config.xeno_fire, fire_stacks * 2 + 4.5)
			adjustFireLoss(dmg)

/mob/living/carbon/Xenomorph/proc/handle_pheromones()
	//Rollercoaster of fucking stupid because Xeno life ticks aren't synchronised properly and values reset just after being applied
	//At least it's more efficient since only Xenos with an aura do this, instead of all Xenos
	//Basically, we use a special tally var so we don't reset the actual aura value before making sure they're not affected
	//Now moved out of healthy only state, because crit xenos can def still be affected by pheros

	if(aura_strength > 0) //Ignoring pheromone underflow
		if(current_aura && !stat && plasma_stored > 5)
			if(caste_name == "Queen" && anchored) //stationary queen's pheromone apply around the observed xeno.
				var/mob/living/carbon/Xenomorph/Queen/Q = src
				var/atom/phero_center = Q
				if(Q.observed_xeno)
					phero_center = Q.observed_xeno
				if(!phero_center || !phero_center.loc)
					return
				if(phero_center.loc.z == Q.loc.z)//Only same Z-level
					var/pheromone_range = round(6 + aura_strength * 2)
					for(var/mob/living/carbon/Xenomorph/Z in range(pheromone_range, phero_center)) //Goes from 8 for Queen to 16 for Ancient Queen
						if(Z.ignores_pheromones)
							continue
						if((current_aura == "all" || current_aura == "frenzy") && aura_strength > Z.frenzy_new && hivenumber == Z.hivenumber)
							Z.frenzy_new = aura_strength
						if((current_aura == "all" || current_aura == "warding") && aura_strength > Z.warding_new && hivenumber == Z.hivenumber)
							Z.warding_new = aura_strength
						if((current_aura == "all" || current_aura == "recovery") && aura_strength > Z.recovery_new && hivenumber == Z.hivenumber)
							Z.recovery_new = aura_strength
			else
				var/pheromone_range = round(6 + aura_strength * 2)
				for(var/mob/living/carbon/Xenomorph/Z in range(pheromone_range, src)) //Goes from 7 for Young Drone to 16 for Ancient Queen
					if(Z.ignores_pheromones)
						continue
					if((current_aura == "all" || current_aura == "frenzy") && aura_strength > Z.frenzy_new && hivenumber == Z.hivenumber)
						Z.frenzy_new = aura_strength
					if((current_aura == "all" || current_aura == "warding") && aura_strength > Z.warding_new && hivenumber == Z.hivenumber)
						Z.warding_new = aura_strength
					if((current_aura == "all" || current_aura == "recovery") && aura_strength > Z.recovery_new && hivenumber == Z.hivenumber)
						Z.recovery_new = aura_strength


	if(hive && hive.living_xeno_queen && hive.living_xeno_queen.loc.z == loc.z) //Same Z-level as the Queen!
		if(leader_current_aura && !stat)
			var/pheromone_range = round(6 + leader_aura_strength * 2)
			for(var/mob/living/carbon/Xenomorph/Z in range(pheromone_range, src)) //Goes from 7 for Young Drone to 16 for Ancient Queen
				if(Z.ignores_pheromones)
					continue
				if((leader_current_aura == "all" || leader_current_aura == "frenzy") && leader_aura_strength > Z.frenzy_new && hivenumber == Z.hivenumber)
					Z.frenzy_new = leader_aura_strength
				if((leader_current_aura == "all" || leader_current_aura == "warding") && leader_aura_strength > Z.warding_new && hivenumber == Z.hivenumber)
					Z.warding_new = leader_aura_strength
				if((leader_current_aura == "all" || leader_current_aura == "recovery") && leader_aura_strength > Z.recovery_new && hivenumber == Z.hivenumber)
					Z.recovery_new = leader_aura_strength
	
	if(ignores_pheromones)
		frenzy_aura = 0
		warding_aura = 0
		recovery_aura = 0
		hud_set_pheromone()
		return

	if(frenzy_aura != frenzy_new || warding_aura != warding_new || recovery_aura != recovery_new)
		frenzy_aura = frenzy_new
		warding_aura = warding_new
		recovery_aura = recovery_new
		recalculate_move_delay = TRUE
		hud_set_pheromone()

	frenzy_new = 0
	warding_new = 0
	recovery_new = 0

/mob/living/carbon/Xenomorph/handle_regular_status_updates(regular_update = TRUE)
	if(regular_update && health <= 0 && (!caste || caste.fire_immune || !on_fire)) //Sleeping Xenos are also unconscious, but all crit Xenos are under 0 HP. Go figure
		var/turf/T = loc
		if(istype(T))
			if(!check_weeds_for_healing()) //In crit, damage is maximal if you're caught off weeds
				adjustBruteLoss(2.5 - warding_aura*0.5) //Warding can heavily lower the impact of bleedout. Halved at 2.5 phero, stopped at 5 phero
			else
				adjustBruteLoss(-warding_aura)

	updatehealth()

	if(health <= crit_health - warding_aura * 20) //dead
		if(prob(gib_chance + 0.5*(crit_health - health)))
			gib(last_damage_source)
		else
			death(last_damage_source)
		return

	else if(health <= 0) //in crit
		if(hardcore)
			if(prob(gib_chance))
				gib(last_damage_source)
			else
				death(last_damage_source)
		else
			stat = UNCONSCIOUS
			blinded = 1
			see_in_dark = 5
			if(isXenoRunner(src) && layer != initial(layer)) //Unhide
				layer = MOB_LAYER

	else						//alive and not in crit! Turn on their vision.
		if(isXenoBoiler(src))
			see_in_dark = 20
		else
			see_in_dark = 8

		ear_deaf = 0 //All this stuff is prob unnecessary
		ear_damage = 0
		eye_blind = 0
		eye_blurry = 0

		if(knocked_out) //If they're down, make sure they are actually down.
			if(regular_update)
				AdjustKnockedout(-3)
			blinded = 1
			stat = UNCONSCIOUS
			if(regular_update && halloss > 0)
				adjustHalLoss(-3)
		else if(sleeping)
			if(regular_update && halloss > 0)
				adjustHalLoss(-3)
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
					adjustHalLoss(-3)
				else
					adjustHalLoss(-1)

		if(regular_update)
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
				if(world.time > devour_timer || H.stat == DEAD)
					regurgitate(H, 0)

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
		overlay_fullscreen("xeno_pain", /obj/screen/fullscreen/xeno_pain, severity)
	else
		clear_fullscreen("xeno_pain")

	if(blinded)
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")

	if(interactee)
		interactee.check_eye(src)
	else if(client && !client.adminobs)
		reset_view(null)

	if(dazed)
		overlay_fullscreen("dazed", /obj/screen/fullscreen/blurry)
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

#define XENO_HEAL_WOUNDS(m, recov) \
adjustBruteLoss(-((maxHealth / 70) + 0.5 + (maxHealth / 70) * recov/2)*(m)); \
adjustFireLoss(-(maxHealth / 60 + 0.5 + (maxHealth / 60) * recov/2)*(m)); \
adjustOxyLoss(-(maxHealth * 0.1 + 0.5 + (maxHealth * 0.1) * recov/2)*(m)); \
adjustToxLoss(-(maxHealth / 5 + 0.5 + (maxHealth / 5) * recov/2)*(m)); \
updatehealth()


/mob/living/carbon/Xenomorph/proc/handle_environment()
	var/turf/T = loc
	var/recoveryActual = (!caste || caste.fire_immune || fire_stacks == 0) ? recovery_aura : 0
	var/env_temperature = loc.return_temperature()
	if(caste && !caste.fire_immune)
		if(env_temperature > (T0C + 66))
			adjustFireLoss((env_temperature - (T0C + 66)) / 5) //Might be too high, check in testing.
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
			plasma_stored += plasma_gain * plasma_max / 100
			if(recovery_aura)
				plasma_stored += round(plasma_gain * plasma_max / 100 * recovery_aura/4) //Divided by four because it gets massive fast. 1 is equivalent to weed regen! Only the strongest pheromones should bypass weeds
			if(health < maxHealth && !hardcore)
				//var/datum/hive_status/hive = hive_datum[hivenumber]
				//if(caste.innate_healing || !hive.living_xeno_queen || hive.living_xeno_queen.loc.z == loc.z)
				if(lying || resting)
					if(health > -100 && health < 0) //Unconscious
						XENO_HEAL_WOUNDS(0.33,recoveryActual) //Healing is much slower. Warding pheromones make up for the rest if you're curious
					else
						XENO_HEAL_WOUNDS(1,recoveryActual)
				else if(isXenoCrusher(src) || isXenoRavager(src))
					XENO_HEAL_WOUNDS(0.66,recoveryActual)
				else
					XENO_HEAL_WOUNDS(0.40,recoveryActual) //Healing nerf if standing
				updatehealth()

			if(armor_integrity < armor_integrity_max && armor_deflection > 0 && world.time > armor_integrity_last_damage_time + XENO_ARMOR_REGEN_DELAY)
				var/curve_factor = armor_integrity/armor_integrity_max
				curve_factor *= curve_factor
				if(curve_factor < 0.5)
					curve_factor = 0.5
				if(armor_integrity/armor_integrity_max < 0.3)
					curve_factor /= 2

				var/factor = ((armor_deflection / 60) * MINUTES_6 / SECONDS_2) // 60 armor is restored in 10 minutes in 2 seconds intervals
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

	if(hive && !hive.living_xeno_queen || (caste && caste.is_intelligent) || !loc)
		hud_used.locate_leader.icon_state = "trackoff"
		return

	if(hive && hive.living_xeno_queen.loc.z != loc.z || get_dist(src,hive.living_xeno_queen) < 1 || src == hive.living_xeno_queen)
		hud_used.locate_leader.icon_state = "trackondirect"
	else
		var/area/A = get_area(loc)
		var/area/QA = get_area(hive.living_xeno_queen.loc)
		if(A.fake_zlevel == QA.fake_zlevel)
			hud_used.locate_leader.dir = get_dir(src,hive.living_xeno_queen)
			hud_used.locate_leader.icon_state = "trackon"
		else
			hud_used.locate_leader.icon_state = "trackondirect"

/mob/living/carbon/Xenomorph/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else if(xeno_shields.len != 0)
		overlay_shields()
		health = maxHealth - getFireLoss() - getBruteLoss()
	else
		health = maxHealth - getFireLoss() - getBruteLoss() //Xenos can only take brute and fire damage.

	recalculate_move_delay = TRUE

	med_hud_set_health()
	med_hud_set_armor()

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
		interference -= 2

	if(observed_xeno && observed_xeno.interference)
		overwatch(observed_xeno,TRUE)

	return interference

/mob/living/carbon/Xenomorph/handle_dazed()
	if(dazed)
		dazed = max(dazed-1.5,0)
	return dazed

/mob/living/carbon/Xenomorph/handle_slowed()
	if(slowed)
		slowed = max(superslowed-1.5,0)
	return stunned

/mob/living/carbon/Xenomorph/handle_superslowed()
	if(superslowed)
		superslowed = max(superslowed-1.5,0)
	return dazed

/mob/living/carbon/Xenomorph/handle_knocked_down()
	if(knocked_down)
		knocked_down = max(knocked_down-1.5,0)
		knocked_down_callback_check()
	return knocked_down

//Returns TRUE if xeno is on weeds
//Returns TRUE if xeno is off weeds AND doesn't need weeds for healing AND is not on Almayer UNLESS Queen is also on Almayer (aka - no solo Lurker Almayer hero)
/mob/living/carbon/Xenomorph/proc/check_weeds_for_healing()
	var/turf/T = loc
	if(locate(/obj/effect/alien/weeds) in T)
		return TRUE //weeds, yes!
	if(need_weeds)
		return FALSE //needs weeds, doesn't have any
	if(hive && hive.living_xeno_queen && hive.living_xeno_queen.loc.z != MAIN_SHIP_Z_LEVEL && loc.z == MAIN_SHIP_Z_LEVEL)
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
