
//procs directly related to mob health


/mob/living/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))

/mob/living/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	oxyloss = amount

/mob/living/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/setToxLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	toxloss = amount

/mob/living/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))

/mob/living/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))

/mob/living/proc/setCloneLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	cloneloss = amount

/mob/living/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))

/mob/living/proc/setBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	brainloss = amount

/mob/living/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setHalLoss(amount)
	if(status_flags & GODMODE)
		return 0 //godmode
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(newMaxHealth)
	maxHealth = newMaxHealth

/* STUN (Incapacitation) */
/// Overridable handler to adjust the numerical value of status effects. Expand as needed
/mob/living/proc/GetStunDuration(amount)
	return amount * GLOBAL_STATUS_MULTIPLIER
/mob/living/proc/IsStun() //If we're stunned
	return has_status_effect(/datum/status_effect/incapacitating/stun)
/mob/living/proc/AmountStun() //How much time remain in our stun - scaled by GLOBAL_STATUS_MULTIPLIER (normally in multiples of legacy 2 seconds)
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		return S.get_duration_left() / GLOBAL_STATUS_MULTIPLIER
	return 0
/mob/living/proc/Stun(amount)
	if(!(status_flags & CANSTUN))
		return
	amount = GetStunDuration(amount)
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	for(var/datum/reagent/nst_stim as anything in reagents.reagent_list) //reduce amount of NST stim in blood for every stun
		if(nst_stim.get_property(PROPERTY_NERVESTIMULATING))
			nst_stim.volume += max(min((-1*amount)/10, 0), -10)
	if(S)
		S.update_duration(amount, increment = TRUE)
	else if(amount > 0)
		S = apply_status_effect(/datum/status_effect/incapacitating/stun, amount)
	return S
