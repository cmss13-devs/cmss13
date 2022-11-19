/obj/item/hardpoint/armor/snowplow
	name = "snowplow"
	desc = "Clears a path in the snow for friendlies."

	icon_state = "snowplow"
	disp_icon = "tank"
	disp_icon_state = "snowplow"

	health = 600

/obj/item/hardpoint/armor/snowplow/livingmob_interact(var/mob/living/M)
	var/turf/targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	M.throw_atom(targ, 4, SPEED_FAST, src, 1)
	M.apply_damage(7 + rand(0, 3), BRUTE)

/obj/item/hardpoint/armor/snowplow/on_move(var/turf/old, var/turf/new_turf, var/move_dir)
	if(health <= 0)
		return

	if(dir != move_dir)
		return

	var/turf/ahead = get_step(new_turf, move_dir)
	var/list/turfs_ahead = list(ahead, get_step(ahead, turn(move_dir, 90)), get_step(ahead, turn(move_dir, -90)))
	for(var/turf/turf in turfs_ahead) // not doing as anything because turf might be null
		turf.handle_snowplow()
