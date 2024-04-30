#define XENO_SHIELD_SOURCE_OVERSHIELD_TECH 13

/datum/tech/xeno/powerup/overshield
	name = "Temporary Overshield"
	desc = "Give the hive overshields for protection!"
	icon_state = "overshield"

	flags = TREE_FLAG_XENO

	required_points = 4
	tier = /datum/tier/two/additional

	var/shield_amount = 200

/datum/tech/xeno/powerup/overshield/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Shield Given: [shield_amount]",
			"color" = "orange",
			"icon" = "shield-alt"
		)
	)

/datum/tech/xeno/powerup/overshield/apply_powerup(mob/living/carbon/xenomorph/target)
	target.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_OVERSHIELD_TECH)

/datum/tech/xeno/powerup/overshield/get_applicable_xenos(mob/user)
	return hive.totalXenos
