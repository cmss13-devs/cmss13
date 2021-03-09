/**
 * A tech that can be purchased multiple times
 */
/datum/tech/repeatable
	name = "Repeatable Tech"

	var/announce_name
	var/announce_message

	tech_flags = TECH_FLAG_MULTIUSE
	var/purchase_cooldown = 10 SECONDS
	var/next_purchase = 0
	var/increase_per_purchase = 0

	unlocked = TRUE

/datum/tech/repeatable/can_unlock(mob/M)
	. = ..()
	if(!.)
		return

	if(next_purchase > world.time)
		to_chat(M, SPAN_WARNING("You recently purchased this! Wait [DisplayTimeText(next_purchase - world.time, 0.1)]"))
		return FALSE

/datum/tech/repeatable/on_unlock()
	..()
	if(announce_message && announce_name)
		marine_announcement(announce_message, announce_name, 'sound/misc/notice2.ogg')

	next_purchase = world.time + purchase_cooldown
	required_points += increase_per_purchase
	return FALSE
