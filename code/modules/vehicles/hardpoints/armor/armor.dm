/obj/item/hardpoint/buff/armor
	name = "armor hardpoint"
	desc = "i'm protecting :)"

	slot = HDPT_ARMOR
	hdpt_layer = HDPT_LAYER_ARMOR

	damage_multiplier = 0.5

	// List of multipliers for every damage type
	var/list/type_multipliers

/obj/item/hardpoint/buff/armor/apply_buff(var/obj/vehicle/multitile/V)
	for(var/type in type_multipliers)
		owner.dmg_multipliers[type] *= type_multipliers[type]

obj/item/hardpoint/buff/armor/remove_buff(var/obj/vehicle/multitile/V)
	for(var/type in type_multipliers)
		owner.dmg_multipliers[type] *= 1 / type_multipliers[type]