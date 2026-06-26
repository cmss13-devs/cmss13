/obj/effect/alien/resin/special/fogger
	name = PATHOGEN_STRUCTURE_FOGGER
	desc = "A tall pillar of mycelium emitting large clouds of harmless spores obscuring vision."
	icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
	icon_state = "fog_pillar"
	pixel_x = -8
	pixel_y = -8
	health = 800
	var/list/fog_clouds = list()
	var/cloud_radius = 5

/obj/effect/alien/resin/special/fogger/Initialize(mapload, hive_ref)
	. = ..()
	spawn_fog_clouds()
	update_minimap_icon()

/obj/effect/alien/resin/special/fogger/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, get_minimap_flag_for_faction(linked_hive?.hivenumber), image('icons/mob/pathogen/neo_blips.dmi', null, "fogger"))

/obj/effect/alien/resin/special/fogger/update_icon()
	..()
	appearance_flags |= KEEP_TOGETHER
	overlays.Cut()
	overlays += "[icon_state]_spores"


/obj/effect/alien/resin/special/fogger/Destroy()
	for(var/cloud in fog_clouds)
		qdel(cloud)
	SSminimaps.remove_marker(src)
	. = ..()

/obj/effect/alien/resin/special/fogger/proc/spawn_fog_clouds()
	var/datum/cause_data/new_cause_data = create_cause_data("mycelial fog cloud")
	var/list/turfs_to_spread = list()//I'm good at finding clunky ways to do things, aren't I?
	var/list/ground_turfs = circlerangeturfs(src, cloud_radius)
	var/list/view_turfs = view(cloud_radius + 1, loc)


	for(var/turf/ground_turf in ground_turfs)
		if(!(ground_turf in view_turfs))
			continue
		var/turf/below = SSmapping.get_turf_below(ground_turf)
		var/turf/above = SSmapping.get_turf_above(ground_turf)
		if(below && istype(ground_turf,/turf/open_space))
			var/obj/effect/particle_effect/smoke/foundsmoke = locate() in below
			if(foundsmoke)
				if(foundsmoke.smokeranking <= SMOKE_RANK_PATHOGEN_FOG)
					qdel(foundsmoke)
					turfs_to_spread += below
			else
				turfs_to_spread += below

		if(above && istype(above,/turf/open_space))
			var/obj/effect/particle_effect/smoke/foundsmoke = locate() in above
			if(foundsmoke)
				if(foundsmoke.smokeranking <= SMOKE_RANK_PATHOGEN_FOG)
					qdel(foundsmoke)
					turfs_to_spread += above
			else
				turfs_to_spread += above
		if(ground_turf.density)
			continue
		turfs_to_spread += ground_turf

	for(var/turf/target_turf in turfs_to_spread)
		var/fog_cloud =	new /obj/effect/particle_effect/smoke/mycelium_cloud(target_turf, null, new_cause_data)
		fog_clouds += fog_cloud

/obj/effect/particle_effect/smoke/mycelium_cloud
	name = "mycelial spore fog"
	amount = 1
	time_to_live = INFINITY
	smokeranking = SMOKE_RANK_PATHOGEN_FOG
	opacity = FALSE
	alpha = 50
	color = "#5f5f5f"
	var/fire_suppression_level = 3

/obj/effect/particle_effect/smoke/mycelium_cloud/Crossed(mob/living/carbon/moob as mob)
	if(!istype(moob))
		return
	moob.update_tint()
	. = ..()

/obj/effect/particle_effect/smoke/mycelium_cloud/Uncrossed(mob/living/carbon/moob as mob)
	if(!istype(moob))
		return
	moob.update_tint()

	. = ..()

/obj/effect/particle_effect/smoke/mycelium_cloud/apply_smoke_effect(turf/cur_turf)
	for(var/mob/living/affected_mob in cur_turf)
		if(affected_mob.on_fire)
			affected_mob.adjust_fire_stacks(-fire_suppression_level, min_stacks = 0)
			to_chat(affected_mob, SPAN_WARNING("[src] smothers the flames upon you!"))

	for(var/obj/flamer_fire/fire in cur_turf)
		var/penetrating = fire.tied_reagent?.fire_penetrating
		var/extinguish_strength = fire_suppression_level
		if(fire.fire_variant == FIRE_VARIANT_TYPE_B)
			extinguish_strength = fire_suppression_level*2
		if(penetrating)
			extinguish_strength = floor(extinguish_strength/2)
		fire.firelevel -= extinguish_strength
		fire.update_flame()

/obj/effect/particle_effect/smoke/mycelium_cloud/ex_act(severity)
	return


/datum/construction_template/xenomorph/fogger
	name = PATHOGEN_STRUCTURE_FOGGER
	description = "Produces large clouds of harmless spores to impede vision."
	build_type = /obj/effect/alien/resin/special/fogger
	build_icon_state = "fog_pillar"

/datum/construction_template/xenomorph/fogger/set_structure_image()
	build_icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'

/mob/proc/in_spore_cloud()
	if(locate(/obj/effect/particle_effect/smoke/mycelium_cloud) in get_turf(src))
		return TRUE
	return FALSE
