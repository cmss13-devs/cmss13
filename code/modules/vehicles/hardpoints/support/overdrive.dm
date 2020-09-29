/obj/item/hardpoint/support/overdrive_enhancer
	name = "Overdrive Enhancer"
	desc = "Increases the movement speed of the vehicle it's atached to"

	icon_state = "odrive_enhancer"
	disp_icon = "tank"
	disp_icon_state = "odrive_enhancer"

	health = 250

	// 25% movespeed increase. Remember that movespeed is given in delay
	buff_multipliers = list(
		"move" = 0.75
	)

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 32),
		"8" = list(0, 0)
	)

/obj/item/hardpoint/support/overdrive_enhancer/apply_buff(var/obj/vehicle/multitile/V)
	if(buff_applied)
		return
	for(var/obj/item/hardpoint/locomotion/TR in V.hardpoints)
		if(TR.health > 0)
			V.misc_multipliers["move"] *= LAZYACCESS(buff_multipliers, "move")
			buff_applied = TRUE
			break

/obj/item/hardpoint/support/overdrive_enhancer/remove_buff(var/obj/vehicle/multitile/V)
	if(!buff_applied)
		return
	V.misc_multipliers["move"] /= LAZYACCESS(buff_multipliers, "move")
	buff_applied = FALSE