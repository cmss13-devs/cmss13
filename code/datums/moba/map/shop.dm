/obj/effect/alien/resin/moba_shop
	name = "acid shop"
	desc = "Alan please add details"
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "acid_pillar_idle"
	var/hivenumber = XENO_HIVE_MOBA_LEFT

/obj/effect/alien/resin/moba_shop/attack_alien(mob/living/carbon/xenomorph/M)
	. = ..()
	if(M.hive.hivenumber != hivenumber)
		return

	var/datum/moba_item_store/store = new(M, src)
	store.tgui_interact(M)
