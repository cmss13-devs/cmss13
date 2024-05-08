/obj/item/hardpoint/armor/snowplow
	name = "Snowplow"
	desc = "Clears road for friendlies."

	icon_state = "snowplow"
	disp_icon = "tank"
	disp_icon_state = "snowplow"

	health = 2000
	activatable = 1

	type_multipliers = list(
		"blunt" = 0.05,
		"all" = 0.8
	)

/obj/item/hardpoint/armor/snowplow/livingmob_interact(mob/living/M)
	var/turf/targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	M.throw_atom(targ, 4, SPEED_VERY_FAST, src, 1)
	M.apply_damage(50 + rand(0, 100), BRUTE)

/obj/item/hardpoint/armor/snowplow/on_move(turf/old, turf/new_turf, move_dir)
	if(health <= 0)
		return

	if(dir != move_dir)
		return

	var/turf/ahead = get_step(new_turf, move_dir)

	var/list/turfs_ahead = list(ahead, get_step(ahead, turn(move_dir, 90)), get_step(ahead, turn(move_dir, -90)))
	for(var/turf/turf in turfs_ahead)
		if(istype(turf.weeds))
			turf.weeds.Destroy()
		else if(istype(turf, /turf/closed/wall))
			var/turf/closed/wall/next_wall = turf
			next_wall.take_damage(250)

		if(istype(turf, /turf/open))
			if(istype(turf, /turf/open/snow) || istype(turf, /turf/open/auto_turf/snow))
				var/turf/open/open = turf
				new /obj/item/stack/snow(open, open.bleed_layer)
				if(istype(open, /turf/open/auto_turf/snow))
					var/turf/open/auto_turf/snow/auto_turf = open
					auto_turf.changing_layer(0)
				else
					open.bleed_layer = 0
					open.update_icon(TRUE, FALSE)
			for(var/atom/movable/atom in turf.contents)
				if(atom.anchored)
					continue
				INVOKE_ASYNC(atom, TYPE_PROC_REF(/atom/movable, throw_atom), get_step(turf, turn(move_dir, 90)), 4, SPEED_SLOW, src, TRUE, HIGH_LAUNCH)
		else
			continue
