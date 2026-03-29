/obj/item/explosive/grenade/empgrenade
	name = "classic emp grenade"
	desc = "Wide area EMP grenade."
	icon_state = "emp"
	item_state = "emp"


/obj/item/explosive/grenade/empgrenade/prime()
	..()
	if(empulse(src, 4, 10, cause_data?.resolve_mob()))
		qdel(src)
	return

/obj/item/explosive/grenade/empgrenade/dutch
	name = "Dutch's Concoction"
	desc = "Wide area EMP grenade. The label reads, 'CLOAKER DESTROYER - EXTREMELY STRONG'."
	icon_state = "emp"
	item_state = "emp"

/obj/item/explosive/grenade/empgrenade/dutch/prime()
	..()
	if(empulse(src, 15, 20, cause_data?.resolve_mob()))
		qdel(src)
	return
