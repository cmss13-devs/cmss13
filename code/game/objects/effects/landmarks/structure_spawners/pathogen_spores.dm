/obj/effect/landmark/structure_spawner/spore_sac_rng
	name = "pathogen spore sac spawner (30)"
	icon_state = "spore_spawner"
	var/chance = 30
	var/silent_sac = TRUE

/obj/effect/landmark/structure_spawner/spore_sac_rng/fifty
	name = "pathogen spore sac spawner (50)"
	chance = 50

/obj/effect/landmark/structure_spawner/spore_sac_rng/seventy_five
	name = "pathogen spore sac spawner (75)"
	chance = 75

/obj/effect/landmark/structure_spawner/spore_sac_rng/twenty
	name = "pathogen spore sac spawner (20)"
	chance = 20

/obj/effect/landmark/structure_spawner/spore_sac_rng/ten
	name = "pathogen spore sac spawner (10)"
	chance = 10

/*
/obj/effect/landmark/structure_spawner/spore_sac_rng/post_setup()
	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/no_random_spores) || !prob(chance))
		qdel(src)
		return
	if(silent_sac)
		new /obj/effect/pathogen/spore_sac/silent(loc)
	else
		new /obj/effect/pathogen/spore_sac(loc)
	qdel(src)
*/
