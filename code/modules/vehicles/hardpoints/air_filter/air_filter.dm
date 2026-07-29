/obj/item/hardpoint/air_filter
	name = "\improper air filter"
	desc = "Filters outside air before it reaches the crew compartment."

	slot = HDPT_AIR_FILTER
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "filter-0"

	health = 700
	damage_multiplier = 0.2
	power_draw = AIR_FILTER_POWER_DRAW

// obs. this is an internal fighting compartment air filter, not an engine air filter.
/obj/item/hardpoint/air_filter/uscm
	name = "\improper M39 air filter"
	desc = "The air filtration system of a USCM ground vehicle. Standard issue across the fleet."

/obj/item/hardpoint/air_filter/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "filter-[get_shared_damage_suffix()]"

/obj/item/hardpoint/air_filter/on_uninstall(obj/vehicle/multitile/vehicle)
	update_icon()
	. = ..()

/**
 * How much of a gas cloud gets through into the crew compartment, 0 to 1.
 * Scales with wound tier and integrity. Fully leaks if unpowered or destroyed.
 */
/obj/item/hardpoint/air_filter/proc/get_gas_leak_fraction()
	if(health <= 0 || !owner?.has_vehicle_power())
		return 1

	var/worst_tier = 0
	for(var/family_type in wound_tiers)
		worst_tier = max(worst_tier, wound_tiers[family_type])

	var/tier_floor = 0
	var/tier_ceiling = AIR_FILTER_LEAK_FRACTION_TIER_1
	if(worst_tier == 1)
		tier_floor = AIR_FILTER_LEAK_FRACTION_TIER_1
		tier_ceiling = AIR_FILTER_LEAK_FRACTION_TIER_2
	else if(worst_tier >= 2)
		tier_floor = AIR_FILTER_LEAK_FRACTION_TIER_2
		tier_ceiling = 1

	var/degrade_ratio = CLAMP01((AIR_FILTER_LEAK_HEALTH_THRESHOLD_PCT - get_integrity_percent()) / AIR_FILTER_LEAK_HEALTH_THRESHOLD_PCT)
	return tier_floor + (tier_ceiling - tier_floor) * degrade_ratio
