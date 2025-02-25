//items designed as weapon
/obj/item/weapon
	name = "weapon"
	hitsound = "swing_hit"
	flags_atom = FPRINT|QUICK_DRAWABLE

/obj/item/weapon/get_examine_text(mob/user)
	. = ..()
	var/strong_text = "a weak"
	if(force >= MELEE_FORCE_TIER_1)
		switch(force)
			if((MELEE_FORCE_TIER_2 + 1) to MELEE_FORCE_TIER_5)
				strong_text = "a normal"
			if((MELEE_FORCE_TIER_5 + 1) to MELEE_FORCE_TIER_7)
				strong_text = "a strong"
			if((MELEE_FORCE_TIER_7 + 1) to MELEE_FORCE_TIER_9)
				strong_text = "a very strong"
			if((MELEE_FORCE_TIER_9 + 1) to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to hit someone with it.")

	if(throwforce >= MELEE_FORCE_TIER_1)
		strong_text = "a weak"
		switch(throwforce)
			if((MELEE_FORCE_TIER_2 + 1) to MELEE_FORCE_TIER_5)
				strong_text = "a normal"
			if((MELEE_FORCE_TIER_5 + 1) to MELEE_FORCE_TIER_7)
				strong_text = "a strong"
			if((MELEE_FORCE_TIER_7 + 1) to MELEE_FORCE_TIER_9)
				strong_text = "a very strong"
			if((MELEE_FORCE_TIER_9 + 1) to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to throw it at someone.")
