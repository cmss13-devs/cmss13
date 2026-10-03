/obj/item/hardpoint/primary
	name = "primary hardpoint"
	desc = "Main big gun."

	slot = HDPT_PRIMARY

	damage_multiplier = 0.15

	activatable = TRUE
	uses_live_rotation_tracking = TRUE
	//so it draws above wheels.
	hdpt_layer = HDPT_LAYER_TURRET

/**
 * Accuracy/scatter depend on this weapon's raw integrity, not just its wound tiers.
 * Health drifts on every hit, so bonuses need a refresh here to stay live.
 */
/obj/item/hardpoint/primary/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	if(owner)
		recalculate_hardpoint_bonuses()
	recalculate_own_turn_rate()

/obj/item/hardpoint/primary/recalculate_wound_effects()
	. = ..()
	recalculate_own_turn_rate()
