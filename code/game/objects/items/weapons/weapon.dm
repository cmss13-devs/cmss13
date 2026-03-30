//items designed as weapon
/obj/item/weapon
	name = "weapon"
	hitsound = "swing_hit"
	flags_atom = FPRINT|QUICK_DRAWABLE

	/// Base percentage chance of blocking something
	var/shield_chance = SHIELD_CHANCE_NONE
	/// Multiplier on the base percentage when dealing with projectiles, including thrown weapons.
	var/shield_projectile_mult = PROJECTILE_BLOCK_PERC_20
	/// The type of shield, DIRECTIONAL or ABSOLUTE, and whether or not it needs two hands.
	var/shield_type = SHIELD_NONE
	/// Sound used when blocking.
	var/shield_sound = 'sound/items/block_shield.ogg'
	/// Can bash shields for a sound.
	var/shield_flags

/obj/item/weapon/get_examine_text(mob/user)
	. = ..()
	var/melee_text = SPAN_RED("a pitiful")
	switch(force)
		if(MELEE_FORCE_TIER_1 to MELEE_FORCE_WEAK)
			melee_text = SPAN_DANGER("a weak")
		if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
			melee_text = SPAN_CYAN("a normal")
		if((MELEE_FORCE_NORMAL + 1) to MELEE_FORCE_STRONG)
			melee_text = SPAN_ORANGE("a strong")
		if((MELEE_FORCE_STRONG + 1) to MELEE_FORCE_VERY_STRONG)
			melee_text = SPAN_GREEN("a very strong")
		if((MELEE_FORCE_VERY_STRONG + 1) to INFINITY)
			melee_text = SPAN_GREEN("an inhumanely strong")

	var/throw_text = SPAN_RED("a pitiful")
	switch(throwforce)
		if(MELEE_FORCE_TIER_1 to MELEE_FORCE_WEAK)
			throw_text = SPAN_DANGER("a weak")
		if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
			throw_text = SPAN_CYAN("a normal")
		if((MELEE_FORCE_NORMAL + 1) to MELEE_FORCE_STRONG)
			throw_text = SPAN_ORANGE("a strong")
		if((MELEE_FORCE_STRONG + 1) to MELEE_FORCE_VERY_STRONG)
			throw_text = SPAN_GREEN("a very strong")
		if((MELEE_FORCE_VERY_STRONG + 1) to INFINITY)
			throw_text = SPAN_GREEN("an inhumanely strong")

	. += SPAN_INFO("It would be [melee_text] melee weapon, and [throw_text] throwing weapon.")
