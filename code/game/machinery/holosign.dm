////////////////////HOLOSIGN///////////////////////////////////////
/obj/structure/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector"
	icon = 'icons/obj/structures/machinery/holosign.dmi'
	icon_state = "sign_off"
	layer = MOB_LAYER
	anchored = 1
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"

/obj/structure/machinery/holosign/proc/toggle()
	if(inoperable())
		return
	lit = !lit
	update_icon()

/obj/structure/machinery/holosign/update_icon()
	if(!lit)
		icon_state = "sign_off"
	else
		icon_state = on_icon

/obj/structure/machinery/holosign/power_change()
	if(stat & NOPOWER)
		lit = 0
	update_icon()

/obj/structure/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"
////////////////////SWITCH///////////////////////////////////////

/obj/structure/machinery/holosign_switch
	name = "holosign switch"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "light1"
	desc = "A remote control switch for holosign."
	var/id = null
	var/active = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/structure/machinery/holosign_switch/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/holosign_switch/attackby(obj/item/W, mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/holosign_switch/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	if(inoperable())
		return
	add_fingerprint(user)

	use_power(5)

	active = !active
	if(active)
		icon_state = "light1"
	else
		icon_state = "light0"

	for(var/obj/structure/machinery/holosign/M in machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, /obj/structure/machinery/holosign.proc/toggle)

	return