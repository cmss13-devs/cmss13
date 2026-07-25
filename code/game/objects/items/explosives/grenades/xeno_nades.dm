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

/obj/item/explosive/grenade/xeno_acid_grenade/Move(NewLoc, direct)
	if(throwing)
		for(var/obj/structure/barricade/target_barricade in NewLoc)
			if(!target_barricade.density)
				continue
			playsound(target_barricade, 'sound/effects/slam1.ogg', 15, 1)
			return FALSE

	return ..()

/obj/item/explosive/grenade/xeno_acid_grenade/prime()
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	qdel(src)
	..()
