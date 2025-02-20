/obj/item/hardpoint/locomotion/treads
	name = "\improper Treads"
	desc = "Integral to the movement of the vehicle. Steel reinforced rubber tracks, they allow the tank to move faster but in turn need repairs more often."

	icon_state = "treads"
	disp_icon = "tank"
	disp_icon_state = "treads"

	slot = HDPT_TREADS

	health = 300

	//with this settings, takes 3 tiles to reach top speed
	move_delay = 3.8
	move_max_momentum = 3
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

/obj/item/hardpoint/locomotion/treads/robust
	name = "\improper Reinforced Treads"
	desc = "These treads are made of solid steel plates and are more durable. However, the extra weight slows the tank down."

	health = 500
	acid_resistant = TRUE

	move_max_momentum = 5 //same top speed, but takes 5 tiles to reach it

/obj/item/hardpoint/locomotion/treads/on_install(obj/vehicle/multitile/V)
	for(var/obj/item/hardpoint/support/overdrive_enhancer/OD in V.hardpoints)
		if(OD.health > 0)
			OD.apply_buff(V)
	if(move_delay)
		V.move_delay = move_delay
	if(move_max_momentum)
		V.move_max_momentum = move_max_momentum
	if(move_momentum_build_factor)
		V.move_momentum_build_factor = move_momentum_build_factor
	if(move_turn_momentum_loss_factor)
		V.move_turn_momentum_loss_factor = move_turn_momentum_loss_factor

/obj/item/hardpoint/locomotion/treads/deactivate()
	for(var/obj/item/hardpoint/support/overdrive_enhancer/OD in owner.hardpoints)
		if(OD.health > 0)
			OD.remove_buff(owner)
	owner.move_delay = initial(owner.move_delay)
	owner.move_max_momentum = initial(owner.move_max_momentum)
	owner.move_momentum_build_factor = initial(owner.move_momentum_build_factor)
	owner.move_turn_momentum_loss_factor = initial(owner.move_turn_momentum_loss_factor)
