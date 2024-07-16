

//Simple borg hand.
//Limited use.
/obj/item/device/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool for synthetic assets."
	icon_state = "gripper"

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/cell,
		/obj/item/circuitboard,
		/obj/item/stock_parts,
		/obj/item/frame,
		/obj/item/tank,
		/obj/item/stock_parts/smes_coil
		)

	//Item currently being held.
	var/obj/item/wrapped = null

/obj/item/device/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/clipboard,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/card/id,
	)

/obj/item/device/gripper/attack_self(mob/user as mob)
	..()

	if(wrapped)
		wrapped.attack_self(user)

/obj/item/device/gripper/verb/drop_item()

	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Drone"
	set src in usr
	if(!wrapped)
		//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
		for(var/obj/item/thing in src.contents)
			thing.forceMove(get_turf(src))
		return

	if(wrapped.loc != src)
		wrapped = null
		return

	to_chat(src.loc, SPAN_WARNING("You drop \the [wrapped]."))
	wrapped.forceMove(get_turf(src))
	wrapped = null
	//update_icon()

/obj/item/device/gripper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/device/gripper/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)

	if(!target || !proximity) //Target is invalid or we are not adjacent.
		return

	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break

	if(wrapped) //Already have an item.

		//Temporary put wrapped into user so target's attackby() checks pass.
		wrapped.forceMove(user)

		//Pass the attack on to the target. This might delete/relocate wrapped.
		target.attackby(wrapped,user)

		//If wrapped was neither deleted nor put into target, put it back into the gripper.
		if(wrapped && user && (wrapped.loc == user))
			wrapped.forceMove(src)
		else
			wrapped = null
			return

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			to_chat(user, "You collect \the [I].")
			I.forceMove(src)
			wrapped = I
			return
		else
			to_chat(user, SPAN_DANGER("Your gripper cannot hold \the [target]."))

	else if(istype(target,/obj/structure/machinery/power/apc))
		var/obj/structure/machinery/power/apc/A = target
		if(A.opened)
			if(A.cell)

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.cell.forceMove(src)
				A.cell = null

				A.charging = 0
				A.update_icon()

				user.visible_message(SPAN_DANGER("[user] removes the power cell from [A]!"), "You remove the power cell.")
