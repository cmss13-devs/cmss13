//This is to replace the previous datum/disease/alien_embryo for slightly improved handling and maintainability
//It functions almost identically (see code/datums/diseases/alien_embryo.dm)
/obj/item/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yucky."
	icon = 'icons/mob/xenos/larva.dmi'
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

/obj/item/alien_embryo/Initialize(mapload, ...)
	. = ..()
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

/obj/item/alien_embryo/process()
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

	process_growth()

/obj/item/alien_embryo/proc/process_growth()
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	//Low temperature seriously hampers larva growth (as in, way below livable), so does stasis
	if(!hive.hardcore) // Cannot progress if the hive has entered hardcore mode.
		if(affected_mob.in_stasis || affected_mob.bodytemperature < 170)
			if(stage < 5)
				counter += 0.33 * hive.larva_gestation_multiplier
			else if(stage == 4)
				counter += 0.11 * hive.larva_gestation_multiplier
		else if(HAS_TRAIT(affected_mob, TRAIT_NESTED)) //Hosts who are nested in resin nests provide an ideal setting, larva grows faster
			counter += 1.5 * hive.larva_gestation_multiplier //Currently twice as much, can be changed
		else
			if(stage < 5)
				counter += 1 * hive.larva_gestation_multiplier

		if(stage < 5 && counter >= 90)
			counter = 0
			stage++
			if(iscarbon(affected_mob))
				var/mob/living/carbon/affected_carbon = affected_mob
				affected_carbon.med_hud_set_status()

	switch(stage)
		if(2)
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
		if(4)
			if(prob(1))
				if(affected_mob.knocked_out < 1)
					affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
					affected_mob.visible_message(SPAN_DANGER("\The [affected_mob] starts shaking uncontrollably!"), \
												SPAN_DANGER("You start shaking uncontrollably!"))
					affected_mob.apply_effect(10, PARALYZE)
					affected_mob.make_jittery(105)
					affected_mob.take_limb_damage(1)
			if(prob(2))
				affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
				var/message = pick("Your chest hurts badly", "It becomes difficult to breathe", "Your heart starts beating rapidly, and each beat is painful")
				message = SPAN_WARNING("[message].")
				to_chat(affected_mob, message)
				if(prob(50))
					affected_mob.emote("scream")
		if(5)
			become_larva()
		if(6)
			larva_autoburst_countdown--
			if(!larva_autoburst_countdown)
				var/mob/living/carbon/xenomorph/larva/larva_embryo = locate() in affected_mob
				if(larva_embryo)
					larva_embryo.chest_burst(affected_mob)

//We look for a candidate. If found, we spawn the candidate as a larva
//Order of priority is bursted individual (if xeno is enabled), then random candidate, and then it's up for grabs and spawns braindead
/obj/item/alien_embryo/proc/become_larva()
	// We do not allow chest bursts on the Centcomm Z-level, to prevent
	// stranded players from admin experiments and other issues
	if(!affected_mob || is_admin_level(affected_mob.z))
		return

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	var/mob/picked
	// If the bursted person themselves has Xeno enabled, they get the honor of first dibs on the new larva.
	if((!isyautja(affected_mob) || (isyautja(affected_mob) && prob(20))) && istype(affected_mob.buckled, /obj/structure/bed/nest))
		if(affected_mob.first_xeno || (affected_mob.client && affected_mob.client.prefs && (affected_mob.client.prefs.be_special & BE_ALIEN_AFTER_DEATH) && !jobban_isbanned(affected_mob, JOB_XENOMORPH)))
			picked = affected_mob
		else if(affected_mob.mind && affected_mob.mind.ghost_mob && affected_mob.client && affected_mob.client.prefs && (affected_mob.client.prefs.be_special & BE_ALIEN_AFTER_DEATH) && !jobban_isbanned(affected_mob, JOB_XENOMORPH))
			picked = affected_mob.mind.ghost_mob

	if(!picked)
		// Get a candidate from observers
		var/list/candidates = get_alien_candidates()
		if(candidates && candidates.len)
			// If they were facehugged by a player thats still in queue, they get second dibs on the new larva.
			if(hugger_ckey)
				for(var/mob/dead/observer/cur_obs as anything in candidates)
					if(cur_obs.ckey == hugger_ckey)
						picked = cur_obs
						candidates -= cur_obs
						message_alien_candidates(candidates, dequeued = 0)
						for(var/obj/item/alien_embryo/embryo as anything in GLOB.player_embryo_list)
							if(embryo.hugger_ckey == cur_obs.ckey && embryo != src)
								// Skipping src just in case an admin wants to quickly check before this thing fully deletes
								// If this nulls out any embryo, wow
								embryo.hugger_ckey = null
						break

			if(!picked)
				picked = candidates[1]
				message_alien_candidates(candidates, dequeued = 1)

	// Spawn the larva
	var/mob/living/carbon/xenomorph/larva/new_xeno

	if(isyautja(affected_mob) || (flags_embryo & FLAG_EMBRYO_PREDATOR))
		new_xeno = new /mob/living/carbon/xenomorph/larva/predalien(affected_mob)
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nAn abomination has been detected at [get_area_name(new_xeno)]. It is a stain upon our purity and is unfit for life. Exterminate it immediately"))
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
			new_xeno.client.change_view(world_view_size)

		SSround_recording.recorder.track_player(new_xeno)

		to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva inside a host! Move to burst out of it!"))
		to_chat(new_xeno, "<B>Your job is to spread the hive and protect the Queen. If there's no Queen, you can become the Queen yourself by evolving into a drone.</B>")
		to_chat(new_xeno, "Talk in Hivemind using <strong>;</strong> (e.g. ';My life for the queen!')")
		playsound_client(new_xeno.client, 'sound/effects/xeno_newlarva.ogg', 25, 1)

	stage = 6

