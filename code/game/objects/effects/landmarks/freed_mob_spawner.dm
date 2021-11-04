/obj/effect/landmark/freed_mob_spawner
	name = "Naked Human"
	icon_state = "freed_mob_spawner"
	var/job_name = "*strip*"
	var/count_participant = FALSE

/obj/effect/landmark/freed_mob_spawner/Initialize()
	..()
	spawn_freed_mob()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/freed_mob_spawner/proc/spawn_freed_mob()
	var/mob/living/carbon/human/H = new(loc)
	H.setDir(dir)
	if(!H.hud_used)
		H.create_hud()
	arm_equipment(H, job_name, TRUE, count_participant)
	H.free_for_ghosts()

/obj/effect/landmark/freed_mob_spawner/upp_conscript
	name = "UPP Conscript"
	job_name = "UPP Conscript"
	count_participant = TRUE

/obj/effect/landmark/freed_mob_spawner/upp_soldier
	name = "UPP Soldier"
	job_name = "UPP Soldier"
	count_participant = TRUE