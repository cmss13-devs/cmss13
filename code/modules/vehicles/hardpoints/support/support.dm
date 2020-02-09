/obj/item/hardpoint/buff/support
	name = "support hardpoint"
	desc = "i'm helping :)"

	slot = HDPT_SUPPORT
	hdpt_layer = HDPT_LAYER_SUPPORT

	damage_multiplier = 0.075

	// List of ratios that should be applied to the vehicle
	var/list/buff_multipliers

/obj/item/hardpoint/buff/support/apply_buff(var/obj/vehicle/multitile/V)
	for(var/type in buff_multipliers)
		V.misc_multipliers[type] *= buff_multipliers[type]

obj/item/hardpoint/buff/support/remove_buff(var/obj/vehicle/multitile/V)
	for(var/type in buff_multipliers)
		V.misc_multipliers[type] *= 1 / buff_multipliers[type]
