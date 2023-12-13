//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/recharger
	name = "\improper recharger"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "recharger"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 15000 //15 kW
	black_market_value = 35
	has_wrench_delay = FALSE

/obj/structure/machinery/recharger/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/recharger, \
		charge_overlays = list(\
			"recharger-100" = 100,\
			"recharger-75" = 75,\
			"recharger-50" = 50,\
			"recharger-25" = 25,\
			"recharger-10" = 10,\
			"recharger-power" = 0,\
		),\
		overlay_icon = 'icons/obj/structures/props/stationobjs.dmi',\
		custom_overlay_items = list(\
			/obj/item/weapon/gun/energy = "recharger-taser",\
			/obj/item/weapon/baton = "recharger-baton",\
		),\
	)
	AddElement(/datum/element/simple_unwrench)

/obj/structure/machinery/recharger/unanchored
	anchored = FALSE

/*
/obj/structure/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 25000 //25 kW , It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/baton)
	icon_state_charged = "wrecharger2"
	icon_state_idle = "wrecharger0"
	icon_state_charging = "wrecharger1"
*/
