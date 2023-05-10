

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

/obj/item/device/gripper/attack(mob/living/carbon/current_mob as mob, mob/living/carbon/user as mob)
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

		var/obj/item/current_object = target

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(current_object,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			to_chat(user, "You collect \the [current_object].")
			current_object.forceMove(src)
			wrapped = current_object
			return
		else
			to_chat(user, SPAN_DANGER("Your gripper cannot hold \the [target]."))

	else if(istype(target,/obj/structure/machinery/power/apc))
		var/obj/structure/machinery/power/apc/apc = target
		if(apc.opened)
			if(apc.cell)

				wrapped = apc.cell

				apc.cell.add_fingerprint(user)
				apc.cell.update_icon()
				apc.cell.forceMove(src)
				apc.cell = null

				apc.charging = 0
				apc.update_icon()

				user.visible_message(SPAN_DANGER("[user] removes the power cell from [apc]!"), "You remove the power cell.")







//TODO: Matter decompiler.
/obj/item/device/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon_state = "decompiler"

	//Metal, glass, wood, plastic.
	var/list/stored_comms = list(
		"metal" = 0,
		"glass" = 0,
		"wood" = 0,
		"plastic" = 0
		)

/obj/item/device/matter_decompiler/attack(mob/living/carbon/current_mob as mob, mob/living/carbon/user as mob)
	return

/obj/item/device/matter_decompiler/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)

	if(!proximity) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/current_turf = get_turf(target)
	if(!istype(current_turf))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/current_mob in current_turf)
		if(istype(current_mob,/mob/living/simple_animal/lizard) || istype(current_mob,/mob/living/simple_animal/mouse))
			src.loc.visible_message(SPAN_DANGER("[src.loc] sucks [current_mob] into its decompiler. There's a horrible crunching noise."),SPAN_DANGER("It's a bit of a struggle, but you manage to suck [current_mob] into your decompiler. It makes a series of visceral crunching noises."))
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(current_mob)
			stored_comms["wood"]++
			stored_comms["wood"]++
			stored_comms["plastic"]++
			stored_comms["plastic"]++
			return

		else if(ismaintdrone(current_mob) && !current_mob.client)

			var/mob/living/silicon/robot/drone/drone = src.loc

			if(!istype(drone))
				return

			to_chat(drone, SPAN_DANGER("You begin decompiling the other drone."))

			if(!do_after(drone, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
				to_chat(drone, SPAN_DANGER("You need to remain still while decompiling such a large object."))
				return

			if(!current_mob || !drone) return

			to_chat(drone, SPAN_DANGER("You carefully and thoroughly decompile your downed fellow, storing as much of its resources as you can within yourself."))

			qdel(current_mob)
			new/obj/effect/decal/cleanable/blood/oil(get_turf(src))

			stored_comms["metal"] += 15
			stored_comms["glass"] += 15
			stored_comms["wood"] += 5
			stored_comms["plastic"] += 5

			return
		else
			continue

	for(var/obj/current_obj in current_turf)
		//Different classes of items give different commodities.
		if (istype(current_obj,/obj/item/trash/cigbutt))
			stored_comms["plastic"]++
		else if(istype(current_obj,/obj/effect/spider/spiderling))
			stored_comms["wood"]++
			stored_comms["wood"]++
			stored_comms["plastic"]++
			stored_comms["plastic"]++
		else if(istype(current_obj,/obj/item/light_bulb))
			var/obj/item/light_bulb/bulb = current_obj
			if(bulb.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				stored_comms["metal"]++
				stored_comms["glass"]++
			else
				continue
		else if(istype(current_obj,/obj/effect/decal/remains/robot))
			stored_comms["metal"]++
			stored_comms["metal"]++
			stored_comms["plastic"]++
			stored_comms["plastic"]++
			stored_comms["glass"]++
		else if(istype(current_obj,/obj/item/trash))
			stored_comms["metal"]++
			stored_comms["plastic"]++
			stored_comms["plastic"]++
			stored_comms["plastic"]++
		else if(istype(current_obj,/obj/effect/decal/cleanable/blood/gibs/robot))
			stored_comms["metal"]++
			stored_comms["metal"]++
			stored_comms["glass"]++
			stored_comms["glass"]++
		else if(istype(current_obj,/obj/item/ammo_casing))
			stored_comms["metal"]++
		else if(istype(current_obj,/obj/item/shard/shrapnel))
			stored_comms["metal"]++
			stored_comms["metal"]++
			stored_comms["metal"]++
		else if(istype(current_obj,/obj/item/shard))
			stored_comms["glass"]++
			stored_comms["glass"]++
			stored_comms["glass"]++
		else if(istype(current_obj,/obj/item/reagent_container/food/snacks/grown))
			stored_comms["wood"]++
			stored_comms["wood"]++
			stored_comms["wood"]++
			stored_comms["wood"]++
		else if(istype(current_obj,/obj/item/ammo_magazine))
			var/obj/item/ammo_magazine/AM = current_obj
			if(AM.current_rounds)
				continue
			stored_comms["metal"]++
		else
			continue

		qdel(current_obj)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, SPAN_NOTICE(" You deploy your decompiler and clear out the contents of \the [current_turf]."))
	else
		to_chat(user, SPAN_DANGER("Nothing on \the [current_turf] is useful to you."))
	return
