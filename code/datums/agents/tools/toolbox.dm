/obj/item/storage/toolbox/antag
	name = "suspicious toolbox"
	desc = "A compact and suspicious looking toolbox. This one is small enough to fit into a bag."
	icon_state = "syndicate"
	item_state = "toolbox_syndi"

	w_class = SIZE_MEDIUM

	storage_slots = 8

/obj/item/storage/toolbox/antag/Initialize(mapload, ...)
	. = ..()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/pamphlet/antag/skill/engineer(src)
