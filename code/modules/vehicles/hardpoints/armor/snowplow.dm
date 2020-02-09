/obj/item/hardpoint/buff/armor/snowplow
	name = "Snowplow"
	desc = "Clears a path in the snow for friendlies"

	icon_state = "snowplow"
	disp_icon = "tank"
	disp_icon_state = "snowplow"

	point_cost = 500
	health = 600
	activatable = 1

/obj/item/hardpoint/buff/armor/snowplow/livingmob_interact(var/mob/living/M)
	var/turf/targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	targ = get_step(M, owner.dir)
	M.launch_towards(targ, 4, SPEED_FAST, src, 1)
	M.apply_damage(7 + rand(0, 3), BRUTE)

/obj/item/hardpoint/buff/armor/snowplow/on_move(var/turf/old, var/turf/new_turf, var/move_dir)
	if(health <= 0)
		return

	if(dir != move_dir)
		return

	var/turf/ahead = get_step(new_turf, move_dir)

	var/list/turfs_ahead = list(ahead, get_step(ahead, turn(move_dir, 90)), get_step(ahead, turn(move_dir, -90)))
	for(var/turf/T in turfs_ahead)
		if(!istype(T, /turf/open/snow)) continue
		var/turf/open/snow/ST = T
		if(!ST || !ST.slayer)
			continue
		new /obj/item/stack/snow(ST, ST.slayer)
		ST.slayer = 0
		ST.update_icon(1, 0)
