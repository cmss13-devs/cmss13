/obj/item/stack/tile/light
	name = "light floor tile"
	singular_name = "light floor tile"
	desc = "A floor tile, made out of glass. It produces light."
	icon_state = "tile_e"
	force = 3
	throwforce = 5
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	stack_id = "light floor tile"
	turf_type = /turf/open/floor/light

/obj/item/stack/tile/light/attackby(obj/item/item_in_hand as obj, mob/user as mob)
	..()
	if (HAS_TRAIT(item_in_hand, TRAIT_TOOL_CROWBAR))
		new/obj/item/stack/sheet/metal(user.loc)
		amount--
		new/obj/item/stack/light_w(user.loc)
		if(amount <= 0)
			user.temp_drop_inv_item(src)
			qdel(src)
