
//Hat Station 13

/obj/item/clothing/head/collectable
	name = "collectable hat"
	desc = "A rare collectable hat."

/obj/item/clothing/head/collectable/xenom
	name = "collectable xenomorph helmet!"
	desc = "Hiss hiss hiss!"
	icon_state = "xenom"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/head/collectable/tophat
	name = "collectable top hat"
	desc = "A top hat worn by only the most prestigious hat collectors."
	icon_state = "tophat"
	item_state = "that"
	icon = 'icons/obj/items/clothing/hats/formal_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/formal_hats.dmi'
	)
	flags_armor_protection = 0

/obj/item/clothing/head/collectable/tophat/super
	name = "collectable super top hat"
	desc = "A super top hat worn by only the highest echelon of hat collectors."
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/head_64.dmi'
	)
	icon_state = "super_top_hat"
	item_state = "super_top_hat"
	worn_x_dimension = 64
	worn_y_dimension = 64
	w_class = SIZE_LARGE

/obj/item/clothing/head/collectable/petehat
	icon_state = "petehat"
	item_state = "petehat"
