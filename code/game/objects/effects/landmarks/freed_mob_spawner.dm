/obj/effect/landmark/freed_mob_spawner
	name = "Naked Human"
	icon_state = "freed_mob_spawner"
	var/equipment_path = /datum/equipment_preset/strip
	var/count_participant = FALSE

/obj/effect/landmark/freed_mob_spawner/Initialize()
	. = ..()
	spawn_freed_mob()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/freed_mob_spawner/Destroy()
	equipment_path = null
	return ..()

/obj/effect/landmark/freed_mob_spawner/proc/spawn_freed_mob()
	var/mob/living/carbon/human/current_human = new(loc)
	current_human.setDir(dir)
	if(!current_human.hud_used)
		current_human.create_hud()
	arm_equipment(current_human, equipment_path, TRUE, count_participant)
	current_human.free_for_ghosts()

/obj/effect/landmark/freed_mob_spawner/upp_conscript
	name = "UPP Conscript"
	equipment_path = /datum/equipment_preset/upp/conscript
	count_participant = TRUE

/obj/effect/landmark/freed_mob_spawner/upp_soldier
	name = "UPP Soldier"
	equipment_path = /datum/equipment_preset/upp/soldier
	count_participant = TRUE
