/datum/tech/xeno/powerup/queen_beacon
	name = "Queen Beacon"
	desc = "Rally the hive to a specific position!"
	icon_state = "beacon"

	flags = TREE_FLAG_XENO

	required_points = 10
	var/charges_to_give = 1
	tier = /datum/tier/two

/datum/tech/xeno/powerup/queen_beacon/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Charges Given: [charges_to_give]",
			"color" = "green",
			"icon" = "exchange-alt"
		)
	)

/datum/tech/xeno/powerup/queen_beacon/apply_powerup(mob/living/carbon/Xenomorph/target)
	var/datum/action/xeno_action/A = get_xeno_action_by_type(target, /datum/action/xeno_action/activable/place_queen_beacon)

	if(!A)
		A = give_action(target, /datum/action/xeno_action/activable/place_queen_beacon)

	A.charges += charges_to_give

/datum/tech/xeno/powerup/queen_beacon/get_applicable_xenos(var/mob/user)
	return hive.living_xeno_queen
