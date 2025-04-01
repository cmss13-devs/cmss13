/obj/item/circuitboard
	w_class = SIZE_SMALL
	name = "Circuit board"
	icon = 'icons/obj/items/circuitboards.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi',
	)
	icon_state = "id_mod"
	item_state = "circuitboard"
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 50, "glass" = 50)
	var/build_path = null





//Called when the circuitboard is used to contruct a new machine.
/obj/item/circuitboard/proc/construct(obj/structure/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0


//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/circuitboard/proc/disassemble(obj/structure/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0



/obj/item/circuitboard/aicore
	name = "Circuit board (AI Core)"


/obj/item/circuitboard/airalarm
	name = "air alarm electronics"
	gender = PLURAL
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."



/obj/item/circuitboard/firealarm
	name = "fire alarm electronics"
	gender = PLURAL
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""


/obj/item/circuitboard/apc
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."

/obj/item/circuitboard/apc/attackby(obj/item/W , mob/user)
	if (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		var/obj/item/circuitboard/machine/ghettosmes/newcircuit = new(user.loc)
		user.put_in_hands(newcircuit)
		qdel(src)



// Tracker Electronic
/obj/item/circuitboard/solar_tracker
	name = "tracker electronics"
	gender = PLURAL
	icon_state = "door_electronics"
