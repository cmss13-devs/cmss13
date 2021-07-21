/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/items/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 500, "glass" = 0)
	var/list/part = null

/obj/item/robot_parts/l_arm
	name = "robot left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	part = list("l_arm","l_hand")

/obj/item/robot_parts/r_arm
	name = "robot right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	part = list("r_arm","r_hand")

/obj/item/robot_parts/l_leg
	name = "robot left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	part = list("l_leg","l_foot")

/obj/item/robot_parts/r_leg
	name = "robot right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	part = list("r_leg","r_foot")

/obj/item/robot_parts/chest
	name = "robot torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	var/wires = 0.0
	var/obj/item/cell/cell = null

/obj/item/robot_parts/head
	name = "robot head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	var/obj/item/device/flash/flash1 = null
	var/obj/item/device/flash/flash2 = null

/// A cameo of a real robotic head with limited gameplay functionality
/obj/item/fake_robot_head
	name = "malfunctioning robot head"
	desc = "A standard reinforced braincase. Or it would be if it had been made correctly. This one looks deficient."
	icon = 'icons/obj/items/robot_parts.dmi'
	icon_state = "head"
	item_state = "buildpipe"
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 500, "glass" = 0)

/obj/item/robot_parts/robot_suit
	name = "robot endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	var/obj/item/robot_parts/l_arm/l_arm = null
	var/obj/item/robot_parts/r_arm/r_arm = null
	var/obj/item/robot_parts/l_leg/l_leg = null
	var/obj/item/robot_parts/r_leg/r_leg = null
	var/obj/item/robot_parts/chest/chest = null
	var/obj/item/robot_parts/head/head = null
	var/created_name = ""

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	if(src.l_arm)
		src.overlays += "l_arm+o"
	if(src.r_arm)
		src.overlays += "r_arm+o"
	if(src.chest)
		src.overlays += "chest+o"
	if(src.l_leg)
		src.overlays += "l_leg+o"
	if(src.r_leg)
		src.overlays += "r_leg+o"
	if(src.head)
		src.overlays += "head+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				return 1
	return 0

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/l_leg))
		if(l_leg)	return
		if(user.drop_inv_item_to_loc(W, src))
			l_leg = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/r_leg))
		if(r_leg)	return
		if(user.drop_inv_item_to_loc(W, src))
			r_leg = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/l_arm))
		if(l_arm)	return
		if(user.drop_inv_item_to_loc(W, src))
			l_arm = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/r_arm))
		if(r_arm)	return
		if(user.drop_inv_item_to_loc(W, src))
			r_arm = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/chest))
		if(chest)	return
		if(W:wires && W:cell)
			if(user.drop_inv_item_to_loc(W, src))
				chest = W
				updateicon()
		else if(!W:wires)
			to_chat(user, SPAN_NOTICE(" You need to attach wires to it first!"))
		else
			to_chat(user, SPAN_NOTICE(" You need to attach a cell to it first!"))

	if(istype(W, /obj/item/robot_parts/head))
		if(head)	return
		if(W:flash2 && W:flash1)
			if(user.drop_inv_item_to_loc(W, src))
				head = W
				updateicon()
		else
			to_chat(user, SPAN_NOTICE(" You need to attach a flash to it first!"))

	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!istype(loc,/turf))
				to_chat(user, SPAN_DANGER("You can't put \the [W] in, the frame has to be standing on the ground to be perfectly precise."))
				return
			if(!M.brainmob)
				to_chat(user, SPAN_DANGER("Sticking an empty [W] into the frame would sort of defeat the purpose."))
				return
			if(!M.brainmob.key)
				var/ghost_can_reenter = 0
				if(M.brainmob.mind)
					for(var/mob/dead/observer/G in GLOB.observer_list)
						if(G.can_reenter_corpse && G.mind == M.brainmob.mind)
							ghost_can_reenter = 1
							break
				if(!ghost_can_reenter)
					to_chat(user, SPAN_NOTICE("\The [W] is completely unresponsive; there's no point."))
					return

			if(M.brainmob.stat == DEAD)
				to_chat(user, SPAN_DANGER("Sticking a dead [W] into the frame would sort of defeat the purpose."))
				return

			if(jobban_isbanned(M.brainmob, "Cyborg"))
				to_chat(user, SPAN_DANGER("This [W] does not seem to fit."))
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(loc), unfinished = 1)
			if(!O)	return

			user.drop_held_item()

			O.mmi = W
			O.invisibility = 0
			O.custom_name = created_name
			O.updatename("Default")

			M.brainmob.mind.transfer_to(O)

			O.job = "Cyborg"

			O.cell = chest.cell
			O.cell.forceMove(O)
			W.forceMove(O)//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

			// Since we "magically" installed a cell, we also have to update the correct component.
			if(O.cell)
				var/datum/robot_component/cell_component = O.components["power cell"]
				cell_component.wrapped = O.cell
				cell_component.installed = 1
			O.Namepick()

			qdel(src)
		else
			to_chat(user, SPAN_NOTICE(" The MMI must go in after everything else!"))

	if (istype(W, /obj/item/tool/pen))
		var/t = stripped_input(user, "Enter new robot name", src.name, src.created_name, MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t

	return

/obj/item/robot_parts/chest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/cell))
		if(src.cell)
			to_chat(user, SPAN_NOTICE(" You have already inserted a cell!"))
			return
		else
			if(user.drop_inv_item_to_loc(W, src))
				cell = W
				to_chat(user, SPAN_NOTICE(" You insert the cell!"))
	if(istype(W, /obj/item/stack/cable_coil))
		if(src.wires)
			to_chat(user, SPAN_NOTICE(" You have already inserted wire!"))
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			src.wires = 1.0
			to_chat(user, SPAN_NOTICE(" You insert the wire!"))
	return

/obj/item/robot_parts/head/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/flash))
		if(istype(user,/mob/living/silicon/robot))
			to_chat(user, SPAN_DANGER("How do you propose to do that?"))
			return
		else if(src.flash1 && src.flash2)
			to_chat(user, SPAN_NOTICE(" You have already inserted the eyes!"))
			return
		else if(src.flash1)
			if(user.drop_inv_item_to_loc(W, src))
				flash2 = W
				to_chat(user, SPAN_NOTICE(" You insert the flash into the eye socket!"))
		else
			user.drop_inv_item_to_loc(W, src)
			flash1 = W
			to_chat(user, SPAN_NOTICE(" You insert the flash into the eye socket!"))
	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, SPAN_NOTICE(" You install some manipulators and modify the head, creating a functional spider-bot!"))
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		user.temp_drop_inv_item(W)
		qdel(W)
		qdel(src)
		return
	return

/obj/item/fake_robot_head/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/device/flash))
		to_chat(user, SPAN_DANGER("That thing looks way too busted to do anything with it..."))
	// I lied
	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, SPAN_NOTICE("You jury rig the head with some manipulators, creating a mostly functional spider-bot!"))
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		qdel(W)
		qdel(src)