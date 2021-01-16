/*
	Pain datum for holding all pain related proc to mobs.

	The threshold vars determine when the associated threshold procs should activate.
	The threshold vars are percentage values, so if you want the mild effect to appear at 20% pain, you assign it 20.

	Each mob should spawn with a pain datumn.

	Can be customized for each mob, default procs are slow and messages appearing at mild.
		discomforting-moderate, more slow, new message.
		distressing, slow getting worse, vision starting to fade.
		severe, slowed a lot, oxygen damage starting to build up.
		horrible, rapid oxygen buildup, knocked out.

	Pain is applied and removed when needed with the apply_pain() proc.
	Negative values remove and positive values add.
*/

// Pain level, how bad are you in pain right now
#define PAIN_LEVEL_NONE				0
#define PAIN_LEVEL_MILD				1
#define PAIN_LEVEL_DISCOMFORTING	2
#define PAIN_LEVEL_MODERATE			3
#define PAIN_LEVEL_DISTRESSING		4
#define PAIN_LEVEL_SEVERE			5
#define PAIN_LEVEL_HORRIBLE			6

// Time to wait between each pain level increase/decrease
#define PAIN_UPDATE_FREQUENCY 20

// The rate at which pain reduction decreases as pain goes up. (-PAIN_REDUCTION_DECREASE_RATE * current_pain) + reduction_pain = pain_reduction
#define PAIN_REDUCTION_DECREASE_RATE 0.25

// Movespeed levels, how much is the pain slowing you
#define PAIN_SPEED_VERYSLOW	4.50
#define PAIN_SPEED_SLOW		3.75
#define PAIN_SPEED_HIGH		2.75
#define PAIN_SPEED_MED		1.50
#define PAIN_SPEED_LOW		1

// Multipliers for how much pain the different types give
#define BRUTE_PAIN_MULTIPLIER 1
#define BURN_PAIN_MULTIPLIER 1.2
#define TOX_PAIN_MULTIPLIER 1.5

/datum/pain
	var/mob/living/source_mob 		= null

	var/current_pain 		= 0
	var/max_pain 			= 100
	var/reduction_pain		= 0

	var/pain_level 			= PAIN_LEVEL_NONE
	var/last_level			= PAIN_LEVEL_NONE

	var/threshold_mild 				= 20
	var/threshold_discomforting 	= 30
	var/threshold_moderate			= 40
	var/threshold_distressing		= 60
	var/threshold_severe			= 75
	var/threshold_horrible			= 85

	var/pain_slowdown		= 0

	var/last_reduction_update = 0
	var/level_updating		= FALSE

	var/feels_pain = TRUE

/datum/pain/New(var/mob/owner)
	. = ..()

	if(istype(owner))
		source_mob = owner
	else
		qdel(src)

/datum/pain/proc/get_pain_percentage()
	//Pain reduction effectiveness linear decreases as the pain goes up
	var/new_pain_reduction = max(0, (-PAIN_REDUCTION_DECREASE_RATE * current_pain) + reduction_pain)

	if(current_pain - new_pain_reduction > max_pain)
		return 100

	var/percentage = round(((current_pain - new_pain_reduction) / max_pain) * 100)
	if(percentage < 0)
		return 0
	else
		return percentage

/datum/pain/proc/apply_pain(var/amount = 0, var/type = BRUTE)
	var/actual_amount = amount

	switch(type)
		if(BRUTE)
			actual_amount = BRUTE_PAIN_MULTIPLIER * amount
		if(BURN)
			actual_amount = BURN_PAIN_MULTIPLIER * amount
		if(TOX)
			actual_amount = TOX_PAIN_MULTIPLIER * amount
		if(OXY)
			return
		if(HALLOSS)
			return

	if(current_pain + actual_amount <= 0)
		current_pain = 0
	else
		current_pain += actual_amount

	update_pain_level()

/datum/pain/proc/apply_pain_reduction(var/amount = 0)
	if(last_reduction_update > world.time || amount <= reduction_pain) // Needed so pain meds cant spam us, neccesary evil.
		return

	last_reduction_update = world.time + 10 SECONDS
	reduction_pain = amount

	update_pain_level()

/datum/pain/proc/reset_pain_reduction()
	reduction_pain = 0

	update_pain_level()

/datum/pain/proc/update_pain_level()
	if(level_updating)
		return

	var/new_level = PAIN_LEVEL_NONE
	var/pain_percentage = get_pain_percentage()
	if(pain_percentage >= threshold_horrible && !isnull(threshold_horrible))
		new_level = PAIN_LEVEL_HORRIBLE
	else if(pain_percentage >= threshold_severe && !isnull(threshold_severe))
		new_level = PAIN_LEVEL_SEVERE
	else if (pain_percentage >= threshold_distressing && !isnull(threshold_distressing))
		new_level = PAIN_LEVEL_DISTRESSING
	else if (pain_percentage >= threshold_moderate && !isnull(threshold_moderate))
		new_level = PAIN_LEVEL_MODERATE
	else if (pain_percentage >= threshold_discomforting && !isnull(threshold_discomforting))
		new_level = PAIN_LEVEL_DISCOMFORTING
	else if (pain_percentage >= threshold_mild && !isnull(threshold_mild))
		new_level = PAIN_LEVEL_MILD

	if(!check_active_pain(new_level))
		return

	if(new_level > last_level)
		increase_pain_level()
	else
		decrease_pain_level()


/datum/pain/proc/check_active_pain(var/level = 0)
	if(level == last_level) //Check if the new level is same as old one
		return FALSE

	for(var/datum/effects/pain/P in source_mob.effects_list)
		qdel(P)

	pain_slowdown = 0

	return TRUE

