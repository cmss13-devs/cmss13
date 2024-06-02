// A slowing effect that can be applied to humans or Xenos.
// Very simple: just updates the 'slowed' var for its duration

// As to why this is an effect and I'm not just updating the 'slowed' var wherever necessary:
// for a lot of MOBA xenos things, you need to check the originator of a status effect
// not just that one is applied
// or else you'd get crushers combo-ing off of effects applied by a lurker
// applies to HUDs as well

/datum/effects/xeno_buff
	effect_name = "buff"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION

	var/bonus_damage = 0
	var/bonus_speed = 0

/datum/effects/xeno_buff/New(atom/A, mob/from = null, last_dmg_source = null, zone = "chest", ttl = 35, bonus_damage = 0, bonus_speed = 0)
	. = ..(A, from, last_dmg_source, zone)

	if(!isxeno(A))
		qdel(src)

	to_chat(A, SPAN_XENONOTICE("We feel empowered"))

	var/mob/living/carbon/xenomorph/X = A
	X.melee_damage_lower += bonus_damage
	X.melee_damage_upper += bonus_damage

	X.ability_speed_modifier -= bonus_speed

	src.bonus_damage = bonus_damage
	src.bonus_speed = bonus_speed

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), ttl)

/datum/effects/xeno_buff/validate_atom(atom/A)
	if (!isxeno(A))
		return FALSE

	var/mob/M = A
	if (M.stat == DEAD)
		return FALSE

	. = ..()

/datum/effects/xeno_buff/Destroy()

	if(affected_atom)
		to_chat(affected_atom, SPAN_XENONOTICE("We no longer feel empowered"))
		var/mob/living/carbon/xenomorph/X = affected_atom
		X.melee_damage_lower -= bonus_damage
		X.melee_damage_upper -= bonus_damage

		X.ability_speed_modifier += bonus_speed

	. = ..()

