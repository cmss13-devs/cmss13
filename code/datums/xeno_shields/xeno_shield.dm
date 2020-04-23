



// Generalized form of a Xenomorph shield for use with MOBA Xenos
// Concept: acts as an HP 'cushion', and can define any backend behaviors it wants
// They are all stored in a list on Xenos that gets iterated through whenever the Xeno 
// takes damage

// Data class for holding the results of a hit
/datum/xeno_shield_hit_result
    var/shield_survived = TRUE  // Should we get deleted by whatever called on_hit?
    var/damage_carryover = 0    // Any damage that we didn't block
    

/datum/xeno_shield
    var/shield_source = XENO_SHIELD_SOURCE_GENERIC  // Unique so that you can only get one shield from a given source at a time
    var/amount = 0                                  // How much damage the shield will protect
    var/last_damage_taken                           // Time we last took damage

// Handle a hit. return a new shield hit result class
// indicating the outcome.
/datum/xeno_shield/proc/on_hit(damage)
    var/datum/xeno_shield_hit_result/XSHR = new /datum/xeno_shield_hit_result()
    last_damage_taken = world.time

    apply_damage(damage)
    
    if (amount <= 0)
        XSHR.shield_survived = FALSE
        XSHR.damage_carryover = -amount
    
    return XSHR

// Actually calculate how much the damage reduces our amount
/datum/xeno_shield/proc/apply_damage(damage)
    amount -= damage
    return

// Anything special to do on removal
/datum/xeno_shield/proc/on_removal()
    return

// Add a shield or replace the existing one on a Xeno
// Use the type var if you need to construct a shield with different on hit behavior, damage reduction, etc.
/mob/living/carbon/Xenomorph/proc/add_xeno_shield(amount, shield_source, type = /datum/xeno_shield)
	for (var/datum/xeno_shield/curr_shield in xeno_shields)
		if (shield_source == curr_shield.shield_source)
			// New shield from the same source? increment amount if we can
			curr_shield.amount = max(curr_shield.amount, amount)
			return

	var/datum/xeno_shield/new_shield = new type()
	new_shield.amount = amount
	new_shield.shield_source = shield_source
	xeno_shields += new_shield
	new_shield.last_damage_taken = world.time // So we don't insta-delete our shield.
	overlay_shields()
	return new_shield


