//This is to replace the previous datum/disease/alien_embryo for slightly improved handling and maintainability
//It functions almost identically (see code/datums/diseases/alien_embryo.dm)
/obj/item/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yucky."
	icon_state = "Larva Dead"
	var/mob/living/affected_mob
	var/stage = 0
	var/counter = 0 //How developed the embryo is, if it ages up highly enough it has a chance to burst
	var/larva_autoburst_countdown = 20 //to kick the larva out
	var/hivenumber = XENO_HIVE_NORMAL
	var/faction = FACTION_XENOMORPH
	var/flags_embryo = FALSE // Used in /ciphering/predator property

/obj/item/alien_embryo/Initialize(mapload, ...)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_embryo))
	if(istype(loc, /mob/living))
		affected_mob = loc
		affected_mob.status_flags |= XENO_HOST
		START_PROCESSING(SSobj, src)
		if(iscarbon(affected_mob))
			var/mob/living/carbon/C = affected_mob
			C.med_hud_set_status()
	else
		return INITIALIZE_HINT_QDEL

/obj/item/alien_embryo/Destroy()
	if(affected_mob)
		affected_mob.status_flags &= ~(XENO_HOST)
		if(iscarbon(affected_mob))
			var/mob/living/carbon/C = affected_mob
			C.med_hud_set_status()
		STOP_PROCESSING(SSobj, src)
		affected_mob = null
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
			var/mob/living/carbon/C = affected_mob
			C.med_hud_set_status()
		affected_mob = null
		return FALSE

	if(affected_mob.stat == DEAD)
		if(ishuman(affected_mob))
			var/mob/living/carbon/human/H = affected_mob
			if(world.time > H.timeofdeath + H.revive_grace_period) //Can't be defibbed.
				var/mob/living/carbon/Xenomorph/Larva/L = locate() in affected_mob
				if(L)
					L.chest_burst(affected_mob)
				qdel(src)
				return FALSE
		else
			var/mob/living/carbon/Xenomorph/Larva/L = locate() in affected_mob
			if(L)
				L.chest_burst(affected_mob)
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
		else if(istype(affected_mob.buckled, /obj/structure/bed/nest)) //Hosts who are nested in resin nests provide an ideal setting, larva grows faster
			counter += 1.5 * hive.larva_gestation_multiplier //Currently twice as much, can be changed
		else
			if(stage < 5)
				counter += 1.0 * hive.larva_gestation_multiplier

		if(stage < 5 && counter >= 120)
			counter = 0
			stage++
			if(iscarbon(affected_mob))
				var/mob/living/carbon/C = affected_mob
				C.med_hud_set_status()

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
					affected_mob.visible_message(SPAN_DANGER("\The [affected_mob] starts shaking uncontrollably!"), \
												 SPAN_DANGER("You start shaking uncontrollably!"))
					affected_mob.KnockOut(10)
					affected_mob.make_jittery(105)
					affected_mob.take_limb_damage(1)
			if(prob(2))
				var/message = pick("Your chest hurts badly", "It becomes difficult to breathe", "Your heart starts beating rapidly, and each beat is painful")
				message = SPAN_WARNING("[message].")
				to_chat(affected_mob, message)
		if(5)
			become_larva()
		if(6)
			larva_autoburst_countdown--
			if(!larva_autoburst_countdown)
				var/mob/living/carbon/Xenomorph/Larva/L = locate() in affected_mob
				if(L)
					L.chest_burst(affected_mob)

//We look for a candidate. If found, we spawn the candidate as a larva
//Order of priority is bursted individual (if xeno is enabled), then random candidate, and then it's up for grabs and spawns braindead
/obj/item/alien_embryo/proc/become_larva()
	// We do not allow chest bursts on the Centcomm Z-level, to prevent
	// stranded players from admin experiments and other issues
	if(!affected_mob || is_admin_level(affected_mob.z))
		return

	var/mob/picked
	// If the bursted person themselves has Xeno enabled, they get the honor of first dibs on the new larva.
	if((!isYautja(affected_mob) || (isYautja(affected_mob) && prob(20))) && istype(affected_mob.buckled,  /obj/structure/bed/nest))
		if(affected_mob.first_xeno || (affected_mob.client && affected_mob.client.prefs && (affected_mob.client.prefs.be_special & BE_ALIEN_AFTER_DEATH) && !jobban_isbanned(affected_mob, "Alien")))
			picked = affected_mob
		else if(affected_mob.mind && affected_mob.mind.ghost_mob && affected_mob.client && affected_mob.client.prefs && (affected_mob.client.prefs.be_special & BE_ALIEN_AFTER_DEATH) && !jobban_isbanned(affected_mob, "Alien"))
			picked = affected_mob.mind.ghost_mob


	if(!picked)
		// Get a candidate from observers
		var/list/candidates = get_alien_candidates()

		if(candidates && candidates.len)
			picked = pick(candidates)

	// Spawn the larva
	var/mob/living/carbon/Xenomorph/Larva/new_xeno

	if(isYautja(affected_mob) || (flags_embryo & FLAG_EMBRYO_PREDATOR))
		new_xeno = new /mob/living/carbon/Xenomorph/Larva/predalien(affected_mob)
		yautja_announcement(SPAN_YAUTJABOLDBIG("WARNING!\n\nAn abomination has been detected at [get_area_name(new_xeno)]. It is a stain upon our purity and is unfit for life. Exterminate it immediately"))
	else
		new_xeno = new(affected_mob)


	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive)
		hive.add_xeno(new_xeno)

	new_xeno.update_icons()

	// If we have a candidate, transfer it over
	if(picked)
		new_xeno.key = picked.key

		if(new_xeno.client)
			new_xeno.client.change_view(world_view_size)

		SSround_recording.recorder.track_player(new_xeno)

		to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva inside a host! Move to burst out of it!"))
		to_chat(new_xeno, "<B>Your job is to spread the hive and protect the Queen. If there's no Queen, you can become the Queen yourself by evolving into a drone.</B>")
		to_chat(new_xeno, "Talk in Hivemind using <strong>;</strong> (e.g. ';My life for the queen!')")
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 25, 1)

	stage = 6

