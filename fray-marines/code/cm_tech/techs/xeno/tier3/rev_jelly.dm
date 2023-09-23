/datum/tech/xeno/powerup/revive
	name = "Revival Jelly"
	desc = {"The queen dispenses a special type of royal jelly, which can be given to a fallen sister to rejuvenate and revive them. \
	The amount of jelly required depends on the caste tier. \
	"}
	icon_state = "jelly"

	flags = TREE_FLAG_XENO

	required_points = 15
	increase_per_purchase = 1
	tier = /datum/tier/three/additional

	var/amount_to_give = 6

/datum/tech/xeno/powerup/revive/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Amount Given: [amount_to_give]",
			"color" = "green",
			"icon" = "shopping-bag"
		)
	)
	.["stats"] += list(
		list(
			"content" = "Can only be used whilst the Queen is on her ovipositor.",
			"color" = "purple",
			"icon" = "biohazard"
		)
	)

/datum/tech/xeno/powerup/revive/can_unlock(mob/M)
	. = ..()
	if(!.)
		return
	if(!hive.living_xeno_queen?.ovipositor)
		to_chat(M, SPAN_XENOWARNING("The Queen must be on her ovipositor to apply this tech!"))
		return FALSE

/datum/tech/xeno/powerup/revive/apply_powerup(mob/living/carbon/xenomorph/target)
	var/turf/deployment_turf = get_turf(target)

	new /obj/item/stack/revival_jelly(deployment_turf, amount_to_give)
	playsound(deployment_turf, "alien_resin_build", 50)

/datum/tech/xeno/powerup/revive/get_applicable_xenos(mob/user)
	return hive.living_xeno_queen
