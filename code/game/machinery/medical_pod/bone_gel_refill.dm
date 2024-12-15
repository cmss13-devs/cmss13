/obj/structure/machinery/gel_refiller
	name = "osteomimetic lattice fabricator"
	desc = "Often called the bone gel refiller by those unable to pronounce its full name, this machine synthesizes and stores bone gel for later use. A slot in the front allows you to insert a bone gel bottle to refill it."
	desc_lore = "In an attempt to prevent counterfeit bottles of bone gel not created by Weyland-Yutani, also known as a regular bottle, from being refilled, there is a chip reader in the fabricator and a chip in each bottle to make sure it is genuine. However, due to a combination of quality issues and being unmaintainable from proprietary parts, the machine often has problems. One such problem is in the chip reader, resulting in the fabricator being unable to detect a bottle directly on it, and such fails to activate, resulting in a person having to stand there and manually hold a bottle at the correct height to fill it."
	icon_state = "bone_gel_vendor"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	density = TRUE

/obj/structure/machinery/gel_refiller/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/tool/surgery/bonegel))
		return ..()
	var/obj/item/tool/surgery/bonegel/gel = attacking_item
	gel.refill_gel(src, user)
