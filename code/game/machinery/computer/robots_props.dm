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

/obj/item/broken_device
	name = "broken component"
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "broken"

/obj/item/robot_parts/robot_component
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "working"

/obj/item/robot_parts/robot_component/binary_communication_device
	name = "binary communication device"
	icon_state = "binradio"

/obj/item/robot_parts/robot_component/actuator
	name = "actuator"
	icon_state = "motor"

/obj/item/robot_parts/robot_component/armour
	name = "armour plating"
	icon_state = "armor"

/obj/item/robot_parts/robot_component/camera
	name = "camera"
	icon_state = "camera"

/obj/item/robot_parts/robot_component/diagnosis_unit
	name = "diagnosis unit"
	icon_state = "analyser"

/obj/item/robot_parts/robot_component/radio
	name = "radio"
	icon_state = "radio"
