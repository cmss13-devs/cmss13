#define ALIGATOR_SPEED_DRAGING 2.8
#define LIZARD_SPEED_NORMAL 1.2


/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough
	name = "Bortrough"
	icon = 'icons/mob/bortrough.dmi'
	icon_state = "Bortrough Running"
	icon_living = "Bortrough Running"
	icon_dead = "Bortrough Dead"
	stun_duration = 2
	grab_level = GRAB_CHOKE
	base_state = "Bortrough"
	death_sound = 'sound/effects/bortrough-die.ogg'
	growl_sound = "bortrough_growl"
	hiss_sound = "bortrough_hiss"
	wound_icon = 'icons/mob/bortrough.dmi'
	pixel_x = -22
	has_tongue = FALSE
	var/pulling_state = "Bortrough Running Open Jaws"

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/Destroy()
	. = ..()
	stop_pulling()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/ListTargets(dist = 4)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/update_transform(instant_update = FALSE)
	. = ..()
	if(pulling)
		icon_state = "Bortrough Running Open Jaws"
	if(istype(loc, /turf/open/gm/river) && stat != DEAD)
		icon_state = "Bortrough Submerged"

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/Move(NewLoc, direct)
	. = ..()
	if(istype(loc, /turf/open/gm/river) && stat != DEAD)
		icon_state = "Bortrough Submerged"
		update_wounds()
	else
		if(icon_state == "Bortrough Submerged")
			update_transform()
			update_wounds()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/update_wounds()
	. = ..()
	if(istype(loc, /turf/open/gm/river) && stat != DEAD)
		wound_icon_holder.icon_state = "none"

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/try_to_extinguish()
	if(istype(get_turf(src), /turf/open/gm/river) || (/obj/effect/blocker/water in loc) || istype(get_turf(src), /turf/open/beach/coastline) || istype(get_turf(src), /turf/open/gm/coast))
		ExtinguishMob()
		return
	. = ..()

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/pounced_mob(mob/living/pounced_mob)
	. = ..()
	throwing = 0
	start_pulling(pounced_mob, TRUE, simple_mob = TRUE)
	MoveTo(target_mob_ref?.resolve(), 5, TRUE, 2 SECONDS, TRUE) //drag our target away

/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/start_pulling(atom/movable/clone/AM, lunge, no_msg, simple_mob)
	. = ..()
	if(.)
		update_transform()
		speed = ALIGATOR_SPEED_DRAGING
/mob/living/simple_animal/hostile/retaliate/giant_lizard/bortrough/stop_pulling()
	. = ..()
	speed = LIZARD_SPEED_NORMAL
	update_transform()

#undef ALIGATOR_SPEED_DRAGING
#undef LIZARD_SPEED_NORMAL
