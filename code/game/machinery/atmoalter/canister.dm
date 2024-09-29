/obj/structure/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "yellow"
	density = TRUE
	health = 100
	flags_atom = FPRINT|CONDUCT


	var/canister_color = "yellow"
	var/can_label = 1
	use_power = USE_POWER_NONE

/obj/structure/machinery/portable_atmospherics/canister/sleeping_agent
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/structure/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/structure/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/structure/machinery/portable_atmospherics/canister/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/structure/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/structure/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/structure/machinery/portable_atmospherics/canister/air/airlock

/obj/structure/machinery/portable_atmospherics/canister/empty/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"

/obj/structure/machinery/portable_atmospherics/canister/empty/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"

/obj/structure/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (destroyed)
		overlays = 0
		icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	overlays = 0

	return


/obj/structure/machinery/portable_atmospherics/canister/update_health(damage = 0)
	..()
	if (health <= 20)
		destroyed = 1
		playsound(src.loc, 'sound/effects/spray.ogg', 25, 1, 5)
		density = FALSE
		update_icon()

/obj/structure/machinery/portable_atmospherics/canister/bullet_act(obj/projectile/Proj)
	if(Proj.ammo.damage)
		update_health(floor(Proj.ammo.damage / 2))
	..()
	return 1

/obj/structure/machinery/portable_atmospherics/canister/attackby(obj/item/W as obj, mob/user as mob)
	if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && !istype(W, /obj/item/tank) && !istype(W, /obj/item/device/analyzer))
		visible_message(SPAN_DANGER("[user] hits [src] with [W]!"))
		update_health(W.force)
		src.add_fingerprint(user)
	..()

	SSnano.nanomanager.update_uis(src) // Update all NanoUIs attached to src

/obj/structure/machinery/portable_atmospherics/canister/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/portable_atmospherics/canister/attack_hand(mob/user as mob)
	return src.ui_interact(user)

/obj/structure/machinery/portable_atmospherics/canister/phoron/New()
	..()
	src.update_icon()
	return 1

/obj/structure/machinery/portable_atmospherics/canister/oxygen/New()
	..()
	src.update_icon()
	return 1

/obj/structure/machinery/portable_atmospherics/canister/sleeping_agent/New()
	..()
	src.update_icon()
	return 1


/obj/structure/machinery/portable_atmospherics/canister/nitrogen/New()
	..()
	src.update_icon()
	return 1

/obj/structure/machinery/portable_atmospherics/canister/carbon_dioxide/New()
	..()
	return 1


/obj/structure/machinery/portable_atmospherics/canister/air/New()
	..()
	src.update_icon()
	return 1
