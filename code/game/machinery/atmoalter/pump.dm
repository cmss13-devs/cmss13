/obj/structure/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"

	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "psiphon:0"
	density = 1

	var/on = 0

/obj/structure/machinery/portable_atmospherics/powered/pump/New()
	..()
	cell = new/obj/item/cell(src)

/obj/structure/machinery/portable_atmospherics/powered/pump/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_OVER, PASS_AROUND, PASS_UNDER)

/obj/structure/machinery/portable_atmospherics/powered/pump/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	return
