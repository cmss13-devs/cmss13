/datum/tech/xeno/powerup/revive
	name = "Revival Jelly"
	desc = {"The queen dispenses a special type of royal jelly, which can be given to a fallen sister to rejuvenate and revive them. \
	The amount of jelly required depends on the caste tier. \
	Can only be used whilst the Queen is on her ovipositor. \
	"}
	icon_state = "jelly"

	flags = TREE_FLAG_XENO

	required_points = 15
	var/amount_to_give = 6
	tier = /datum/tier/three

/datum/tech/xeno/powerup/revive/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Amount Given: [amount_to_give]",
			"color" = "green",
			"icon" = "shopping-bag"
		)
	)

/datum/tech/xeno/powerup/revive/can_unlock(mob/M)
	. = ..()
	if(!.)
		return
	if(!hive.living_xeno_queen?.ovipositor)
		to_chat(M, SPAN_XENOWARNING("The Queen must be on her ovipositor to apply this tech!"))
		return FALSE

/datum/tech/xeno/powerup/revive/apply_powerup(mob/living/carbon/Xenomorph/target)
	var/turf/deployment_turf = get_turf(target)

	new /obj/item/stack/revival_jelly(deployment_turf, amount_to_give)
	playsound(deployment_turf, "alien_resin_build", 50)

/datum/tech/xeno/powerup/revive/get_applicable_xenos(var/mob/user)
	return hive.living_xeno_queen

/obj/item/stack/revival_jelly
	name = "revival jelly"
	singular_name = "revival jelly"
	desc = "A weird jelly, capable of bringing a dead Xenomorph back to life."

	icon_state = "royal_jelly"

	stack_id = "royal jelly"

	amount = 0
	max_amount = 9
	var/time_to_take = 3 SECONDS

/obj/item/stack/revival_jelly/attack_alien(mob/living/carbon/Xenomorph/M)
	attack_hand(M) //This has a .2 second delay of its own.
	return XENO_NO_DELAY_ACTION

/obj/item/stack/revival_jelly/proc/can_revive(var/required_jelly, var/mob/living/carbon/Xenomorph/X, var/mob/living/user)
	if(user.action_busy)
		to_chat(user, SPAN_WARNING("You're already performing an action!"))
		return FALSE

	if(!X.caste.can_be_revived)
		to_chat(user, SPAN_WARNING("This Xenomorph cannot be revived!"))
		return FALSE

	if(X == user)
		to_chat(user, SPAN_WARNING("You can't use this on yourself!"))
		return FALSE

	if(!X.stat || !X.caste.can_be_revived)
		to_chat(user, SPAN_WARNING("You can't use this on [X]!"))
		return FALSE

	if(amount < required_jelly)
		to_chat(user, SPAN_WARNING("There isn't enough of [src] to revive [X]! You require [required_jelly] to do this action."))
		return FALSE

	return TRUE

/obj/item/stack/revival_jelly/attack(mob/living/carbon/Xenomorph/X, mob/living/user, def_zone)
	if(!istype(X))
		return ..()

	var/required_jelly = max(1, X.tier)

	if(!can_revive(required_jelly, X, user))
		return

	to_chat(user, SPAN_NOTICE("You start applying [src] onto [X]."))
	if(!do_after(user, time_to_take, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, X, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		to_chat(user, SPAN_WARNING("You stop applying [src] onto [X]."))
		return

	if(!can_revive(required_jelly, X, user))
		return

	X.away_timer = 0
	X.revive()
	playsound(get_turf(X), 'sound/effects/xeno_newlarva.ogg', 35)

	var/mob/original_mob = X.mind?.current
	// Make sure they still have a client and are still a ghost.
	if(original_mob?.client && original_mob.stat == DEAD)
		X.mind.transfer_to(X, TRUE)
	else
		X.away_timer = XENO_LEAVE_TIMER

	use(required_jelly)

