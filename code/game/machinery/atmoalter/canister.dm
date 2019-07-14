/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/machines/atmos.dmi'
	icon_state = "yellow"
	density = 1
	health = 100.0
	flags_atom = FPRINT|CONDUCT


	var/canister_color = "yellow"
	var/can_label = 1
	use_power = 0

/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock

/obj/machinery/portable_atmospherics/canister/empty/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"

/obj/machinery/portable_atmospherics/canister/empty/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"

/obj/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (src.destroyed)
		src.overlays = 0
		src.icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	src.overlays = 0

	return


/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return 1

	if (src.health <= 10)
		src.destroyed = 1
		playsound(src.loc, 'sound/effects/spray.ogg', 25, 1, 5)
		src.density = 0
		update_icon()

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/process()
	if (destroyed)
		return
	..()


/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.ammo.damage)
		src.health -= round(Proj.ammo.damage / 2)
		healthcheck()
	..()
	return 1

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!istype(W, /obj/item/tool/wrench) && !istype(W, /obj/item/tank) && !istype(W, /obj/item/device/analyzer) && !istype(W, /obj/item/device/pda))
		visible_message(SPAN_DANGER("[user] hits the [src] with a [W]!"))
		src.health -= W.force
		src.add_fingerprint(user)
		healthcheck()

	..()

	nanomanager.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(var/mob/user as mob)
	return src.ui_interact(user)

/obj/machinery/portable_atmospherics/canister/phoron/New()
	..()
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/oxygen/New()
	..()
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/sleeping_agent/New()
	..()
	src.update_icon()
	return 1


/obj/machinery/portable_atmospherics/canister/nitrogen/New()
	..()
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/New()
	..()
	return 1


/obj/machinery/portable_atmospherics/canister/air/New()
	..()
	src.update_icon()
	return 1
