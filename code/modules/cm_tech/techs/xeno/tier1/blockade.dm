/datum/tech/xeno/powerup/blockade
	name = "Blockade"
	desc = "The queen gets the ability to place blockades."

	flags = TREE_FLAG_XENO

	required_points = 5
	var/charges_to_give = 2
	tier = /datum/tier/one

/datum/tech/xeno/powerup/blockade/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Charges Given: [charges_to_give]",
			"color" = "green",
			"icon" = "exchange-alt"
		)
	)

/datum/tech/xeno/powerup/blockade/apply_powerup(mob/living/carbon/Xenomorph/target)
	var/datum/action/xeno_action/B = get_xeno_action_by_type(target, /datum/action/xeno_action/activable/blockade)

	if(!B)
		B = give_action(target, /datum/action/xeno_action/activable/blockade)

	B.charges += charges_to_give

/datum/tech/xeno/powerup/blockade/get_applicable_xenos(var/mob/user)
	return hive.living_xeno_queen
