////////////////////////////////////////////////////////////////////////////////
/// For dilutable items, like tea bags, coffee, etc.

/obj/item/reagent_container/pill/teabag
	name = "instant tea bag"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "teabag"
	item_state = null
	volume = 15
	ground_offset_x = 0
	ground_offset_y = 0
	reagent_desc_override = FALSE
	identificable = FALSE
	pill_desc = null
	pill_initial_reagents = list("tea_leaves" = 15)
	fluff_text = "tea bag"
	var/list/tea_blends = list("Earl Grey", "English Breakfast", "Yorkshire", "Kenyan", "Ceylon")

/obj/item/reagent_container/pill/teabag/Initialize(mapload, ...)
	. = ..()
	var/tea_name = pick(tea_blends)
	name = "instant [tea_name] tea bag"
	desc = "A bag of instant [tea_name] black tea. Fully dilutable including the bag itself, bag is probably made out of tea as well. No heating required."

/obj/item/reagent_container/pill/teabag/earl_grey
	tea_blends = list("Earl Grey")
