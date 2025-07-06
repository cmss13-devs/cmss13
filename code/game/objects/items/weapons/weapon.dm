//items designed as weapon
/obj/item/weapon
	name = "weapon"
	hitsound = "swing_hit"
	flags_atom = FPRINT|QUICK_DRAWABLE
	var/shield_chance = 0
	var/shield_projectile_mult = PROJECTILE_BLOCK_PERC_20
	var/shield_type = SHIELD_NONE
	var/shield_sound = 'sound/items/block_shield.ogg'

/obj/item/weapon/get_examine_text(mob/user)
	. = ..()
	var/strong_text = "a weak"
	if(force >= MELEE_FORCE_TIER_1)
		switch(force)
			if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
				strong_text = "a normal"
			if((MELEE_FORCE_NORMAL + 1) to MELEE_FORCE_STRONG)
				strong_text = "a strong"
			if((MELEE_FORCE_STRONG + 1) to MELEE_FORCE_VERY_STRONG)
				strong_text = "a very strong"
			if((MELEE_FORCE_VERY_STRONG + 1) to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to hit someone with it.")

	if(throwforce >= MELEE_FORCE_TIER_1)
		strong_text = "a weak"
		switch(throwforce)
			if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
				strong_text = "a normal"
			if((MELEE_FORCE_NORMAL + 1) to MELEE_FORCE_STRONG)
				strong_text = "a strong"
			if((MELEE_FORCE_STRONG + 1) to MELEE_FORCE_VERY_STRONG)
				strong_text = "a very strong"
			if((MELEE_FORCE_VERY_STRONG + 1) to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to throw it at someone.")
