/obj/item/hardpoint/armor
	name = "armor hardpoint"
	desc = "Primary armor source."

	slot = HDPT_ARMOR
	hdpt_layer = HDPT_LAYER_ARMOR

	damage_multiplier = 0.5

	health = 1000

	/// Whether this armor's type_multipliers also protect internal modules, not just external ones.
	var/protects_internal_modules = FALSE
	/// Multiplier on neurotoxin wound chance vehicle-wide. 1 for every type except Caustic.
	var/neuro_wound_chance_mult = 1

/**
 * Scales incoming damage by this panel's own current wound multiplier before applying it.
 * A corroded/cracked panel gets weaker where it's already been hit, unlike the turret
 * holder's cascade which buffs damage to other hardpoints.
 */
/obj/item/hardpoint/armor/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	var/scaled_damage = damage * get_incoming_damage_wound_multiplier(wound_damage_type_for(type))
	. = ..(scaled_damage, type, attacker, unmitigated, wound_chance_mult)
