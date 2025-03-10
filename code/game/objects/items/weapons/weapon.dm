//items designed as weapon
/obj/item/weapon
	name = "weapon"
	hitsound = "swing_hit"
	flags_atom = FPRINT|QUICK_DRAWABLE

/obj/item/weapon/get_examine_text(mob/user)
	. = ..()
	var/strong_text = "a pitiful"
	if(force >= MELEE_FORCE_TIER_1)
		switch(force)
			if((MELEE_FORCE_TIER_2 + 1) to MELEE_FORCE_TIER_4)
				strong_text = "a weak"
			if((MELEE_FORCE_TIER_4 + 1) to MELEE_FORCE_TIER_6)
				strong_text = "a normal"
			if((MELEE_FORCE_TIER_6 + 1) to MELEE_FORCE_TIER_9)
				strong_text = "a strong"
			if((MELEE_FORCE_TIER_9 + 1) to MELEE_FORCE_TIER_11)
				strong_text = "a very strong"
			if((MELEE_FORCE_TIER_11 + 1) to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to hit someone with it.")

	if(throwforce >= MELEE_FORCE_TIER_1)
		strong_text = "a pitiful"
		switch(throwforce)
			if((MELEE_FORCE_TIER_2 + 1) to MELEE_FORCE_TIER_4)
				strong_text = "a weak"
			if((MELEE_FORCE_TIER_4 + 1) to MELEE_FORCE_TIER_6)
				strong_text = "a normal"
			if((MELEE_FORCE_TIER_6 + 1) to MELEE_FORCE_TIER_9)
				strong_text = "a strong"
			if((MELEE_FORCE_TIER_9 + 1) to MELEE_FORCE_TIER_11)
				strong_text = "a very strong"
			if((MELEE_FORCE_TIER_11 + 1) to INFINITY)
				strong_text = "an inhumanely strong"
		. += SPAN_INFO("[src] would be [strong_text] weapon if you were to throw it at someone.")

	if(flags_item & ADJACENT_CLICK_DELAY)
		. += SPAN_INFO("[src] would take time to recover if you were to miss someone.")
