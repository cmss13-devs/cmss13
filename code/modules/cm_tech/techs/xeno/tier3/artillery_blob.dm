/datum/tech/xeno/powerup/artillery_blob
	name = "Artillery Blob"
	desc = "The queen can fire a glob of gas to siege fortified enemies or stall attackers!"
	icon_state = "boiler_glob"

	flags = TREE_FLAG_XENO

	required_points = 15
	var/charges_to_give = 5
	tier = /datum/tier/three

/datum/tech/xeno/powerup/artillery_blob/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Charges Given: [charges_to_give]",
			"color" = "green",
			"icon" = "exchange-alt"
		)
	)

/datum/tech/xeno/powerup/artillery_blob/apply_powerup(mob/living/carbon/Xenomorph/target)
	var/datum/action/xeno_action/B = get_xeno_action_by_type(target, /datum/action/xeno_action/activable/bombard/queen)

	if(!B)
		B = give_action(target, /datum/action/xeno_action/activable/bombard/queen)

	B.charges += charges_to_give

/datum/tech/xeno/powerup/artillery_blob/get_applicable_xenos(var/mob/user)
	return hive.living_xeno_queen
