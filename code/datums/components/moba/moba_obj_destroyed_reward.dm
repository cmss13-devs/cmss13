/datum/component/moba_obj_destroyed_reward
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// How much gold to award on death to everyone nearby
	var/gold = 0
	/// How much XP to award on death to everyone nearby
	var/xp = 0
	/// What hive we're friendly to, if any
	var/allied_hive
	/// How much gold to give to each person on the team regardless of distance
	var/global_gold = 0

/datum/component/moba_obj_destroyed_reward/Initialize(gold = 0, xp = 0, allied_hive, global_gold = 0)
	. = ..()
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE

	src.gold = gold
	src.xp = xp
	src.allied_hive = allied_hive
	src.global_gold = global_gold

/datum/component/moba_obj_destroyed_reward/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_del))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/moba_obj_destroyed_reward/proc/on_del(datum/source, force)
	SIGNAL_HANDLER

	var/list/awarding_xenos = list()

	for(var/mob/living/carbon/xenomorph/xeno in view(world.view, parent))
		if(!xeno.client || (xeno.stat == DEAD)) // Must be a player and can't be dead
			continue

		if(xeno.hive.hivenumber == allied_hive) // We don't reward our allies when we die
			continue

		if(global_gold)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, global_gold)

		awarding_xenos += xeno

	for(var/mob/living/carbon/xenomorph/xeno as anything in awarding_xenos)
		if(gold)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, floor(gold / length(awarding_xenos)))

		if(xp)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_XP, floor(xp / length(awarding_xenos)))

/datum/component/moba_obj_destroyed_reward/proc/on_examine(datum/source, mob/observer, list/strings)
	SIGNAL_HANDLER

	var/show_text = FALSE
	if(isobserver(observer))
		show_text = TRUE

	else if(isxeno(observer))
		var/mob/living/carbon/xenomorph/xeno = observer
		if(xeno.hivenumber != allied_hive)
			show_text = TRUE

	if(show_text)
		var/atom/atom_parent = parent
		if(gold)
			strings += SPAN_XENONOTICE("[gold][MOBA_GOLD_NAME_SHORT] will be split among the destroying team of this [atom_parent.name].")
		if(xp)
			strings += SPAN_XENONOTICE("[xp] XP will be split among the destroying team of this [atom_parent.name].")
		if(global_gold)
			strings += SPAN_XENONOTICE("[global_gold][MOBA_GOLD_NAME_SHORT] will be given to each member of the destroying team of this [atom_parent.name].")
