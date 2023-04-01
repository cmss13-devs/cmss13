//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/get_examine_text(mob/user)
	. = ..()
	var/strong_text = "a weak"
	if(force >= MELEE_FORCE_TIER_1)
		switch(force)
			if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
				strong_text = "a normal"
			if(MELEE_FORCE_NORMAL to MELEE_FORCE_STRONG)
				strong_text = "a strong"
			if(MELEE_FORCE_STRONG to MELEE_FORCE_VERY_STRONG)
				strong_text = "a very strong"
			if(MELEE_FORCE_VERY_STRONG to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were hit someone with it.")

	if(force != throwforce && throwforce >= MELEE_FORCE_TIER_1)
		switch(throwforce)
			if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
				strong_text = "a normal"
			if(MELEE_FORCE_NORMAL to MELEE_FORCE_STRONG)
				strong_text = "a strong"
			if(MELEE_FORCE_STRONG to MELEE_FORCE_VERY_STRONG)
				strong_text = "a very strong"
			if(MELEE_FORCE_VERY_STRONG to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were throw it at someone.")
