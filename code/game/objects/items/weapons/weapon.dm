//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/weapon/melee/examine(mob/user)
	. = ..()
	var/strong_text = "weak"
	switch(force)
		if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
			strong_text = "normal"
		if(MELEE_FORCE_NORMAL to MELEE_FORCE_STRONG)
			strong_text = "strong"
		if(MELEE_FORCE_STRONG to MELEE_FORCE_VERY_STRONG)
			strong_text = "very strong"
		if(MELEE_FORCE_VERY_STRONG to INFINITY)
			strong_text = "inhumanely strong"
	to_chat(user, SPAN_INFO("This weapon looks [strong_text]."))