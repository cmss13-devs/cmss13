/obj/effect/alien/resin/moba_shop
	name = "acid shop"
	desc = "Alan please add details"
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "acid_pillar_idle"
	can_block_movement = TRUE
	density = TRUE
	unacidable = TRUE
	var/hivenumber = XENO_HIVE_MOBA_LEFT

/obj/effect/alien/resin/moba_shop/Initialize(mapload, mob/builder)
	. = ..()
	if(!GLOB.moba_shop)
		GLOB.moba_shop = new /datum/moba_item_store
	set_hive_data(src, hivenumber)

/obj/effect/alien/resin/moba_shop/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.hive.hivenumber != hivenumber)
		return

	GLOB.moba_shop.tgui_interact(M)

/obj/effect/alien/resin/moba_shop/right
	hivenumber = XENO_HIVE_MOBA_RIGHT