/datum/pain/proc/increase_pain_level()
	level_updating = TRUE

	var/new_level = PAIN_LEVEL_NONE
	switch(last_level)
		if(PAIN_LEVEL_NONE)
			new_level = PAIN_LEVEL_MILD
			if(!isnull(threshold_mild))
				activate_mild()
		if(PAIN_LEVEL_MILD)
			new_level = PAIN_LEVEL_DISCOMFORTING
			if(!isnull(threshold_discomforting))
				activate_discomforting()
		if(PAIN_LEVEL_DISCOMFORTING)
			new_level = PAIN_LEVEL_MODERATE
			if(!isnull(threshold_moderate))
				activate_moderate()
		if(PAIN_LEVEL_MODERATE)
			new_level = PAIN_LEVEL_DISTRESSING
			if(!isnull(threshold_distressing))
				activate_distressing()
		if(PAIN_LEVEL_DISTRESSING)
			new_level = PAIN_LEVEL_SEVERE
			if(!isnull(threshold_severe))
				activate_severe()
		if(PAIN_LEVEL_SEVERE)
			new_level = PAIN_LEVEL_HORRIBLE
			if(!isnull(threshold_horrible))
				activate_horrible()

	if(new_level >= PAIN_LEVEL_SEVERE)
		RegisterSignal(source_mob, COMSIG_MOB_DRAGGED, .proc/oxyloss_drag, override = TRUE)
		RegisterSignal(source_mob, COMSIG_MOB_DEVOURED, .proc/handle_devour, override = TRUE)
		RegisterSignal(source_mob, COMSIG_MOVABLE_PRE_THROW, .proc/oxy_kill, override = TRUE)

	last_level = new_level
	addtimer(CALLBACK(src, .proc/before_update), PAIN_UPDATE_FREQUENCY)

/datum/pain/proc/decrease_pain_level()
	level_updating = TRUE

	var/new_level = PAIN_LEVEL_SEVERE
	switch(last_level)
		if(PAIN_LEVEL_MILD)
			new_level = PAIN_LEVEL_NONE
		if(PAIN_LEVEL_DISCOMFORTING)
			new_level = PAIN_LEVEL_MILD
			if(!isnull(threshold_mild))
				activate_mild()
		if(PAIN_LEVEL_MODERATE)
			new_level = PAIN_LEVEL_DISCOMFORTING
			if(!isnull(threshold_discomforting))
				activate_discomforting()
		if(PAIN_LEVEL_DISTRESSING)
			new_level = PAIN_LEVEL_MODERATE
			if(!isnull(threshold_moderate))
				activate_moderate()
		if(PAIN_LEVEL_SEVERE)
			new_level = PAIN_LEVEL_DISTRESSING
			if(!isnull(threshold_distressing))
				activate_distressing()
		if(PAIN_LEVEL_HORRIBLE)
			new_level = PAIN_LEVEL_SEVERE
			if(!isnull(threshold_severe))
				activate_severe()

	if(new_level < PAIN_LEVEL_SEVERE)
		UnregisterSignal(source_mob, list(
			COMSIG_MOB_DRAGGED,
			COMSIG_MOB_DEVOURED,
			COMSIG_MOVABLE_PRE_THROW
		))

	last_level = new_level
	addtimer(CALLBACK(src, .proc/before_update), PAIN_UPDATE_FREQUENCY)

/datum/pain/proc/before_update()
	level_updating = FALSE
	update_pain_level()

/datum/pain/proc/recalculate_pain()
	// Reset the current pain back to start
	current_pain = 0
	pain_slowdown = 0

	for(var/datum/effects/pain/P in source_mob.effects_list)
		qdel(P)

	// Reapply it all
	apply_pain(source_mob.getBruteLoss(), BRUTE)
	apply_pain(source_mob.getFireLoss(), BURN)
	apply_pain(source_mob.getOxyLoss(), OXY)
	apply_pain(source_mob.getToxLoss(), TOX)

	return TRUE

/datum/pain/proc/activate_mild()
	pain_slowdown = PAIN_SPEED_LOW
	new /datum/effects/pain/human/mild(source_mob)

/datum/pain/proc/activate_discomforting()
	pain_slowdown = PAIN_SPEED_MED
	new /datum/effects/pain/human/discomforting(source_mob)

/datum/pain/proc/activate_moderate()
	pain_slowdown = PAIN_SPEED_HIGH
	new /datum/effects/pain/human/moderate(source_mob)

/datum/pain/proc/activate_distressing()
	pain_slowdown = PAIN_SPEED_SLOW
	new /datum/effects/pain/human/distressing(source_mob)

/datum/pain/proc/activate_severe()
	pain_slowdown = PAIN_SPEED_VERYSLOW
	new /datum/effects/pain/human/severe(source_mob)

/datum/pain/proc/activate_horrible()
	pain_slowdown = PAIN_SPEED_VERYSLOW
	new /datum/effects/pain/human/horrible(source_mob)

/datum/pain/proc/oxyloss_drag(mob/living/source, mob/puller)
	SIGNAL_HANDLER
	if(isXeno(puller) && source.stat == UNCONSCIOUS)
		source.apply_damage(20, OXY)

/datum/pain/proc/handle_devour(mob/living/source)
	SIGNAL_HANDLER
	if(source.chestburst)
		return
	oxy_kill(source)
	return COMPONENT_CANCEL_DEVOUR

/datum/pain/proc/oxy_kill(mob/living/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(source, /mob/proc.death)

/datum/pain/Destroy()
	. = ..()

	source_mob = null
