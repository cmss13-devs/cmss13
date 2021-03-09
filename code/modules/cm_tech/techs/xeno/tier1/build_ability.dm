/datum/tech/xeno/build_distribution
	name = "Build Distribution"
	desc = "Distribute the ability to build to all xenomorphs"
	icon_state = "build_distro"

	flags = TREE_FLAG_XENO

	required_points = 15
	tier = /datum/tier/one

	var/list/actions_to_give = list(
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin
	)

/datum/tech/xeno/build_distribution/on_unlock()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, .proc/give_build_ability)

	for(var/m in hive.totalXenos)
		give_build_ability(src, m)

/datum/tech/xeno/build_distribution/proc/give_build_ability(datum/source, var/mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER

	if(X.stat == DEAD)
		return

	if(X.hivenumber != hivenumber)
		return

	// Exclude xenos with no plasma
	if(X.plasma_max == 0)
		return

	if(X.tier == 0)
		return

	for(var/typepath in actions_to_give)
		if(!get_xeno_action_by_type(X, typepath))
			var/datum/action/xeno_action/XA = give_action(X, typepath)

			// No need to give this ability a macro as it is an additional ability
			XA.ability_primacy = null
