/mob/var/stun_timer = TIMER_ID_NULL

/mob/proc/stun_callback()
	stunned = 0
	handle_regular_status_updates(FALSE)
	update_canmove()
	if(stun_timer != TIMER_ID_NULL)
		deltimer(stun_timer)
		stun_timer = TIMER_ID_NULL

/mob/proc/stun_callback_check()
	if(stunned && stunned < recovery_constant)
		stun_timer = addtimer(CALLBACK(src, PROC_REF(stun_callback)), (stunned/recovery_constant) * 2 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)
		return

	if(stun_timer != TIMER_ID_NULL)
		deltimer(stun_timer)
		stun_timer = TIMER_ID_NULL

// adjust stun if needed, do not call it in adjust stunned
/mob/proc/stun_clock_adjustment()
	return

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		stun_clock_adjustment()
		stun_callback_check()
		update_canmove()
	return

/mob/proc/SetStun(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		stun_clock_adjustment()
		stun_callback_check()
		update_canmove()
	return

/mob/proc/AdjustStun(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		stun_callback_check()
		update_canmove()
	return

/mob/proc/Daze(amount)
	if(status_flags & CANDAZE)
		dazed = max(max(dazed,amount),0)
	return

/mob/proc/SetDaze(amount)
	if(status_flags & CANDAZE)
		dazed = max(amount,0)
	return

/mob/proc/AdjustDaze(amount)
	if(status_flags & CANDAZE)
		dazed = max(dazed + amount,0)
	return

/mob/proc/Slow(amount)
	if(status_flags & CANSLOW)
		slowed = max(slowed, amount, 0)
	return

/mob/proc/SetSlow(amount)
	if(status_flags & CANSLOW)
		slowed = max(amount,0)
	return

/mob/proc/AdjustSlow(amount)
	SetSlow(amount + slowed)
	return

/mob/proc/Superslow(amount)
	if(status_flags & CANSLOW)
		superslowed = max(superslowed, amount, 0)
	return

/mob/proc/SetSuperslow(amount)
	if(status_flags & CANSLOW)
		superslowed = max(amount,0)
	return

/mob/proc/AdjustSuperslow(amount)
	SetSuperslow(superslowed + amount)
	return

/mob/var/knocked_down_timer

/mob/proc/knocked_down_callback()
	knocked_down = 0
	handle_regular_status_updates(FALSE)
	update_canmove()
	knocked_down_timer = null

/mob/proc/knocked_down_callback_check()
	if(knocked_down && knocked_down < recovery_constant)
		knocked_down_timer = addtimer(CALLBACK(src, PROC_REF(knocked_down_callback)), (knocked_down/recovery_constant) * 2 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE) // times whatever amount we have per tick
		return

	if(knocked_down_timer)
		deltimer(knocked_down_timer)
	knocked_down_timer = null

/mob/var/knocked_out_timer

/mob/proc/knocked_out_callback()
	knocked_out = 0
	handle_regular_status_updates(FALSE)
	update_canmove()
	knocked_out_timer = null

/mob/proc/knocked_out_callback_check()
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
/mob/proc/knockdown_clock_adjustment()
	return

/mob/proc/KnockDown(amount, force)
	if((status_flags & CANKNOCKDOWN) || force)
		knocked_down = max(max(knocked_down,amount),0)
		knockdown_clock_adjustment()
		knocked_down_callback_check()
		update_canmove() //updates lying, canmove and icons
	return

/mob/proc/SetKnockDown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(amount,0)
		knockdown_clock_adjustment()
		knocked_down_callback_check()
		update_canmove() //updates lying, canmove and icons
	return

/mob/proc/AdjustKnockDown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(knocked_down + amount,0)
		knocked_down_callback_check()
		update_canmove() //updates lying, canmove and icons
	return

/mob/proc/knockout_clock_adjustment()
	return

/mob/proc/KnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(max(knocked_out,amount),0)
		knockout_clock_adjustment()
		knocked_out_callback_check()
		update_canmove() //updates lying, canmove and icons
	return

/mob/proc/SetKnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(amount,0)
		knockout_clock_adjustment()
		knocked_out_callback_check()
		update_canmove() //updates lying, canmove and icons
	return

/mob/proc/AdjustKnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(knocked_out + amount,0)
		knocked_out_callback_check()
		update_canmove() //updates lying, canmove and icons
	return

/mob/proc/Sleeping(amount)
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Resting(amount)
	resting = max(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	return

/mob/proc/EyeBlur(amount)
	eye_blurry = max(max(eye_blurry, amount), 0)
	update_eye_blur()
	return

/mob/proc/SetEyeBlur(amount)
	eye_blurry = max(amount, 0)
	update_eye_blur()
	return

/mob/proc/AdjustEyeBlur(amount)
	eye_blurry = max(eye_blurry + amount, 0)
	update_eye_blur()
	return

/mob/proc/ReduceEyeBlur(amount)
	eye_blurry = max(eye_blurry - amount, 0)
	update_eye_blur()
	return

///Apply the blurry overlays to a mobs clients screen
/mob/proc/update_eye_blur()
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


/mob/proc/TalkStutter(amount)
	stuttering = max(max(stuttering, amount), 0)
	return

/mob/proc/SetTalkStutter(amount)
	stuttering = max(amount, 0)
	return

/mob/proc/AdjustTalkStutter(amount)
	stuttering = max(stuttering + amount,0)
	return

/mob/proc/SetEyeBlind(amount)
	eye_blind = max(amount, 0)
	return

/mob/proc/AdjustEyeBlind(amount)
	eye_blind = max(eye_blind + amount, 0)
	return

/mob/proc/ReduceEyeBlind(amount)
	eye_blind = max(eye_blind - amount, 0)
	return

/mob/proc/AdjustEarDeafness(amount)
	var/prev_deaf = ear_deaf
	ear_deaf = max(ear_deaf + amount, 0)
	if(prev_deaf)
		if(ear_deaf == 0)
			on_deafness_loss()
	else if(ear_deaf)
		on_deafness_gain()


/mob/proc/SetEarDeafness(amount)
	var/prev_deaf = ear_deaf
	ear_deaf = max(amount, 0)
	if(prev_deaf)
		if(ear_deaf == 0)
			on_deafness_loss()
	else if(ear_deaf)
		on_deafness_gain()

/mob/proc/on_deafness_gain()
	to_chat(src, SPAN_WARNING("You notice you can't hear anything... you're deaf!"))
	SEND_SIGNAL(src, COMSIG_MOB_DEAFENED)

/mob/proc/on_deafness_loss()
	to_chat(src, SPAN_WARNING("You start hearing things again!"))
	SEND_SIGNAL(src, COMSIG_MOB_REGAINED_HEARING)

/mob/proc/getBruteLoss()
	return

/mob/proc/getOxyLoss()
	return

/mob/proc/getToxLoss()
	return

/mob/proc/getFireLoss()
	return

/mob/proc/getCloneLoss()
	return

/mob/proc/getBrainLoss()
	return

/mob/proc/getHalLoss()
	return

//Regular update means we do it during the life run
/mob/proc/handle_regular_status_updates(regular_update = TRUE)
	return
