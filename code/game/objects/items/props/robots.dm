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

/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries. It looks broken."
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	matter = list("metal" = 200)
