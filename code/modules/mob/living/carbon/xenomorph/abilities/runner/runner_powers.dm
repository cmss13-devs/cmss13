/datum/action/xeno_action/activable/runner_skillshot/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return
	
	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state()) 
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("[X] fires a burst of bone chips at [A]!"), SPAN_XENOWARNING("You fire a burst of bone chips at [A]!"))

	var/turf/target = locate(A.x, A.y, A.z)
	var/obj/item/projectile/P = new /obj/item/projectile(initial(X.caste_name), X, X.loc)
	
	var/datum/ammo/ammoDatum = ammo_list[ammo_type]

	P.generate_bullet(ammoDatum)

	P.fire_at(target, X, X, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	..()
	return