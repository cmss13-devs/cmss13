//This is to replace the previous datum/disease/alien_embryo for slightly improved handling and maintainability
//It functions almost identically (see code/datums/diseases/alien_embryo.dm)
/obj/item/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yucky."
	icon = 'icons/mob/xenos/castes/tier_0/larva.dmi'
	icon_state = "Embryo"
	var/mob/living/affected_mob
	var/stage = 0
	var/counter = 0 //How developed the embryo is, if it ages up highly enough it has a chance to burst
	var/larva_autoburst_countdown = 20 //to kick the larva out
	var/hivenumber = XENO_HIVE_NORMAL
	var/faction = FACTION_XENOMORPH
	var/flags_embryo = FALSE // Used in /ciphering/predator property
	/// The ckey of any player hugger that made this embryo
	var/hugger_ckey
	/// The total time the person is hugged divided by stages until burst
	var/per_stage_hugged_time = 90 //Set in Initialize due to config

/obj/item/alien_embryo/Initialize(mapload, ...)
	. = ..()
	per_stage_hugged_time = CONFIG_GET(number/embryo_burst_timer) / 5
	if(istype(loc, /mob/living))
		affected_mob = loc
		affected_mob.status_flags |= XENO_HOST
		START_PROCESSING(SSobj, src)
		if(iscarbon(affected_mob))
			var/mob/living/carbon/affected_carbon = affected_mob
			affected_carbon.med_hud_set_status()
	else
		return INITIALIZE_HINT_QDEL

/obj/item/alien_embryo/Destroy()
	if(affected_mob)
		affected_mob.status_flags &= ~(XENO_HOST)
		if(iscarbon(affected_mob))
			var/mob/living/carbon/affected_carbon = affected_mob
			affected_carbon.med_hud_set_status()
		STOP_PROCESSING(SSobj, src)
		affected_mob = null
	GLOB.player_embryo_list -= src
	. = ..()

/obj/item/alien_embryo/process(delta_time)
	if(!affected_mob) //The mob we were gestating in is straight up gone, we shouldn't be here
		STOP_PROCESSING(SSobj, src)
		qdel(src)
		return FALSE

	if(loc != affected_mob) //Our location is not the host
		affected_mob.status_flags &= ~(XENO_HOST)
		STOP_PROCESSING(SSobj, src)
		if(iscarbon(affected_mob))
			var/mob/living/carbon/affected_carbon = affected_mob
			affected_carbon.med_hud_set_status()
		affected_mob = null
		return FALSE

	if(affected_mob.stat == DEAD)
		if(ishuman(affected_mob))
			var/mob/living/carbon/human/affected_human = affected_mob
			if(world.time > affected_human.timeofdeath + affected_human.revive_grace_period) //Can't be defibbed.
				var/mob/living/carbon/xenomorph/larva/larva_embryo = locate() in affected_mob
				if(larva_embryo)
					larva_embryo.chest_burst(affected_mob)
				qdel(src)
				return FALSE
		else
			var/mob/living/carbon/xenomorph/larva/larva_embryo = locate() in affected_mob
			if(larva_embryo)
				larva_embryo.chest_burst(affected_mob)
			STOP_PROCESSING(SSobj, src)
			return FALSE

	if(affected_mob.in_stasis == STASIS_IN_CRYO_CELL)
		return FALSE //If they are in cryo, the embryo won't grow.

	process_growth(delta_time)

