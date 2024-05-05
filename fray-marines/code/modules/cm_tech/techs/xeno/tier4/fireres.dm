/datum/tech/xeno/fireres
	name = "Fire resistence"
	desc = "Strengthens hide of xeno for more survival rate. Reduces the time of resistance from fire"
	icon = 'fray-marines/icons/effects/techtree/tech.dmi'
	icon_state = "fireres"

	flags = TREE_FLAG_XENO

	required_points = 10
	tier = /datum/tier/two

/datum/tech/xeno/fireres/on_unlock(datum/techtree/two)
	. = ..()
	hive.resist_xeno_countdown = 2
