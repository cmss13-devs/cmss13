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
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, initial(name), source_mob)
	qdel(src)
	..()
