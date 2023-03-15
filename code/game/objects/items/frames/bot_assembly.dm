

//Cleanbot assembly
/obj/item/frame/bucket_sensor
	desc = "It's a bucket. With a sensor attached."
	name = "proxy bucket"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/created_name = "Cleanbot"


/obj/item/frame/bucket_sensor/attackby(obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/arm/l_arm) || istype(W, /obj/item/robot_parts/arm/r_arm))
		user.drop_held_item()
		qdel(W)
		var/turf/T = get_turf(src.loc)
		var/obj/structure/machinery/bot/cleanbot/A = new /obj/structure/machinery/bot/cleanbot(T)
		A.name = src.created_name
		to_chat(user, SPAN_NOTICE("You add the robot arm to the bucket and sensor assembly. Beep boop!"))
		user.temp_drop_inv_item(src)
		qdel(src)

	else if (HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t



//Floorbot assemblies
/obj/item/frame/toolbox_tiles
	desc = "It's a toolbox with tiles sticking out the top"
	name = "tiles and toolbox"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/created_name = "Floorbot"


/obj/item/frame/toolbox_tiles/attackby(obj/item/W, mob/user as mob)
	..()
	if(isprox(W))
		qdel(W)
		var/obj/item/frame/toolbox_tiles_sensor/B = new /obj/item/frame/toolbox_tiles_sensor()
		B.created_name = src.created_name
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You add the sensor to the toolbox and tiles!"))
		user.temp_drop_inv_item(src)
		qdel(src)

	else if (HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t



/obj/item/frame/toolbox_tiles_sensor
	desc = "It's a toolbox with tiles sticking out the top and a sensor attached"
	name = "tiles, toolbox and sensor arrangement"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/created_name = "Floorbot"

/obj/item/frame/toolbox_tiles_sensor/attackby(obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/arm/l_arm) || istype(W, /obj/item/robot_parts/arm/r_arm))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/obj/structure/machinery/bot/floorbot/A = new /obj/structure/machinery/bot/floorbot(T)
		A.name = src.created_name
		to_chat(user, SPAN_NOTICE("You add the robot arm to the odd looking toolbox assembly! Boop beep!"))
		user.temp_drop_inv_item(src)
		qdel(src)
	else if (HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = stripped_input(user, "Enter new robot name", src.name, src.created_name)

		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t







/obj/item/frame/firstaid_arm_assembly
	name = "first aid/robot arm assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "firstaid_arm"
	var/build_step = 0
	var/created_name = "Medibot" //To preserve the name if it's a unique medbot I guess
	var/skin = null //Same as medbot, set to tox or ointment for the respective kits.
	w_class = SIZE_MEDIUM

/obj/item/frame/firstaid_arm_assembly/New()
	..()
	spawn(5)
		if(src.skin)
			src.overlays += image('icons/obj/structures/machinery/aibots.dmi', "kit_skin_[src.skin]")


/obj/item/frame/firstaid_arm_assembly/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t
	else
		switch(build_step)
			if(0)
				if(istype(W, /obj/item/device/healthanalyzer))
					user.drop_held_item()
					qdel(W)
					src.build_step++
					to_chat(user, SPAN_NOTICE("You add the health sensor to [src]."))
					src.name = "First aid/robot arm/health analyzer assembly"
					src.overlays += image('icons/obj/structures/machinery/aibots.dmi', "na_scanner")

			if(1)
				if(isprox(W))
					user.drop_held_item()
					qdel(W)
					src.build_step++
					to_chat(user, SPAN_NOTICE("You complete the Medibot! Beep boop."))
					var/turf/T = get_turf(src)
					var/obj/structure/machinery/bot/medbot/S = new /obj/structure/machinery/bot/medbot(T)
					S.skin = src.skin
					S.name = src.created_name
					user.temp_drop_inv_item(src)
					qdel(src)
