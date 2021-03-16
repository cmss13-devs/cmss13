/**
 * A tech that applies a buff to a specific set of xenos (or the whole hive) once.
 * Can be purchased multiple times.
 */
/datum/tech/xeno/powerup
	name = "Xeno Powerup Tech"

	tech_flags = TECH_FLAG_MULTIUSE
	var/purchase_cooldown = 10 SECONDS
	var/next_purchase = 0

	unlocked = TRUE

	var/xenos_required = TRUE

/datum/tech/xeno/powerup/can_unlock(mob/M)
	. = ..()
	if(next_purchase > world.time)
		to_chat(M, SPAN_WARNING("You recently purchased this powerup! Wait [DisplayTimeText(next_purchase - world.time, 0.1)]"))
		return FALSE

/datum/tech/xeno/powerup/on_unlock(var/mob/M)
	var/list/applicable_xenos = get_applicable_xenos(M)
	if(!applicable_xenos && xenos_required)
		to_chat(M, SPAN_WARNING("No applicable xenos found! Refunding points."))
		return FALSE

	..()

	if(!islist(applicable_xenos))
		applicable_xenos = list(applicable_xenos)

	for(var/i in applicable_xenos)
		apply_powerup(i)

	next_purchase = world.time + purchase_cooldown
	return FALSE

/datum/tech/xeno/powerup/proc/get_applicable_xenos(mob/user)
	return

/datum/tech/xeno/powerup/proc/apply_powerup(mob/living/carbon/Xenomorph/target)
	return
