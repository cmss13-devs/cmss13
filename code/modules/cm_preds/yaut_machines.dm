/obj/structure/machinery/prop/almayer/CICmap/yautja
	name = "hunter globe"
	desc = "A globe designed by the hunters to show them the location of prey across the hunting grounds."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "globe"

	minimap_type = MINIMAP_FLAG_XENO|MINIMAP_FLAG_USCM

/obj/structure/machinery/autolathe/yautja
	name = "yautja autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	stored_material =  list("metal" = 40000, "glass" = 20000)

/obj/structure/machinery/prop/yautja/bubbler
	name = "yautja cauldron"
	desc = "A large, black machine emitting an ominous hum with an attached pot of boiling fluid. Bits of what appears to be leftover lard and balls of hair can be seen floating inside of it."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "vat"

/obj/structure/machinery/prop/yautja/bubbler/attackby(obj/item/limb as obj, mob/user as mob)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_NOTICE("You have no idea what this does, and you figure it is not time to find out."))
		return
