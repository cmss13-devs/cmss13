/// Called on [/mob/living/Initialize(mapload)], for the mob to register to relevant signals.
/mob/living/proc/register_init_signals()
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_KNOCKEDOUT), PROC_REF(on_knockedout_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_KNOCKEDOUT), PROC_REF(on_knockedout_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED), PROC_REF(on_immobilized_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_IMMOBILIZED), PROC_REF(on_immobilized_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_FLOORED), PROC_REF(on_floored_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_FLOORED), PROC_REF(on_floored_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_FORCED_STANDING), PROC_REF(on_forced_standing_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_FORCED_STANDING), PROC_REF(on_forced_standing_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED), PROC_REF(on_incapacitated_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_INCAPACITATED), PROC_REF(on_incapacitated_trait_loss))

	RegisterSignal(src, list(SIGNAL_ADDTRAIT(TRAIT_UNDENSE), SIGNAL_REMOVETRAIT(TRAIT_UNDENSE)), PROC_REF(undense_changed))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_DAZED), PROC_REF(on_dazed_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_DAZED), PROC_REF(on_dazed_trait_loss))

/// Called when [TRAIT_KNOCKEDOUT] is added to the mob.
/mob/living/proc/on_knockedout_trait_gain(datum/source)
	SIGNAL_HANDLER
	if(stat < UNCONSCIOUS)
		set_stat(UNCONSCIOUS)
	sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC
	client?.soundOutput?.update_mob_environment_override()

/// Called when [TRAIT_KNOCKEDOUT] is removed from the mob.
/mob/living/proc/on_knockedout_trait_loss(datum/source)
	SIGNAL_HANDLER
	if(stat <= UNCONSCIOUS)
		update_stat()
	sound_environment_override = SOUND_ENVIRONMENT_NONE
	client?.soundOutput?.update_mob_environment_override()

/// Called when [TRAIT_IMMOBILIZED] is added to the mob.
/mob/living/proc/on_immobilized_trait_gain(datum/source)
	SIGNAL_HANDLER
	mobility_flags &= ~MOBILITY_MOVE

/// Called when [TRAIT_IMMOBILIZED] is removed from the mob.
/mob/living/proc/on_immobilized_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_MOVE

/// Called when [TRAIT_FLOORED] is added to the mob.
/mob/living/proc/on_floored_trait_gain(datum/source)
	SIGNAL_HANDLER
	if(buckled && buckled.buckle_lying != NO_BUCKLE_LYING)
		return // Handled by the buckle.
	if(HAS_TRAIT(src, TRAIT_FORCED_STANDING))
		return // Don't go horizontal if mob has forced standing trait.
	mobility_flags &= ~MOBILITY_STAND
	on_floored_start()


/// Called when [TRAIT_FLOORED] is removed from the mob.
/mob/living/proc/on_floored_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_STAND
	on_floored_end()

/// Called when [TRAIT_FORCED_STANDING] is added to the mob.
/mob/living/proc/on_forced_standing_trait_gain(datum/source)
	SIGNAL_HANDLER

	set_body_position(STANDING_UP)
	set_lying_angle(0)

/// Called when [TRAIT_FORCED_STANDING] is removed from the mob.
/mob/living/proc/on_forced_standing_trait_loss(datum/source)
	SIGNAL_HANDLER

	if(HAS_TRAIT(src, TRAIT_FLOORED))
		on_fall()
		set_lying_down()
	else if(resting)
		set_lying_down()

/// Called when [TRAIT_INCAPACITATED] is added to the mob.
/mob/living/proc/on_incapacitated_trait_gain(datum/source)
	SIGNAL_HANDLER
	//add_traits(list(TRAIT_UI_BLOCKED, TRAIT_PULL_BLOCKED), TRAIT_INCAPACITATED)
	//update_appearance()
	return

/// Called when [TRAIT_INCAPACITATED] is removed from the mob.
/mob/living/proc/on_incapacitated_trait_loss(datum/source)
	SIGNAL_HANDLER
	//remove_traits(list(TRAIT_UI_BLOCKED, TRAIT_PULL_BLOCKED), TRAIT_INCAPACITATED)
	//update_appearance()
	return

/// Called when [TRAIT_DAZED] is added to the mob.
/mob/living/proc/on_dazed_trait_gain(datum/source)
	SIGNAL_HANDLER

/// Called when [TRAIT_DAZED] is removed from the mob.
/mob/living/proc/on_dazed_trait_loss(datum/source)
	SIGNAL_HANDLER

/// Called when [TRAIT_UNDENSE] is gained or lost
/mob/living/proc/undense_changed(datum/source)
	SIGNAL_HANDLER
	update_density()
