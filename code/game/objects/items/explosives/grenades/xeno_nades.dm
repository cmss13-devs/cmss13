// Praetorian Neurotoxin grenade.
/obj/item/explosive/grenade/xeno_acid_grenade
	name = "acid ball"
	desc = "A small, pulsating ball of gas."
	icon_state = "neuro_nade"
	det_time = 30
	item_state = "neuro_nade"

	rebounds = FALSE

	var/shrapnel_count = 14
	var/shrapnel_type = /datum/ammo/xeno/acid/prae_nade

/obj/item/explosive/grenade/xeno_acid_grenade/prime()
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	qdel(src)
	..()



/obj/item/explosive/grenade/xeno_weed_grenade
	name = "Node Ball"
	desc = "a small resin node pulsating and turning in itself."
	icon_state = "neuro_nade"
	det_time = 1 SECONDS
	item_state = "neuro_nade"

	rebounds = FALSE

/obj/item/explosive/grenade/xeno_weed_grenade/prime()


	var/turf/current_turf = get_turf(src)
	var/obj/effect/alien/weeds/weed = locate() in current_turf

	if((locate(/obj/effect/alien/weeds/node) in current_turf))
		qdel(src)
		return
	if(weed && weed.weed_strength >= WEED_LEVEL_HIVE)
		qdel(src)
		return
	else
		new /obj/effect/alien/weeds/node(current_turf)
		qdel(src)
