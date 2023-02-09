/obj/structure/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/structures/machinery/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40

/obj/structure/machinery/biogenerator/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM
/obj/structure/machinery/computer3
	name = "computer"
	icon = 'icons/obj/structures/machinery/computer3.dmi'
	icon_state = "frame"
	density = TRUE
	anchored = TRUE
	projectile_coverage = PROJECTILE_COVERAGE_LOW

	idle_power_usage = 20
	active_power_usage = 50

/obj/structure/machinery/computer3/New(L, built = 0)
	..()
	spawn(2)
		power_change()

	update_icon()
	start_processing()

/obj/structure/machinery/computer3/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/computer3/laptop/secure_data
	icon_state = "laptop"

/obj/structure/machinery/computer3/powermonitor
	icon_state = "frame-eng"
/obj/structure/machinery/computer3/server
	name = "server"
	icon = 'icons/obj/structures/machinery/computer3.dmi'
	icon_state = "serverframe"

/obj/structure/machinery/computer3/server/rack
	name = "server rack"
	icon_state = "rackframe"

/obj/structure/machinery/computer3/server/rack/update_icon()
	//overlays.Cut()
	return

/obj/structure/machinery/computer3/server/rack/attack_hand() // Racks have no screen, only AI can use them
	return


/obj/structure/machinery/lapvend
	name = "Laptop Vendor"
	desc = "A generic vending machine."
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "robotics"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/machinery/lapvend/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/mech_bay_recharge_port
	name = "Mech Bay Power Port"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/props/mech.dmi'
	icon_state = "recharge_port"

/obj/structure/machinery/mech_bay_recharge_port/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/mecha_part_fabricator
	icon = 'icons/obj/structures/machinery/robotics.dmi'
	icon_state = "fab-idle"
	name = "Exosuit Fabricator"
	desc = "Nothing is being built."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000

/obj/structure/machinery/mecha_part_fabricator/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/computer/mecha
	name = "Exosuit Control"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "mecha"
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	circuit = /obj/item/circuitboard/computer/mecha_control
