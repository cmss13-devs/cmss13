//CORE PACKAGE ITEM
/obj/item/mre_food_packet
	name = "\improper ration component"
	desc = "A ration package."
	icon_state = "entree"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	w_class = SIZE_SMALL
	var/contents_food
	var/no_packet_label = FALSE
	var/list/food_list = list()

/obj/item/mre_food_packet/Initialize(mapload, ...)
	. = ..()
	if(length(food_list))
		contents_food = pick(food_list)
	if(!no_packet_label)
		var/obj/item/reagent_container/food/snacks/food = contents_food
		name += " ([food?.name])"

/obj/item/mre_food_packet/ex_act()
	deconstruct(FALSE)
	return

/obj/item/mre_food_packet/attack_self(mob/M)
	..()

	if(!ispath(contents_food, /obj/item))
		return

	var/obj/item/I = new contents_food(M)
	M.temp_drop_inv_item(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	to_chat(M, SPAN_NOTICE("You pull open the package of the meal!"))
	playsound(loc, "rip", 15, 1)
	qdel(src)
	return

//CORE MRE FOOD ITEM
/obj/item/reagent_container/food/snacks/mre_food
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	bitesize = 3
