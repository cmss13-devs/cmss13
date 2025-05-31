/datum/component/automatedfire/autofire
	///The current fire mode of the shooter
	var/fire_mode
	///Delay between two shots when in full auto
	var/auto_fire_shot_delay
	///Delay between two burst shots
	var/burstfire_shot_delay
	///How many bullets are fired in burst mode
	var/burst_shots_to_fire
	///Count the shots fired when bursting
	var/shots_fired = 0
	///If the shooter is currently shooting
	var/shooting = FALSE
	///If TRUE, the shooter will reset its references at the end of the burst
	var/have_to_reset_at_burst_end = FALSE
	///If we are in a burst
	var/bursting = FALSE
	/// The multiplier for how much slower the parent should fire in automatic mode. 1 is normal, 1.2 is 20% slower, 2 is 100% slower, etc.
	var/automatic_delay_mult = 1
	///Callback to set bursting mode on the parent
	var/datum/callback/callback_bursting
	///Callback to ask the parent to reset its firing vars
	var/datum/callback/callback_reset_fire
	///Callback to ask the parent to fire
	var/datum/callback/callback_fire
	///Callback to ask the parent to display ammo
	var/datum/callback/callback_display_ammo
	///Callback to set parent's fa_firing
	var/datum/callback/callback_set_firing

/datum/component/automatedfire/autofire/Initialize(auto_fire_shot_delay = 0.3 SECONDS, burstfire_shot_delay, burst_shots_to_fire = 3, fire_mode = GUN_FIREMODE_SEMIAUTO, automatic_delay_mult = 1, datum/callback/callback_bursting, datum/callback/callback_reset_fire, datum/callback/callback_fire, datum/callback/callback_display_ammo, datum/callback/callback_set_firing)
	. = ..()

	RegisterSignal(parent, COMSIG_GUN_FIRE_MODE_TOGGLE, PROC_REF(modify_fire_mode))
	RegisterSignal(parent, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, PROC_REF(modify_fire_shot_delay))
	RegisterSignal(parent, COMSIG_GUN_BURST_SHOTS_TO_FIRE_MODIFIED, PROC_REF(modify_burst_shots_to_fire))
	RegisterSignal(parent, COMSIG_GUN_BURST_SHOT_DELAY_MODIFIED, PROC_REF(modify_burstfire_shot_delay))
	RegisterSignal(parent, COMSIG_GUN_FIRE, PROC_REF(initiate_shot))
	RegisterSignal(parent, COMSIG_GUN_STOP_FIRE, PROC_REF(stop_firing))
	RegisterSignal(parent, COMSIG_GUN_INTERRUPT_FIRE, PROC_REF(hard_reset))
	RegisterSignal(parent, COMSIG_GUN_NEXT_FIRE_MODIFIED, PROC_REF(set_next_fire))

	src.auto_fire_shot_delay = auto_fire_shot_delay
	src.burstfire_shot_delay = burstfire_shot_delay
	src.burst_shots_to_fire = burst_shots_to_fire
	src.fire_mode = fire_mode
	src.automatic_delay_mult = automatic_delay_mult
	src.callback_bursting = callback_bursting
	src.callback_reset_fire = callback_reset_fire
	src.callback_fire = callback_fire
	src.callback_display_ammo = callback_display_ammo
	src.callback_set_firing = callback_set_firing

/datum/component/automatedfire/autofire/Destroy(force, silent)
	QDEL_NULL(callback_fire)
	QDEL_NULL(callback_reset_fire)
	QDEL_NULL(callback_bursting)
	QDEL_NULL(callback_display_ammo)
	QDEL_NULL(callback_set_firing)
	return ..()

///Setter for fire mode
/datum/component/automatedfire/autofire/proc/modify_fire_mode(datum/source, fire_mode)
	SIGNAL_HANDLER
	src.fire_mode = fire_mode

///Setter for auto fire shot delay
/datum/component/automatedfire/autofire/proc/modify_fire_shot_delay(datum/source, auto_fire_shot_delay)
	SIGNAL_HANDLER
	src.auto_fire_shot_delay = auto_fire_shot_delay

///Setter for the number of shots in a burst
/datum/component/automatedfire/autofire/proc/modify_burst_shots_to_fire(datum/source, burst_shots_to_fire)
	SIGNAL_HANDLER
	src.burst_shots_to_fire = burst_shots_to_fire

///Setter for burst shot delay
/datum/component/automatedfire/autofire/proc/modify_burstfire_shot_delay(datum/source, burstfire_shot_delay)
	SIGNAL_HANDLER
	src.burstfire_shot_delay = burstfire_shot_delay

///Insert the component in the bucket system if it was not in already
/datum/component/automatedfire/autofire/proc/initiate_shot()
	SIGNAL_HANDLER
	if(shooting)//if we are already shooting, it means the shooter is still on cooldown
		if(bursting && (world.time > (next_fire + (burstfire_shot_delay * burst_shots_to_fire))))
			hard_reset()
		return
	shooting = TRUE
	process_shot()

///Remove the component from the bucket system if it was in
/datum/component/automatedfire/autofire/proc/stop_firing()
	SIGNAL_HANDLER
	if(!shooting)
		return
	///We are burst firing, we can't clean the state now. We will do it when the burst is over
	if(bursting)
		have_to_reset_at_burst_end = TRUE
		return
	shooting = FALSE
	shots_fired = 0

///Hard reset the autofire, happens when the shooter fall/is thrown, at the end of a burst or when it runs out of ammunition
/datum/component/automatedfire/autofire/proc/hard_reset()
	SIGNAL_HANDLER
	callback_reset_fire.Invoke() //resets the gun
	shots_fired = 0
	have_to_reset_at_burst_end = FALSE
	if(bursting)
		bursting = FALSE
		callback_bursting.Invoke(FALSE)
	shooting = FALSE

///Manually sets firedelay
/datum/component/automatedfire/autofire/proc/set_next_fire(gun, new_next_fire)
	SIGNAL_HANDLER
	next_fire = new_next_fire

///Ask the shooter to fire and schedule the next shot if need
/datum/component/automatedfire/autofire/process_shot()
	if(!shooting)
		return
	if(next_fire > world.time)//This mean duplication somewhere, we abort now
		return
	if(!(callback_fire.Invoke() & AUTOFIRE_CONTINUE))//reset fire if we want to stop
		hard_reset()
		return
	switch(fire_mode)
		if(GUN_FIREMODE_BURSTFIRE)
			shots_fired++
			if(shots_fired == burst_shots_to_fire)
				callback_bursting?.Invoke(FALSE)
				callback_display_ammo?.Invoke()
				bursting = FALSE
				stop_firing()
				if(have_to_reset_at_burst_end)//We failed to reset because we were bursting, we do it now
					callback_reset_fire?.Invoke()
					have_to_reset_at_burst_end = FALSE
				return
			callback_bursting?.Invoke(TRUE)
			bursting = TRUE
			next_fire = world.time + burstfire_shot_delay
		if(GUN_FIREMODE_AUTOMATIC)
			callback_set_firing?.Invoke(TRUE)
			next_fire = world.time + (auto_fire_shot_delay * automatic_delay_mult)
		if(GUN_FIREMODE_SEMIAUTO)
			return
	schedule_shot()
