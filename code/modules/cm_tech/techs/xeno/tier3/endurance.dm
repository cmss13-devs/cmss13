/datum/tech/xeno/endurance
	name = "Endurance"
	desc = "Xenomorphs become faster off weeds. Additionally, they heal very slowly as well."
	icon_state = "endurance"

	flags = TREE_FLAG_XENO

	required_points = 25
	tier = /datum/tier/three

	/// Speed multiplier off weeds for xenomorphs
	var/offweed_speed_mult = 0.95

	/// Amount to heal xenos per second by if they're not on weeds
	var/heal_amt_per_second = AMOUNT_PER_TIME(50, 30 SECONDS)

/datum/tech/xeno/endurance/on_unlock(mob/M)
	. = ..()

	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, .proc/apply_tech)
	for(var/i in hive.totalXenos)
		apply_tech(src, i)

	START_PROCESSING(SSprocessing, src)

/datum/tech/xeno/endurance/process(delta_time)
	for(var/i in hive.totalXenos)
		var/mob/living/carbon/Xenomorph/X = i
		var/turf/T = get_turf(X)
		if(!T.weeds)
			X.apply_damage(-(heal_amt_per_second*delta_time), BRUTE)

/datum/tech/xeno/endurance/proc/apply_tech(var/datum/source, var/mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	RegisterSignal(X, COMSIG_XENO_MOVEMENT_DELAY, .proc/handle_speed)

/datum/tech/xeno/endurance/proc/handle_speed(var/mob/living/carbon/Xenomorph/X, var/list/speeds)
	SIGNAL_HANDLER
	var/turf/T = get_turf(X)

	if(!T.weeds)
		speeds["speed"] *= offweed_speed_mult
