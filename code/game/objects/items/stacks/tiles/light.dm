/obj/item/stack/tile/light
	name = "light floor tile"
	singular_name = "light floor tile"
	desc = "A floor tile, made out of glass. It produces light."
	icon_state = "tile_e"
	force = 3.0
	throwforce = 5.0
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	stack_id = "light floor tile"
	var/on = 1
	var/state //0 = fine, 1 = flickering, 2 = breaking, 3 = broken

/obj/item/stack/tile/light/New(var/loc, var/amount=null)
	..()
	if(prob(5))
		state = 3 //broken
	else if(prob(5))
		state = 2 //breaking
	else if(prob(10))
		state = 1 //flickering occasionally
	else
		state = 0 //fine

/obj/item/stack/tile/light/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	if(istype(O,/obj/item/tool/crowbar))
		new/obj/item/stack/sheet/metal(user.loc)
		amount--
		new/obj/item/stack/light_w(user.loc)
		if(amount <= 0)
			user.temp_drop_inv_item(src)
			qdel(src)
