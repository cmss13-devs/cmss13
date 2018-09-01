
//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/weapon/proc/equip_to_holster(mob/living/user) // unsafe proc called by equip_to_slot()
	for(var/obj/item/storage/large_holster/holster in user.contents)
		if(holster.can_be_inserted(src,1))
			if(holster.attackby(src, user))
				holster.update_icon()
				return

	for(var/obj/item/storage/belt/gun/gun_belt in user.contents)
		if(gun_belt.can_be_inserted(src,1))
			if(gun_belt.attackby(src, user))
				gun_belt.update_icon()
				return

/obj/item/weapon/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(slot == WEAR_IN_HOLSTER)
		for(var/obj/item/storage/large_holster/holster in M.contents)
			if(holster.can_be_inserted(src,1))
				return 1
		for(var/obj/item/storage/belt/gun/gun_belt in M.contents)
			if(gun_belt.can_be_inserted(src,1))
				return 1
	return ..()
