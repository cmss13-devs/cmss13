



// Generalized form of a Xenomorph shield for use with MOBA Xenos
// Concept: acts as an HP 'cushion', and can define any backend behaviors it wants
// They are all stored in a list on Xenos that gets iterated through whenever the Xeno
// takes damage

/datum/xeno_shield
	var/shield_source = XENO_SHIELD_SOURCE_GENERIC  // Unique so that you can only get one shield from a given source at a time
	var/amount = 0                                  // How much damage the shield will protect
	var/last_damage_taken                           // Time we last took damage
	var/duration                                    // Time before decay starts. If not specified, doesn't decay.
	var/decay_amount_per_second                     // Once the shield begins decaying, how much damage is it taking per tick.
	var/mob/living/carbon/Xenomorph/linked_xeno		// Xeno to whom the shield is attached
	var/processing = FALSE

// Handle a hit. return a new shield hit result class
// indicating the outcome.
/datum/xeno_shield/proc/on_hit(damage)
    last_damage_taken = world.time

    apply_damage(damage)

    if (amount <= 0)
        return -amount
    return 0

/datum/xeno_shield/Destroy()
	if(linked_xeno)
		linked_xeno.xeno_shields -= src
		linked_xeno.overlay_shields()
		linked_xeno = null
	if(processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

// Actually calculate how much the damage reduces our amount
/datum/xeno_shield/proc/apply_damage(damage)
    amount -= damage
    return

// Anything special to do on removal
/datum/xeno_shield/proc/on_removal()
	return

/datum/xeno_shield/proc/begin_decay()
	START_PROCESSING(SSobj, src)
	processing = TRUE

/datum/xeno_shield/process(delta_time)
	..()
	amount = max(amount - decay_amount_per_second * delta_time, 0)
	if (amount <= 0)
		on_removal()
		qdel(src)


// Add a shield or replace the existing one on a Xeno
// Use the type var if you need to construct a shield with different on hit behavior, damage reduction, etc.
/mob/living/carbon/Xenomorph/proc/add_xeno_shield(\
	amount, shield_source, type = /datum/xeno_shield, \
	duration = -1, decay_amount_per_second = 1, \
	add_shield_on = FALSE, max_shield = 200)
	for (var/datum/xeno_shield/curr_shield in xeno_shields)
		if (shield_source == curr_shield.shield_source)
			// New shield from the same source? increment amount if we can
			if(add_shield_on)
				curr_shield.amount = min(curr_shield.amount + amount, max_shield)
			else
				curr_shield.amount = max(curr_shield.amount, amount)

			return

	var/datum/xeno_shield/new_shield = new type()
	new_shield.amount = amount
	new_shield.shield_source = shield_source
	xeno_shields += new_shield
	new_shield.last_damage_taken = world.time // So we don't insta-delete our shield.

	new_shield.decay_amount_per_second = decay_amount_per_second
	new_shield.linked_xeno = src

	if(duration > -1)
		addtimer(CALLBACK(new_shield, /datum/xeno_shield.proc/begin_decay), duration)

	overlay_shields()
	return new_shield