/obj/item/alien_embryo/proc/process_growth(delta_time)
	//Tutorial embryos do not progress.
	if(hivenumber == XENO_HIVE_TUTORIAL)
		return
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	//Low temperature seriously hampers larva growth (as in, way below livable), so does stasis
	if(!hive.hardcore) // Cannot progress if the hive has entered hardcore mode.
		if(affected_mob.in_stasis || affected_mob.bodytemperature < BODYTEMP_CRYO_LIQUID_THRESHOLD)
			if(stage < 5)
				counter += 0.33 * hive.larva_gestation_multiplier * delta_time
			if(stage == 4) // Stasis affects late-stage less
				counter += 0.11 * hive.larva_gestation_multiplier * delta_time
		else if(HAS_TRAIT(affected_mob, TRAIT_NESTED)) //Hosts who are nested in resin nests provide an ideal setting, larva grows faster
			counter += 1.5 * hive.larva_gestation_multiplier * delta_time //Currently twice as much, can be changed
		else
			if(stage < 5)
				counter += 1 * hive.larva_gestation_multiplier * delta_time

		if(stage < 5 && counter >= per_stage_hugged_time)
			counter = 0
			stage++
			if(iscarbon(affected_mob))
				var/mob/living/carbon/affected_carbon = affected_mob
				affected_carbon.med_hud_set_status()

	switch(stage)
		if(2)
			if(prob(4))
				if(!HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
					affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
					affected_mob.visible_message(SPAN_DANGER("[affected_mob] starts shaking uncontrollably!"),
												SPAN_DANGER("You feel something moving inside you! You start shaking uncontrollably!"))
					affected_mob.apply_effect(1, PARALYZE)
					affected_mob.make_jittery(105)
					affected_mob.take_limb_damage(1)
			if(prob(2))
				var/message = SPAN_WARNING("[pick("Your chest hurts a little bit", "Your stomach hurts")].")
				to_chat(affected_mob, message)
		if(3)
			if(prob(2))
				var/message = SPAN_WARNING("[pick("Your throat feels sore", "Mucous runs down the back of your throat")].")
				to_chat(affected_mob, message)
			else if(prob(1))
				to_chat(affected_mob, SPAN_WARNING("Your muscles ache."))
				if(prob(20))
					affected_mob.take_limb_damage(1)
			else if(prob(2))
				affected_mob.emote("[pick("sneeze", "cough")]")
			if(prob(5))
				if(!HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
					affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
					affected_mob.visible_message(SPAN_DANGER("\The [affected_mob] starts shaking uncontrollably!"),
												SPAN_DANGER("You feel something moving inside you! You start shaking uncontrollably!"))
					affected_mob.apply_effect(2, PARALYZE)
					affected_mob.make_jittery(105)
					affected_mob.take_limb_damage(1)
		if(4)
			if(prob(2))
				affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
				var/message = pick("Your chest hurts badly", "It becomes difficult to breathe", "Your heart starts beating rapidly, and each beat is painful")
				message = SPAN_WARNING("[message].")
				to_chat(affected_mob, message)
				if(prob(50))
					affected_mob.emote("scream")
			if(prob(6))
				if(!HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
					affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
					affected_mob.visible_message(SPAN_DANGER("[affected_mob] starts shaking uncontrollably!"),
												SPAN_DANGER("You feel something moving inside you! You start shaking uncontrollably!"))
					affected_mob.apply_effect(3, PARALYZE)
					affected_mob.make_jittery(105)
					affected_mob.take_limb_damage(1)
		if(5)
			become_larva()
		if(7) // Stage 6 is while we are trying to find a candidate in become_larva
			larva_autoburst_countdown--
			if(!larva_autoburst_countdown)
				var/mob/living/carbon/xenomorph/larva/larva_embryo = locate() in affected_mob
				if(larva_embryo)
					larva_embryo.chest_burst(affected_mob)

///We look for a candidate. If found, we spawn the candidate as a larva
///Order of priority is bursted individual (if xeno is enabled), then player hugger, then random candidate, and then it's up for grabs and spawns braindead
/obj/item/alien_embryo/proc/become_larva()
	// We do not allow chest bursts on the Centcomm Z-level, to prevent
	// stranded players from admin experiments and other issues
	if(!affected_mob || should_block_game_interaction(affected_mob))
		return

	stage = 6 // Increase the stage value to prevent this proc getting repeated

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	var/mob/picked
	var/mob/dead/observer/hugger = null
	var/is_nested = istype(affected_mob.buckled, /obj/structure/bed/nest)

	// If the bursted person themselves has Xeno enabled, they get the honor of first dibs on the new larva.
	if((!isyautja(affected_mob) || (isyautja(affected_mob) && prob(20))) && is_nested)
		if(affected_mob.first_xeno || (affected_mob.client?.prefs?.be_special & BE_ALIEN_AFTER_DEATH && !jobban_isbanned(affected_mob, JOB_XENOMORPH)))
			picked = affected_mob
		else if(affected_mob.mind?.ghost_mob && affected_mob.client?.prefs?.be_special & BE_ALIEN_AFTER_DEATH && !jobban_isbanned(affected_mob, JOB_XENOMORPH))
			picked = affected_mob.mind.ghost_mob // This currently doesn't look possible
		else if(affected_mob.persistent_ckey)
			for(var/mob/dead/observer/cur_obs as anything in GLOB.observer_list)
				if(!cur_obs)
					continue
				if(cur_obs.ckey != affected_mob.persistent_ckey)
					continue
				if(cur_obs.client?.prefs?.be_special & BE_ALIEN_AFTER_DEATH && !jobban_isbanned(cur_obs, JOB_XENOMORPH))
					picked = cur_obs
				break

	if(!picked)
		// Get a candidate from observers
		var/list/candidates = get_alien_candidates(hive, abomination = (isyautja(affected_mob) || (flags_embryo & FLAG_EMBRYO_PREDATOR)))
		if(candidates && length(candidates))
			// If they were facehugged by a player thats still in queue, they get second dibs on the new larva.
			if(hugger_ckey)
				for(var/mob/dead/observer/cur_obs as anything in candidates)
					if(cur_obs.ckey == hugger_ckey)
						hugger = cur_obs
						if(!is_nested)
							cur_obs.ManualFollow(affected_mob)
							if(cur_obs.client.prefs?.toggles_flashing & FLASH_POOLSPAWN)
								window_flash(cur_obs.client)
						if(is_nested || tgui_alert(cur_obs, "An unnested host you hugged is about to burst! Do you want to control the new larva?", "Larva maturation", list("Yes", "No"), 10 SECONDS) == "Yes")
							picked = cur_obs
							candidates -= cur_obs
							message_alien_candidates(candidates, dequeued = 0)
							for(var/obj/item/alien_embryo/embryo as anything in GLOB.player_embryo_list)
								if(!embryo)
									continue
								if(embryo.hugger_ckey == cur_obs.ckey && embryo != src)
									// Skipping src just in case an admin wants to quickly check before this thing fully deletes
									// If this nulls out any embryo, wow
									embryo.hugger_ckey = null
						break

			// Get a candidate from the front of the queue
			if(!picked)
				if(is_nested)
					picked = candidates[1]
					message_alien_candidates(candidates, dequeued = 1)
				else
					// Make up to 5 attempts from the queue for an unnested host
					// At 10s per candidate, for 6 candidates (facehugger is the +1) this means we may have delayed an unnested autoburst up to 60 seconds
					for(var/i in 1 to min(5, length(candidates)))
						var/mob/dead/observer/cur_candidate = candidates[i]
						if(!cur_candidate?.client) // Make sure they are still a valid candidate since tgui_alerts may have delayed us to this point
							continue
						if(cur_candidate == hugger)
							continue // They were already asked
						cur_candidate.ManualFollow(affected_mob)
						if(cur_candidate.client.prefs?.toggles_flashing & FLASH_POOLSPAWN)
							window_flash(cur_candidate.client)
						if(tgui_alert(cur_candidate, "An unnested host is about to burst! Do you want to control the new larva?", "Larva maturation", list("Yes", "No"), 10 SECONDS) == "Yes")
							picked = cur_candidate
							candidates -= cur_candidate
							message_alien_candidates(candidates, dequeued = 0)
							break

	// Spawn the larva
	var/mob/living/carbon/xenomorph/larva/new_xeno

	if(isyautja(affected_mob) || (flags_embryo & FLAG_EMBRYO_PREDATOR))
		new_xeno = new /mob/living/carbon/xenomorph/larva/predalien(affected_mob)
	else
		new_xeno = new(affected_mob)

	if(hive)
		hive.add_xeno(new_xeno)
		if(!affected_mob.first_xeno && hive.hive_location)
			hive.increase_larva_after_burst()
			hive.hive_ui.update_burrowed_larva()

	new_xeno.update_icons()

	new_xeno.cause_unbearable_pain(affected_mob) //the embryo is now a larva!! its so painful, ow!

	// If we have a candidate, transfer it over
	if(picked)
		new_xeno.key = picked.key

		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)
			if(new_xeno.client.prefs?.toggles_flashing & FLASH_POOLSPAWN)
				window_flash(new_xeno.client)

		SSround_recording.recorder.track_player(new_xeno)
		if(HAS_TRAIT(affected_mob, TRAIT_LISPING))
			ADD_TRAIT(new_xeno, TRAIT_LISPING, affected_mob)

		to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva inside a host! Move to burst out of it!"))
		to_chat(new_xeno, "<B>Your job is to spread the hive and protect the Queen. If there's no Queen, you can become the Queen yourself by evolving into a drone.</B>")
		to_chat(new_xeno, "Talk in Hivemind using <strong>;</strong> (e.g. ';My life for the queen!')")
		playsound_client(new_xeno.client, 'sound/effects/xeno_newlarva.ogg', 25, 1)

	// Inform observers to grab some popcorn if it isnt nested
	if(!HAS_TRAIT(affected_mob, TRAIT_NESTED))
		var/area/burst_area = get_area(src)
		var/area_text = burst_area ? " at <b>[burst_area]</b>" : ""
		notify_ghosts(header = "Burst Imminent", message = "A <b>[new_xeno.hive.prefix]Larva</b> is about to chestburst out of <b>[affected_mob]</b>[area_text]!", source = affected_mob)

	stage = 7 // Begin the autoburst countdown

/mob/living/carbon/xenomorph/larva/proc/cause_unbearable_pain(mob/living/carbon/victim)
	if(loc != victim)
		return
	victim.emote("scream")
	if(prob(50)) //dont want them passing out too quick D:
		victim.pain.apply_pain(PAIN_CHESTBURST_STRONG)  //ow that really hurts larvie!
	var/message = SPAN_HIGHDANGER( pick("IT'S IN YOUR INSIDES!", "IT'S GNAWING YOU!", "MAKE IT STOP!", "YOU ARE GOING TO DIE!", "IT'S TEARING YOU APART!"))
	to_chat(victim, message)
	addtimer(CALLBACK(src, PROC_REF(cause_unbearable_pain), victim), rand(1, 3) SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/mob/living/carbon/xenomorph/larva/proc/chest_burst(mob/living/carbon/victim)
	set waitfor = 0
	if(victim.chestburst || loc != victim)
		return
	victim.chestburst = TRUE
	to_chat(src, SPAN_DANGER("We start bursting out of [victim]'s chest!"))
	if(!HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
		victim.apply_effect(20, DAZE)
	victim.visible_message(SPAN_DANGER("\The [victim] starts shaking uncontrollably!"),
						SPAN_DANGER("You feel something ripping up your insides!"))
	victim.make_jittery(300)
	sleep(30)
	if(!victim || !victim.loc)
		return//host could've been deleted, or we could've been removed from host.
	if(loc != victim)
		victim.chestburst = 0
		return
	if(ishuman(victim) || isyautja(victim))
		victim.emote("burstscream")
	sleep(25) //Sound delay
	victim.update_burst()
	sleep(10) //Sprite delay
	if(!victim || !victim.loc)
		return
	if(loc != victim)
		victim.chestburst = 0 //if a doc removes the larva during the sleep(10), we must remove the 'bursting' overlay on the human
		victim.update_burst()
		return

	var/burstcount = 0

	victim.spawn_gibs()

	for(var/mob/living/carbon/xenomorph/larva/larva_embryo in victim)
		var/datum/hive_status/hive = GLOB.hive_datum[larva_embryo.hivenumber]
		larva_embryo.forceMove(get_turf(victim)) //moved to the turf directly so we don't get stuck inside a cryopod or another mob container.
		larva_embryo.grant_spawn_protection(1 SECONDS)
		playsound(larva_embryo, pick('sound/voice/alien_chestburst.ogg','sound/voice/alien_chestburst2.ogg'), 25)

		if(larva_embryo.client)
			larva_embryo.set_lighting_alpha_from_prefs(larva_embryo.client)

		larva_embryo.attack_log += "\[[time_stamp()]\]<font color='red'> chestbursted from [key_name(victim)] in [get_area_name(larva_embryo)] at X[victim.x], Y[victim.y], Z[victim.z]</font>"
		victim.attack_log += "\[[time_stamp()]\]<font color='orange'> Was chestbursted in [get_area_name(larva_embryo)] at X[victim.x], Y[victim.y], Z[victim.z]. The larva was [key_name(larva_embryo)].</font>"

		if(burstcount)
			step(larva_embryo, pick(GLOB.cardinals))

		if(GLOB.round_statistics && (ishuman(victim)) && (SSticker.current_state == GAME_STATE_PLAYING) && (ROUND_TIME > 1 MINUTES))
			GLOB.round_statistics.total_larva_burst++
		GLOB.larva_burst_by_hive[hive] = (GLOB.larva_burst_by_hive[hive] || 0) + 1
		burstcount++

		if(!larva_embryo.ckey && larva_embryo.burrowable && loc && is_ground_level(loc.z) && (locate(/obj/structure/bed/nest) in loc) && hive.living_xeno_queen && hive.living_xeno_queen.z == loc.z)
			larva_embryo.visible_message(SPAN_XENODANGER("[larva_embryo] quickly burrows into the ground."))
			if(GLOB.round_statistics && !larva_embryo.statistic_exempt)
				GLOB.round_statistics.track_new_participant(faction, -1) // keep stats sane
			hive.stored_larva++
			hive.hive_ui.update_burrowed_larva()
			qdel(larva_embryo)

		if(!victim.first_xeno)
			if(hive.hive_orders)
				to_chat(larva_embryo, SPAN_XENOHIGHDANGER("The Queen's will overwhelms our instincts..."))
				to_chat(larva_embryo, SPAN_XENOHIGHDANGER("\"[hive.hive_orders]\""))
			log_attack("[key_name(victim)] chestbursted in [get_area_name(larva_embryo)] at X[victim.x], Y[victim.y], Z[victim.z]. The larva was [key_name(larva_embryo)].") //this is so that admins are not spammed with los logs

	for(var/obj/item/alien_embryo/AE in victim)
		qdel(AE)

	var/datum/cause_data/cause = create_cause_data("chestbursting", src)
	if(burstcount >= 4)
		victim.gib(cause)
	else
		if(ishuman(victim))
			var/mob/living/carbon/human/victim_human = victim
			victim_human.last_damage_data = cause
			var/datum/internal_organ/O
			var/i
			for(i in list("heart","lungs")) //This removes (and later garbage collects) both organs. No heart means instant death.
				O = victim_human.internal_organs_by_name[i]
				victim_human.internal_organs_by_name -= i
				victim_human.internal_organs -= O
		victim.death(cause) // Certain species were still surviving bursting (predators), DEFINITELY kill them this time.
		victim.chestburst = 2
		victim.update_burst()
