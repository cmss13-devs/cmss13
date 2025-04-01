/obj/structure/machinery/computer/aifixer
	name = "AI System Integrity Restorer"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ai-fixer"
	circuit = /obj/item/circuitboard/computer/aifixer
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING)
	processing = TRUE

/obj/structure/machinery/computer/aifixer/New()
	..()
	src.overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-empty")

/obj/structure/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to monitor the station's drone population and the assembler that services them."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "power"
	circuit = /obj/item/circuitboard/computer/drone_control

