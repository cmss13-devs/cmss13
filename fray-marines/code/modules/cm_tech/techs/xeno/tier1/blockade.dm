/datum/tech/xeno/powerup/blockade
	name = "Blockade"
	desc = "The queen gets the ability to place blockades."
	icon_state = "weed_reinforcement"

	flags = TREE_FLAG_XENO

	required_points = 2

	var/charges_to_give = 1

/datum/tech/xeno/powerup/blockade/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Charges Given: [charges_to_give]",
			"color" = "green",
			"icon" = "exchange-alt"
		)
	)

/datum/tech/xeno/powerup/blockade/apply_powerup(mob/living/carbon/xenomorph/target)
	var/datum/action/xeno_action/B = get_xeno_action_by_type(target, /datum/action/xeno_action/activable/blockade)

	if(!B)
		B = give_action(target, /datum/action/xeno_action/activable/blockade)

	B.charges += charges_to_give

/datum/tech/xeno/powerup/blockade/get_applicable_xenos(mob/user)
	return hive.living_xeno_queen
