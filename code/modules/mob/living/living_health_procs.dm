
//procs directly related to mob health


/mob/living/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))

/mob/living/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	oxyloss = amount

/mob/living/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/setToxLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	toxloss = amount

/mob/living/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))

/mob/living/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))

/mob/living/proc/setCloneLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	cloneloss = amount

/mob/living/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))

/mob/living/proc/setBrainLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	brainloss = amount

/mob/living/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setHalLoss(amount)
	if(status_flags & GODMODE) return 0 //godmode
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(newMaxHealth)
	maxHealth = newMaxHealth


/mob/living
	VAR_PROTECTED/stun_timer = TIMER_ID_NULL

/mob/living/proc/stun_callback()
	REMOVE_TRAIT(src, TRAIT_INCAPACITATED, STUNNED_TRAIT)
	stunned = 0
	handle_regular_status_updates(FALSE)
	if(stun_timer != TIMER_ID_NULL)
		deltimer(stun_timer)
		stun_timer = TIMER_ID_NULL

/mob/living/proc/stun_callback_check()
	if(stunned)
		ADD_TRAIT(src, TRAIT_INCAPACITATED, STUNNED_TRAIT)
	if(stunned && stunned < recovery_constant)
		stun_timer = addtimer(CALLBACK(src, PROC_REF(stun_callback)), (stunned/recovery_constant) * 2 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)
		return
	if(!stunned) // Force reset since the timer wasn't called
		stun_callback()
		return

	if(stun_timer != TIMER_ID_NULL)
		deltimer(stun_timer)
		stun_timer = TIMER_ID_NULL

// adjust stun if needed, do not call it in adjust stunned
/mob/living/proc/stun_clock_adjustment()
	return

/mob/living/proc/Stun(amount)
	if(status_flags & CANSTUN)
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		stun_clock_adjustment()
		stun_callback_check()
	return

