#define SUPPRESSING_STACKS_1	10
#define SUPPRESSING_STACKS_2	20
#define SUPPRESSING_STACKS_3	30	//maxed suppression

#define SUPPRESSING_STACKS_HUMAN	4
#define SUPPRESSING_STACKS_XENOS	2
#define SUPPRESSING_STACKS_LARGE	1

#define SUPPRESSING_STACKS_DISSIPATE_TIME	2 SECONDS
#define SUPPRESSING_STACK_LOSS_PER_SECOND	AMOUNT_PER_TIME(3, 1 SECONDS)	//loss of stack per second after DISSIPATE_TIME

/datum/component/suppressing_stack
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/suppressing_stack = 0
	var/last_stack

/datum/component/suppressing_stack/Initialize(var/_suppressing_stack, var/time)
	. = ..()
	src.suppressing_stack = _suppressing_stack * get_mob_size_modifier()
	src.last_stack = time
	if(!time)
		src.last_stack = world.time

/datum/component/suppressing_stack/InheritComponent(datum/component/suppressing_stack/S, i_am_original, var/_suppressing_stack, var/_time)
	. = ..()
	if(!S)
		src.suppressing_stack += _suppressing_stack * get_mob_size_modifier()
		src.last_stack = _time
		if(!_time)
			src.last_stack = world.time
	else
		src.suppressing_stack += S.suppressing_stack
		src.last_stack = S.last_stack

	src.suppressing_stack = min(src.suppressing_stack, SUPPRESSING_STACKS_3)

/datum/component/suppressing_stack/process(delta_time)
	if(last_stack + SUPPRESSING_STACKS_DISSIPATE_TIME < world.time)
		suppressing_stack = suppressing_stack - SUPPRESSING_STACK_LOSS_PER_SECOND * delta_time

	var/mob/M = parent
	switch(suppressing_stack)
		if(SUPPRESSING_STACKS_3)
			M.Superslow(1.6)
			M.Slow(1.6)
			M.Daze(1.6)
		if(SUPPRESSING_STACKS_2 to SUPPRESSING_STACKS_3-1)
			M.Slow(1.6)
			M.Daze(1.6)
		if(SUPPRESSING_STACKS_1 to SUPPRESSING_STACKS_2-1)
			M.Daze(1.6)
		if(-INFINITY to 0)
			qdel(src)

/datum/component/suppressing_stack/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(,
		COMSIG_XENO_BULLET_ACT,
		COMSIG_HUMAN_BULLET_ACT
	), .proc/apply_suppressing_stacks)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, .proc/stat_append)

/datum/component/suppressing_stack/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_HUMAN_BULLET_ACT,
		COMSIG_BULLET_ACT_XENO,
		COMSIG_XENO_APPEND_TO_STAT
	))

/datum/component/suppressing_stack/proc/stat_append(var/mob/M, var/list/L)
	SIGNAL_HANDLER
	L += "Suppressing Stack: [suppressing_stack]/[SUPPRESSING_STACKS_3]"

/datum/component/suppressing_stack/proc/apply_suppressing_stacks(var/mob/living/L)
	SIGNAL_HANDLER
	if(!(suppressing_stack % 2))
		shake_camera(L, strength = max(0.1, suppressing_stack/SUPPRESSING_STACKS_3))

/datum/component/suppressing_stack/proc/get_mob_size_modifier()
	var/mob/living/carbon/Xenomorph/X = parent
	if(istype(X))
		if(X.mob_size >= MOB_SIZE_BIG)
			. = SUPPRESSING_STACKS_LARGE
		else
			. = SUPPRESSING_STACKS_XENOS
	else
		. = SUPPRESSING_STACKS_HUMAN

#undef SUPPRESSING_STACKS_1
#undef SUPPRESSING_STACKS_2
#undef SUPPRESSING_STACKS_3

#undef SUPPRESSING_STACKS_HUMAN
#undef SUPPRESSING_STACKS_XENOS
#undef SUPPRESSING_STACKS_LARGE

#undef SUPPRESSING_STACKS_DISSIPATE_TIME
#undef SUPPRESSING_STACK_LOSS_PER_SECOND
