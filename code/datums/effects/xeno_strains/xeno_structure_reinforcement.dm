/datum/effects/xeno_structure_reinforcement
	effect_name = "structure_reinforcement"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION
	var/previous_health = 0
	var/bonus_health = 0
	var/original_color = null

/datum/effects/xeno_structure_reinforcement/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest", ttl = 3 SECONDS, bonus_health = 6000)
	. = ..(A, from, last_dmg_source, zone)

	src.bonus_health = bonus_health

	if (istype(A, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/door = A
		previous_health = door.health
		door.health += bonus_health
		original_color = door.color
		door.color = "#FFFF00"

	else if(istype(A, /turf/closed/wall/resin))
		var/turf/closed/wall/resin/wall = A
		previous_health = wall.damage
		wall.damage_cap += bonus_health
		original_color = wall.color
		wall.color = "#FFFF00"

	QDEL_IN(src, ttl)


/datum/effects/xeno_structure_reinforcement/validate_atom(var/atom/A)
	if(istype(A, /obj/structure/mineral_door/resin) || istype(A, /turf/closed/wall/resin))
		return TRUE

	return FALSE

/datum/effects/xeno_structure_reinforcement/Destroy()
	if(affected_atom)
		if (istype(affected_atom, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/door = affected_atom
			door.health = previous_health
			door.color = original_color

		else if(istype(affected_atom, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/wall = affected_atom
			wall.damage = previous_health
			wall.damage_cap -= bonus_health
			wall.color = original_color

	return ..()
