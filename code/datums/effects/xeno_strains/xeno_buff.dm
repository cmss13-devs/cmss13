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

/datum/effects/xeno_buff/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest", var/ttl = 35, var/bonus_damage = 0, var/bonus_speed = 0)
	. = ..(A, from, last_dmg_source, zone)

	if(!isXeno(A))
		qdel(src)

	to_chat(A, SPAN_XENONOTICE("You feel empowered"))

	var/mob/living/carbon/Xenomorph/X = A
	X.melee_damage_lower += bonus_damage
	X.melee_damage_upper += bonus_damage

	X.ability_speed_modifier -= bonus_speed

	src.bonus_damage = bonus_damage
	src.bonus_speed = bonus_speed

	add_timer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), ttl)

/datum/effects/xeno_buff/validate_atom(var/atom/A)
	if (!isXeno(A))
		return FALSE

	var/mob/M = A
	if (M.stat == DEAD)
		return FALSE

	. = ..()

/datum/effects/xeno_buff/Destroy()

	if(affected_atom)
		to_chat(affected_atom, SPAN_XENONOTICE("You no longer feel empowered"))
		var/mob/living/carbon/Xenomorph/X = affected_atom
		X.melee_damage_lower -= bonus_damage
		X.melee_damage_upper -= bonus_damage

		X.ability_speed_modifier += bonus_speed

	. = ..()

