/*
	Pain datum for holding all pain related proc to mobs.

	The threshold vars determine when the associated threshold procs should activate.
	The threshold vars are percentage values, so if you want the mild effect to appear at 20% pain, you assign it 20.

	Each mob should spawn with a pain datumn. 

	Can be customized for each mob, default procs are slow and messages appearing at mild.
		Moderate, more slow, new message.
		Modsevere, slow getting worse, vision starting to fade.
		Severe, slowed a lot, oxygen damage starting to build up.
		Very severe, rapid oxygen buildup, knocked out.

	Pain is applied and removed when needed with the apply_pain() proc.
	Negative values remove and positive values add.
*/

// Pain level, how bad are you in pain right now
#define PAIN_LEVEL_NONE 0
#define PAIN_LEVEL_MILD 1
#define PAIN_LEVEL_MODERATE 2
#define PAIN_LEVEL_MODSEVERE 3
#define PAIN_LEVEL_SEVERE 4
#define PAIN_LEVEL_VERY_SEVERE 5

// Movespeed levels, how much is the pain slowing you
#define PAIN_SPEED_VERYSLOW	4.50
#define PAIN_SPEED_SLOW		3.75
#define PAIN_SPEED_MED		2.75
#define PAIN_SPEED_LOW		1.50

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

	var/threshold_mild 		= 20
	var/threshold_moderate 	= 40
	var/threshold_modsevere	= 60
	var/threshold_severe 	= 75
	var/threshold_very_severe = 90

	var/pain_slowdown		= 0
	
	var/last_reduction_update = 0

	var/feels_pain = TRUE

/datum/pain/New(var/mob/owner)
	. = ..()

	if(istype(owner))
		source_mob = owner
	else
		qdel(src)

/datum/pain/proc/get_pain_percentage()
	if(current_pain - reduction_pain > max_pain)
		return 100

	var/percentage = round(((current_pain - reduction_pain) / max_pain) * 100)
	if(percentage < 0)
		log_debug("[source_mob] has a pain percentage under 0. Current pain: [current_pain], Reduction pain: [reduction_pain], Max pain: [max_pain]")
		CRASH("Pain percentage was under 0 for a mob")
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

	last_reduction_update = world.time + SECONDS_10
	reduction_pain = amount

	update_pain_level()

/datum/pain/proc/reset_pain_reduction()
	reduction_pain = 0
	
	update_pain_level()

/datum/pain/proc/update_pain_level()
	var/new_level = PAIN_LEVEL_NONE
	var/pain_percentage = get_pain_percentage()
	if(pain_percentage >= threshold_very_severe && !isnull(threshold_very_severe))
		new_level = PAIN_LEVEL_VERY_SEVERE
	else if (pain_percentage >= threshold_severe && !isnull(threshold_severe))
		new_level = PAIN_LEVEL_SEVERE
	else if (pain_percentage >= threshold_modsevere && !isnull(threshold_modsevere))
		new_level = PAIN_LEVEL_MODSEVERE
	else if (pain_percentage >= threshold_moderate && !isnull(threshold_moderate))
		new_level = PAIN_LEVEL_MODERATE
	else if (pain_percentage >= threshold_mild && !isnull(threshold_mild))
		new_level = PAIN_LEVEL_MILD

	if(!check_active_pain(new_level))
		return

	switch(new_level)
		if(PAIN_LEVEL_MILD)
			activate_mild()
		if(PAIN_LEVEL_MODERATE)
			activate_moderate()
		if(PAIN_LEVEL_MODSEVERE)
			activate_modsevere()
		if(PAIN_LEVEL_SEVERE)
			activate_severe()
		if(PAIN_LEVEL_VERY_SEVERE)
			activate_very_severe()
			
	last_level = new_level

/datum/pain/proc/check_active_pain(var/level = 0)
	if(level == last_level) //Check if the new level is same as old one
		return FALSE

	for(var/datum/effects/pain/P in source_mob.effects_list)
		qdel(P)

	pain_slowdown = 0

	return TRUE

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

/datum/pain/proc/activate_moderate()
	pain_slowdown = PAIN_SPEED_MED
	new /datum/effects/pain/human/moderate(source_mob)

/datum/pain/proc/activate_modsevere()
	pain_slowdown = PAIN_SPEED_SLOW
	new /datum/effects/pain/human/modsevere(source_mob)

/datum/pain/proc/activate_severe()
	pain_slowdown = PAIN_SPEED_SLOW
	new /datum/effects/pain/human/severe(source_mob)

/datum/pain/proc/activate_very_severe()
	pain_slowdown = PAIN_SPEED_VERYSLOW
	new /datum/effects/pain/human/very_severe(source_mob)

/datum/pain/Dispose()
	. = ..()
	
	source_mob = null