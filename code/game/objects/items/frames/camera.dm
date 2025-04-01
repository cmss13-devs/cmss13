/obj/item/frame/camera
	name = "camera assembly"
	desc = "The basic construction for Corporate-Always-Watching-You cameras."
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "cameracase"
	w_class = SIZE_SMALL
	anchored = FALSE

	matter = list("metal" = 700,"glass" = 300)

	// Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_upgrades = list(/obj/item/device/assembly/prox_sensor, /obj/item/stack/sheet/mineral/osmium, /obj/item/stock_parts/scanning_module)
	var/list/upgrades = list()
	var/state = 0

	/*
				0 = Nothing done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach upgrades)
				4 = Screwdriver panel closed and is fully built (you cannot attach upgrades)
	*/

/obj/item/frame/camera/attackby(obj/item/W as obj, mob/living/user as mob)

	switch(state)

		if(0)
			// State 0
			if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && isturf(src.loc))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, "You wrench the assembly into place.")
				anchored = TRUE
				state = 1
				update_icon()
				auto_turn()
				return

		if(1)
			// State 1
			if(iswelder(W))
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				if(weld(W, user))
					to_chat(user, "You weld the assembly securely into place.")
					anchored = TRUE
					state = 2
				return

			else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, "You unattach the assembly from it's place.")
				anchored = FALSE
				update_icon()
				state = 0
				return

		if(2)
			// State 2
			if(iscoil(W))
				var/obj/item/stack/cable_coil/C = W
				if(C.use(2))
					to_chat(user, SPAN_NOTICE("You add wires to the assembly."))
					state = 3
				else
					to_chat(user, SPAN_WARNING("You need 2 coils of wire to wire the assembly."))
				return

			else if(iswelder(W))
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				if(weld(W, user))
					to_chat(user, "You unweld the assembly from it's place.")
					state = 1
					anchored = TRUE
				return


		if(3)
			// State 3
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)

				var/input = strip_html(input(usr, "Which networks would you like to connect this camera to? Separate networks with a comma. No Spaces!\nFor example: military, Security,Secret ", "Set Network", "military"))
				if(!input)
					to_chat(usr, "No input found please hang up and try your call again.")
					return

				var/list/tempnetwork = splittext(input, ",")
				if(length(tempnetwork) < 1)
					to_chat(usr, "No network found please hang up and try your call again.")
					return

				var/area/camera_area = get_area(src)
				var/temptag = "[strip_html(camera_area.name)] ([rand(1, 999)])"
				input = strip_html(input(usr, "How would you like to name the camera?", "Set Camera Name", temptag))

				state = 4
				var/obj/structure/machinery/camera/C = new(src.loc)
				src.forceMove(C)
				C.assembly = src

				C.auto_turn()
				C.network = uniquelist(tempnetwork)
				C.c_tag = input

				for(var/i = 5; i >= 0; i -= 1)
					var/direct = tgui_input_list(user, "Direction?", "Assembling Camera", list("LEAVE IT", "NORTH", "EAST", "SOUTH", "WEST" ))
					if(direct != "LEAVE IT")
						C.setDir(text2dir(direct))
					if(i != 0)
						var/confirm = alert(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", "Yes", "No")
						if(confirm == "Yes")
							break
				return

			else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))

				new/obj/item/stack/cable_coil(get_turf(src), 2)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				to_chat(user, "You cut the wires from the circuits.")
				state = 2
				return

	// Upgrades!
	if(is_type_in_list(W, possible_upgrades) && !is_type_in_list(W, upgrades)) // Is a possible upgrade and isn't in the camera already.
		to_chat(user, "You attach \the [W] into the assembly inner circuits.")
		upgrades += W
		user.drop_held_item()
		W.forceMove(src)
		return

	// Taking out upgrades
	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && length(upgrades))
		var/obj/U = locate(/obj) in upgrades
		if(U)
			to_chat(user, "You unattach an upgrade from the assembly.")
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			U.forceMove(get_turf(src))
			upgrades -= U
		return

	..()

/obj/item/frame/camera/update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/frame/camera/attack_hand(mob/user as mob)
	if(!anchored)
		..()

/obj/item/frame/camera/proc/weld(obj/item/tool/weldingtool/WT, mob/user)

	if(user.action_busy)
		return 0
	if(!WT.isOn())
		to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
		return 0

	to_chat(user, SPAN_NOTICE("You start to weld [src].."))
	playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
	WT.eyecheck(user)
	if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
			return 0
		return 1
	return 0
