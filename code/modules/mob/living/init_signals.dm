/// Called when [TRAIT_FLOORED] is added to the mob.
/mob/living/proc/on_floored_trait_gain(datum/source)
	SIGNAL_HANDLER
	if(!buckled || buckled.buckle_lying)
		mobility_flags &= ~MOBILITY_STAND
	update_canmove() // TODO replace this with granular updates


/// Called when [TRAIT_FLOORED] is removed from the mob.
/mob/living/proc/on_floored_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_STAND
	update_canmove() // TODO replace this with granular updates
