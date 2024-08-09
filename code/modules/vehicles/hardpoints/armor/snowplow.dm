/obj/item/hardpoint/armor/snowplow
	name = "\improper Snowplow"
	desc = "Clears road for friendlies."

	icon_state = "snowplow"
	disp_icon = "tank"
	disp_icon_state = "snowplow"

	health = 150
	activatable = 1

/obj/item/hardpoint/armor/snowplow/livingmob_interact(mob/living/M)
	var/turf/targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	M.throw_atom(targ, 4, SPEED_FAST, src, 1)
	M.apply_damage(7 + rand(0, 3), BRUTE)

/obj/item/hardpoint/armor/snowplow/on_move(turf/old, turf/new_turf, move_dir)
	if(health <= 0)
		return

	if(dir != move_dir)
		return

	var/turf/ahead = get_step(new_turf, move_dir)

	var/list/turfs_ahead = list(ahead, get_step(ahead, turn(move_dir, 90)), get_step(ahead, turn(move_dir, -90)))
	for(var/turf/turf_ahead in turfs_ahead)
		if(istype(turf_ahead.snow))
			var/obj/structure/snow/snow = turf_ahead.snow
			if(!snow)
				continue
			new /obj/item/stack/snow(snow.loc, snow.bleed_layer)
			snow.changing_layer(0)
		else if(istype(turf_ahead.weeds))
			turf_ahead.weeds.Destroy()
		else if(istype(turf_ahead, /turf/closed/wall))
			var/turf/closed/wall/next_wall = turf_ahead
			next_wall.take_damage(250)
		else if(istype(turf_ahead, /turf/open))
			for(var/atom/movable/atom in turf_ahead.contents)
				if(atom.anchored)
					continue
				atom.throw_atom(get_step(turf_ahead, turn(move_dir, 90)), 4, SPEED_SLOW, src, TRUE, HIGH_LAUNCH)
		else
			continue
