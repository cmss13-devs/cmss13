/obj/item/stack/light_w
	name = "wired glass tile"
	singular_name = "wired glass floor tile"
	desc = "A glass tile, which is wired, somehow."
	icon_state = "glass_wire"
	w_class = SIZE_MEDIUM
	force = 3.0
	throwforce = 5.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 60
	stack_id = "wired glass tile"

/obj/item/stack/light_w/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	if(HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 5
		amount--
		new/obj/item/stack/sheet/glass(user.loc)
		if(amount <= 0)
			user.temp_drop_inv_item(src)
			qdel(src)

	if(istype(O,/obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		if (M.use(1))
			new/obj/item/stack/tile/light(user.loc, 1)
			use(1)
			to_chat(user, SPAN_NOTICE("You make a light tile."))
		else
			to_chat(user, SPAN_WARNING("You need one metal sheet to finish the light tile."))
		return