/mob/living/proc/SetStun(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		stun_clock_adjustment()
		stun_callback_check()
	return

/mob/living/proc/AdjustStun(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		stun_callback_check()
	return

/mob/living/proc/Daze(amount)
	if(status_flags & CANDAZE)
		dazed = max(max(dazed,amount),0)
	return

/mob/living/proc/SetDaze(amount)
	if(status_flags & CANDAZE)
		dazed = max(amount,0)
	return

/mob/living/proc/AdjustDaze(amount)
	if(status_flags & CANDAZE)
		dazed = max(dazed + amount,0)
	return

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

/mob/living
	VAR_PRIVATE/knocked_down_timer

/mob/living/proc/knocked_down_callback()
	remove_traits(list(TRAIT_FLOORED, TRAIT_INCAPACITATED), KNOCKEDDOWN_TRAIT)
	knocked_down = 0
	handle_regular_status_updates(FALSE)
	knocked_down_timer = null

/mob/living/proc/knocked_down_callback_check()
	if(knocked_down)
		add_traits(list(TRAIT_FLOORED, TRAIT_INCAPACITATED), KNOCKEDDOWN_TRAIT)

	if(knocked_down && knocked_down < recovery_constant)
		knocked_down_timer = addtimer(CALLBACK(src, PROC_REF(knocked_down_callback)), (knocked_down/recovery_constant) * 2 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE) // times whatever amount we have per tick
		return

	if(!knocked_down) // Force reset since the timer wasn't called
		knocked_down_callback()
		return

	if(knocked_down_timer)
		deltimer(knocked_down_timer)
	knocked_down_timer = null

/mob/living
	VAR_PRIVATE/knocked_out_timer

/mob/living/proc/knocked_out_start()
	return

/mob/living/proc/knocked_out_callback()
	REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, KNOCKEDOUT_TRAIT)
	knocked_out = 0
	handle_regular_status_updates(FALSE)
	knocked_out_timer = null

/mob/living/proc/knocked_out_callback_check()
	if(knocked_out)
		ADD_TRAIT(src, TRAIT_KNOCKEDOUT, KNOCKEDOUT_TRAIT)
	if(knocked_out && knocked_out < recovery_constant)
		knocked_out_timer = addtimer(CALLBACK(src, PROC_REF(knocked_out_callback)), (knocked_out/recovery_constant) * 2 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE) // times whatever amount we have per tick
		return
	else if(!knocked_out)
		//It's been called, and we're probably inconscious, so fix that.
		knocked_out_callback()

	if(knocked_out_timer)
		deltimer(knocked_out_timer)
	knocked_out_timer = null

// adjust knockdown if needed, do not call it in adjust knockdown
/mob/living/proc/knockdown_clock_adjustment()
	return

/mob/living/proc/KnockDown(amount, force)
	if((status_flags & CANKNOCKDOWN) || force)
		knocked_down = max(max(knocked_down,amount),0)
		knockdown_clock_adjustment()
		knocked_down_callback_check()
	return

/mob/living/proc/SetKnockDown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(amount,0)
		knockdown_clock_adjustment()
		knocked_down_callback_check()
	return

/mob/living/proc/AdjustKnockDown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(knocked_down + amount,0)
		knocked_down_callback_check()
	return

/mob/living/proc/knockout_clock_adjustment()
	return

/mob/living/proc/KnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(max(knocked_out,amount),0)
		knockout_clock_adjustment()
		knocked_out_callback_check()
	return

/mob/living/proc/SetKnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(amount,0)
		knockout_clock_adjustment()
		knocked_out_callback_check()
	return

/mob/living/proc/AdjustKnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(knocked_out + amount,0)
		knocked_out_callback_check()
	return

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
			overlay_fullscreen("eye_blur", /atom/movable/screen/fullscreen/impaired, CEILING(clamp(eye_blurry * 0.3, 1, 6), 1))
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
	ear_deaf = max(ear_deaf + amount, 0)
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
	SEND_SIGNAL(src, COMSIG_MOB_DEAFENED)

/mob/living/proc/on_deafness_loss()
	to_chat(src, SPAN_WARNING("You start hearing things again!"))
	SEND_SIGNAL(src, COMSIG_MOB_REGAINED_HEARING)

// heal ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_limb_damage(brute, burn)
	apply_damage(-brute, BRUTE)
	apply_damage(-burn, BURN)
	src.updatehealth()

// damage ONE limb, organ gets randomly selected from damaged ones.
/mob/living/proc/take_limb_damage(brute, burn)
	if(status_flags & GODMODE) return 0 //godmode
	apply_damage(brute, BRUTE)
	apply_damage(burn, BURN)
	src.updatehealth()

// heal MANY limbs, in random order
/mob/living/proc/heal_overall_damage(brute, burn)
	apply_damage(-brute, BRUTE)
	apply_damage(-burn, BURN)
	src.updatehealth()

// damage MANY limbs, in random order
/mob/living/proc/take_overall_damage(brute, burn, used_weapon = null)
	if(status_flags & GODMODE) return 0 //godmode
	apply_damage(brute, BRUTE)
	apply_damage(burn, BURN)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive(keep_viruses)
	rejuvenate()


/mob/living/proc/rejuvenate()
	heal_all_damage()

	SEND_SIGNAL(src, COMSIG_LIVING_REJUVENATED)

	// shut down ongoing problems
	status_flags &= ~PERMANENTLY_DEAD
	nutrition = NUTRITION_NORMAL
	bodytemperature = T20C
	recalculate_move_delay = TRUE
	sdisabilities = 0
	disabilities = 0
	drowsyness = 0
	hallucination = 0
	jitteriness = 0
	dizziness = 0

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

	// remove the character from the list of the dead
	if(stat == DEAD)
		GLOB.dead_mob_list -= src
		GLOB.alive_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)
	regenerate_all_icons()


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

/mob/living/keybind_face_direction(direction)
	if(!canface())
		return
	if(stat >= UNCONSCIOUS)
		return
	face_dir(direction)
	return ..()

// Transition handlers. do NOT use this. I mean seriously don't. It's broken. Players love their broken behaviors.
/mob/living/proc/GetStunValueNotADurationDoNotUse()
	return stunned
/mob/living/proc/GetKnockDownValueNotADurationDoNotUse()
	return knocked_down
/mob/living/proc/GetKnockOutValueNotADurationDoNotUse()
	return knocked_out
