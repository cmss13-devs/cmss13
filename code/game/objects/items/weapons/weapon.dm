
//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons.dmi'
	hitsound = "swing_hit"
/obj/item/weapon/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(slot == WEAR_IN_BACK || slot == WEAR_IN_ACCESSORY) 
		return 0
	else
		return ..()