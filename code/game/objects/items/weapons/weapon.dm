//items designed as weapon
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/get_examine_text(mob/user)
	. = ..()
	var/strong_text = "a weak"
	if(force >= MELEE_FORCE_WEAK)
		switch(force)
			if(MELEE_FORCE_WEAK to MELEE_FORCE_NORMAL)
				strong_text = "a normal"
			if(MELEE_FORCE_NORMAL to MELEE_FORCE_STRONG)
				strong_text = "a strong"
			if(MELEE_FORCE_STRONG to MELEE_FORCE_VERY_STRONG)
				strong_text = "a very strong"
			if(MELEE_FORCE_VERY_STRONG to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to hit someone with it.")

	if(force != throwforce && throwforce >= MELEE_FORCE_WEAK)
		switch(throwforce)
			if(MELEE_FORCE_WEAK to MELEE_FORCE_NORMAL)
				strong_text = "a normal"
			if(MELEE_FORCE_NORMAL to MELEE_FORCE_STRONG)
				strong_text = "a strong"
			if(MELEE_FORCE_STRONG to MELEE_FORCE_VERY_STRONG)
				strong_text = "a very strong"
			if(MELEE_FORCE_VERY_STRONG to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to throw it at someone.")