/mob/living/proc/SetStun(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(!(status_flags & CANSTUN))
		return
	amount = GetStunDuration(amount)
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(amount <= 0)
		if(S)
			qdel(S)
	else
		if(S)
			S.update_duration(amount)
		else
			S = apply_status_effect(/datum/status_effect/incapacitating/stun, amount)
	return S
/mob/living/proc/AdjustStun(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(!(status_flags & CANSTUN))
		return
	amount = GetStunDuration(amount)
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	for(var/datum/reagent/nst_stim as anything in reagents.reagent_list) //reduce amount of NST stim in blood for every stun
		if(nst_stim.get_property(PROPERTY_NERVESTIMULATING))
			nst_stim.volume += max(min((-1*amount)/10, 0), -10)
	if(S)
		S.adjust_duration(amount)
	else if(amount > 0)
		S = apply_status_effect(/datum/status_effect/incapacitating/stun, amount)
	return S

/* ROOT (Immobilisation) */
/// Overridable handler to adjust the numerical value of status effects. Expand as needed
/mob/living/proc/GetRootDuration(amount)
	return amount * GLOBAL_STATUS_MULTIPLIER

/mob/living/proc/IsRoot() //If we're stunned
	return has_status_effect(/datum/status_effect/incapacitating/immobilized)

/mob/living/proc/AmountRoot() //How much time remain in our stun - scaled by GLOBAL_STATUS_MULTIPLIER (normally in multiples of legacy 2 seconds)
	var/datum/status_effect/incapacitating/immobilized/root = IsRoot()
	if(root)
		return root.get_duration_left() / GLOBAL_STATUS_MULTIPLIER
	return FALSE

/mob/living/proc/Root(amount)
	if(!(status_flags & CANROOT))
		return
	amount = GetRootDuration(amount)
	var/datum/status_effect/incapacitating/immobilized/root = IsRoot()
	if(root)
		root.update_duration(amount, increment = TRUE)
	else if(amount > 0)
		root = apply_status_effect(/datum/status_effect/incapacitating/immobilized, amount)
	return root

/mob/living/proc/SetRoot(amount) //Sets remaining duration
	if(!(status_flags & CANROOT))
		return
	amount = GetRootDuration(amount)
	var/datum/status_effect/incapacitating/immobilized/root = IsRoot()
	if(amount <= 0)
		if(root)
			qdel(root)
	else
		if(root)
			root.update_duration(amount)
		else
			root = apply_status_effect(/datum/status_effect/incapacitating/immobilized, amount)
	return root

/mob/living/proc/AdjustRoot(amount) //Adds to remaining duration
	if(!(status_flags & CANROOT))
		return
	amount = GetRootDuration(amount)
	var/datum/status_effect/incapacitating/immobilized/root = IsRoot()
	if(root)
		root.adjust_duration(amount)
	else if(amount > 0)
		root = apply_status_effect(/datum/status_effect/incapacitating/immobilized, amount)
	return root

/* DAZE (Light incapacitation) */
/// Overridable handler to adjust the numerical value of status effects. Expand as needed
/mob/living/proc/GetDazeDuration(amount)
	return amount * GLOBAL_STATUS_MULTIPLIER

/mob/living/proc/IsDaze() //If we're stunned
	return has_status_effect(/datum/status_effect/incapacitating/dazed)

/mob/living/proc/AmountDaze() //How many deciseconds remains
	var/datum/status_effect/incapacitating/dazed/dazed = IsDaze()
	if(dazed)
		return dazed.get_duration_left() / GLOBAL_STATUS_MULTIPLIER
	return 0

/mob/living/proc/Daze(amount)
	if(!(status_flags & CANDAZE))
		return
	amount = GetDazeDuration(amount)
	var/datum/status_effect/incapacitating/dazed/dazed = IsDaze()
	if(dazed)
		dazed.update_duration(amount, increment = TRUE)
	else if(amount > 0)
		dazed = apply_status_effect(/datum/status_effect/incapacitating/dazed, amount)
	return dazed

/mob/living/proc/SetDaze(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(!(status_flags & CANDAZE))
		return
	amount = GetDazeDuration(amount)
	var/datum/status_effect/incapacitating/dazed/dazed = IsDaze()
	if(amount <= 0)
		if(dazed)
			qdel(dazed)
	else
		if(dazed)
			dazed.update_duration(amount)
		else
			dazed = apply_status_effect(/datum/status_effect/incapacitating/dazed, amount)
	return dazed

/mob/living/proc/AdjustDaze(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(!(status_flags & CANDAZE))
		return
	amount = GetStunDuration(amount)
	var/datum/status_effect/incapacitating/dazed/dazed = IsDaze()
	if(dazed)
		dazed.adjust_duration(amount)
	else if(amount > 0)
		dazed = apply_status_effect(/datum/status_effect/incapacitating/dazed, amount)
	return dazed

/mob/living/proc/Slow(amount)
	if(status_flags & CANSLOW)
		slowed = max(slowed, amount, 0)
	return

/mob/living/proc/SetSlow(amount)
	if(status_flags & CANSLOW)
		slowed = max(amount,0)
	return

/mob/living/proc/AdjustSlow(amount)
	SetSlow(amount + slowed)
	return

/mob/living/proc/Superslow(amount)
	if(status_flags & CANSLOW)
		superslowed = max(superslowed, amount, 0)
	return

/mob/living/proc/SetSuperslow(amount)
	if(status_flags & CANSLOW)
		superslowed = max(amount,0)
	return

/mob/living/proc/AdjustSuperslow(amount)
	SetSuperslow(superslowed + amount)
	return

/* KnockDown (Flooring) */
/// Overridable handler to adjust the numerical value of status effects. Expand as needed
/mob/living/proc/GetKnockDownDuration(amount)
	return amount * GLOBAL_STATUS_MULTIPLIER

/mob/living/proc/IsKnockDown()
	return has_status_effect(/datum/status_effect/incapacitating/knockdown)

///How much time remains - scaled by GLOBAL_STATUS_MULTIPLIER (normally in multiples of legacy 2 seconds)
/mob/living/proc/AmountKnockDown()
	var/datum/status_effect/incapacitating/knockdown/S = IsKnockDown()
	if(S)
		return S.get_duration_left() / GLOBAL_STATUS_MULTIPLIER
	return 0

/mob/living/proc/KnockDown(amount)
	if(!(status_flags & CANKNOCKDOWN))
		return
	amount = GetKnockDownDuration(amount)
	var/datum/status_effect/incapacitating/knockdown/S = IsKnockDown()
	if(S)
		S.update_duration(amount, increment = TRUE)
	else if(amount > 0)
		S = apply_status_effect(/datum/status_effect/incapacitating/knockdown, amount)
	return S

///Sets exact remaining KnockDown duration
/mob/living/proc/SetKnockDown(amount, ignore_canstun = FALSE)
	if(!(status_flags & CANKNOCKDOWN))
		return
	amount = GetKnockDownDuration(amount)
	var/datum/status_effect/incapacitating/knockdown/S = IsKnockDown()
	if(amount <= 0)
		if(S)
			qdel(S)
	else
		if(S)
			S.update_duration(amount)
		else
			S = apply_status_effect(/datum/status_effect/incapacitating/knockdown, amount)
	return S

///Adds to remaining Knockdown duration
/mob/living/proc/AdjustKnockDown(amount, ignore_canstun = FALSE)
	if(!(status_flags & CANKNOCKDOWN))
		return
	amount = GetKnockDownDuration(amount)
	var/datum/status_effect/incapacitating/knockdown/S = IsKnockDown()
	if(S)
		S.adjust_duration(amount)
	else if(amount > 0)
		S = apply_status_effect(/datum/status_effect/incapacitating/knockdown, amount)
	return S

/* KnockOut (Unconscious) */
/// Overridable handler to adjust the numerical value of status effects. Expand as needed
/mob/living/proc/GetKnockOutDuration(amount)
	return amount * GLOBAL_STATUS_MULTIPLIER

/mob/living/proc/IsKnockOut()
	return has_status_effect(/datum/status_effect/incapacitating/unconscious)

/mob/living/proc/AmountKnockOut() //How much time remains - scaled by GLOBAL_STATUS_MULTIPLIER (normally in multiples of legacy 2 seconds)
	var/datum/status_effect/incapacitating/unconscious/S = IsKnockOut()
	if(S)
		return S.get_duration_left() / GLOBAL_STATUS_MULTIPLIER
	return 0

/// Sets Knockout duration to at least the amount provided
/mob/living/proc/KnockOut(amount)
	if(!(status_flags & CANKNOCKOUT))
		return
	amount = GetKnockOutDuration(amount)
	var/datum/status_effect/incapacitating/unconscious/S = IsKnockOut()
	if(S)
		S.update_duration(amount, increment = TRUE)
	else if(amount > 0)
		S = apply_status_effect(/datum/status_effect/incapacitating/unconscious, amount)
	return S

/// Sets exact remaining Knockout duration
/mob/living/proc/SetKnockOut(amount, ignore_canstun = FALSE)
	if(!(status_flags & CANKNOCKOUT))
		return
	amount = GetKnockOutDuration(amount)
	var/datum/status_effect/incapacitating/unconscious/S = IsKnockOut()
	if(amount <= 0)
		if(S)
			qdel(S)
	else
		if(S)
			S.update_duration(amount)
		else
			S = apply_status_effect(/datum/status_effect/incapacitating/unconscious, amount)
	return S

/// Adds to remaining Knockout duration
/mob/living/proc/AdjustKnockOut(amount, ignore_canstun = FALSE)
	if(!(status_flags & CANKNOCKOUT))
		return
	amount = GetKnockOutDuration(amount)
	var/datum/status_effect/incapacitating/unconscious/S = IsKnockOut()
	if(S)
		S.adjust_duration(amount)
	else if(amount > 0)
		S = apply_status_effect(/datum/status_effect/incapacitating/unconscious, amount)
	return S

/mob/living/proc/Sleeping(amount)
	sleeping = max(max(sleeping,amount),0)
	return

/mob/living/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/living/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/living/proc/EyeBlur(amount)
	eye_blurry = max(max(eye_blurry, amount), 0)
	update_eye_blur()
	return

/mob/living/proc/SetEyeBlur(amount)
	eye_blurry = max(amount, 0)
	update_eye_blur()
	return

/mob/living/proc/AdjustEyeBlur(amount)
	eye_blurry = max(eye_blurry + amount, 0)
	update_eye_blur()
	return

/mob/living/proc/ReduceEyeBlur(amount)
	eye_blurry = max(eye_blurry - amount, 0)
	update_eye_blur()
	return

///Apply the blurry overlays to a mobs clients screen
/mob/living/proc/update_eye_blur()
	if(!client)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	if(!eye_blurry)
		clear_fullscreen("eye_blur", 0.5 SECONDS)
		game_plane_master_controller.remove_filter("eye_blur")
		return

	switch(client.prefs?.pain_overlay_pref_level)
		if(PAIN_OVERLAY_IMPAIR)
			overlay_fullscreen("eye_blur", /atom/movable/screen/fullscreen/impaired, ceil(clamp(eye_blurry * 0.3, 1, 6)))
		if(PAIN_OVERLAY_LEGACY)
			overlay_fullscreen("eye_blur", /atom/movable/screen/fullscreen/blurry)
		else // PAIN_OVERLAY_BLURRY
			game_plane_master_controller.add_filter("eye_blur", 1, gauss_blur_filter(clamp(eye_blurry * 0.1, 0.6, 3)))


/mob/living/proc/TalkStutter(amount)
	stuttering = max(max(stuttering, amount), 0)
	return


/mob/living/proc/SetTalkStutter(amount)
	stuttering = max(amount, 0)
	return

/mob/living/proc/AdjustTalkStutter(amount)
	stuttering = max(stuttering + amount,0)
	return


/mob/living/proc/SetEyeBlind(amount)
	eye_blind = max(amount, 0)
	return


/mob/living/proc/AdjustEyeBlind(amount)
	eye_blind = max(eye_blind + amount, 0)
	return

/mob/living/proc/ReduceEyeBlind(amount)
	eye_blind = max(eye_blind - amount, 0)
	return

/mob/living/proc/AdjustEarDeafness(amount)
	var/prev_deaf = ear_deaf
	ear_deaf = clamp(ear_deaf + amount, 0, 30) //roughly 1 minute
	if(prev_deaf)
		if(ear_deaf == 0)
			on_deafness_loss()
	else if(ear_deaf)
		on_deafness_gain()


/mob/living/proc/SetEarDeafness(amount)
	var/prev_deaf = ear_deaf
	ear_deaf = max(amount, 0)
	if(prev_deaf)
		if(ear_deaf == 0)
			on_deafness_loss()
	else if(ear_deaf)
		on_deafness_gain()

/mob/living/proc/on_deafness_gain()
	to_chat(src, SPAN_WARNING("You notice you can't hear anything... you're deaf!"))
	// We should apply deafness here instead of in handle_regular_status_updates
	SEND_SIGNAL(src, COMSIG_MOB_DEAFENED)

/mob/living/proc/on_deafness_loss()
	to_chat(src, SPAN_WARNING("You start hearing things again!"))
	SEND_SIGNAL(src, COMSIG_MOB_REGAINED_HEARING)
	// Consider moving this to a signal on soundOutput. This is a fallback as handle_regular_status_updates SHOULD do the job.
	if(!ear_deaf && (client?.soundOutput?.status_flags & EAR_DEAF_MUTE))
		client.soundOutput.status_flags ^= EAR_DEAF_MUTE
		client.soundOutput.apply_status()

/mob/living/proc/grant_spawn_protection(duration)
	status_flags |= RECENTSPAWN|GODMODE
	RegisterSignal(src, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED), PROC_REF(handle_fire_protection))
	addtimer(CALLBACK(src, PROC_REF(end_spawn_protection)), duration)

/mob/living/proc/end_spawn_protection()
	status_flags &= ~(RECENTSPAWN|GODMODE)
	UnregisterSignal(src, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED))

/mob/living/proc/handle_fire_protection(mob/living/living, datum/reagent/chem)
	SIGNAL_HANDLER
	if(status_flags & (RECENTSPAWN|GODMODE))
		return COMPONENT_NO_IGNITE

// heal ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_limb_damage(brute, burn)
	apply_damage(-brute, BRUTE)
	apply_damage(-burn, BURN)
	src.updatehealth()

// damage ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/take_limb_damage(brute, burn)
	if(status_flags & GODMODE)
		return 0 //godmode
	apply_damage(brute, BRUTE)
	apply_damage(burn, BURN)
	src.updatehealth()

// heal MANY limbs, in random order
/mob/living/proc/heal_overall_damage(brute, burn)
	apply_damage(-brute, BRUTE)
	apply_damage(-burn, BURN)
	src.updatehealth()

// damage MANY limbs, in random order
/mob/living/proc/take_overall_damage(brute, burn, used_weapon = null, limb_damage_chance = 80)
	if(status_flags & GODMODE)
		return 0 //godmode
	apply_damage(brute, BRUTE)
	apply_damage(burn, BURN)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive(keep_viruses)
	rejuvenate()


/mob/living/proc/rejuvenate()
	heal_all_damage()

	// shut down ongoing problems
	status_flags &= ~PERMANENTLY_DEAD
	nutrition = NUTRITION_NORMAL
	bodytemperature = T37C
	recalculate_move_delay = TRUE
	sdisabilities = 0
	disabilities = 0
	drowsyness = 0
	hallucination = 0
	jitteriness = 0
	dizziness = 0
	stamina.apply_damage(-stamina.max_stamina)

	// restore all of a human's blood
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.restore_blood()
		H.reagents.clear_reagents() //and clear all reagents in them
		SShuman.processable_human_list |= H
		H.undefibbable = FALSE
		H.chestburst = 0
		H.update_headshot_overlay() //They don't have their brains blown out anymore, if they did.

	// fix all of our organs
	restore_all_organs()

	//Reset any surgeries.
	active_surgeries = DEFENSE_ZONES_LIVING
	initialize_incision_depths()
	remove_surgery_overlays()

	// remove the character from the list of the dead
	if(stat == DEAD)
		GLOB.dead_mob_list -= src
		GLOB.alive_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to consciousness
	set_stat(CONSCIOUS)
	regenerate_all_icons()

	SEND_SIGNAL(src, COMSIG_LIVING_REJUVENATED)


/mob/living/proc/heal_all_damage()
	// shut down various types of badness
	heal_overall_damage(getBruteLoss(), getFireLoss())
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	set_effect(0, PARALYZE)
	set_effect(0, STUN)
	set_effect(0, DAZE)
	set_effect(0, SLOW)
	set_effect(0, SUPERSLOW)
	set_effect(0, WEAKEN)
	ExtinguishMob()
	fire_stacks = 0

	// fix blindness and deafness
	blinded = FALSE
	SetEyeBlind(0)
	SetEyeBlur(0)
	SetEarDeafness(0)
	ear_damage = 0
	paralyzed = 0
	confused = 0
	druggy = 0

/mob/living/proc/regenerate_all_icons()
	// make the icons look correct
	regenerate_icons()
	med_hud_set_status()
	med_hud_set_health()
	med_hud_set_armor()
	reload_fullscreens()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.update_body()

/mob/living/proc/remove_surgery_overlays() // Mainly for ahealing
	if(overlays)
		overlays -= image('icons/mob/humans/dam_human.dmi', "skull_surgery_closed")
		overlays -= image('icons/mob/humans/dam_human.dmi', "skull_surgery_open")
		overlays -= image('icons/mob/humans/dam_human.dmi', "chest_surgery_closed")
		overlays -= image('icons/mob/humans/dam_human.dmi', "chest_surgery_open")


/mob/living/keybind_face_direction(direction)
	if(!canface())
		return
	if(stat >= UNCONSCIOUS)
		return
	face_dir(direction)
	return ..()