/mob/living/carbon/xenomorph/larva/proc/cause_unbearable_pain(mob/living/carbon/victim)
	if(loc != victim)
		return
	victim.emote("scream")
	if(prob(50)) //dont want them passing out too quick D:
		victim.pain.apply_pain(PAIN_CHESTBURST_STRONG)  //ow that really hurts larvie!
	var/message = SPAN_HIGHDANGER( pick("IT'S IN YOUR INSIDES!", "IT'S GNAWING YOU!", "MAKE IT STOP!", "YOU ARE GOING TO DIE!", "IT'S TEARING YOU APART!"))
	to_chat(victim, message)
	addtimer(CALLBACK(src, PROC_REF(cause_unbearable_pain), victim), rand(1, 3) SECONDS, TIMER_UNIQUE)

/mob/living/carbon/xenomorph/larva/proc/chest_burst(mob/living/carbon/victim)
	set waitfor = 0
	if(victim.chestburst || loc != victim)
		return
	victim.chestburst = TRUE
	to_chat(src, SPAN_DANGER("You start bursting out of [victim]'s chest!"))
	if(victim.knocked_out < 1)
		victim.apply_effect(20, DAZE)
	victim.visible_message(SPAN_DANGER("\The [victim] starts shaking uncontrollably!"), \
						SPAN_DANGER("You feel something ripping up your insides!"))
	victim.make_jittery(300)
	sleep(30)
	if(!victim || !victim.loc)
		return//host could've been deleted, or we could've been removed from host.
	if(loc != victim)
		victim.chestburst = 0
		return
	victim.update_burst()
	sleep(6) //Sprite delay
	if(!victim || !victim.loc)
		return
	if(loc != victim)
		victim.chestburst = 0 //if a doc removes the larva during the sleep(6), we must remove the 'bursting' overlay on the human
		victim.update_burst()
		return

	if(isyautja(victim))
		victim.emote("roar")
	else
		victim.emote("scream")

	var/burstcount = 0

	victim.spawn_gibs()

	for(var/mob/living/carbon/xenomorph/larva/larva_embryo in victim)
		var/datum/hive_status/hive = GLOB.hive_datum[larva_embryo.hivenumber]
		larva_embryo.forceMove(get_turf(victim)) //moved to the turf directly so we don't get stuck inside a cryopod or another mob container.
		playsound(larva_embryo, pick('sound/voice/alien_chestburst.ogg','sound/voice/alien_chestburst2.ogg'), 25)

		if(larva_embryo.client)
			larva_embryo.set_lighting_alpha_from_prefs(larva_embryo.client)

		larva_embryo.attack_log += "\[[time_stamp()]\]<font color='red'> chestbursted from [key_name(victim)]</font>"
		victim.attack_log += "\[[time_stamp()]\]<font color='orange'> Was chestbursted, larva was [key_name(larva_embryo)]</font>"

		if(burstcount)
			step(larva_embryo, pick(cardinal))

		if(round_statistics)
			round_statistics.total_larva_burst++
		burstcount++

		if(!larva_embryo.ckey && larva_embryo.burrowable && loc && is_ground_level(loc.z) && (locate(/obj/structure/bed/nest) in loc) && hive.living_xeno_queen && hive.living_xeno_queen.z == loc.z)
			larva_embryo.visible_message(SPAN_XENODANGER("[larva_embryo] quickly burrows into the ground."))
			if(round_statistics && !larva_embryo.statistic_exempt)
				round_statistics.track_new_participant(faction, -1) // keep stats sane
			hive.stored_larva++
			hive.hive_ui.update_burrowed_larva()
			qdel(larva_embryo)

		if(!victim.first_xeno)
			to_chat(larva_embryo, SPAN_XENOHIGHDANGER("The Queen's will overwhelms your instincts..."))
			to_chat(larva_embryo, SPAN_XENOHIGHDANGER("\"[hive.hive_orders]\""))
			log_attack("[key_name(victim)] chestbursted, the larva was [key_name(larva_embryo)].") //this is so that admins are not spammed with los logs

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

// Squeeze thru dense objects as a larva, as airlocks
/mob/living/carbon/xenomorph/larva/proc/scuttle(obj/structure/target)
	var/move_dir = get_dir(src, loc)
	for(var/atom/movable/AM in get_turf(target))
		if(AM != target && AM.density && AM.BlockedPassDirs(src, move_dir))
			to_chat(src, SPAN_WARNING("\The [AM] prevents you from squeezing under \the [target]!"))
			return
	// Is it an airlock?
	if(istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/selected_airlock = target
		if(selected_airlock.locked || selected_airlock.welded) //Can't pass through airlocks that have been bolted down or welded
			to_chat(src, SPAN_WARNING("\The [selected_airlock] is locked down tight. You can't squeeze underneath!"))
			return
	visible_message(SPAN_WARNING("\The [src] scuttles underneath \the [target]!"), \
	SPAN_WARNING("You squeeze and scuttle underneath \the [target]."), null, 5)
	forceMove(target.loc)