/mob/living/carbon/Xenomorph/Larva/proc/chest_burst(mob/living/carbon/victim)
	set waitfor = 0
	if(victim.chestburst || loc != victim)
		return
	victim.chestburst = TRUE
	to_chat(src, SPAN_DANGER("You start bursting out of [victim]'s chest!"))
	if(victim.knocked_out < 1)
		victim.KnockOut(20)
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

	if(isYautja(victim))
		victim.emote("roar")
	else
		victim.emote("scream")

	var/burstcount = 0

	for(var/mob/living/carbon/Xenomorph/Larva/L in victim)
		var/datum/hive_status/hive = GLOB.hive_datum[L.hivenumber]
		L.forceMove(get_turf(victim)) //moved to the turf directly so we don't get stuck inside a cryopod or another mob container.
		playsound(L, pick('sound/voice/alien_chestburst.ogg','sound/voice/alien_chestburst2.ogg'), 25)

		if(burstcount)
			step(L, pick(cardinal))

		if(round_statistics)
			round_statistics.total_larva_burst++
		burstcount++

		if(!L.ckey && loc && is_ground_level(loc.z) && (locate(/obj/structure/bed/nest) in loc) && hive.living_xeno_queen && hive.living_xeno_queen.z == loc.z)
			L.visible_message(SPAN_XENODANGER("[L] quickly burrows into the ground."))
			if(round_statistics && !L.statistic_exempt)
				round_statistics.track_new_participant(faction, -1) // keep stats sane
			hive.stored_larva++
			hive.hive_ui.update_pooled_larva()
			qdel(L)

		if(!victim.first_xeno)
			to_chat(L, SPAN_XENOHIGHDANGER("The Queen's will overwhelms your instincts..."))
			to_chat(L, SPAN_XENOHIGHDANGER("\"[hive.hive_orders]\""))

	for(var/obj/item/alien_embryo/AE in victim)
		qdel(AE)

	if(burstcount >= 4)
		victim.gib("chestbursting")
	else
		if(ishuman(victim))
			var/mob/living/carbon/human/H = victim
			H.last_damage_source = "chestbursting"
			H.last_damage_mob = null
			var/datum/internal_organ/O
			var/i
			for(i in list("heart","lungs")) //This removes (and later garbage collects) both organs. No heart means instant death.
				O = H.internal_organs_by_name[i]
				H.internal_organs_by_name -= i
				H.internal_organs -= O
		victim.death("chestbursting") // Certain species were still surviving bursting (predators), DEFINITELY kill them this time.
		victim.chestburst = 2
		victim.update_burst()

// Squeeze thru dense objects as a larva, as airlocks
/mob/living/carbon/Xenomorph/Larva/proc/scuttle(var/obj/structure/S)
	var/move_dir = get_dir(src, loc)
	for(var/atom/movable/AM in get_turf(S))
		if(AM != S && AM.density && AM.BlockedPassDirs(src, move_dir))
			to_chat(src, SPAN_WARNING("\The [AM] prevents you from squeezing under \the [S]!"))
			return
	// Is it an airlock?
	if(istype(S, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/A = S
		if(A.locked || A.welded) //Can't pass through airlocks that have been bolted down or welded
			to_chat(src, SPAN_WARNING("\The [A] is locked down tight. You can't squeeze underneath!"))
			return
	visible_message(SPAN_WARNING("\The [src] scuttles underneath \the [S]!"), \
	SPAN_WARNING("You squeeze and scuttle underneath \the [S]."), null, 5)
	forceMove(S.loc)
