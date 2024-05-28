/obj/structure/machinery/newscaster
	name = "newscaster"
	desc = "A standard Weyland-Yutani-licensed newsfeed handler for use in commercial space stations. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/structures/machinery/terminals.dmi'
	icon_state = "newscaster_normal"
	anchored = TRUE

/obj/structure/machinery/newscaster/security_unit
	name = "Security Newscaster"

/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard Weyland-Yutani Space Stations."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "newspaper"
	w_class = SIZE_TINY //Let's make it fit in trashbags!
	attack_verb = list("bapped")
